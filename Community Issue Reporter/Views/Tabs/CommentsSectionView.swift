//
//  CommentsSectionView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/4/26.
//

import SwiftUI
import CoreLocation

struct CommentsSectionView: View {
    @State private var controller: CommentsController
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isTextFieldFocused: Bool
    @State private var title: String
    @State private var subtitle: String
    
    init(for commentFor: CommentForType, with resourceId: String, title: String, subtitle: String) {        
        controller = CommentsController(commentFor: commentFor, resourceId: resourceId)
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                if controller.comments.isEmpty {
                    /// Empty state
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
                    }
                    .containerRelativeFrame(.vertical)
                } else {
                    ForEach(controller.comments) { c in
                        CommentRow(comment: c)
                        .task {
                            if let lastComment = controller.comments.last, c.id == lastComment.id {
                                await controller.loadMoreComments()
                            }
                        }
                    }
                }
                
                if controller.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding()
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
        }
        .alert("Status Update", isPresented: $controller.presentAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(controller.message)
        }
        .background(Color.theme.background)
        .task {
            await controller.fetchComments()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Comments for: \(title)")
        .navigationSubtitle(subtitle)
        .interactiveDismissDisabled(isTextFieldFocused && !controller.commentInput.isEmpty)
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
                TextField("Add a comment", text: $controller.commentInput, axis: .vertical)
                    .foregroundStyle(controller.disableInput ? Color.theme.muted : .primary)
                    .focused($isTextFieldFocused)
                    .padding(.leading, 8)
                    .disabled(controller.disableInput)
                
                Button {
                    addComment()
                } label: {
                    if !controller.isSubmitting {
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
                .disabled(controller.commentInput.trimmingCharacters(in: .whitespaces).isEmpty || controller.isSubmitting)
            }
            .padding(8)
            .glassEffect()
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private func addComment() {
        isTextFieldFocused = false
        Task {
            await controller.addComment()
        }
    }
}

#Preview {
    NavigationStack {
        CommentsSectionView(for: .report, with: "", title: "", subtitle: "")
    }
}
