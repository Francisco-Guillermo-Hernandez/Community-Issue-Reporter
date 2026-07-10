//
//  CommentsController.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 16/6/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class CommentsController {
    
    let commentFor: CommentForType
    let resourceId: String
    var commentInput: String = ""
    var comments: [Comment] = []
    var disableInput: Bool = false
    var isLoading: Bool = false
    var currentPage: Int = 1
    var canLoadMore: Bool = true
    var isSubmitting: Bool = false
    var paginatedResult: PaginatedResponse<Comment>
    var limit: Int = 16
    var animateInputIn: Bool = false
    var presentAlert: Bool = false
    var message: String = ""
    
    init(commentFor: CommentForType, resourceId: String) {
        self.commentFor = commentFor
        self.resourceId = resourceId
        self.paginatedResult = PaginatedResponse<Comment>(
            documents: [],
            total: 0,
            page: 0,
            documentsPerPage: 0,
            totalPages: 0,
            hasNext: false,
            hasPrev: false
        )
    }
    
    func fetchComments() async {
        self.isLoading = true
        guard !Task.isCancelled else { return }
        
        do {
            let result = try await CommentsRepository.shared.list(
                resourceId,
                page: currentPage,
                limit: self.limit
            )
            
            self.paginatedResult = result
            self.comments = result.documents ?? []
        } catch {
            print(error)
        }
        
        self.isLoading = false
    }
    
    func addComment() async {
        guard !commentInput.isEmpty else { return }
        
        self.isSubmitting = true
        self.disableInput = true
        
        let comment = Comment(commentFor: commentFor, resourceId: resourceId, message: commentInput)
        
        do {
            let result = try await CommentsRepository.shared.post(comment)
            if result == .done {
                self.comments.insert(comment, at: 0)
            }
        } catch CommonIntercommunicationErrors.networkError(let error) {
            self.message = error
            self.presentAlert = true
        } catch {
            print(error)
        }
        
        self.disableInput = false
        self.commentInput = ""
        self.isSubmitting = false
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
            
            if let newComments = result.documents {
                print("load more")
                dump(newComments)
            }
        } catch {
            print(error)
        }
        
        self.isLoading = false
    }
}
