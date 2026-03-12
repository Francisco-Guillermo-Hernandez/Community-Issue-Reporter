//
//  ReportView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/2/26.
//

import PhotosUI
import SwiftUI
import UIKit

struct Option: Hashable {
    var icon: String
    var text: String
}

struct ReportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var issueType: IssueTypes = .all
    @State private var severityLevel: Severity = .low
    @State private var location = ""
    @State private var descriptionText = ""
    @State private var showDiscardAlert = false
    @State private var isSubmitting = false
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var isCameraPresented = false
    @State private var cameraCompletion: (([UIImage]) -> Void)?
    @State private var previewImage: UIImage?
    @State private var isImagePreviewPresented = false
    var onCompletion: (String, AlertType) -> Void
    

    private var isFormFilled: Bool {
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || !descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || !selectedImages.isEmpty
    }

    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                Section("Issue Details") {
                    
                    Picker("Issue type", selection: $issueType) {
                        ForEach(IssueTypes.allCases, id: \.self) { issue in
                            HStack(spacing: 8) {
                                Text(issue.title)
                                Image(systemName: issue.iconName)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .tag(issue)
                        }
                    }
                    
                    Picker("Severity level", selection: $severityLevel) {
                        ForEach(Severity.allCases, id: \.self) { level in
                            HStack(spacing: 8) {
                                Text(level.title).tag(level.title)
                                Image(systemName: level.iconName)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .tag(level)
                        }
                    }
                    
                }

                Section("Location") {
                    TextField("Address", text: $location)
                    
                }
                
                Section("Description") {
                    TextEditor(text: $descriptionText)
                        .frame(minHeight: 60)
                }

                Section("Photos") {
                    VStack {
                        HStack(spacing: 16) {
                            Button {
                                takePhotoUsingCamera { images in
                                    handleSelectedImages(images)
                                }
                            } label: {
                                Label("Camera", systemImage: "camera")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(.secondary)

                            PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: 6, matching: .images) {
                                Label("Gallery", systemImage: "photo.on.rectangle")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(.secondary)
                            .onChange(of: selectedPhotoItems) { _, newItems in
                                loadSelectedImages(from: newItems) { images in
                                    handleSelectedImages(images)
                                }
                            }
                        }
                        
                        Divider()
                            .padding(.bottom, 8)
                            .padding(.top, 8)
                        
                        ScrollView(.horizontal, showsIndicators: true) {
                            LazyHStack(spacing: 12) {
                                ForEach(0..<selectedImages.count, id: \.self) { index in
                                    ZStack(alignment: .topLeading) {
                                        Image(uiImage: selectedImages[index])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .contentShape(RoundedRectangle(cornerRadius: 8))
                                            .onTapGesture {
                                                showPreview(for: selectedImages[index])
                                            }
                                            .onLongPressGesture(minimumDuration: 0.4) {
                                                triggerHaptic()
                                                showPreview(for: selectedImages[index])
                                            }
                                        
                                        Button {
                                            deleteImage(at: index)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .symbolRenderingMode(.multicolor)
                                                .font(Font.headline.bold())
                                        }
                                        .padding(4)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                }
            }
            .navigationTitle("Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        if isFormFilled {
                            showDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Close")
                    .confirmationDialog("Are you sure...", isPresented: $showDiscardAlert)  {
                       
                        Button("Keep editing", role: .cancel) {
                            showDiscardAlert = false
                        }
                        Button("Discard changes", role: .destructive) {
                            dismiss()
                        }
                    } message: {
                        Text("You have unsaved information in this report.")
                    }
                }
                
                ToolbarItem(placement: .title) {
                    Text("Report a new issue")
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isSubmitting = true

                        Task {
                            let id = await ReportRepository.create(report: Report(id: nil, coordinate: [], address: "", description: "", severityId: 1, statusId: 1, issueTypeId: 1, matterToSolveId: 1, reportedAt: nil, cellIndex: "", createdAt: nil, updatedAt: nil, reportedBy: ""))
                            print(id)
                            await MainActor.run {
                                dismiss()
                                onCompletion("Report submitted successfully.", .success)
                            }
                        }
                    } label: {
                        if isSubmitting {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Label("Submit", systemImage: "checkmark")
                        }
                    }
                    .disabled(isSubmitting)
                }
            }
            .interactiveDismissDisabled(isFormFilled)
                .sheet(isPresented: $isCameraPresented) {
                    ImagePicker(sourceType: .camera) { image in
                        if let image {
                            cameraCompletion?([image])
                        }
                        cameraCompletion = nil
                        isCameraPresented = false
                    }
                }
            }
            
            if isImagePreviewPresented, let previewImage {
                ZStack {
                    Rectangle()
                        .opacity(0.1)
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
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: isImagePreviewPresented)
            }
        }
    }

    private func handleSelectedImages(_ images: [UIImage]) {
        selectedImages = images
        // TODO: Send `images` to the upload service.
    }

    private func deleteImage(at index: Int) {
        guard selectedImages.indices.contains(index) else {
            return
        }

        selectedImages.remove(at: index)
    }

    private func showPreview(for image: UIImage) {
        previewImage = image
        isImagePreviewPresented = true
    }

    private func dismissPreview() {
        isImagePreviewPresented = false
        previewImage = nil
    }

    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    private func takePhotoUsingCamera(onComplete: @escaping ([UIImage]) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }

        cameraCompletion = onComplete
        isCameraPresented = true
    }

    private func loadSelectedImages(from items: [PhotosPickerItem], onComplete: @escaping ([UIImage]) -> Void) {
        Task {
            var images: [UIImage] = []
            images.reserveCapacity(items.count)

            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    images.append(image)
                }
            }

            await MainActor.run {
                onComplete(images)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        private let onImagePicked: (UIImage?) -> Void

        init(onImagePicked: @escaping (UIImage?) -> Void) {
            self.onImagePicked = onImagePicked
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onImagePicked(nil)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as? UIImage
            onImagePicked(image)
        }
    }
}

#Preview {
    ReportView(onCompletion: { data, type in
        
    })
}
