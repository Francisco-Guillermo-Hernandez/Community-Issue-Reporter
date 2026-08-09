//
//  UserProfileView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/2/26.
//

import SwiftUI
import PhotosUI

struct ProfileOption: Identifiable, Hashable {
    let id: String
    let title: String
    let icon: String
    let color: Color
}

struct UserProfileView: View {
    @State private var navigationPath: [InsightsNavigation] = []
    @State private var sheetSizePreference = "normal"
    @State private var show: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.mySettings) private var settings
    @State private var showSheet = false
    @State private var selectedOption: String = ""
    @State var controller = LandingController.shared
    @State private var profile = ProfileDataModel()
    @State private var profileRouter = ProfileRouter.shared
    
    let options: [ProfileOption] = [
        ProfileOption(
            id: "op:reports",
            title: String(localized: "My Reports"),
            icon: "bubble.left.and.exclamationmark.bubble.right.fill",
            color: Color.blue
        ),
        ProfileOption(
            id: "op:comments",
            title: String(localized: "My Comments"),
            icon: "text.bubble.fill",
            color: Color.orange
        ),
        ProfileOption(
            id: "op:signPetitions",
            title: String(localized: "My Sign petitions"),
            icon: "signature",
            color: Color.purple
        ),
        ProfileOption(
            id: "op:settings",
            title: String(localized: "Settings"),
            icon: "gear",
            color: Color.gray
        ),
        ProfileOption(
            id: "op:licenses",
            title: String(localized: "Licenses"),
            icon: "text.page.fill",
            color: Color.green
        ),
    ]

    var body: some View {
        NavigationStack(path: $profileRouter.path) {
            
            ScrollView(.vertical) {
                
                VStack(spacing: 4) {
                    
                    ProfileImage(viewModel: profile)
                        .padding(.bottom, 8)
                        .disabled(controller.isGuest)
                    
                    Text(UserRepository.shared.getName())
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(userAlias(UserRepository.shared.getUsername()))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                List(options, id: \.self) { option in
                    
                    Button {
                        switch option.id {
                        case "op:reports":
                            profileRouter.goTo(.reports)
                        case "op:comments":
                            profileRouter.goTo(.comments)
                        case "op:signPetitions":
                            profileRouter.goTo(.signPetitions)
                        case "op:settings":
                            profileRouter.goTo(.settings)
                        case "op:licenses":
                            profileRouter.goTo(.licenses)
                        default:
                            break
                        }
                    } label: {
                        HStack {
                            
                            RoundedRectangle(cornerRadius: .themeRadius, style: .continuous)
                                .fill(option.color.slantedGradient)
                                .frame(width: 36, height: 36)
                                .overlay {
                                    Image(systemName: option.icon)
                                        .font(Font.system(size: 16, weight: .medium))
                                        .foregroundStyle( Color.white)
                                }
                                .padding(.trailing, 8)
                            
                            
                            Text(option.title)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.theme.inputText)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(uiColor: .tertiaryLabel))
                        }
                    }
                }
                .frame(height: 500)
                .contentMargins(.top, 16, for: .scrollContent)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .navigationDestination(for: ProfileDestinations.self) { destination in
                    destinationView(for: destination)
                }
                
            }
            .background(Color.theme.background)
            .overlay {
                if profile.showPicker {
                    CustomBlurryOverlay(show: $profile.showPicker)
                        
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button(role: .destructive) {
                    Task {
                        do {
                            
                            _ = try await UserRepository.shared.logout()
                            controller.logout()
                            dismiss()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text(String(localized: "Log Out"))
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .padding(8)
                }
                .accessibilityIdentifier("LogoutButton")
                .buttonSizing(.flexible)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .padding()
                .padding(.top, 0)
               
            }
            .task {
                profile.isGuest = controller.isGuest
                profile.setUserName(UserRepository.shared.getName())
            }
            .toolbar {
                
                ToolbarItem(placement: .title) {
                    Text(String(localized: "Profile"))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
    
    @ViewBuilder
    private func destinationView(for destination: ProfileDestinations) -> some View {
        switch destination {
        case .settings:
            SettingsSubView(subViewName: String(localized: "Settings"))
        case .licenses:
            LicensesSubView(subViewName: String(localized: "Licenses"))
        case .comments:
            CommentsSubView(subViewName: String(localized: "My Comments"), mode: .listAndModify)
        case .reports:
            MyReportsSubView(path: $navigationPath, subViewName: String(localized: "My Reports"), mode: .listAndModify)
        case .signPetitions:
            MyPetitionsSubView(path: $navigationPath, subViewName: String(localized: "My Sign petitions"), mode: .listAndModify)
        }
    }
    
    
    private var region: GeographicalRegion {
        return geographicalRegions.first(where: { $0.id == settings.geographicalRegion })!
    }
    
    private var countryName: String {
        return region.countries.first(where: { $0.id == settings.selectedCountry })?.name ?? "Earth"
    }
    
}

#Preview {
    UserProfileView()
        .environmentObject(AuthViewModel())
        .environment(NotificationManager())
        .environment(SettingsStore())
        .environment(NetworkMonitor())
        .environment(SubscriptionManager.shared)
}


extension Color {
    var slantedGradient: LinearGradient {
        LinearGradient(
            colors: [self, self.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
