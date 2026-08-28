//
//  PhotoPreview.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI
import Observation

// MARK: - Enum definitions

enum PhotoPreviewMode {
    case sized
    case full
}

enum ContentViolationReportOptions: String, Codable, CaseIterable {
    case explicitContent
    case spam
    case violence
    case privacyIssues
    case other
    
    var description: String {
        switch self  {
            case .explicitContent:
                return String(localized: "Explicit Content")
            case .spam:
                return String(localized: "Spam")
            case .violence:
                return String(localized: "Violence")
            case .privacyIssues:
                return String(localized: "Privacy issue")
            case .other:
                return String(localized: "Other")
            
        }
    }
}

// MARK: - Controller

@MainActor
@Observable
class PhotoPreviewController {
    var selectedOption = "None"
    var showPopover = false
    var presentAlert: Bool = false
    var reason: String = ""
    var showAlert: Bool = false
    var alertMessage: String = ""
    let options = ContentViolationReportOptions.allCases.map(\.description)
    var showSuccessfulAlert: Bool = false
    
    func report(_ attachment: PreviewAttachment) -> Void {
        Task {
            let blockedReasonId = ContentViolationReportOptions.allCases.first(where: { $0.description == selectedOption })?.rawValue ?? ContentViolationReportOptions.other.rawValue
            let type = TypeOfContentToReport(rawValue: attachment.type.rawValue) ?? .image
            
            let violation = ReportViolation(
                type: type,
                content: attachment,
                profileId: attachment.uploaderUserName,
                reason: reason.isEmpty ? selectedOption : reason,
                blockedReasonId: blockedReasonId,
                status: .sentToModeration
            )
            
            do {
                _ = try await ModerationRepository.shared.moderateContent(reason: violation, type: type)
                alertMessage = String(localized: "Your moderation petition was sent")
                showSuccessfulAlert = true
            } catch CommonIntercommunicationErrors.serverError(_) {
                alertMessage = String(localized: "Server Error")
                showAlert = true
            } catch CommonIntercommunicationErrors.networkError(_) {
                alertMessage = String(localized: "It looks like that your network is experiencing some delays, please try again.")
                showAlert = true
            } catch {
                alertMessage = String(localized: "Error")
                showAlert = true
            }
        }
    }
}

// MARK: - Views
struct PhotoPreview: View {
    
    @State private var controller = PhotoPreviewController()
    @State private var cornerRadius: CGFloat = .themeRadius * 1.4
    @State private var completed: Bool = false
    var height: CGFloat = 170
    var width: CGFloat = 170
    
    var mode: PhotoPreviewMode
    var attachment: PreviewAttachment
    
    init(_ attachment: PreviewAttachment, _ mode: PhotoPreviewMode = .sized) {
        self.attachment = attachment
        self.mode = mode
    }
    
    init (_ attachment: PreviewAttachment, height: CGFloat, width: CGFloat) {
        
        self.attachment = attachment
        self.height = height
        self.width = width
        self.mode = .sized
    }
    
    var body: some View {
        if let url = attachment.url {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: mode == .sized ? width : nil,
                        height: mode == .sized ? height : nil,
                        alignment: .top
                    )
                    .frame(
                        maxWidth: mode == .full ? .infinity : nil,
                        maxHeight: mode == .full ? .infinity : nil,
                        alignment: .top
                    )
                    .blur(radius: attachment.state == .confirmed ? 0 : 3)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .overlay  {
                        if self.attachment.state == .pending {
                            ZStack {
                                
                                Image(systemName: "hourglass")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        if self.attachment.state == .inappropriate {
                            ZStack {
                                Color.theme.destructive
                                Image(systemName: "nosign")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        if self.attachment.state == .deleted {
                            ZStack {
                                
                                Image(systemName: "xmark.bin.circle.fill")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        if self.attachment.state == .manualRevision {
                            ZStack {
                                
                                Image(systemName: "rectangle.and.hand.point.up.left.filled")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                            
                    }
                    .overlay {
                        ZStack(alignment: .bottomLeading) {
                            
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            .init(color: .black.opacity(0.6), location: 0),
                                            .init(color: .black.opacity(0.33), location: 0.5),
                                            .init(color: .clear, location: 1)
                                        ],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                                .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(userAlias(attachment.uploaderUserName))
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                
                                Text(attachment.createdAt.formatted(date: .numeric, time: .omitted))
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(12)
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        
                        if !UserRepository.shared.isGuestUser() {
                            

                            Button {
                                controller.showPopover.toggle()
                            } label: {
                                Image(systemName: "ellipsis")
                                    .padding(6)
                            }
                            .buttonBorderShape(.circle)
                            .buttonStyle(.glass)
                            .popover(isPresented: $controller.showPopover, arrowEdge: .top) {
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Content options")
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
                                .frame(width: 256) /// Sets a fixed width for desktop/iPad presentation
                                .presentationCompactAdaptation(.popover) /// Forces popover look on iPhone
                            }
                            .padding(.top, 10)
                            .alert(String(localized: "Confirm content blocking"), isPresented: $controller.presentAlert) {
                                
                                TextField(String(localized: "Type your reason"), text: $controller.reason)
                                
                                Button(String(localized: "Cancel"), role: .cancel) { }
                                Button(String(localized: "Block"), role: .destructive) {
                                    controller.report(attachment)
                                }
                            } message: {
                                Text(String(localized: "I confirm that this content violates our community guidelines."))
                            }
                            .alert(String(localized: "Error"), isPresented: $controller.showAlert) {
                                Button(String(localized: "OK"), role: .cancel) { }
                            } message: {
                                Text(controller.alertMessage)
                            }
                            .alert(String(localized: "Confirmation"), isPresented: $controller.showSuccessfulAlert) {
                                Button(String(localized: "OK"), role: .cancel) { }
                            } message: {
                                Text(controller.alertMessage)
                            }
                        }
                        
                    }
            
                   
            } placeholder: {
                ProgressView()
                    .frame(width: width, height: height)
            }
            .id(url)
        }
    }
}

#Preview {
    let attachment = PreviewAttachment(
        id: "24b93d66-07ff-4141-91ce-408b615123c3",
        type: .image,
        createdAtRaw: 0,
        updatedAtRaw: 0,
        uploaderUserName: "jhon.doe",
        validatedBy: .bot,
        state: .pending,
        fileName: "1783058838224-f02fb5e4-07d1-49d4-a9f5-742816b669c9.webp",
        reportContainer: "587d3ac3-0715-4958-8955-1d6d29a3d489"
    )
    PhotoPreview(attachment)
}


