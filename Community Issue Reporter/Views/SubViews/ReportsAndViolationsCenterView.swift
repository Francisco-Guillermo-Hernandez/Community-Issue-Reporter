//
//  ReportsAndViolationsCenterView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez.
//

import SwiftUI
import Observation

// MAK: - Controller

@Observable
final class ModerationController {
    
    var isLoading = false
    var errorMessage: String?
    var showAlert: Bool = false
    var showReportRemovalAlert: Bool = false
    var showAlertError: Bool = false
    var selectedTab: Int = 0
    var selectedType: ViolationContentType = .attachment
    var showConfirmationOfRemoval: Bool = false
    var indictedModeratedContent: [ReportViolation<ModeratedContent>] = []
    var myComplaints: [ReportViolation<ModeratedContent>] = []
    
    var selectedReportId: String = ""
    var selectedReportType: TypeOfContentToReport? = nil
    var selectedProfileId: String = ""
    
    func unlock(_ profileId: String, reportId: String) -> Void {
        Task {
            do {
                _ = try await UserRepository.shared.unlock(profileId)
                
                _ = KeychainService.removeFromArray(key: .blockedUsers, element: profileId)
                _ = try await ModerationRepository.shared.remove(id: reportId, type: .account)
                showConfirmationOfRemoval.toggle()
            } catch {
                print(error)
                showAlertError.toggle()
            }
        }
    }
    
    func remove(reportId: String, type: TypeOfContentToReport) -> Void {
        Task {
            do {
                _ = try await ModerationRepository.shared.remove(id: reportId, type: type)
                showConfirmationOfRemoval.toggle()
            } catch {
                print(error)
                showAlertError.toggle()
            }
        }
    }
    
    func appealForReportRemoval(_ id: String, _ type: TypeOfContentToReport) {
        Task {
            do {
                let _ = try await ModerationRepository.shared.appeal(id: id, type: type)
                Toast.shared.show(
                    message: String(localized: "Your appeal has been sent"),
                    type: .success
                )
            } catch {
                Toast.shared.show(
                    message: error.localizedDescription,
                    type: .error
                )
            }
        }
    }
    
    func loadComplaints() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await ModerationRepository.shared.myComplaints()
            
