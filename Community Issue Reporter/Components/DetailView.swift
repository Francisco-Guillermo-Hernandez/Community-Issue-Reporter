//
//  DetailView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import SwiftUI
import CoreLocation

struct PhotoSample:Identifiable {
    let id: String
    let photo: String
}

struct DetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric var adaptiveSpacing: CGFloat = 20
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var photos: [PhotoSample] = [
        PhotoSample(id: "1", photo: "a"),
        PhotoSample(id: "2", photo: "b"),
        PhotoSample(id: "3", photo: "c"),
        PhotoSample(id: "4", photo: "d"),
    ]
    
    var issue: IssueMarker
    @State private var color: Color
    @State private var commentButtonPressed: Bool = false
    @State private var showConfirmationDialogRaiseHand: Bool = false
    @State private var showConfirmationDialogAddNotification: Bool = false
    
    init(issue: IssueMarker) {
        self.issue = issue
        self.color = self.issue.status.color
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    VStack( spacing: 4) {
                        Text(issue.title)
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(issue.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 16)
                    
                    
                    
                    HStack(spacing: 17) {
                        
                        Group {
                            VStack {
                                Text("Reported at")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(color.mix(with: .black, by: 0.4))
                                
                                Text("04/02/2026")
                                    .font(.footnote)
                                    .foregroundStyle(color)
                                
                            }
                            
                            VStack {
                                Text("Issue Type")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(color.mix(with: .black, by: 0.4))
                                
                                Text(issue.issueType.title)
                                    .font(.footnote)
                                    .foregroundStyle(color)
                            }
                            
                            
                            VStack {
                                Text("Severity")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(color.mix(with: .black, by: 0.4))
                                
                                Text(issue.severity.title)
                                    .font(.footnote)
                                    .foregroundStyle(color)
                            }
                            
                            
                            VStack {
                                Text("Status")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(color.mix(with: .black, by: 0.4))
                                
                                Text(issue.status.title)
                                    .font(.footnote)
                                    .foregroundStyle(color)
                                
                            }
                            
                            
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)
                    
                    
                    
                    
                    Group {
                        SectionHeader(title: "Evidence of the issue")
                        ScrollView(.horizontal, showsIndicators: true) {
                            LazyHGrid(rows: gridColumns, spacing: 16) {
                                ForEach(photos, id: \.id) { photo in
                                    
                                    Image(photo.photo)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .cornerRadius(16)
                                        .frame(width: 160, height: 160)
                                    
                                    
                                }
                            }
                        }
                        
                        .scrollClipDisabled()
                    }
                    .padding(.leading, 16)
                    
                    Group {
                        SectionHeader(title: "More Information")
                        List {
                            
                            HStack {
                                Text("Reported by:")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("Anonymous user")
                                    .font(.caption)
                            }
                            
                            HStack {
                                Text("Last update:")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("2d ago")
                                    .font(.caption)
                            }
                            
                            HStack {
                                Text("Address:")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("demo demo demo demo")
                                    .font(.caption)
                            }
                            
                            
                            HStack {
                                Text("Coordinates:")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("\(issue.coordinate.latitude)° N, \(abs(issue.coordinate.longitude))° W")
                                    .font(.caption)
                                
                            }
                        }
                        .scrollDisabled(true)
                        .listStyle(.plain)
                        .scrollClipDisabled(true)
                        .frame(height: 185)
                        
                    }
                    .padding(.leading, 16)
                    
                    
                    Group {
                        SectionHeader(title: "Last Comments")
                        LazyVStack(spacing: 16) {
                            
                            ForEach(1..<5) { _ in
                                CommentRow(name: "Ethan Carter", time: "2d", message: "This pothole is really dangerous! I almost lost control of my car last night...................... demo deo demo demo")
                                
                                CommentRow(name: "Ethan ", time: "1d", message: "This ")
                            }
                            
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                }
            }
            
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 36) {
                    
                    
                    
                    
                    Button {
                        commentButtonPressed.toggle()
                    } label: {
                        Image(systemName: "text.bubble")
                            .font(Font.system(size: 17))
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(.plain)
                    .buttonSizing(.flexible)
                    
                    Button {
                        showConfirmationDialogRaiseHand.toggle()
                    } label: {
                        Image(systemName: "hand.raised")
                            .font(Font.system(size: 17))
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(.plain)
                    .buttonSizing(.flexible)
                    .confirmationDialog("I'm  affected by this",
                                        isPresented: $showConfirmationDialogRaiseHand,
                                        titleVisibility: .visible
                    ) {
                        Button("Confirm", role: .confirm) {
                            
                        }
                        
                    } message: {
                        Text("Do you want to report that your are affected by this issue?")
                    }
                    
                    
                    Button {
                        showConfirmationDialogAddNotification.toggle()
                    } label: {
                        Image(systemName: "bell.badge")
                            .font(Font.system(size: 17))
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(.plain)
                    .buttonSizing(.flexible)
                    .confirmationDialog("Follow up",
                                        isPresented: $showConfirmationDialogAddNotification,
                                        titleVisibility: .visible
                    ) {
                        Button("Confirm", role: .confirm) {
                            
                        }
                        
                    } message: {
                        Text("Do you want to get notification about this issue?")
                    }
                }
                .padding()
                .optionalGlassWithShape(colorScheme, shape: .capsule)
                .shadow(color: Color.black.opacity(0.125), radius: 10, x: 0, y: 6)
                .padding(.horizontal, 16)
            }
            .sheet(isPresented: $commentButtonPressed) {
                CommentsSectionView()
            }
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                
                ToolbarItem(placement: .automatic) {
                    ShareLink(item: "") {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
            
        }
        .toolbarTitleDisplayMode(.inlineLarge)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    private  let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        
    ]
    
}

func getMatterToSolve(id: String) -> String {
    return matterToResolve.first(where: { $0.id == id })?.title ?? ""
}

#Preview {
    let coordinate = CLLocationCoordinate2D(
        latitude: 37.7749,
        longitude: -122.4194
    )
    
    let issue = IssueMarker(
        id: UUID().uuidString,
        title: "A big pothole",
        description: "There is a big pothole in the middle of the street",
        status: 4,
        coordinate: coordinate,
        issueType: 1,
        severity: 2,
        matterToSolve: 1,
        address: "lorem ipsum dolor sit amet consectetur adipiscing elit."
    )
    
    DetailView(issue: issue)
}
