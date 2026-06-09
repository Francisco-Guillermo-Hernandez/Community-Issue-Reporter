//
//  DetailView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import CoreLocation
import SwiftUI

struct PhotoSample: Identifiable {
    let id: String
    let photo: String
    let published: Date
    let user: String
    var more: Bool

    init(
        id: String,
        photo: String,
        published: Date,
        user: String,
        more: Bool = false
    ) {
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
        PhotoSample(
            id: "3",
            photo: "c",
            published: Date(),
            user: "Michael Brown"
        ),
        PhotoSample(
            id: "4",
            photo: "d",
            published: Date(),
            user: "Emily Davis"
        ),
        PhotoSample(
            id: "5",
            photo: "",
            published: Date(),
            user: "",
            more: true
        ),
    ]

    //    var issue: IssueMarker
    var report: MapExplorerReport
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

    init(report: MapExplorerReport) {
        self.report = report
        self.color = self.report.status.color
        self.comments = [
            Comment(
                commentFor: .report, 
                resourceId: "",
                message: "We have problems with potholes in this area."
            ),
            Comment(
                commentFor: .report,
                resourceId: "",
                message: "My car is getting damages because of the potholes."
            ),
            Comment(
                commentFor: .report,
                resourceId: "",
                message: "We have problems with potholes in this area."
            )
        ]
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
        let urlString =
            "comgooglemaps://?q=\(report.clLocation.latitude),\(report.clLocation.longitude)&zoom=14"
        if let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    fileprivate func moreInformation() -> some View {
        return Group {
            SectionHeader(title: String(localized: "More Information"))
            List {

                HStack {
                    Text("Report Id:")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(report.id)
                        .font(.caption)
                }
                
                HStack {
                    Text("Reported by:")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(report.reportedBy)
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
                    Text(report.address)
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
                        Text("\(report.lat)° *N*, \(abs(report.lng))° *W*")
                            .font(.caption)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .trailing
                            )
                            .background(Color.black.opacity(0.001))
                    }
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .confirmationDialog(
                    "Coordinates",
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
            .listRowBackground(Color.clear)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .scrollClipDisabled(true)
            .frame(height: 295)

        }
    }

    fileprivate func evidenceOfTheIssues() -> Group<TupleView<(SectionHeader, some View)>> {
        return Group {
            SectionHeader(title: String(localized: "Evidence of the report"))
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHGrid(rows: gridColumns, spacing: .themeSpacing * 2) {
                    ForEach(photos, id: \.id) { photo in

                        if photo.more {
                           
                            
                            NavigationLink(destination:  EvidencesView()) {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.theme.primary, lineWidth: 2)
                                    .frame(width: 160, height: 160)
                                    .foregroundStyle(
                                        Color(uiColor: .systemGray6)
                                    )
                                    .overlay {
                                        VStack(spacing: 8) {
                                            Image(systemName: "photo.stack")
                                                .foregroundStyle(
                                                    Color.theme.foreground
                                                )
                                                .font(.largeTitle)

                                            HStack {
                                                Text(String(localized: "More Evidences..."))
                                                    .font(.caption)
                                                    .fontWeight(.black)
                                                  
                                                    .foregroundStyle(
                                                        Color.theme.foreground
                                                    )
                                            }
                                        }
                                    }
                                    .padding(.trailing, 16)
                            }

                        } else {

                            photoPreview(photo)
                                .frame(width: 160, height: 160)
                        }
                    }
                }
            }
            .padding(.leading, .themePadding)
            .padding(.top, 16)
            .scrollClipDisabled()
        }
    }

    @ViewBuilder
    func lastComments() -> some View {
        Group {
            SectionHeader(title: String(localized: "Latest Comments"))
            LazyVStack(spacing: 16) {
                ForEach(comments) { c in
                    CommentRow(comment: c)
                }
            }
            .padding(.leading, 16)
        }
    }

