//
//  CommentsSubView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 19/4/26.
//

import SwiftUI

struct CommentsSubView: View {
    
    @State private var paginatedResult: PaginatedResponse<Comment>
    @State private var comments: [Comment] = []
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    
    var subViewName: String
    var mode: ViewOptions
    
    init(subViewName: String, mode: ViewOptions = .list) {
        self.subViewName = subViewName
        self.mode = mode
        self.comments = []
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
        ZStack {
            if isLoading {
                LoadingView()
            }
            
            if comments.isEmpty && !isLoading {
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
                List {
                    ForEach(comments, id: \.id) { c in
                        CommentRow(comment: c)
                            .cellStyle()
                            .listRowInsets(themeCellEdgeInsets)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                // The Delete Button
                                Button(role: .destructive) {
                                    if let id = c.id {
                                        Task {
                                            do {
                                                let result = try await CommentsRepository.shared.delete(id)
                                                if result == .deleted {
                                                    if let index = comments.firstIndex(where: { $0.id == id }) {
                                                        comments.remove(at: index)
                                                    }
                                                }
                                            } catch {
                                                print("Failed to delete comment: \(error)")
                                            }
                                        }
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                               
                            }
                    }
                }
                .listStyle(.plain)
            }
        }
        .task {
            isLoading = true
            guard !Task.isCancelled else { return }
            
            do {
                let result = try await CommentsRepository.shared.listByUser(page: 1)
                guard let documents = result.documents else { return }
                
                self.comments.append(contentsOf: documents)
            } catch {
                
            }
            
            isLoading = false
        }
        .background(Color.theme.background)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("My Comments")
    }
}

#Preview {
    return NavigationStack {
        CommentsSubView(subViewName: "My Comments")
    }
}
