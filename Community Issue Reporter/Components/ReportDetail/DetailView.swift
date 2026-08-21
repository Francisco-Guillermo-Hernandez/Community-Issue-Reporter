//
//  DetailView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 2/4/26.
//

import SwiftUI
import Observation
import CoreLocation


@MainActor
@Observable
final class DetailController {
    
    var selectedOption = "None"
    var showPopover = false
    var presentAlert: Bool = false
    var reason: String = ""
    let options = DetailReportOptions.allCases.map(\.description)
    func report(_ report: MapExplorerReport) -> Void {
        Task {
            let blockedReasonId = DetailReportOptions.allCases.first(where: { $0.description == selectedOption })?.rawValue ?? DetailReportOptions.other.rawValue
            let type: TypeOfContentToReport = .report
            
            let violation = ReportViolation(
                type: type,
                content: report,
                profileId: report.profileId,
                reason: reason.isEmpty ? selectedOption : reason,
                blockedReasonId: blockedReasonId,
                status: .sentToModeration
            )
            
            do {
                _ = try await ModerationRepository.shared.moderateReport(reason: violation, type: type)
                Toast.shared.show(message: String(localized: "Your moderation petition was sent"), type: .info)
            } catch CommonIntercommunicationErrors.serverError(_) {
                Toast.shared.show(message: String(localized: "Server Error"), type: .error)
            } catch CommonIntercommunicationErrors.networkError(_) {
                Toast.shared.show(message: String(localized: "It looks like that your network is experiencing some delays, please try again."), type: .error)
            } catch {
                Toast.shared.show(message: String(localized: "Error"), type: .error)
            }
        }
    }
}


// MARK: - Definitions

enum DetailReportOptions: String, Codable, CaseIterable {
    case wrongInformation
    case explicitContent
    case spam
    case violence
    case privacyIssues
    case other
    
    var description: String {
        switch self  {
        case .wrongInformation:
                return String(localized: "Wrong Information")
            case .explicitContent:
                return String(localized: "Explicit Content")
            case .spam:
                return String(localized: "Spam")
            case .violence:
                return String(localized: "Violence")
            case .privacyIssues:
                return String(localized: "Privacy issue")
            case .other:
                return String(localized: "Other")
            
        }
    }
}

enum DetailNavigationDestination: Hashable {
    case comment(String)
    case reportFollowUp(Report)
    case moreEvidences(String)
    case citizenProfile(profileId: String)
}

struct ReportFollowUpView: View {
    let report: Report
    
    var body: some View {
        Text("Follow up for \(report.title)")
    }
}