    fileprivate func basicInformation() -> some View {
        return HStack(spacing: 17) {

            
//            VStack(alignment: .leading) {
//                Text(String(localized: "Category", comment: "Category text at petition list"))
//                    .font(.caption)
//                    .foregroundStyle(Color.gray)
//                
//                Text(getCategoryName(id: petition.categoryId))
//                    .font(.caption)
//                    .fontWeight(.semibold)
//            }
            
            Group {
                VStack {
                    Text("Reported at")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
//                        .foregroundStyle(color.mix(with: .black, by: 0.4))

                    Text("04/02/2026")
                        .font(.caption)
                        .fontWeight(.semibold)

                }

                VStack {
                    Text("Issue Type")
                        .font(.caption)
                        .foregroundStyle(.gray)

                    Text(report.issueType.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                }

                VStack {
                    Text("Severity")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        

                    Text(report.severity.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                }

                VStack {
                    Text("Status")
                        .font(.caption)
                        .foregroundStyle(.gray)

                    Text(report.status.title)
                        .font(.caption)
                        .fontWeight(.semibold)

                }
            }
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.top, 8)
    }

    fileprivate func headers() -> VStack<TupleView<(some View, some View)>> {
        return VStack(spacing: 4) {
            Text(report.title)
                .font(.title2)
                .bold()
                .fontWidth(.condensed)
                .fontWeight(.bold)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(report.description)
                .font(.subheadline)
//                .fontWidth(.condensed)
                .foregroundStyle(.secondary)
                .lineLimit(1)
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
                guard !Task.isCancelled else { return }
                let result = await CommentsRepository.shared.list(
                    report.id,
                    page: 1,
                    onError: { _ in }
                )

                print(result)
            }
            .safeAreaInset(edge: .bottom) {
                customBottomToolbar(
                    commentAction: {
                        commentButtonPressed.toggle()
                    },
                    addPhotoAction: {},
                    affectedAction: { status in
                        type = .info
                        status
                            ? (message = "Added to affected list")
                            : (message = "Removed from affected list")
                        showAlert = true
                        hideAlert()
                    },
                    addNotificationAction: { status in
                        type = .info
                        status
                            ? (message = "Added to notification list")
                            : (message = "Removed from notification list")
                        showAlert = true
                        hideAlert()
                    },
                    affectedState: $affectedState,
                    notificationState: $notificationState
                )
            }
            .sheet(isPresented: $commentButtonPressed) {
                CommentsSectionView(for: .report, with: self.report.id)
            }
            .overlay(alignment: .bottom) {
                if showAlert {
                    Group {
                        if #available(iOS 26, *) {
                            customAlert(message: message, type: type)
                                .transition(
                                    .asymmetric(
                                        insertion: .identity,
                                        removal: .opacity
                                    )
                                )
                                .optionalGlassEffect(
                                    colorScheme,
                                    cornerRadius: 16
                                )
                                .shadow(
                                    color: Color.black.opacity(0.115),
                                    radius: 10,
                                    x: 0,
                                    y: 6
                                )
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
                    ShareLink(
                        item: buildShareURL(
                            for: "7BTheYpPwK1L/report/traffic-light-ou"
                        )!
                    ) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }

        }
        .toolbarTitleDisplayMode(.inlineLarge)
        .presentationDetents([.fraction(0.30), .medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func hideAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.250) {
            self.showAlert = false

        }
    }
}

func getMatterToSolve(id: Int) -> String {
    return mattersToResolve.first(where: { $0.id == id })?.title ?? ""
}

#Preview {
    
    NavigationStack {
        Text("")
            .sheet(isPresented: .constant(true)) {
                var report = MapExplorerReport(
                    id: "SV-SS-260601-aXWsaxls",
                    lat: 13.701270,
                    lng: -89.224432,
                    address: "Lorem ipsum dolor sit ammet",
                    title: "A big pothole in the middle of the street",
                    description: "There is a big pothole that is affecting our cars",
                    severityId: 1,
                    statusId: 1,
                    issueTypeId: 1,
                    matterToSolveId: 1,
                    reportedAtRaw: nil,
                    cellIndex: "",
                    createdAtRaw: 0,
                    updatedAtRaw: 0,
                    reportedBy: "John Doe",
                    cityId: "",
                    petitionId: ""
                )

                DetailView(report: report)
            }
    }
}
