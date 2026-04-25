//
//  customBottomToolbar.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI

struct customBottomToolbar: View {
    @Environment(\.colorScheme) private var colorScheme
    var commentAction: () -> Void
    var addPhotoAction: () -> Void
    var affectedAction: (Bool) -> Void
    var addNotificationAction: (Bool) -> Void
    @State private var commentState: Bool = false
    @State private var pictureState: Bool = false
    
    @Binding var affectedState: Bool
    @Binding var notificationState: Bool
    
    var body: some View {
        
        HStack(spacing: 36) {
            
            Button(action: performCommentActions) {
                Image(systemName: "text.bubble")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.001))
            }
            .accessibilityLabel("Comment")
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .buttonSizing(.flexible)
            
            Button(action: performPhotoActions) {
                Image(systemName: "photo.badge.plus")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.001))
                    .symbolRenderingMode(pictureState ? .multicolor : .monochrome)
                
            }
            .accessibilityLabel("Add a photo")
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .buttonSizing(.flexible)
            
            Button(action: performAffectedActions) {
                Image(systemName: affectedState ? "person.fill.xmark" :  "person.fill.checkmark")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.001))
                    .symbolRenderingMode(.palette )
                    .foregroundStyle(
                        affectedState ? .red: .blue,
                        colorScheme == .dark ? .white : .black
                    )
                    .contentTransition(
                        .symbolEffect(.replace.magic(fallback: .upUp.byLayer),
                        options: .nonRepeating)
                    )
                    
            }
            .accessibilityLabel("Comment")
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .buttonSizing(.flexible)
            
            Button(action: performNotificationActions) {
                Image(systemName: "bell.badge")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.001))
                    .symbolRenderingMode(notificationState ? .multicolor : .monochrome)
                    .symbolEffect(
                        .wiggle.wholeSymbol,
                        options: .nonRepeating,
                        value: notificationState
                    )
            }
            
            .accessibilityLabel("Add Notification")
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .buttonSizing(.flexible)
        }
        .padding()
        .optionalGlassWithShape(colorScheme, shape: .capsule)
        .shadow(color: Color.black.opacity(0.125), radius: 10, x: 0, y: 6)
        .padding(.horizontal, 16)
        
    }
    
    private func performCommentActions() -> Void {
        self.commentState.toggle()
        commentAction()
    }
    private func performPhotoActions() -> Void {
        self.pictureState.toggle()
        addPhotoAction()
    }
    
    private func performAffectedActions() -> Void {
        self.affectedState.toggle()
        affectedAction(self.affectedState)
    }
    
    private func performNotificationActions() -> Void {
        self.notificationState.toggle()
        addNotificationAction(self.notificationState)
    }
}

#Preview {
    @Previewable
    @State var affectedState: Bool = false
    
    @Previewable
    @State var notificationState: Bool = false
    customBottomToolbar(
        commentAction: {},
        addPhotoAction: {},
        affectedAction: { _ in  },
        addNotificationAction: { _ in },
        affectedState: $affectedState,
        notificationState: $notificationState
    )
}