// MARK: - View
struct DetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric var adaptiveSpacing: CGFloat = 20
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var showMoreEvidences: Bool = false
    @State private var attachments: [PreviewAttachment] = []
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
    @State private var controller = DetailController()

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

    @ViewBuilder
    func lastComments() -> some View {
        Group {
            SectionHeader(title: String(localized: "Latest Comments"))
                LazyVStack(spacing: .themeSpacing * 4) {
                ForEach(comments.documents ?? []) { c in
                    CommentRow(comment: c)
                    
                    Divider()
                        .opacity(0.65)
                        .padding(.bottom, .themePadding / 4)
                }
            }
            .padding(.horizontal, .themePadding)
        }
    }



    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: .themeSpacing * 5) {
                    DetailsHeader(title: report.title, description: report.description)

                    ///
                    BasicInformationView(for: report)
                        .padding(.leading, -8)
                        .padding(.trailing, 8)

                    ///
                    EvidenceOfTheReportView(report.attachments, id: report.id)

                    ///
                    FollowUpSectionView(for: report)
                    
                    ///
                    MoreInformationView(report: report)
                        .padding(.bottom, .themePadding)
                    
                    lastComments()

                }
                .padding(.leading, 16)
            }
            .task(id: activeDetent) {
                
                if !UserRepository.shared.isGuestUser() {
                    guard activeDetent == .large else { return }
                    do {
                        self.comments = try await CommentsRepository.shared.list(report.id, page: 1)
                        
                    } catch {
                        
                    }
                }
                
            }
            .safeAreaInset(edge: .bottom) {
                if activeDetent == .large {
                    customBottomToolbar(
                        commentAction: {
                            path.append(DetailNavigationDestination.comment(self.report.id))
                        },
                        addPhotoAction: {
                            path.append(DetailNavigationDestination.moreEvidences(self.report.id))
                        },
                        affectedAction: { status in
//                            type = .info
//                            status
//                                ? (message = "Added to affected list")
//                                : (message = "Removed from affected list")
//                            showAlert = true
//                            hideAlert()
                            
                        },
                        boostReportValidationAction: { status in
                            Task {
                                let adUnitID = Bundle.main.object(forInfoDictionaryKey: "ADMOB_REPORT_VALIDATION_AD_UNIT") as? String ?? ""
                                await AdMobManager.shared.loadRewardedAd(adUnitID: adUnitID)
                                
                                DispatchQueue.main.async {
                                    AdMobManager.shared.showRewardedAd {
                                        Task {
                                            do {
                                                _ = try await ReportRepository.shared.boostReportValidation(self.report.id)
                                                let wasValidated = try await ReportRepository.shared.haveReportBeenValidatedByMe(self.report.id)
                                                
                                                DispatchQueue.main.async {
                                                    self.type = .info
                                                    self.message = wasValidated ? "Boost applied and validated!" : "Boost applied."
                                                    self.showAlert = true
                                                    self.hideAlert()
                                                }
                                            } catch {
                                                DispatchQueue.main.async {
                                                    self.type = .error
                                                    self.message = "Failed to boost report"
                                                    self.showAlert = true
                                                    self.hideAlert()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
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
                    CommentsSectionView(for: .report, with: id, title: report.title, subtitle: report.description)
                case .reportFollowUp(let report):
                    ReportFollowUpView(report: report)
                case .moreEvidences(let id):
                    EvidencesView(with: id)
                case .citizenProfile(let profileId):
                    CitizenProfile(with: profileId)
                    
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

                ToolbarItem(placement: .navigation) {
                    Button(role: .none) {
                        if activeDetent == .fraction(0.3) {
                            activeDetent = .large
                        } else {
                            activeDetent = .fraction(0.3)
                        }
                    } label: {
                        Image(systemName: activeDetent == .large ?  "chevron.down" : "chevron.up" )
                    }
                    .accessibilityIdentifier("ExpandCollapseSheetButton")
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }

                if  report.status == .assigned       ||
                    report.status == .inProgress     ||
                    report.status == .confirmed      ||
                    report.status == .petitionToSign {
                    
                    ToolbarItem(placement: .automatic) {
                        ShareLink(item: buildShareURL(for: report.shareUrl)!) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                }
                
                if !UserRepository.shared.isOwnProfile(report.profileId) {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            
                            Button {
                                UIPasteboard.general.string = report.id
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            } label: {
                                Label("Copy Report ID", systemImage: "document.on.document")
                            }
                            .accessibilityIdentifier("CopyReportIdButton")
                            
                            Button(role: .destructive) {
                                controller.showPopover.toggle()
                            } label: {
                                Label("Report content", systemImage: "hand.raised.slash.fill")
                            }
                            .accessibilityIdentifier("ReportThisContentButton")
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                        .popover(isPresented: $controller.showPopover, arrowEdge: .top) {
                            VStack(alignment: .leading, spacing: 15) {
                                Text(String(localized: "Content options"))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 5)
                                
                                ForEach(controller.options, id: \.self) { option in
                                    Button(action: {
                                        Task {
                                            controller.selectedOption = option
                                            controller.showPopover = false
                                            try? await Task.sleep(for: .milliseconds(128))
                                            controller.presentAlert.toggle()
                                        }
                                    }) {
                                        HStack {
                                            Text(option)
                                            Spacer()
                                        }
                                        .contentShape(Rectangle())
                                    }
                                    .foregroundColor(.primary)
                                    
                                    if option != controller.options.last {
                                        Divider()
                                    }
                                }
                            }
                            .padding()
                            .frame(width: 256)
                            .presentationCompactAdaptation(.popover)
                        }
                        .alert(String(localized: "Confirm content reporting"), isPresented: $controller.presentAlert) {
                            if controller.selectedOption == DetailReportOptions.other.description {
                                TextField(String(localized: "Type your reason"), text: $controller.reason)
                            }
                            
                            Button(String(localized: "Cancel"), role: .cancel) { }
                            Button(String(localized: "Report"), role: .destructive) {
                                controller.report(report)
                            }
                        } message: {
                            Text(String(localized: "I confirm that this report violates our community guidelines."))
                        }
                    }
                }
                
            }

        }
        .toolbarTitleDisplayMode(.inlineLarge)
        .presentationDetents([.fraction(0.30), .medium, .large], selection: $activeDetent)
        .presentationDragIndicator(.visible)
//        .withToast()
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
    
    @Previewable @State var isPresented: Bool = true
    @Previewable @State var isLoading: Bool = false
    
    NavigationStack {
        Button("Open"){
            isPresented.toggle()
        }
        .sheet(isPresented: $isPresented) {
               
            DetailView(report: MapExplorerMockedData.shared.report)
                .skeleton(isRedacted: isLoading)
                    
        }
    }
}
