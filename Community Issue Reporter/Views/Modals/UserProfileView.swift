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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.mySettings) private var settings
    @State private var showSheet = false
    @State private var selectedOption: String = ""
    @EnvironmentObject var appState: AuthViewModel
    @ObservedObject var profile = ProfileDataModel()
    
    init () {
        
    }
    
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
            id: "op:licenses",
            title: String(localized: "Licenses"),
            icon: "text.page.fill",
            color: Color.green
        ),
        ProfileOption(
            id: "op:settings",
            title: String(localized: "Settings"),
            icon: "gear",
            color: Color.gray
        ),

    ]
//    @ObservedObject var viewModel: ProfileModel

    var body: some View {
        NavigationStack {
            
            ScrollView(.vertical) {
                
                VStack(spacing: 4) {
//                    
                    ProfileImage(viewModel: profile)
                        .padding(.bottom, 8)
                    
                    Text(UserRepository.shared.getName())
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(userAlias(UserRepository.shared.getUsername()))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                List(options, id: \.self) { option in
                    
                    NavigationLink(destination: destinationView(for: option)) {
                        HStack {
                            
                            RoundedRectangle(cornerRadius: .themeRadius, style: .continuous)
                                .fill(option.color.slantedGradient)
                                .frame(width: 36, height: 36)
                                .overlay {
                                    Image(systemName: option.icon)
                                        .font(Font.system(size: 17, weight: .medium))
                                        .foregroundStyle( Color.white)
                                }
                                
                                .padding(.trailing, 8)
                            
                            
                            Text(option.title)
                                
                           
                           
                        }
//                        .cellStyle()
                        
                    }
                }
//                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
//                .listStyle(.plain)
//                .listSectionSpacing(32)
                .frame(height: 500)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                
            }
            .background(Color.theme.background)
            .overlay {
                if profile.showPicker {
                    CustomBlurryOverlay(show: $profile.showPicker)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button(role: .destructive) {
                    appState.logout()
                    dismiss()
                } label: {
                    Text(String(localized: "Log Out"))
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .padding(8)
                }
                .buttonSizing(.flexible)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .padding()
                .padding(.top, 0)
               
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .close) { dismiss() }
                }
                
                ToolbarItem(placement: .title) {
                    Text(String(localized: "Profile"))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
    
    @ViewBuilder
    private func destinationView(for option: ProfileOption) -> some View {
        
        switch option.id {
        case "op:settings":
            SettingsSubView(subViewName: option.title)
        case "op:licenses":
            LicensesSubView(subViewName: option.title)
        case "op:comments":
            CommentsSubView(subViewName: option.title)
        case "op:reports":
            MyReportsSubView(path: $navigationPath, subViewName: option.title)
        case "op:signPetitions":
            MyPetitionsSubView(path: $navigationPath, subViewName: option.title)
            
        default:
            Text("\(option.id) selected")
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
