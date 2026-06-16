//
//  CommentsSectionView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/4/26.
//

import SwiftUI
import CoreLocation

struct CommentsSectionView: View {
    
    var commentFor: CommentForType
    var resourceId: String
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
    @State private var animateInputIn: Bool = false
    
    init(for commentFor: CommentForType, with resourceId: String) {
        
        self.commentFor = commentFor
        self.resourceId = resourceId
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
                        CommentRow(comment: c)
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
            
            do {
                let result = try await CommentsRepository.shared.list(
                    resourceId,
                    page: currentPage,
                    limit: self.limit
                )
                
                self.paginatedResult = result
                self.comments.append(contentsOf: result.documents ?? [])
            } catch {
                
            }
            
            
            self.isLoading = false
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Comments")
        .interactiveDismissDisabled(isTextFieldFocused && !commentInput.isEmpty)
        .safeAreaInset(edge: .bottom) {
            inputBar
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
        
        /// Apply validations
        if !commentInput.isEmpty {
            
            self.isSubmitting = true
            
            /// Prepare the comment to send
            let comment = Comment(commentFor: .report, resourceId: resourceId, message: commentInput)
            
            /// lest add the comment at the top
            comments.insert(comment, at: 0)
            
            disableInput = true
            isTextFieldFocused = false
            
            Task {
                
                await CommentsRepository.shared.post(
                    comment,
                    onComplete: {
                        self.disableInput = false
                        self.commentInput = ""
                        self.isSubmitting = false
                    },
                    onError: { error in
                        
                        /// TODO: Error handling
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
        
        do {
            let result = try await CommentsRepository.shared.list(
                resourceId,
                page: self.currentPage,
                limit: self.limit
            )
            
            if let comments = result.documents {
    //            self.currentPage += 1
    //            self.comments.append(contentsOf: result.documents)
    //            self.canLoadMore = result.hasNext
                
                print("load more")
            }
        } catch {
          
        }
        
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        CommentsSectionView(for: .report, with: "")
    }
}
