//
//  CommentsSectionView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/4/26.
//

import SwiftUI
import CoreLocation

struct CommentsSectionView: View {
    
    var report: MapExplorerReport
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
    
    init(for report: MapExplorerReport) {
        
        
        self.report = report
        self.paginatedResult = PaginatedResponse<Comment>(
            documents: [],
            total: 0,
            page: 0,
            documentsPerPage: 0,
            totalPages: 0,
            hasNext: false,
            hasPrev: false,
        )
        
        print("issue detail")
        print(report.id)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    if comments.isEmpty {
                        // Empty state
                        ContentUnavailableView {
                            Label("No comments yet.", systemImage: "bubble.left.and.text.bubble.right")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(
                                    Color.theme.foreground.opacity(0.7),
                                    Color.theme.primary,
                                    Color.theme.foreground.opacity(0.7)
                                )
                        } description: {
                            Text("Please tell us how that problem affects you.")
                        } actions: {
                            
                        }
                        .containerRelativeFrame(.vertical)
                    } else {
                        ForEach(comments) { c in
                            CommentRow(
                                name: c.name!,
                                time: c.createdAt!,
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
            .background(Color.theme.background)
            .task {
                self.isLoading = true
                guard !Task.isCancelled else { return }
                
                let result = await CommentsRepository.shared.list(
                    report.id,
                    page: currentPage,
                    limit: self.limit,
                    onError: { _ in
                        print("error")
                    }
                )
                self.paginatedResult = result
                self.comments.append(contentsOf: result.documents ?? [])
                
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
                    .foregroundStyle(disableInput ? Color.theme.muted : .primary)
                    .focused($isTextFieldFocused)
                    .padding(.leading, 8)
                    .disabled(disableInput)
                
                Button {
                    addComment()
                } label: {
                    if !isSubmitting {
                        ZStack {
                            RoundedRectangle(cornerRadius: .themeRadius * 2)
                                .frame(width: 64, height: 32)
                            
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
                createdAt: Date(),
                name: "Anonymous",
                reportId: report.id,
                message: commentInput,
            )
            
            /// lest add the comment at the top
            comments.insert(comment, at: 0)
            
            disableInput = true
            isTextFieldFocused = false
            
            Task {
                
                await CommentsRepository.shared.post(
                    reportId: report.id,
                    message: self.commentInput,
                    onComplete: {
                        self.disableInput = false
                        self.commentInput = ""
                        self.isSubmitting = false
                    },
                    onError: { error in
                        print(error)
                        print("error")
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
        
        let result = await CommentsRepository.shared.list(
            report.id,
            page: self.currentPage,
            limit: self.limit,
            onError: { _ in
                print("error")
            }
        )
        
        isLoading = false
    }
}

#Preview {
    
    
    var report = MapExplorerReport(id: "", lat: 0, lng: 0, address: "", title: "", description: "", severityId: 1, statusId: 1, issueTypeId: 1, matterToSolveId: 1, reportedAtRaw: nil, cellIndex: "", createdAtRaw: 0, updatedAtRaw: 0, reportedBy: "", cityId: "", petitionId: "")
    
    CommentsSectionView(for: report)
}
