//
//  PhotoChooser.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 17/4/26.
//

import SwiftUI
import PhotosUI

enum MediaTypes: String {
    case photo
    case image
    case video
}

enum DeviceOrientation: String {
    case landscape
    case portrait
}

struct BasicMetadata {
    let deviceOrientation: DeviceOrientation
}

struct MediaResources: Identifiable {
    let id = UUID()
    let type: MediaTypes
    let data: UIImage?
    let metadata: BasicMetadata
}

struct PhotoChooser: View {
    @Namespace private var nameSpace
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var isCameraPresented: Bool
    @State private var cameraCompletion: (([MediaResources]) -> Void)?
    @State private var previewImage: UIImage?
    @State private var previewID: UUID?
    @State private var isImagePreviewPresented: Bool
    @State var orientation = UIDevice.current.orientation
    
    var reportContainer: String
    @Binding var uploadTrackers: [PhotoUploadTracker]
    var isReadyToContinue: Bool {
        !uploadTrackers.isEmpty && uploadTrackers.allSatisfy { $0.phase == .success }
    }
    
    
    init(reportContainer: String, uploadTrackers: Binding<[PhotoUploadTracker]>) {
        self.reportContainer = reportContainer
        self._uploadTrackers = uploadTrackers
        self.isCameraPresented = false
        self.isImagePreviewPresented = false
        self.previewID = nil
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack(spacing: .themeSpacing * 4) {
                    
                    ThemedButton(
                        message: String(localized: "Take Photo"),
                        action: {
                            takePhotoUsingCamera { images in
                                handleSelectedImages(images)
                            }
                        },
                        type: .outline,
                        style: .prominent,
                        icon: "camera"
                    )
                    
                    PhotosPicker(
                        selection: $selectedPhotoItems,
                        maxSelectionCount: 6,
                        matching: .any(
                            of: [
                                .images,
                                .panoramas,
                                .not(.videos),
                                .not(.screenshots),
                                .not(.screenRecordings),
                                .not(.spatialMedia),
                            ]
                        )
                    ) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Gallery")
                                .font(.callout.bold())
                        }
                        .padding(.themeSpacing * 3)
                        .frame(maxWidth: .infinity, maxHeight: 48)
                    }
                    .buttonStyle(ThemedButtonOutlineStyle(style: .prominent))
                    .onChange(of: selectedPhotoItems) { _, newItems in
                        guard !newItems.isEmpty else { return }
                        
                        Task {
                            let images = await loadSelectedImages(from: newItems)
                            handleSelectedImages(images)
                        }
                    }
                    .onChange(of: isReadyToContinue) { _, newValue in
                        selectedPhotoItems.removeAll()
                    }
                }
                
                ScrollView(.vertical, showsIndicators: true) {
                    Divider()
                        .padding(.vertical, 8)
                        .opacity(0.67)
                    
                    /// Use a masonry grid to present images 
                    MasonryGrid(columns: 2, spacing: 8, data: uploadTrackers) { tracker in
                        
                        PreviewImageToUpload(
                            name: tracker.name,
                            phase: tracker.phase,
                            data: tracker.localResource.data,
                            currentValue: Binding(
                                get: { tracker.uploadProgress },
                                set: { _ in }
                            ),
                            total: 1.0,
                            delete: { name in
                                deleteImage(using: name, tracker)
                            },
                            retry: { _ in }
                        )
                    }
                    
                }
            }
            .fullScreenCover(isPresented: $isCameraPresented) {
                ImagePicker(sourceType: .camera) { resource in
                    if let resource {
                        cameraCompletion?([resource])
                    }
                    cameraCompletion = nil
                    isCameraPresented = false
                }
                .ignoresSafeArea()
            }
            .fullScreenCover(isPresented: $isImagePreviewPresented) {
                if isImagePreviewPresented, let previewImage, let previewID {
                    ZStack {
                        Rectangle()
                            .opacity(0.001)
                            .ignoresSafeArea()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onTapGesture {
                                dismissPreview()
                            }
                        
                        GeometryReader { proxy in
                            Image(uiImage: previewImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 32))
                                .shadow(radius: 16)
                                .contentShape(RoundedRectangle(cornerRadius: 32))
                                .frame(width: proxy.size.width - 32, height: proxy.size.height / 2)
                                .position(x: proxy.size.width / 2 , y: proxy.size.height / 2)
                                .onTapGesture {
                                    dismissPreview()
                                }
                        }
                    }
                    .navigationTransition(.zoom(sourceID: previewID, in: nameSpace))
                }
            }
        }
    }
    
    
    private func deleteImage(using key: String, _ tracker: PhotoUploadTracker) {
        Task {
            do {
                tracker.phase = .deleting
                let result = try await ReportRepository.shared.deleteTemporalPicture(reportContainer, key)
                if result == .deleted {
                    await MainActor.run {
                        withAnimation {
                            uploadTrackers.removeAll { $0.name == key }
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func takePhotoUsingCamera(onComplete: @escaping ([MediaResources]) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        cameraCompletion = onComplete
        isCameraPresented = true
    }
    
    
    
    private func handleSelectedImages(_ images: [MediaResources]) {
        for image in images {
            let tracker = PhotoUploadTracker(localResource: image)
            uploadTrackers.append(tracker)
            
            /// Immediately start processing and uploading
            Task {
                await ImageEncoderService().processAndUpload(using: reportContainer, tracker: tracker)
            }
        }
    }
    
    private func deleteImage(at index: Int) {

    }
    
    private func showPreview(for resource: MediaResources) {
        guard let data = resource.data else { return }
        previewImage = data
        previewID = resource.id
        isImagePreviewPresented = true
    }
    
    private func dismissPreview() {
        isImagePreviewPresented = false
        previewImage = nil
        previewID = nil
    }
    
    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    private func loadSelectedImages(from items: [PhotosPickerItem]) async -> [MediaResources] {
        var images: [MediaResources] = []
        images.reserveCapacity(items.count)
        
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                images.append(MediaResources(type: .photo, data: image, metadata: BasicMetadata(deviceOrientation: orientation.isPortrait ? .portrait : .landscape)))
            }
        }
        
        return images
    }
    
    private static let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: .themeSpacing * 3),
        GridItem(.flexible(), spacing: .themeSpacing * 3),
    ]
}

//#Preview {
    //    PhotoChooser(
    //
    //    )
//}

struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (MediaResources?) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        picker.modalPresentationStyle = .fullScreen
        
        picker.view.contentMode = .scaleAspectFit
        picker.view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        picker.view.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        private let onImagePicked: (MediaResources?) -> Void
        
        init(onImagePicked: @escaping (MediaResources?) -> Void) {
            self.onImagePicked = onImagePicked
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onImagePicked(nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as? UIImage

            let orientation = UIDevice.current.orientation
            onImagePicked(MediaResources(type: .photo, data: image, metadata: BasicMetadata(deviceOrientation: orientation.isLandscape ? .landscape : .portrait)))
        }
    }
}
