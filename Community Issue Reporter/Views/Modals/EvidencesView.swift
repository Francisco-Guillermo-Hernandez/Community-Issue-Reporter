//
//  EvidencesView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI
import PhotosUI


struct AttachEvidencesView: View {
    let reportId: String
    let reportContainer: String
    @State private var showAlert: Bool = false
    @State private var attachingNewEvidences: Bool = true
    @State private var showSuccessfulAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var publishingEvidence: Bool = false
    @State private var uploadTrackers: [PhotoUploadTracker] = []
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack() {
           
            
            ScrollView {
                VStack(alignment: .leading, spacing: .themeSpacing * 3) {
                    #if DEBUG
                    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                        Text("Image Picker Placeholder for Preview")
                    } else {
                        PhotoChooser(
                            reportContainer: reportContainer,
                            uploadTrackers: $uploadTrackers
                        )
                    }
                    #else
                    #endif
                    
                }
                .padding(.top)
                .padding(.horizontal)
                .toolbarTitleDisplayMode(.large)
                .navigationSubtitle(String(localized: "Attach new evidence"))
                .navigationTitle(String(localized: "Evidences"))
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button (role: .close) {
                            dismiss()
                        }
                    }
                }
            }
            
        }
        .alert("Notice", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .alert("Success", isPresented: $showSuccessfulAlert) {
            Button("OK", role: .cancel) {
                attachingNewEvidences = false
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            
            ThemedButton(
                message: String(localized: "Attach new evidence"),
                action: {
                    Task {
                        self.publishingEvidence = true
                        let payload = uploadTrackers.map { tracker in
                            GroupedAttachmentPayload(
                                attachmentContainer: self.reportContainer,
                                key: tracker.key,
                                previewFileName: "preview_\(tracker.name)",
                                fileName: tracker.name,
                                reportId: self.reportId,
                                notes: ""
                            )
                        }
                        do {
                            let _ = try await EvidenceRepository.shared.publishExternalContributions(attachments: payload)
                            alertMessage = String(localized: "Your evidence was sent")
                            showSuccessfulAlert = true
                        } catch CommonIntercommunicationErrors.serverError(_) {
                            alertMessage = String(localized: "Server Error")
                            showAlert = true
                        } catch CommonIntercommunicationErrors.networkError(_) {
                            alertMessage = String(localized: "It looks like that your network is experiencing some delays, please try again.")
                            showAlert = true
                        } catch {
                            alertMessage = String(localized: "Error")
                            showAlert = true
                        }
                        
                        self.publishingEvidence = false
                    }
                },
                type: .primary,
                style: .prominent,
                isLoading: $publishingEvidence
            )
            .disabled(!disableAttachButton)
            .padding(.horizontal, 24)
            .padding(.top, 0)
            
        }
    }
    
    var disableAttachButton: Bool {
        !uploadTrackers.isEmpty && uploadTrackers.allSatisfy { $0.phase == .success }
    }
}

struct EvidencesView: View {
    

    @State var orientation = UIDevice.current.orientation
    @State private var mapExplorerController = MapExplorerController.shared
    @State private var selectedImages: UIImage? = nil
    @State private var cameraCompletion: ((UIImage) -> Void)? = nil
    @State private var isCameraPresented: Bool = false
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var page: Int = 1
    @State private var isLoading: Bool = false
    @State private var response: PaginatedResponse<PreviewAttachment> = .init(documents: [], total: 0, page: 1, hasNext: false, hasPrev: false)
    @State private var attachingNewEvidences: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    @State private var photos: [PreviewAttachment] = []
    
    @Namespace private var nameSpace
    @State private var previewID: String = ""
    
    var id: String
    var reportContainer: String
    init(with id: String, reportContainer: String) {
        self.id = id
        self.reportContainer = reportContainer
    }
    
    var body: some View {
        ZStack {
            
            if isLoading {
                LoadingView()
            } else if (response.documents ?? []).isEmpty {
                ContentUnavailableView {
                    Label(
                        String(localized: "No evidences found."),
                        systemImage: "photo.badge.exclamationmark"
                    )
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        Color.theme.foreground.opacity(0.7),
                        Color.theme.primary,
                        Color.theme.foreground.opacity(0.7)
                    )
                } description: {
                    Text(String(localized: "There are no evidences attached to this report yet."))
                }
            } else {
                ScrollView(.vertical) {
                    LazyVGrid(columns: gridColumns, spacing: 4) {
                        ForEach(response.documents ?? [], id: \.id) { photo in
                            NavigationLink(value: photo) {
                                PhotoPreview(photo, .full)
                                    .matchedTransitionSource(id: photo.id, in: nameSpace)
                            }
                            .buttonStyle(.plain)
                            .simultaneousGesture(TapGesture().onEnded {
                                previewID = photo.id
                            })
                        }
                    }
                    .padding(.horizontal, .themePadding)
                }
            }
            
            
        }
        .sheet(isPresented: $attachingNewEvidences) {
            AttachEvidencesView(reportId: id, reportContainer: reportContainer)
                
        }
        .navigationDestination(for: PreviewAttachment.self) { photo in
            PhotoDetailView(photos: response.documents ?? [], previewID: $previewID, nameSpace: nameSpace)
                .navigationTransition(.zoom(sourceID: previewID, in: nameSpace))
        }
        .scrollContentBackground(.hidden)
        .fullScreenCover(isPresented: $isCameraPresented) {
            ImagePicker(sourceType: .camera, onImagePicked: { resource in
                
                if let resource, let avatar = resource.data {
                    
                    onSelect(avatar)
                }
                
                cameraCompletion = nil
                isCameraPresented = false
            })
            .edgesIgnoringSafeArea(.all)
        }
        .task {
            isLoading = true
            defer { isLoading = false }
            do {
                let res = try await ReportRepository.shared.fetchAttachments(id, page: page)
                let filteredDocs = res.documents?.filter { $0.state != .deleted && $0.state != .inappropriate }
                response = PaginatedResponse(
                    documents: filteredDocs,
                    total: res.total,
                    page: res.page,
                    documentsPerPage: res.documentsPerPage,
                    totalPages: res.totalPages,
                    hasNext: res.hasNext,
                    hasPrev: res.hasPrev
                )
            } catch {
                
            }
        }
        .toolbar {
            
            
            if response.documents?.count ?? 0 < 24 {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    
                    Button {
                        attachingNewEvidences.toggle()
                    } label: {
                        Label("Add Evidence", systemImage: "photo.badge.plus")
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .close) {
                    mapExplorerController.expandedItem = nil
                }
            }
            
            
        }
        .toolbarTitleDisplayMode(.large)
        .navigationTitle("Evidences")
        .navigationSubtitle("You can take a look of what is happening")
    }
    
    fileprivate let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]
    
    
    private func takePhotoUsingCamera(onComplete: @escaping (UIImage) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        cameraCompletion = onComplete
        isCameraPresented = true
    }
    
    
    private func onSelect(_ image: UIImage) {
        Task {
            
            try? await Task.sleep(for: .milliseconds(128))
            dismiss()
        }
    }
    
    private func loadSelectedImages(from items: [PhotosPickerItem], onComplete: @escaping (UIImage?) -> Void) {
        Task {
            var image: UIImage?
           
            /// To UIImage
            if let data = try? await items[0].loadTransferable(type: Data.self) {
                image = UIImage(data: data)
            }

            await MainActor.run {
                onComplete(image)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EvidencesView(with: "", reportContainer: "")
    }
}
