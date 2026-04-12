//
//  DetailView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import SwiftUI
import CoreLocation

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    var issue: IssueMarker
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(issue.title)
                        .font(.title)
                        .bold()
                    
                    Text(issue.description)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                VStack {
                    LazyHGrid(rows: gridColumns, spacing: 8) {
//                        ForEach(1...4, id: \.self) { index in
//                            
//                            Button {
//                                
//                            } label: {
//                                Text("1")
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                
//                                    .background(Color.secondary)
//                                    .cornerRadius(8)
//                                //                                           .foregroundColor(.secondary, )
//                            }
//                            .buttonStyle(.plain)
//                            //                                   .buttonStyle(.glass)
//                            .buttonSizing(.flexible)
//                            .fixedSize(horizontal: true, vertical: true)
//                        }
                        
                        VStack {
                            Text("Issue Type")
                                .font(.headline)
                                .fontWeight(.black)
                            
                            Text(issue.issueType.title)
                                .font(.footnote)
                        }
                        .padding()
                        .background(Color.blue.secondary)
                        .cornerRadius(16)
                        
                        VStack {
                            Text("Severity")
                                .font(.headline)
                                .fontWeight(.black)
                            
                            Text(issue.severity.title)
                                .font(.footnote)
                        }
                        .padding()
                        .background(Color.blue.secondary.opacity(0.5))
                        .cornerRadius(16)
                        
                        VStack {
                            Text("Status")
                                .font(.headline)
                                .fontWeight(.black)
                            
                            Text(issue.status.title)
                                .font(.footnote)
                        }
                        .padding()
                        .background(Color.blue.secondary.opacity(0.5))
                        .cornerRadius(16)
                    }
                    .fixedSize()
                }
                
                
                Spacer()
            }
            .padding(.top, 16)
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") {
                        dismiss()
                    }
                }
                
                //                ToolbarItem(placement: .title) {
                //                    Text(issue.title)
                //                }
                
                ToolbarSpacer(.fixed)
                
                ToolbarItem() {
                    ShareLink(item: "") {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
            
        }
        .presentationDetents([.medium, .fraction(0.2)])
        .presentationDragIndicator(.visible)
    }
    
    private  let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        
    ]
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
        status: 1,
        coordinate: coordinate,
        issueType: 1,
        severity: 1,
        matterToSolve: 1,
        address: ""
    )
    
    DetailView(issue: issue)
}
