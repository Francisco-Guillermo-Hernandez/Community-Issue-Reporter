//
//  ReportsAndViolationsCenterView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez.
//

import SwiftUI

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

struct ReportsAndViolationsCenterView: View {
    
    @State private var selectedTab: Int = 0
    @State private var selectedType: ViolationContentType = .attachment
    
    @State private var myComplaints: [ReportViolation<ModeratedContent>] = []
    @State private var indictedAttachments: [ReportViolation<PreviewAttachment>] = []
    @State private var indictedComments: [ReportViolation<CommentToBlock>] = []
    @State private var indictedModeratedContent: [ReportViolation<ModeratedContent>] = []
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @State private var showAlert: Bool = false
    
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
                Button(action: { selectedTab = 0 }) {
                    VStack {
                        Text("Your account")
                            .font(.subheadline)
                            .fontWeight(selectedTab == 0 ? .semibold : .regular)
                            .foregroundColor(selectedTab == 0 ? .primary : .secondary)
                        
                        Rectangle()
                            .fill(selectedTab == 0 ? Color.primary : Color.clear)
                            .frame(height: 2)
                    }
                }
                
                Button(action: { selectedTab = 1 }) {
                    VStack {
                        Text("Your reports")
                            .font(.subheadline)
                            .fontWeight(selectedTab == 1 ? .semibold : .regular)
                            .foregroundColor(selectedTab == 1 ? .primary : .secondary)
                        
                        Rectangle()
                            .fill(selectedTab == 1 ? Color.primary : Color.clear)
                            .frame(height: 2)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            Divider()
            
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    if selectedTab == 0 {
                        /// Your account
                        if indictedModeratedContent.isEmpty {
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
                                
                                ForEach(indictedModeratedContent, id: \.id) { violation in
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
                        if myComplaints.isEmpty {
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
                                ForEach(myComplaints, id: \.id) { violation in
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
            await loadComplaints()
            await loadIndictedData()
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
                        Image(systemName: "slash.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    )
                                
                Text("**Content type:** \(type.description)")
                    .font(.subheadline)
               
                
                Spacer()
                
                if role == .user {
                    // Indicted user actions
                    
                    Menu {
                        
                        Button {
                            showAlert.toggle()
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
                    .alert(String(localized: "Do you want to appeal for removal"), isPresented: $showAlert) {
                        
                        Button(role: .cancel) {
                            
                        } label: {
                            Text(String(localized: "No, cancel", comment: ""))
                        }
                        
                        Button(role: .confirm) {
                            appealForReportRemoval(id, type)
                        } label: {
                            Text(String(localized: "Yes, remove", comment: ""))
                        }
                        
                    } message: {
                        Text(String(localized: "Are you sure you want to appeal for removal of this report?", comment: ""))
                    }
                    
                
                } else {
                    Menu {
                        
                        if type == .account {
                            Button {
                                unlock(profileId: "")
                            } label: {
                                Label("Unlock user", systemImage: "lock.open")
                            }
                        } else {
                            Button {
                                
                            } label: {
                                Label("Remove from moderation", systemImage: "trash")
                            }
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
    }
    
    private func loadComplaints() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await ModerationRepository.shared.myComplaints()
            
            print("my complaints")
            print(response)
            if let docs = response.documents {
                myComplaints = docs
                
                print(myComplaints)
            }
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    private func loadIndictedData() async {
        
        let profileId = KeychainService.getToken(.profileId)
        guard !profileId.isEmpty else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            
            let response = try await ModerationRepository.shared.indictedModeratedContent()
            if let documents = response.documents {
                indictedModeratedContent = documents
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func appealForReportRemoval(_ id: String, _ type: TypeOfContentToReport) {
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
    
    private func unlock(profileId: String) -> Void {
        Task {
            do {
                _ = try await UserRepository.shared.unlock(profileId)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ReportsAndViolationsCenterView()
}
