//
//  CommentsSectionView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/4/26.
//

import SwiftUI

struct CommentsSectionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isTextFieldFocused: Bool
    @State private var commentInput: String = ""
    @State private var comments: [Comment] = [
        
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(comments) { c in
                        CommentRow(name: c.name, time: "", message: c.message)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Comments")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") {
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
            //
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
                
                Button {
                    addComment()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 40, height: 30)
                        
                        Image(systemName: "paperplane")
                            .foregroundStyle(.white)
                            .font(.system(size: 16))
                    }
                }
                .disabled(commentInput.trimmingCharacters(in: .whitespaces).isEmpty)
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
            comments.append(Comment(id: UUID().uuidString, createdAt: Date(), name: "Anonymous", message: commentInput))
            commentInput = ""
            isTextFieldFocused = false
        }
    }
}

#Preview {
    //    @Previewable
    //    @FocusState var isFocused: Bool
    
    CommentsSectionView()
}
