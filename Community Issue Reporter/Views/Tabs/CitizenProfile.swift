//
//  CitizenProfile.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 4/8/26.
//

import SwiftUI

struct CitizenProfile: View {
     
    @State private var controller = CitizenProfileController()
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var profileId: String
    
    init(with profileId: String) {
        self.profileId = profileId
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 8) {
                
                Image("user_b")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    .clipShape(.circle)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                    .padding(.top, 24)
                    
                
                Text(controller.citizen.names)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                
                
                HStack(spacing: 16) {
                    Text("**\(controller.reportsSubmitted)** Reports submitted")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("**\(controller.petitionsPublished)** Petitions published")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 24)
                
                XStyleTabBar<AppTab>(progress: controller.scrollProgress) { tab in
                    /// Updating ScrollView
                    withAnimation(.easeInOut(duration: 0.25)) {
                        let index = AppTab.allCases.firstIndex(of: tab) ?? 0
                        controller.scrollPosition.scrollTo(x: CGFloat(index) * controller.containerSize.width)
                    }
                }
                .padding(.horizontal, 24)
                .background(alignment: .bottom) {
                    Rectangle()
                        .fill(.gray.tertiary)
                        .frame(height: 1)
                }
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 12) {
                        ForEach(AppTab.allCases, id: \.rawValue) { tab in
                            VStack {
                                Text(tab.rawValue)
                                    .containerRelativeFrame(.horizontal)
                                    .frame(maxHeight: .infinity, alignment: .top)
                                    .padding(.top, 100)
                                
                                Text("demo")
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollPosition($controller.scrollPosition)
                /// Calculating Scroll Progress
                .onScrollGeometryChange(for: CGFloat.self) {
                    ($0.contentOffset.x + $0.contentInsets.leading) / $0.containerSize.width
                } action: { oldValue, newValue in
                    controller.scrollProgress = newValue
                }
                .onScrollGeometryChange(for: CGSize.self) {
                    $0.containerSize
                } action: { oldValue, newValue in
                    controller.containerSize = newValue
                }
            }
        }
        .sheet(isPresented: $controller.showBlockUserSheet) {
            BlockUserSheet(profileId: profileId)
        }
        .background {
            VStack {
                LinearGradient(
                    colors: [Color.theme.secondary.opacity(0.6), Color.theme.background],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 300)
                Spacer()
            }
            .ignoresSafeArea()
        }
        .task {
            await controller.fetchCitizenPublicProfile(profileId)
        }
        .background(Color.theme.background)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .enableInteractivePopGesture()
        .toolbar {
            
           
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        controller.showBlockUserSheet.toggle()
                    } label: {
                        Label("Report User", systemImage: "hand.raised.slash.fill")
                    }
                    .accessibilityIdentifier("ReportCitizenButton")
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
                }
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

}

// MARK: - Definitions:  enums
enum ReportReason: String, CaseIterable, Identifiable, Encodable {
    // Existing
    case wrongInformation
    case harassment
    case selfPromotion
    
    // Safety & Abuse
    case hateSpeech
    case violence
    case explicitContent
    
    // Privacy & Security
    case privacyViolation
    case impersonation
    
    // Platform Integrity
    case spam
    case duplicate
    
    // Fallback
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .wrongInformation:
            return String(localized: "Wrong information")
        case .harassment:
            return String(localized: "Harassment or bullying")
        case .selfPromotion:
            return String(localized: "Unwanted self-promotion")
        case .hateSpeech:
            return String(localized: "Hate speech or discrimination")
        case .violence:
            return String(localized: "Threats or violence")
        case .explicitContent:
            return String(localized: "Inappropriate or explicit content")
        case .privacyViolation:
            return String(localized: "Privacy violation or personal data")
        case .impersonation:
            return String(localized: "Impersonation or fake account")
        case .spam:
            return String(localized: "Spam or scam")
        case .duplicate:
            return String(localized: "Duplicate report")
        case .other:
            return String(localized: "Other issue")
        }
    }
    
    /// Optional helper to group by severity for backend routing or UI callouts
    var isUrgent: Bool {
        switch self {
        case .violence, .harassment, .privacyViolation:
            return true
        default:
            return false
        }
    }
}


enum AppTab: String, XStyleTabItem {
    case reports = "Reports"
    case petitions = "Petitions"
    
    var title: String {
        rawValue
    }
    
    var description: String {
        switch self {
            case .petitions:
                return String(localized: "Petitions")
            case .reports:
                return String(localized: "Reports")
        }
    }
    
    var symbol: String {
        switch self {
        case .reports:
            return "bubble.left.and.exclamationmark.bubble.right.fill"
        case .petitions:
            return "signature"
        }
    }
}


// MARK: - Sheet
struct BlockUserSheet: View {
    let profileId: String
    @Environment(\.dismiss) private var dismiss
    
    @State private var reason: String = ""
    @State private var isReasonValid: Bool = false
    @State private var blockedReasonId: ReportReason = .wrongInformation
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Report Reason")
                            .font(.headline)
                        
                        Picker("Select Reason", selection: $blockedReasonId) {
                            ForEach(ReportReason.allCases) { reason in
                                Text(reason.title).tag(reason)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color.theme.secondary.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        TextInput(
                            name: String(localized: "Why are you reporting this user?"),
                            label: String(localized: "Enter details here..."),
                            validators: blockReasonValidator,
                            axis: .vertical,
                            isValid: $isReasonValid,
                            value: $reason
                        )
                    }
                    
                    Spacer(minLength: 40)
                    
                    ThemedButton(
                        message: "Block User",
                        action: {
                            reportUser()
                        },
                        type: .primary,
                        isLoading: $isLoading
                    )
                    .disabled(!isReasonValid)
                }
                .padding()
            }
            .navigationTitle("Block User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func reportUser() {
        isLoading = true
        Task {
            do {
                let payload = BlockUserReason(profileId: profileId, reason: reason, blockedReasonId: blockedReasonId)
                _ = try await UserRepository.shared.reportUser(payload)
                isLoading = false
                dismiss()
            } catch {
                isLoading = false
                Toast.shared.show(message: String(localized: "An error occurred while reporting the user"), type: .error)
            }
        }
    }
}


#Preview {
    @Previewable @State var isLoading: Bool = false
    let profileId: String = "123456789"
    NavigationStack {
        
        CitizenProfile(with: profileId)
            .skeleton(isRedacted: isLoading)
    }
}
