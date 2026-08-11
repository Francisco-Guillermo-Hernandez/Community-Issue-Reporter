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

    
    @Binding var affectedState: Bool
    @Binding var notificationState: Bool
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Button(action: performCommentActions) {
                VStack(spacing: 2) {
                    Image(systemName: "text.bubble")
                        .font(.system(size: 18, weight: .semibold))
                        .background(Color.black.opacity(0.001))
                    
                    Text("Comment")
                        .font(.footnote)
                }
                .frame(width: 64, height: 64)
            }
            .accessibilityLabel("CommentReportButton")
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .buttonSizing(.flexible)
            .disabled(UserRepository.shared.isGuestUser())
            
            Button(action: performPhotoActions) {
                VStack(spacing: 4) {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 18, weight: .semibold))
                        .background(Color.black.opacity(0.001))
                        .symbolRenderingMode(pictureState ? .multicolor : .monochrome)
                    
                    Text("Attach")
                        .font(.footnote)
                }
                .frame(width: 64, height: 64)
                
            }
            .accessibilityLabel("AddAttachmentsButton")
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .buttonSizing(.flexible)
            
//            Button(action: performAffectedActions) {
//                VStack(spacing: 2) {
//                    Image(systemName: "hand.thumbsdown.hand.thumbsup.filled")
//                        .font(.system(size: 18, weight: .semibold))
//                        .background(Color.black.opacity(0.001))
//                        .symbolRenderingMode(.palette )
//                        .foregroundStyle(
//                            affectedState ? .red : .primary,
//                            colorScheme == .dark ? .white : .black
//                        )
//                        .contentTransition(
//                            .symbolEffect(.replace.magic(fallback: .upUp.byLayer),
//                            options: .nonRepeating)
//                        )
//                    
//                    Text("Vote")
//                        .font(.footnote)
//                }
//                .frame(width: 64, height: 64)
//                    
//            }
//            .accessibilityLabel("AffectedButton")
//            .buttonStyle(.plain)
//            .contentShape(Rectangle())
//            .buttonSizing(.flexible)
//            .popover(isPresented: $affectedState) {
//                HStack {
//                    Button {
//                        
//                    } label: {
//                        VStack {
//                            Image(systemName: "hand.thumbsup.fill")
//                                .font(.system(size: 18, weight: .semibold))
//                                .foregroundStyle(.black)
//                            
//                            Text(String(localized: "This report affects me"))
//                                .font(.footnote)
//                        }
//                    }
//                    
//                    
//                    Button {
//                        
//                    } label: {
//                        VStack {
//                            Image(systemName: "hand.thumbsdown.fill")
//                                .symbolRenderingMode(.monochrome)
//                                .font(.system(size: 18, weight: .semibold))
//                                .foregroundStyle(.red)
//                            
//                            Text(String(localized: "This report is helpful"))
//                                .font(.footnote)
//                        }
//                    }
//                }
//                .frame(width: 128, height: 64)
//                .presentationCompactAdaptation(.popover)
//            }
            
            Button(action: performNotificationActions) {
                
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
                            .pulse,
                            options: .repeat(.continuous),
                            value: notificationState
                        )
                    
                    Text("Boost")
                        .font(.footnote)
                }
                
                .frame(width: 64, height: 64)
            }
            
            .accessibilityLabel("BoostButton")
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .buttonSizing(.flexible)
        }
        .padding(.horizontal, 24)
        .optionalGlassWithShape(colorScheme, shape: .capsule)
        .shadow(color: Color.black.opacity(0.125), radius: 16, x: 0, y: 6)
        
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
    customBottomToolbar(
        commentAction: {},
        addPhotoAction: {},
        affectedAction: { _ in  },
        boostReportValidationAction: { _ in },
        affectedState: $affectedState,
        notificationState: $notificationState
    )
}

