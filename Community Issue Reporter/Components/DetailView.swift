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
    let published: Date
    let user: String
    var more: Bool
    
    init(id: String, photo: String, published: Date, user: String, more: Bool = false) {
        self.id = id
        self.photo = photo
        self.published = published
        self.user = user
        self.more = more
    }
}

struct DetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric var adaptiveSpacing: CGFloat = 20
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var showMoreEvidences: Bool = false
    @State private var photos: [PhotoSample] = [
        PhotoSample(id: "1", photo: "a", published: Date(), user: "Jane Doe"),
        PhotoSample(id: "2", photo: "b", published: Date(), user: "John Smith"),
        PhotoSample(id: "3", photo: "c", published: Date(), user: "Michael Brown"),
        PhotoSample(id: "4", photo: "d", published: Date(), user: "Emily Davis"),
        PhotoSample(id: "5", photo: "", published: Date(), user: "", more: true),
    ]
    
    var issue: IssueMarker
    @State private var color: Color
    @State private var commentButtonPressed: Bool = false
    @State private var showConfirmationDialogRaiseHand: Bool = false
    @State private var showConfirmationDialogAddNotification: Bool = false
    @State private var openInMaps: Bool = false
    @State private var affectedState: Bool = false
    @State private var notificationState: Bool = false
    @State private var showAlert: Bool = false
    @State private var message: String = ""
    @State private var type: AlertType = .success
    @State private var paginatedResult: PaginatedResponse<Comment>
    @State private var comments: [Comment] = []
    
    init(issue: IssueMarker) {
        self.issue = issue
        self.color = self.issue.status.color
        self.comments = []
        self.paginatedResult = PaginatedResponse<Comment>(
            total: 0,
            page: 0,
            documentsPerPage: 0,
            totalPages: 0,
            hasNext: false,
            hasPrev: false,
        )
    }
    
    
    fileprivate func openOnGoogleMaps() {
        let urlString = "comgooglemaps://?q=\(issue.coordinate.latitude),\(issue.coordinate.longitude)&zoom=14"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    fileprivate func moreInformation() -> Group<TupleView<(SectionHeader, some View)>> {
        return Group {
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
                    Text("Assigned institution:")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("MOP")
                        .font(.caption)
                }
                
                HStack {
                    Text("Address:")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(issue.address)
                        .lineLimit(2)
                        .font(.caption)
                }
                
                
                Button {
                    self.openInMaps.toggle()
                } label: {
                    HStack {
                        Text("Coordinates:")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(issue.coordinate.latitude)° *N*, \(abs(issue.coordinate.longitude))° *W*")
                            .font(.caption)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                            .background(Color.black.opacity(0.001))
                    }
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .confirmationDialog("Coordinates",
                                    isPresented: $openInMaps,
                                    titleVisibility: .visible
                ) {
                    Button("Confirm", role: .confirm) {
                        
                        Task {
                            openOnGoogleMaps()
                        }
                        
                    }
                    
                } message: {
                    Text("Do you want to open this on Google Maps?")
                }
                
                
            }
            .scrollDisabled(true)
            .listStyle(.plain)
            .scrollClipDisabled(true)
            .frame(height: 245)
            
        }
    }
    
    fileprivate func evidenceOfTheIssues() -> Group<TupleView<(SectionHeader, some View)>> {
        return Group {
            SectionHeader(title: "Evidence of the issue")
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHGrid(rows: gridColumns, spacing: 16) {
                    ForEach(photos, id: \.id) { photo in
                        
                        if photo.more {
                            Button {
                                self.showMoreEvidences.toggle()
                            } label: {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(issue.status.color, lineWidth: 2)
                                    .frame(width: 160, height: 160)
                                    .foregroundStyle(Color(uiColor: .systemGray6))
                                    .overlay {
                                        VStack(spacing: 8) {
                                            Image(systemName: "photo.stack")
                                                .foregroundStyle(.blue)
                                                .font(.largeTitle)
                                            
                                            HStack {
                                                Text("More Evidences...")
                                                    .font(.caption)
                                                    .fontWeight(.black)
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                    }
                            }
                            .padding(.trailing, 16)
                            
                        } else {
                           
                            photoPreview(photo)
                                .frame(width: 160, height: 160)
                        }
                    }
                }
            }
            .padding(.leading, 16)
            .padding(.top, 8)
            .scrollClipDisabled()
        }
    }
    
    @ViewBuilder
    func lastComments() -> some View {
        Group {
            SectionHeader(title: "Last Comments")
            LazyVStack(spacing: 16) {
                ForEach(comments) { c in
                    CommentRow(name: c.name ?? "Annonymous", time: "2d", message: c.message)
                }
            }
        }
    }
    
    fileprivate func basicInformation() -> some View {
        return HStack(spacing: 17) {
            
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
    }
    
    fileprivate func headers() -> VStack<TupleView<(some View, some View)>> {
        return VStack( spacing: 4) {
            Text(issue.title)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(issue.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    headers()
                    .padding(.horizontal, 16)
                    
                    basicInformation()
                    
                    evidenceOfTheIssues()
                    .padding(.leading, 16)
                    
                    moreInformation()
                        .padding(.leading, 16)
                    
                    lastComments()
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                }
            }
            .task {
                await CommentsRepository.list(
                    issue.id,
                    page: 1,
                    onComplete: { result in
                        self.paginatedResult = result
                        self.comments.append(contentsOf: result.documents!)
                    }, onError: { _ in
                        
                    }
                )
            }
            .safeAreaInset(edge: .bottom) {
                customBottomToolbar(
                    commentAction: {
                        commentButtonPressed.toggle()
                    },
                    addPhotoAction: {},
                    affectedAction: { status in
                        type = .info
                        status ? (message = "Added to affected list") : (message = "Removed from affected list")
                        showAlert = true
                        hideAlert()
                    },
                    addNotificationAction: { status in
                        type = .info
                        status ? (message = "Added to notification list") : (message = "Removed from notification list")
                        showAlert = true
                        hideAlert()
                    },
                    affectedState: $affectedState,
                    notificationState: $notificationState
                )
            }
            .sheet(isPresented: $commentButtonPressed) {
                CommentsSectionView(issue: self.issue)
            }
            .sheet(isPresented: $showMoreEvidences) {
                EvidencesView()
            }
            .overlay(alignment: .bottom) {
                if showAlert {
                    Group {
                        if #available(iOS 26, *) {
                            customAlert(message: message, type: type)
                                .transition(.asymmetric(insertion: .identity, removal: .opacity))
                                .optionalGlassEffect(colorScheme, cornerRadius: 16)
                                .shadow(color: Color.black.opacity(0.115), radius: 10, x: 0, y: 6)
                        }
                    }
                    .offset(x: 0, y: -62)
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
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
    
    private func hideAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.250) {
            self.showAlert = false
            
        }
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
        status: 2,
        coordinate: coordinate,
        issueType: 1,
        severity: 2,
        matterToSolve: 1,
        address: "lorem ipsum dolor sit amet consectetur adipiscing elit."
    )
    
    DetailView(issue: issue)
}
