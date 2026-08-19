//
//  CommentRow.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/6/26.
//

import SwiftUI
import Observation

enum CommentViolationReportOptions: String, Codable, CaseIterable {
    /// Existing
    case harassment
    case selfPromotion
    
    /// Safety & Abuse
    case hateSpeech
    case violence
    
    /// Fallback
    case other
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
    
        case .harassment:
            return String(localized: "Harassment or bullying")
        case .selfPromotion:
            return String(localized: "Unwanted self-promotion")
        case .hateSpeech:
            return String(localized: "Hate speech or discrimination")
        case .violence:
            return String(localized: "Threats or violence")
        case .other:
            return String(localized: "Other issue")
        }
    }
    
}

@MainActor
@Observable
class CommentRowController {
 
    var selectedOption: String = "None"
    var showPopover: Bool = false
    var presentAlert: Bool = false
    var cornerRadius: CGFloat = .themeRadius * 1.4
    var reason: String = ""
    let options = CommentViolationReportOptions.allCases.map(\.title)
    
    func report(_ comment: Comment) -> Void {
        Task {
            let payload = CommentToBlock(comment)
            let blockedReasonId = CommentViolationReportOptions.allCases.first(where: { $0.title == selectedOption })?.id ?? CommentViolationReportOptions.other.id
            let violation = ReportViolation(
                type: .comment,
                content: payload,
                profileId: comment.profileId,
                reason: reason.isEmpty ? selectedOption : reason,
                blockedReasonId: blockedReasonId,
                status: .sentToModeration
            )
            
            do {
                _ = try await ModerationRepository.shared.moderateComment(reason: violation, type: .comment)
                Toast.shared.show(message: String(localized: "Your moderation petition was sent"), type: .info)
                print("moderation sent")
            } catch CommonIntercommunicationErrors.serverError(_) {
                Toast.shared.show(message: String(localized: "Server Error"), type: .error)
            } catch CommonIntercommunicationErrors.networkError(_) {
                Toast.shared.show(message: String(localized: "It looks like that your network is experiencing some delays, please try again."), type: .error)
            } catch {
                print(error)
                Toast.shared.show(message: String(localized: "Error"), type: .error)
            }
        }
    }
    
    func disableReportViolationButton(_ profileId: String) -> Bool {
        if profileId == "currentUser" || UserRepository.shared.isOwnProfile(profileId) {
            return true
        }
        
        return false
    }
}

// MARK: - Comment row
struct CommentRow: View {
    @State private var controller = CommentRowController()
    var comment: Comment
    var body: some View {
        
        VStack(alignment: .leading, spacing: .themeSpacing * 2) {
            
            HStack(alignment: .top, spacing: .themeSpacing * 3) {
                
                Group {
                    if let URL = urlFromString(comment.profilePicture) {
                        CachedAsyncImage(url: URL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .id(URL)
                    } else {
                        Circle()
                            .fill(.fill)
                    }
                }
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(comment.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .opacity(0.88)
                        
                        Text(userAlias(comment.userName))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text(formatRelativeDate(from: comment.createdAt))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer(minLength: 0)
                
                
                if !controller.disableReportViolationButton(comment.profileId) {
                    Button {
                        controller.showPopover.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .padding(6)
                    }
                    .frame(width: 24, height: 24, alignment: .top)
                    .disabled(controller.disableReportViolationButton(comment.profileId))
                    .buttonStyle(.borderless)
                    .buttonStyle(.borderless)
                    .foregroundColor(.primary)
                    .popover(isPresented: $controller.showPopover, arrowEdge: .top) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Comment report options")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                            
                            ForEach(controller.options, id: \.self) { option in
                                Button(action: {
                                    Task {
                                        controller.selectedOption = option
                                        controller.showPopover = false /// Closes popover upon selection
                                        try? await Task.sleep(for: .milliseconds(128))
                                        controller.presentAlert.toggle()
                                    }
                                }) {
                                    HStack {
                                        Text(option)
                                        
                                        Spacer()
                                    }
                                    .contentShape(Rectangle()) /// Ensures the whole row is clickable
                                }
                                .foregroundColor(.primary)
                                
                                if option != controller.options.last {
                                    Divider() /// Visual separator between choices
                                }
                            }
                        }
                        .padding()
                        .frame(width: 290) /// Sets a fixed width for desktop/iPad presentation
                        .presentationCompactAdaptation(.popover) /// Forces popover look on iPhone
                    }
                    .padding(.top, 10)
                    .alert(String(localized: "Confirm content blocking"), isPresented: $controller.presentAlert) {
                        
                        Button(String(localized: "Cancel"), role: .cancel) { }
                        Button(String(localized: "Block"), role: .destructive) {
                            controller.report(comment)
                        }
                    } message: {
                        Text(String(localized: "I confirm that this content violates our community guidelines."))
                    }
                }
                
                
            }
            .padding(.bottom, 8)
            
            Text(comment.message)
                .font(.caption)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, .themePadding / 2)
        
    }
}


#Preview {
    
    let comment = Comment(
        id: "1",
        name: "John Doe",
        userName: "john.doe",
        profilePicture: "https://development-api.reportamelo.app/avatars/8e2d458a-8f85-4d92-a220-c19fa6d89883.jpg?v=192929292",
        profileId: "a1bC21119aaX",
        commentFor: .report,
        resourceId: "",
        message: "We have problems with potholes in the road, please help us to fix it. We have problems with potholes in the road, please help us to fix it. We have problems with potholes in the road, please help us to fix it.",
        createdAt: parsePostgresDate("2026-05-01T00:00:00.000Z")!,
        updatedAt: Date()
    )
    
    NavigationStack {
        ScrollView(showsIndicators: false) {
            CommentRow(comment: comment)
            CommentRow(comment: comment)
            CommentRow(comment: comment)
            
        }
        .padding()
        .background(Color.theme.background)
    }
    .withToast()
}
