//
//  CitizenProfile.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 4/8/26.
//

import SwiftUI

struct CitizenProfile: View {
    
    @State private var controller = CitizenProfileController()
    @State private var mapExplorerController = MapExplorerController.shared
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var profileId: String
    
    init(with profileId: String) {
        self.profileId = profileId
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 4) {
                
                Group {
                    if let url = controller.citizen.profilePictureURL {
                        CachedAsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .id(url)
                        
                    } else {
                        Image("user_b")
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 130, height: 130)
                .clipShape(.circle)
                .glassEffect()
//                .overlay(Circle().stroke(.white, lineWidth: 4))
//                .shadow(color: .black.opacity(0.1), radius: 16, y: 8)
                .padding(.top, 16)
                
                
                Text(controller.citizen.names)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                
                Text(userAlias(controller.citizen.userName))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 16)
                
                
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
                            
                            Group {
                                if tab == .reports {
                                    
                                    if controller.fetchingReports && controller.reports.isEmpty {
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                            .controlSize(.large)
                                    }
                                    
                                    if controller.reports.isEmpty {
                                        VStack {
                                            ContentUnavailableView {
                                                Label(
                                                    "No reports yet.",
                                                    systemImage: "exclamationmark.bubble"
                                                )
                                                .symbolRenderingMode(.palette)
                                                .foregroundStyle(
                                                    Color.theme.foreground.opacity(0.7),
                                                    Color.theme.primary,
                                                    Color.theme.foreground.opacity(0.7)
                                                )
                                            } description: {
                                                Text("Please sent us reports.")
                                            }
                                        }
                                        .frame(width: controller.containerSize.width, alignment: .leading)
                                    } else {
                                        VStack(spacing: 16) {
                                            
                                            ForEach(controller.reports) { report in
                                                ReportCellView(report: report)
                                                    .cellStyle()
                                            }
                                        }
                                        .padding(.top, 16)
                                        .padding(.horizontal, 16)
                                        .frame(width: controller.containerSize.width, alignment: .leading)
                                        
                                    }
                                }
                                
                                if tab == .petitions {
                                    VStack {
                                        ContentUnavailableView {
                                            Label("No petitions yet.", systemImage: "person.bubble")
                                                .symbolRenderingMode(.palette)
                                                .foregroundStyle(
                                                    Color.theme.foreground.opacity(0.7),
                                                    Color.theme.primary,
                                                    Color.theme.foreground.opacity(0.7)
                                                )
                                        } description: {
                                            Text(
                                                "Please create petitions in order to accelerate the process of ..."
                                            )
                                        }
                                        
                                        
                                    }
                                    .padding(.top, 16)
                                    .padding(.horizontal, 16)
    //                                .frame(maxWidth: .infinity)
//                                    .frame(width: controller.containerSize.width, alignment: .center)
                                }
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
            BlockUserSheet(controller.citizen)
        }
        .background {
            
            ZStack(alignment: .top) {
                GeometryReader { geo in
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.theme.secondary.mix(with: colorScheme == .dark ? .black : .white, by: 0.3).opacity(0.85),
                            Color.theme.secondary.opacity(0)
                            
                        ]),
                        center: .topTrailing,
                        startRadius: 0,
                        endRadius: geo.size.width * 0.8
                    )
                    
                }
                
