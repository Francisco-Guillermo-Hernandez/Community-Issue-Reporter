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
    
    var subViewName: String
    init(subViewName: String) {
        self.subViewName = subViewName
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
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(comments) { c in
                        CommentRow(name: c.name!, time: c.created_at!, message: c.message)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            // The Delete Button
                                            Button(role: .destructive) {
                                               
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                            
                                            // The Mute Button
                                            Button {
                                               
                                            } label: {
                                                Label("Mute", systemImage: "bell.fill")
                                            }
                                            .tint(.indigo) // Sets the purple/blue color
                                        }
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
            }
            .task {
                guard !Task.isCancelled else { return }
                await CommentsRepository.listByUser(
                    page: 1,
                    onComplete: { result in
                        self.comments.append(contentsOf: result.documents!)
                    },
                    onError: { error in
                        print(error)
                    })
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("My Comments")
        }
    }
}

#Preview {
    CommentsSubView(subViewName: "My Comments")
}
