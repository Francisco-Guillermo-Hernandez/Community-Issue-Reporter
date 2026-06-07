//
//  PetitionDetailView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 21/2/26.
//

import SwiftUI



// MARK: - View
struct PetitionDetailView: View {
    var petition: Petition
    var offline: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Image("pothole")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipped()
                        .cornerRadius(12)
                        .padding(.top, 4)
                    
                    SectionHeader(title: "Description")
                    Text(petition.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    SectionHeader(title: "Category")
                    Text(getCategoryName(id: petition.categoryId))
                    
                    SectionHeader(title: "Location")
                    HStack(alignment: .top, spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 32, height: 32)
                            Image(systemName: "mappin")
                                .foregroundStyle(.gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Intersection of Main St and Elm St")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("123 Main St, Anytown, USA")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Text("Latitude: 99")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Text("Longitude: 99")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    
                    SectionHeader(title: "Severity")
                    HStack(spacing: 16) {

                        Circle()
                            .fill(.ultraThinMaterial)
                                       .frame(width: 32, height: 32)
                                       .overlay {
                                           Image(systemName: "exclamationmark.triangle")
                                               .foregroundStyle(.gray)
                                       }
                        Text("High")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    
                    SectionHeader(title: "Confirmation Status")
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.seal")
                            .foregroundStyle(.gray)
                        Text("Confirmed by 3 users")
                            .font(.subheadline)
                            .fontWeight(.medium)
        
                    }
                    
                    SectionHeader(title: "Petition")
                    VStack(spacing: 8) {
                        Gauge(value: 29.5, in: 0...100) {
                            Text(String(localized: "Signatures", comment: "Signatures text at the bottom of the gauge"))
                                .font(.caption)
                                .fontWeight(.medium)
                        } currentValueLabel: {
                            Text("\(Int(29.5)) %")
                        }
                        .gaugeStyle(.accessoryLinearCapacity)
                        
                            
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    /// Comments section
                    SectionHeader(title: "Comments")
                    VStack(spacing: 16) {
                       
//                        ForEach(1..<5) { _ in
//                            CommentRow(name: "Ethan Carter", time: "2d", message: "This pothole is really dangerous! I almost lost control of my car last night...................... demo deo demo demo")
//                            
//                            CommentRow(name: "Ethan ", time: "1d", message: "This ")
//                        }
                        
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .background(Color.theme.background)
            .toolbar {
                
                ToolbarItem(placement: .title) {
                    Text(petition.title)
                }
                
                ToolbarItem() {
                    Button("Sign petition") {
                        
                    }
                    
                }
                
                ToolbarSpacer(.fixed)
                
                ToolbarItem() {
                    ShareLink(item: buildShareURL(for: "7BTheYpPwK1L/report/traffic-light-ou")!) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
            
        }
//        .overlay {
//           if offline {
//               ContentUnavailableView {
//                   Label("Connection Issue", systemImage: "wifi.slash")
//               } description: {
//                   Text("Check your internet connection and try again.")
//               } actions: {
//                   Button("Refresh") {}
//               }
//            }
//        }
    }
    
    
}

// MARK: - Section
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.top, 16)
            .fontWeight(.bold)
    }
}

// MARK: - Comment row
struct CommentRow: View {
    let name: String
    let time: Date
    let message: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay {
                    Text(String(name.prefix(1)))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(formatRelativeDate(from: time))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Divider()
    }
}

#Preview {

    @Previewable
    @State var petition: Petition = .init(
        id: "",
        title: "Fix those roads, please",
        description: "",
        targetSignatures: 100,
        currentSignatures: 20,
        categoryId: 1,
        statusId: 1,
        reportedBy: UUID(),
        disabled: false,
        createdAt: Date(),
        updatedAt: Date(),
        reportsIds: []
    )

    PetitionDetailView(petition: petition)
}
