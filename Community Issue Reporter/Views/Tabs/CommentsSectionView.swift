//
//  CommentsSectionView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/4/26.
//

import SwiftUI
import CoreLocation

struct CommentsSectionView: View {
    
    var issue: IssueMarker
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isTextFieldFocused: Bool
    @State private var commentInput: String = ""
    @State private var comments: [Comment] = []
    @State private var disableInput: Bool = false
    @State private var isLoading: Bool = false
    @State private var currentPage: Int = 1
    @State private var canLoadMore: Bool = true
    @State private var isSubmitting: Bool = false
    @State private var paginatedResult: PaginatedResponse<Comment>
    @State private var limit: Int = 16
    
    init(issue: IssueMarker) {
        self.issue = issue
        self.paginatedResult = PaginatedResponse<Comment>(
            documents: [],
            total: 0,
            page: 0,
            documentsPerPage: 0,
            totalPages: 0,
            hasNext: false,
            hasPrev: false,
        )
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    if comments.isEmpty {
                        ContentUnavailableView {
                            Label("No comments yet.", systemImage: "bubble.left.and.text.bubble.right")
                        } description: {
                            Text("Please tell us how that problem affects you.")
                        } actions: {
                            
                        }
                        .containerRelativeFrame(.vertical)
                    } else {
                        ForEach(comments) { c in
                            CommentRow(
                                name: c.name!,
                                time: c.created_at!,
                                message: c.message
                            )
                            .task {
                                if let lastComment = self.comments.last, c.id == lastComment.id {
                                    await loadMoreComments()
                                }
                            }
                        }
                    }
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .padding()
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
            }
            .task {
                self.isLoading = true
                guard !Task.isCancelled else { return }
                await CommentsRepository.list(
                    issue.id,
                    page: currentPage,
                    limit: self.limit,
                    onComplete: { result in
                        self.paginatedResult = result
                        self.comments.append(contentsOf: result.documents!)
                        
                        if result.hasNext {
                            self.currentPage += 1
                        }
                    },
                    onError: { _ in }
                )
                
                self.isLoading = false
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Comments")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
            .interactiveDismissDisabled(isTextFieldFocused && !commentInput.isEmpty)
            .safeAreaInset(edge: .bottom) {
                inputBar
            }
            
        }
    }
    
    
    var inputBar: some View {
        ZStack {
            
            Rectangle()
                .fill(.ultraThinMaterial)
                .mask {
                    LinearGradient(
                        stops: [
                            .init(color: .black, location: 0),
                            .init(color: .clear, location: 1)
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                }
                .ignoresSafeArea()
            
            HStack {
                TextField("Add a comment", text: $commentInput, axis: .vertical)
                    .focused($isTextFieldFocused)
                    .padding(.leading, 8)
                    .disabled(disableInput)
                
                Button {
                    addComment()
                } label: {
                    if !isSubmitting {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: 40, height: 30)
                            
                            Image(systemName: "paperplane")
                                .foregroundStyle(.white)
                                .font(.system(size: 16))
                                .symbolEffect(.wiggle.wholeSymbol, options: .nonRepeating)
                        }
                        
                    } else {
                        ProgressView().progressViewStyle(.circular)
                    }
                }
                .disabled(commentInput.trimmingCharacters(in: .whitespaces).isEmpty || isSubmitting)
            }
            .padding(8)
            .glassEffect()
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private func addComment() {
        if !commentInput.isEmpty {
            
            self.isSubmitting = true
            let comment = Comment(
                id: UUID().uuidString,
                created_at: Date(),
                name: "Anonymous",
                report_id: issue.id,
                message: commentInput,
            )
            
            /// lest add the comment at the top
            comments.insert(comment, at: 0)
            
            disableInput = true
            isTextFieldFocused = false
            
            Task {
                
                await CommentsRepository.post(
                    reportId: issue.id,
                    message: self.commentInput,
                    onComplete: {
                        self.disableInput = false
                        self.commentInput = ""
                        self.isSubmitting = false
                    },
                    onError: { error in
                        print(error)
                        self.disableInput = false
                        self.commentInput = ""
                        self.isSubmitting = false
                    }
                )
            }
        }
    }
    
    
    func loadMoreComments() async {
        
        guard !self.isLoading && self.canLoadMore else { return }
        guard !Task.isCancelled else { return }
        
        self.isLoading = true
        
        await CommentsRepository.list(
            issue.id,
            page: self.currentPage,
            limit: self.limit,
            onComplete: { result in
                let existingIds = Set(self.comments.map { $0.id })
                guard let documents = result.documents else { return }
                let uniqueNewComments = documents.filter { !existingIds.contains($0.id) }
                
                if !uniqueNewComments.isEmpty {
                    self.comments.append(contentsOf: uniqueNewComments)
                    self.canLoadMore = result.hasNext
                    if self.canLoadMore { self.currentPage += 1 }
                } else {
                    self.canLoadMore = false
                }
            },
            onError: { _ in self.isLoading = false }
        )
        
        isLoading = false
    }
    
}

#Preview {
    
    
    let coordinate = CLLocationCoordinate2D(
        latitude: 37.7749,
        longitude: -122.4194
    )
    
    let issue = IssueMarker(
        id: UUID().uuidString,
        title: "A big pothole",
        description: "There is a big pothole in the middle of the street",
        status: 2,
        coordinate: coordinate,
        issueType: 1,
        severity: 2,
        matterToSolveId: 1,
        address: "lorem ipsum dolor sit amet consectetur adipiscing elit."
    )
    
    CommentsSectionView(issue: issue)
}
