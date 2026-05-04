//
//  UserProfileView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/2/26.
//

import SwiftUI

struct ProfileOption: Identifiable, Hashable {
    let id: String
    let title: String
    let icon: String
    let color: Color
}

struct UserProfileView: View {
    @State private var path = NavigationPath()
    @State private var sheetSizePreference = "normal"
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.mySettings) private var settings
    @State private var showSheet = false
    @State private var selectedOption: String = ""
    @EnvironmentObject var appState: AuthViewModel
    
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

    var body: some View {
        NavigationStack {
            
            ScrollView(.vertical) {
                
                VStack(spacing: 8) {
                    if let url = UserRepository.getProfilePictureURL() {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    } else {
                        Image("user_b")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    
                    Text(UserRepository.getName())
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(countryName)
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
                        
                    }
                }
//                .listRowSeparator(.hidden)
//                .listRowBackground(Color.clear)
//                .listStyle(.plain)
//                .listSectionSpacing(32)
                .frame(height: 500)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                
            }
            .safeAreaInset(edge: .bottom) {
                Button(role: .destructive) {
                    appState.logout()
                    dismiss()
                } label: {
                    Text(String(localized: "Log Out"))
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
            MyReportsSubView(subViewName: option.title)
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
