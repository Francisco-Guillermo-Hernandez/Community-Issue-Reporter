//
//  UserProfileView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/2/26.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    let options: [String] = ["Settings", "Licenses"]
    
    var body: some View {
        NavigationStack {
            
            VStack {
                ZStack {
                    Image("user")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                
                VStack(spacing: 6) {
                    Text("Sophia Clark")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("San Francisco, CA")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                List(options, id: \.self) { option in
                    NavigationLink {
                        destinationView(for: option)
                    } label: {
                        Text(option)
                    }
                }
                .listStyle(.plain)
                .padding(.top, 32)
                
                VStack(spacing: 16) {
                    
                    Button(role: .destructive) {
                        UserRepository.logout()
                    } label: {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.bold)
                            .padding(8)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    
                }
                .padding(.bottom, 16)
                .padding(.top, 32)
                
            }
            .padding(.horizontal, 16)
            .toolbar {
                
                ToolbarItem(placement: .title) {
                    Text("Profile")
                }
                
                ToolbarItem(placement: .automatic) {
                    Button("Close", systemImage: "checkmark") {
                        dismiss()
                    }
                }
            }
            .presentationDetents([.fraction(0.55), .fraction(0.8)])
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
}

#Preview {
    UserProfileView()
}
