//
//  UserProfileView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/2/26.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.dismiss) private var dismiss

    private struct ReportItem: Identifiable {
        let id = UUID()
        let title: String
        let dateText: String
        let imageName: String
    }

    private let reports: [ReportItem] = [
        ReportItem(title: "Pothole on Elm Street", dateText: "Reported on 05/15/2024", imageName: "pothole"),
        ReportItem(title: "Road damage on Oak Avenue", dateText: "Reported on 04/20/2024", imageName: "pothole_b"),
        
        ReportItem(title: "Road damage on Oak Avenue", dateText: "Reported on 04/20/2024", imageName: "pothole_b"),
        ReportItem(title: "Road damage on Oak Avenue", dateText: "Reported on 04/20/2024", imageName: "pothole_b"),
    ]
    
    let options: [String] = ["My Reports", "My Petitions", "Signed Petitions"]
    
    @State private var selectedOption: String = "My Reports"

    var body: some View {
        NavigationStack {
        
           
        
        ScrollView {
            VStack(spacing: 16) {

                ScrollView {
                    ZStack {
                        Image("user")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 128)
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
                    

                    VStack(alignment: .leading, spacing: 16) {
                        
                        
                       
                        Picker("Options", selection: $selectedOption) {
                            ForEach(options, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.top, 32)

                        VStack(spacing: 14) {
                            ForEach(reports) { report in
                                HStack(spacing: 12) {
                                    Image(report.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 52, height: 52)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(report.title)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.primary)

                                        Text(report.dateText)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer(minLength: 0)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 16) {
                        
                        Button(role: .destructive) {
                            
                        }
                        label: {
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
                    
                    
                    
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Settings")
//                            .font(.headline)
//                            .fontWeight(.semibold)
//                            .foregroundStyle(.primary)
//
//                        VStack(alignment: .leading, spacing: 18) {
//                            Text("Change language")
//                            Text("Credits...")
//                            Text("Coming soon ......")
//                        }
//                        .font(.subheadline)
//                        .foregroundStyle(.primary)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.horizontal, 16)
            .toolbar {
                
                ToolbarItem(placement: .title) {
                    Text("Profile")
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
                
//                .padding(.horizontal, 16)
                
        }
    }
}

#Preview {
    UserProfileView()
}
