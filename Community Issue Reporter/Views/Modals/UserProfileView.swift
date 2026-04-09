//
//  UserProfileView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/2/26.
//

import SwiftUI

struct UserProfileView: View {
    @State private var sheetSizePreference = "normal"
    @Environment(\.dismiss) private var dismiss
    @Environment(\.mySettings) private var settings
    @State private var showSheet = false
    @State private var sheetDetents: Set<PresentationDetent> = [.fraction(0.55)]
    @State private var selectedOption: String = ""
    
    let options: [String] = ["Settings", "Licenses"]
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                VStack(spacing: 6) {
                    Image("user_b")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                    Text("Visitor")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(countryName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                List(options, id: \.self) { option in
                    
                    Button {
                        selectedOption = option
                        showSheet.toggle()
                    } label: {
                        HStack {
                            Text(option)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    
                }
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .sheet(isPresented: $showSheet) {
                    destinationView(for: selectedOption)
                        .presentationDetents([.fraction(0.78)])
                }
                
                VStack(spacing: 16) {
                    
                    Button(role: .destructive) {
                        UserRepository.logout()
                    } label: {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.bold)
                            .padding(8)
                    }
                    .buttonSizing(.flexible)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    
                }
                .padding()
                
            }
            .toolbar {
                
                ToolbarItem(placement: .title) {
                    Text("Profile")
                }
                
                ToolbarItem(placement: .automatic) {
                    Button("Close", systemImage: "checkmark") {
                        dismiss()
                    }
                    .buttonStyle(.glassProminent)
                }
            }
            .presentationDetents(sheetDetents)
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    
    @ViewBuilder
    private func destinationView(for option: String) -> some View {
        switch option {
        case "Settings":
            SettingsSubView(subViewName: option)
        case "Licenses":
            LicensesSubView(subViewName: option)
        default:
            Text("\(option) selected")
        }
    }
    
    
    private var region: GeographicalRegion {
        return geographicalRegions.first(where: { $0.id == settings.geographicalRegion })!
    }
    
    private var countryName: String {
        return region.countries.first(where: { $0.id == settings.selectedCountry })?.name ?? "Unknown"
    }
    
}

#Preview {
    UserProfileView()
}