                LinearGradient(
                    colors: [Color.theme.secondary.opacity(0.11), Color.theme.background],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 350)
            }
            .ignoresSafeArea()
        }
        .task {
            await controller.fetchCitizenPublicProfile(profileId)
            
            if !controller.citizen.hideProfile {
                await controller.fetchReports(profileId)
            }
        }
        .background(Color.theme.background)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .enableInteractivePopGesture()
        .skeleton(isRedacted: controller.isLoading)
        .toolbar {
            if !UserRepository.shared.isOwnProfile(profileId) {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        
                        Button {
                            UIPasteboard.general.string = controller.citizen.profileId
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        } label: {
                            Label("Copy Profile ID", systemImage: "document.on.document")
                        }
                        .accessibilityIdentifier("CopyProfileIDButton")
                        
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
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .close) {
                    mapExplorerController.expandedItem = nil
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
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var reason: String = ""
    @State private var isReasonValid: Bool = false
    @State private var blockedReasonId: ReportReason = .wrongInformation
    @State private var isLoading: Bool = false
    @State private var message: String = String(localized: "Block User")
    @State private var showAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var wasSend: Bool = false
    
    let user: User
    
    init (_ user: User) {
        self.user = user
    }
    
    var body: some View {
        
        
        NavigationStack {
            ScrollView {
                
                
                VStack(spacing: 12) {
                    
                    LabelView(text: String(localized: "Reason"), isDisabled: false)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("Select Reason", selection: $blockedReasonId) {
                        ForEach(ReportReason.allCases) { reason in
                            Text(reason.title).tag(reason)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .cornerRadius(12)
                    
                    TextInput(
                        name: String(localized: "Why are you reporting this user?"),
                        label: String(localized: "Enter details here..."),
                        validators: blockReasonValidator,
                        axis: .vertical,
                        isValid: $isReasonValid,
                        value: $reason
                    )
                    
                    
                    
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                ThemedButton(
                    message: message,
                    action: {
                        showAlert.toggle()
                    },
                    type: .danger,
                    isLoading: $isLoading
                )
                .disabled(!isReasonValid || wasSend)
                .padding()
                .padding(.top, 0)
            }
            .padding(.horizontal)
            .navigationTitle("Block User")
            .navigationBarTitleDisplayMode(.inline)
            .alert(String(localized: "Block User"), isPresented: $showAlert) {
                
                Button(String(localized: "Cancel"), role: .cancel) {}
                
                Button(String(localized: "Send Request"), role: .confirm) {
                    report(user)
                }
            } message: {
                Text(String(localized: "Are you sure you want to block this user?"))
            }
            .alert(String(localized: "An error occurred while reporting the user"), isPresented: $showErrorAlert) {
                
                Button(String(localized: "Cancel"), role: .cancel) {}
                Button(String(localized: "Send Request Again"), role: .confirm) {
                    report(user)
                }
            } message: {
                Text(String(localized: "Failed to report user, please try again"))
            }
            .alert(String(localized: "We've received your report"), isPresented: $wasSend) {
                
                Button(String(localized: "Ok"), role: .close) {
                    dismiss()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .cancel) { dismiss() }
                }
            }
            .background(Color.theme.background)
        }
        
    }
    
    private func report(_ user: User) {
        isLoading = true
        Task {
            do {
                
                let payload: ReportViolation = .init(
                    type: .account,
                    content: user ,
                    profileId: user.profileId,
                    reason: reason,
                    blockedReasonId: blockedReasonId.rawValue,
                    status:  .pending
                )
            
                _ = try await ModerationRepository.shared
                    .moderateAccount(
                        reason: payload,
                        type: .account
                    )
                
                _ = try await UserRepository.shared
                    .block(
                        .init(
                            profileId: user.profileId,
                            reason: reason,
                            blockedReasonId: blockedReasonId
                        )
                    )
                
                reason = ""
                message = String(localized: "Your report has been submitted")
                
                _ = KeychainService.addToArray(key: .blockedUsers, element: user.profileId)
                
                wasSend.toggle()
            } catch {
                showErrorAlert.toggle()
            }
            
            isLoading = false
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

#Preview("BlockSheet") {
    BlockUserSheet(
        User(
            names: "Jane Doe",
            userName: "jane.doe",
            profilePicture: "/avatars/019f4f22-1464-7336-8406-853b453b026d.png",
            profileId: "uiEw3sSu1zcQ1U9",
            userSince: Date(),
            hideProfile: false
        )
    )
}
