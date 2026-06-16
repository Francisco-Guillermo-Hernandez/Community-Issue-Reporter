//
//  DetailView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import CoreLocation
import SwiftUI

enum DetailNavigationDestination: Hashable {
    case comment(String)
    case reportFollowUp(Report)
    case moreEvidences(String)
}

struct ReportFollowUpView: View {
    let report: Report
    
    var body: some View {
        Text("Follow up for \(report.title)")
    }
}

struct PhotoSample: Identifiable, Hashable {
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
    @State private var path = NavigationPath()
    @State private var activeDetent: PresentationDetent = .fraction(0.30)
    @State private var showConfirmationDialogRaiseHand: Bool = false
    @State private var showConfirmationDialogAddNotification: Bool = false
    @State private var openInMaps: Bool = false
    @State private var affectedState: Bool = false
    @State private var notificationState: Bool = false
    @State private var showAlert: Bool = false
    @State private var message: String = ""
    @State private var type: AlertType = .success
    @State private var paginatedResult: PaginatedResponse<Comment>
    @State private var comments: Comments = .init(documents: [], hasNext: false, hasPrev: false)

    init(report: MapExplorerReport) {
        self.report = report
        self.color = self.report.status.color
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


    fileprivate func evidenceOfTheIssues() -> Group<TupleView<(SectionHeader, some View)>> {
        return Group {
            SectionHeader(title: String(localized: "Evidence of the report"))
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHGrid(rows: gridColumns, spacing: .themeSpacing * 2) {
                    ForEach(photos, id: \.id) { photo in

                        if photo.more {
                           
                            
                            NavigationLink(value: DetailNavigationDestination.moreEvidences(report.id)) {
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
            .padding(.top, .themePadding)
            .scrollClipDisabled()
        }
    }

    @ViewBuilder
    func lastComments() -> some View {
        Group {
            SectionHeader(title: String(localized: "Latest Comments"))
            LazyVStack(spacing: .themeSpacing * 4) {
                ForEach(comments.documents ?? []) { c in
                    CommentRow(comment: c)
                }
            }
            .padding(.horizontal, .themePadding)
        }
    }


    fileprivate func headers() -> VStack<TupleView<(some View, some View)>> {
        return VStack {
            Text(report.title)
                .font(.title2)
                .bold()
                .fontWidth(.condensed)
                .fontWeight(.bold)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(report.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, .themePadding)
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: .themeSpacing * 5) {
                    headers()

                    ///
                    BasicInformationView(for: report)

                    ///
                    EvidenceOfTheIssuesView(photos: photos, id: report.id)

                    ///
                    FollowUpSectionView()
                    
                    ///
                    MoreInformationView(report: report)
                        .padding(.bottom, .themePadding)
                    
                    lastComments()

                }
                .padding(.leading, 16)
            }
            .task {
                guard !Task.isCancelled else { return }
                do {
                    self.comments = try await CommentsRepository.shared.list(report.id, page: 1)
                    
                } catch {
                    
                }
            }
            .safeAreaInset(edge: .bottom) {
                if activeDetent == .large {
                    customBottomToolbar(
                        commentAction: {
                            path.append(DetailNavigationDestination.comment(self.report.id))
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
                    .transition(.move(edge: .bottom))
                }
            }
            .animation(.easeInOut, value: activeDetent)
            .navigationDestination(for: DetailNavigationDestination.self) { destination in
                switch destination {
                case .comment(let id):
                    CommentsSectionView(for: .report, with: id)
                case .reportFollowUp(let report):
                    ReportFollowUpView(report: report)
                case .moreEvidences(let id):
                    EvidencesView(with: id)
                }
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
                    ShareLink(item: buildShareURL(for: "7BTheYpPwK1L/report/traffic-light-ou")!) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }

        }
        .toolbarTitleDisplayMode(.inlineLarge)
        .presentationDetents([.fraction(0.30), .medium, .large], selection: $activeDetent)
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
    
    @Previewable
    @State var isPresented: Bool = true
    
//    @Previewable
    @State var isLoading: Bool = false
    
    NavigationStack {
        Button("Open"){
            isPresented.toggle()
        }
            .sheet(isPresented: $isPresented) {
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
                    createdAtRaw: 1780036575602,
                    updatedAtRaw: 1780036575602,
                    reportedBy: "John Doe",
                    cityId: "",
                    petitionId: "",
//                    updatedAt
                )

                DetailView(report: report)
                    .skeleton(isRedacted: isLoading)
//                    .redacted(reason: isLoading ? .placeholder : [])
                    
            }
    }
}