            if let docs = response.documents {
                myComplaints = docs
                
                print(myComplaints)
            }
        } catch CommonIntercommunicationErrors.networkError(let error) {
            Toast.shared.show(message: error, type: .error)
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func loadIndictedData() async {
        
        let profileId = KeychainService.getToken(.profileId)
        guard !profileId.isEmpty else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            
            let response = try await ModerationRepository.shared.indictedModeratedContent()
            if let documents = response.documents {
                indictedModeratedContent = documents
            }
            
        } catch CommonIntercommunicationErrors.networkError(let error) {
            Toast.shared.show(message: error, type: .error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - definitions
enum ModerationRole: String, CaseIterable {
    case moderator
    case user
    case reporter
    
    var description: String {
        switch self {
            case .moderator: return String(localized: "Moderator")
            case .user: return String(localized: "User")
            case .reporter: return String(localized: "Reporter")
        }
    }
}

enum ViolationContentType: String, CaseIterable {
    case attachment = "Attachments"
    case comment = "Comments"
    
    var description: String {
        switch self {
            case .attachment: return String(localized: "Attachments")
            case .comment: return String(localized: "Comments")
        }
    }
}


// MARK: - View
struct ReportsAndViolationsCenterView: View {
    
    @State private var controller = ModerationController()
    
    var body: some View {
        VStack(spacing: 0) {
            
            /// Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Find information related with your content such as images, comments, reports, and petitions that violate our Community Guidelines. If you believe your we've mistakenly taken action , you can submit an appeal to have the action reversed.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                LinksView(type: .policies)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
           
            
            /// Tabs
            HStack(spacing: 32) {
                Button(action: { controller.selectedTab = 0 }) {
                    VStack {
                        Text("Your account")
                            .font(.subheadline)
                            .fontWeight(controller.selectedTab == 0 ? .semibold : .regular)
                            .foregroundColor(controller.selectedTab == 0 ? .primary : .secondary)
                        
                        Rectangle()
                            .fill(controller.selectedTab == 0 ? Color.primary : Color.clear)
                            .frame(height: 2)
                    }
                }
                
                Button(action: { controller.selectedTab = 1 }) {
                    VStack {
                        Text("Your reports")
                            .font(.subheadline)
                            .fontWeight(controller.selectedTab == 1 ? .semibold : .regular)
                            .foregroundColor(controller.selectedTab == 1 ? .primary : .secondary)
                        
                        Rectangle()
                            .fill(controller.selectedTab == 1 ? Color.primary : Color.clear)
                            .frame(height: 2)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            Divider()
            
            if controller.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    if controller.selectedTab == 0 {
                        /// Your account
                        if controller.indictedModeratedContent.isEmpty {
                            ContentUnavailableView {
                                Label(
                                    String(localized: "No violations yet."),
                                    systemImage: "checkmark.shield"
                                )
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(
                                    Color.theme.foreground.opacity(0.7),
                                    Color.green.opacity(0.7),
                                    Color.theme.foreground.opacity(0.7)
                                )
                            } description: {
                                Text(String(localized: "Your account is in good standing."))
                            }
                            .containerRelativeFrame(.vertical)
                        } else {
                            VStack {
                                
                                ForEach(controller.indictedModeratedContent, id: \.id) { violation in
                                    if let id = violation.id {
                                        violationRow(
                                            id: id,
                                            status: violation.status,
                                            reason: violation.reason,
                                            date: violation.updatedAt,
                                            profileId: violation.contentAuthorProfileId,
                                            type: violation.type,
                                            role: .user,
                                            observation: violation.observation,
                                        )
                                    }
                                }
                                
                            }
                            .padding(.top)
                        }
                    } else {
                        /// Your reports
                        if controller.myComplaints.isEmpty {
                            ContentUnavailableView {
                                Label(
                                    String(localized: "No reports yet."),
                                    systemImage: "info.bubble"
                                )
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(
                                    Color.theme.foreground.opacity(0.7),
                                    Color.theme.secondary,
                                    Color.theme.foreground.opacity(0.7)
                                )
                            } description: {
                                Text(String(localized: "You have not submitted any reports."))
                            }
                            .containerRelativeFrame(.vertical)
                        } else {
                            VStack {
                                ForEach(controller.myComplaints, id: \.id) { violation in
                                    if let id = violation.id {
                                        violationRow(
                                            id: id,
                                            status: violation.status,
                                            reason: violation.reason,
                                            date: violation.updatedAt,
                                            profileId: violation.contentAuthorProfileId,
                                            type: violation.type,
                                            role: .reporter,
                                            observation: violation.observation
                                        )
                                        .disabled(violation.status == .removed || violation.status == .approved)
                                    }
                                }
                            }
                            .padding(.top)
                        }
                    }
                }
            }
        }
        .navigationTitle("Reports and violations center")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.theme.background)
        .task {
            await controller.loadComplaints()
            await controller.loadIndictedData()
        }
        .alert(String(localized: "Do you want to appeal for removal"), isPresented: $controller.showAlert) {
            Button(role: .cancel) {} label: {
                Text(String(localized: "No, cancel", comment: ""))
            }
            Button(role: .confirm) {
                if let type = controller.selectedReportType {
                    controller.appealForReportRemoval(controller.selectedReportId, type)
                }
            } label: {
                Text(String(localized: "Yes, remove", comment: ""))
            }
        } message: {
            Text(String(localized: "Are you sure you want to appeal for removal of this report?", comment: ""))
        }
        .alert(String(localized: "Moderation report"), isPresented: $controller.showReportRemovalAlert) {
            Button(role: .cancel) {} label: {
                Label("No, cancel", systemImage: "xmark.circle.fill")
            }
            Button(role: .confirm) {
                if let type = controller.selectedReportType {
                    if type == .account {
                        controller.unlock(controller.selectedProfileId, reportId: controller.selectedReportId)
                    } else {
                        controller.remove(reportId: controller.selectedReportId, type: type)
                    }
                }
            } label: {
                Text(String(localized: "Yes, remove", comment: ""))
            }
            .accessibilityIdentifier("ConfirmRemoveModerationReport")
        } message: {
            Text(String(localized: "Are you sure you want to remove this moderation report?", comment: ""))
        }
        .alert(String(localized: "Moderation report"), isPresented: $controller.showConfirmationOfRemoval) {
            Button(role: .cancel) {} label: {
                Text(String(localized: "Close"))
            }
        } message: {
            Text(String(localized: "Your report has been removed."))
        }
    }
    
    @ViewBuilder
    private func violationRow(
        id: String,
        status: ReportViolationStatus,
        reason: String,
        date: Date? = nil,
        profileId: String,
        type: TypeOfContentToReport,
        role: ModerationRole,
        observation: String? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 80)
                    .overlay(
                        Image(systemName: type.icon)
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    )
                                
                Text("**Content type:** \(type.description)")
                    .font(.subheadline)
               
                
                Spacer()
                
                if role == .user {
                    /// Indicted user actions
                    
                    Menu {
                        
                        Button {
                            controller.selectedReportId = id
                            controller.selectedReportType = type
                            controller.selectedProfileId = profileId
                            controller.showAlert.toggle()
                            print("show appeal")
                        } label: {
                            Label("Appeal", systemImage: "text.badge.minus")
                        }
                        .accessibilityIdentifier("AppealForRemovalButton")
                        .disabled(!UserRepository.shared.isOwnProfile(profileId) || disableButtonByStatus(status))
                        
                    
                        Button {
                            UIPasteboard.general.string = id
                            Toast.shared.show(message: String(localized: "Moderation ID copied to clipboard"), type: .info)
                        } label: {
                            Label("Copy ID", systemImage: "doc.on.doc")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .tint(Color.primary)
                            .padding(12)
                            
                    }
                    .frame(minWidth: 44, minHeight: 44)
                    .contentShape(Rectangle())
                    .foregroundColor(UserRepository.shared.isOwnProfile(profileId) ? .primary : .gray)
                    
                
                } else {
                    
                    /// My reports actions
                    Menu {
                        
                        if type == .account {
                            Button {
                                controller.selectedReportId = id
                                controller.selectedReportType = type
                                controller.selectedProfileId = profileId
                                controller.showReportRemovalAlert.toggle()
                            } label: {
                                Label("Unlock user", systemImage: "lock.open")
                            }
                            .accessibilityIdentifier("UnlockUserButton")
                            
                        } else {
                            Button {
                                controller.selectedReportId = id
                                controller.selectedReportType = type
                                controller.selectedProfileId = profileId
                                controller.showReportRemovalAlert.toggle()
                            } label: {
                                Label("Remove from moderation", systemImage: "trash")
                            }
                            .accessibilityIdentifier("RemoveFromModerationButton")
                        }
                        
                       
                    } label: {
                        Image(systemName: "ellipsis")
                            .tint(Color.primary)
                            .padding(12)
                    }
                    .frame(minWidth: 44, minHeight: 44)
                    .contentShape(Rectangle())
                    
                }
                
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("Status")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(status.description)
                }
                
                HStack {
                    Text("Violation")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(reason)
                        .foregroundColor(Color.theme.secondary)
                }
                
                HStack {
                    Text("Last updated")
                        .fontWeight(.semibold)
                    Spacer()
                    if let date = date {
                        Text(date.formatted(date: .abbreviated, time: .omitted))
                    } else {
                        Text("Unknown")
                    }
                }
                
                VStack {
                    Text("Observations")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let observation = observation {
                        Text(observation)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineSpacing(4)
                    } else {
                        Text("None")
                            .frame(maxWidth: .infinity)
                            
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .font(.subheadline)
            
            Divider()
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .opacity(setOpacityByStatus(status))
    }
    
    
    private func setOpacityByStatus(_ status: ReportViolationStatus) -> Double {
        switch status {
        case .rejected:
            return 0.3
        case .appealing:
            return 0.3
        case .approved:
            return 0.3
        default:
            return 1
        }
    }
    
    private func disableButtonByStatus(_ status: ReportViolationStatus) -> Bool {
        switch status {
            case .rejected:
                return true
            case .appealing:
                return true
            case .approved:
                return true
            default:
                return false
        }
    }
    
}

#Preview {
    ReportsAndViolationsCenterView()
}
