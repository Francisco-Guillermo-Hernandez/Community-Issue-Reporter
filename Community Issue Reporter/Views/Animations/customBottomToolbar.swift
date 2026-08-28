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
    var boostReportValidationAction: (Bool) -> Void
    @State private var commentState: Bool = false
    @State private var pictureState: Bool = false
    @State private var isShowingPopover = false

    @State private var isGuest: Bool = false
    
    @Binding var affectedState: Bool
    @Binding var notificationState: Bool
    @Binding var disableBoostButton: Bool
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Button(action: performCommentActions) {
                VStack(spacing: 2) {
                    Image(systemName: "text.bubble")
                        .font(.system(size: 18, weight: .semibold))
                        .background(Color.black.opacity(0.001))
                        .foregroundStyle(isGuest ? .gray.opacity(0.85) : .primary)
                    
                    Text("Comment")
                        .font(.footnote)
                        .foregroundStyle(isGuest ? .gray.opacity(0.85) : .primary)
                }
                .frame(width: 64, height: 64)
            }
            .accessibilityLabel("CommentReportButton")
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .buttonSizing(.flexible)
            .disabled(isGuest)
            
            Button(action: performPhotoActions) {
                VStack(spacing: 4) {
                    Image(systemName: "photo.stack")
                        .font(.system(size: 18, weight: .semibold))
                        .background(Color.black.opacity(0.001))
                        .symbolRenderingMode(pictureState ? .multicolor : .monochrome)
                    
                    Text("Evidences")
                        .font(.footnote)
                }
                .frame(width: 72, height: 64)
                
            }
            .accessibilityLabel("AddAttachmentsButton")
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .buttonSizing(.flexible)
            
            
            Button(action: performNotificationActions) {
                
                Group {
                    if disableBoostButton {
                        VStack(spacing: 2) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .background(Color.black.opacity(0.001))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(
                                    Color.theme.primary,
                                    Color.white,
                                    Color.white
                                )
                                .symbolEffect(
                                    .breathe,
                                    options: .repeat(.continuous)
                                )
                            Text("Boosted")
                                .font(.footnote)
                                .foregroundStyle(isGuest ? .gray.opacity(0.85) : .primary)
                        }
                    } else {
                        VStack(spacing: 2) {
                            Image(systemName: "flame")
                                .font(.system(size: 18, weight: .semibold))
                                .background(Color.black.opacity(0.001))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(
                                    Color.theme.primary,
                                    Color.white,
                                    Color.white
                                )
                                .symbolEffect(
                                    .pulse,
                                    options: .repeat(.continuous),
                                    value: notificationState
                                )
                            
                            Text("Boost")
                                .font(.footnote)
                                .foregroundStyle(isGuest ? .gray.opacity(0.85) : .primary)
                        }
                    }
                }
                .frame(width: 68, height: 64)
            }
            .disabled(isGuest)
            .allowsHitTesting(!disableBoostButton)
            .accessibilityLabel("BoostButton")
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .buttonSizing(.flexible)
        }
        .padding(.horizontal, 24)
        .optionalGlassWithShape(colorScheme, shape: .capsule)
        .shadow(color: Color.black.opacity(0.125), radius: 16, x: 0, y: 6)
        .task {
            isGuest = UserRepository.shared.isGuestUser()
        }
        
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
        boostReportValidationAction(self.notificationState)
    }
}

#Preview {
    @Previewable
    @State var affectedState: Bool = false
    
    @Previewable
    @State var notificationState: Bool = false
    
    @Previewable
    @State var disabled: Bool = true
    
    customBottomToolbar(
        commentAction: {},
        addPhotoAction: {},
        affectedAction: { _ in  },
        boostReportValidationAction: { _ in },
        affectedState: $affectedState,
        notificationState: $notificationState,
        disableBoostButton: $disabled
    )
}

