//
//  ReportsAndViolationsCenterView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez.
//

import SwiftUI

struct ReportsAndViolationsCenterView: View {
    
    @State private var selectedTab: Int = 0
    @State private var selectedType: ViolationContentType = .attachment
    
    @State private var myComplaints: [ReportViolation<ModeratedContent>] = []
    @State private var indictedAttachments: [ReportViolation<PreviewAttachment>] = []
    @State private var indictedComments: [ReportViolation<CommentToBlock>] = []
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    enum ViolationContentType: String, CaseIterable {
        case attachment = "Attachments"
        case comment = "Comments"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Find information related with your content such as images, comments, reports, and petitions that violate our Community Guidelines. If you believe your we've mistakenly taken action , you can submit an appeal to have the action reversed.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
            
            // Tabs
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
                        // Your account
                        VStack {
                            Picker("Type", selection: $selectedType) {
                                ForEach(ViolationContentType.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .onChange(of: selectedType) { _, _ in
                                Task { await loadIndictedData() }
                            }
                            
                            if selectedType == .attachment {
                                ForEach(indictedAttachments, id: \.id) { violation in
                                    violationRow(status: violation.status.description, reason: violation.reason, date: violation.updatedAt)
                                }
                            } else {
                                ForEach(indictedComments, id: \.id) { violation in
                                    violationRow(status: violation.status.description, reason: violation.reason, date: violation.updatedAt)
                                }
                            }
                        }
                    } else {
                        // Your reports
                        VStack {
                            ForEach(myComplaints, id: \.id) { violation in
                                violationRow(status: violation.status.description, reason: violation.reason, date: violation.updatedAt)
                            }
                        }
                        .padding(.top)
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
    private func violationRow(status: String, reason: String, date: Date?) -> some View {
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
                
                Text(selectedType == .attachment ? "Attachment" : "Comment")
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("Status")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(status)
                }
                
                HStack {
                    Text("Violation")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(reason)
                        .foregroundColor(.blue)
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
            if selectedType == .attachment {
                let response = try await ModerationRepository.shared.indictedModeratedContent(profileId: profileId, type: .image)
                if let docs = response.documents {
                    indictedAttachments = docs
                }
            } else {
                let response = try await ModerationRepository.shared.indictedModeratedMessages(profileId: profileId, type: .comment)
                if let docs = response.documents {
                    indictedComments = docs
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
