//
//  ProfileImage.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 22/5/26.
//

import AVFoundation
import Photos
import PhotosUI
import SwiftUI

// MARK: - Struct definition
struct AvatarOption: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var associatedView: AvatarCreatedFrom
}

// MARK: - Options
let options: [AvatarOption] = [
    .init(title: String(localized: "Google Auth"), associatedView: .GoogleAuth),
//    .init(title: String(localized: "Avatar"), associatedView: .avatar),
    .init(title: String(localized: "Monogram"), associatedView: .monogram),
    .init(title: String(localized: "Initials"), associatedView: .initials),
    .init(title: String(localized: "Photo"), associatedView: .photo),
    .init(title: String(localized: "Camera"), associatedView: .camera),
]

// MARK: - sheet
struct UserAvatarPersonalizationSheet: View {
    var animation: Animation
    @ObservedObject var viewModel: ProfileDataModel
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var currentView: AvatarCreatedFrom = .optionsSelector
    @State private var duration: String = ""
    @State var orientation = UIDevice.current.orientation

    @State private var selectedImages: UIImage? = nil
    @State private var cameraCompletion: ((UIImage) -> Void)? = nil
    @State private var isCameraPresented: Bool = false

    @Environment(\.dismiss) var dismiss
    
    private var selectedOption: AvatarOption? {
        options.first(where: { $0.associatedView == viewModel.selectedAvatarOptionView })
    }
    
    var body: some View {
        VStack(spacing: .themeSpacing * 5) {
            ZStack {
                switch currentView {

                case .optionsSelector:
                    optionsSelectorView(viewModel.selectedAvatarColor)
                        .geometryGroup()
                        .transition(
                            .blurReplace(.downUp)
                        )
                case .avatar:
                    editAvatarView()
                        .geometryGroup()
                        .transition(.blurReplace(.upUp))
                case .photo:
                    Text("Photo")

                case .camera:
                    Text("Camera")

                case .monogram:
                    textBasedAvatarView(.monogram)
                        .geometryGroup()
                        .transition(
                            .blurReplace(.downUp)
                        )

                case .initials:
                    textBasedAvatarView(.initials)
                        .geometryGroup()
                        .transition(
                            .blurReplace(.downUp)
                        )

                case .GoogleAuth:
                    Text("Google auth")
                    
                case .Memoji:
                    Text("Memoji")
                }
            }
            .geometryGroup()
        }
        .padding([.horizontal, .top], .themePadding * 1.23)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    @ViewBuilder
    func textBasedAvatarView(_ option: TextBasedAvatarOptions) -> some View {
        VStack(spacing: .themeSpacing * 5) {

            SheetHeaderView(
                title: String(localized: "Edit your Monogram"),
                onClose: {
                    currentView = .optionsSelector
                }
            )
            
             
            MonogramView(
                text: option == .initials
                    ? viewModel.getInitials() : viewModel.getMonogram(),
                backgroundColor: viewModel.selectedAvatarColor
            )

            ColorGrid(
                selectedColor: $viewModel.selectedAvatarColor,
                colors: viewModel.backgroundColors
            )

            ThemedButton(
                message: String(localized: "Save"),
                action: {
                    applyTextBasedAvatar(option, viewModel.selectedAvatarColor)
                },
                type: .outline
            )
            .padding(.horizontal)
            .padding(.top, .themePadding)
        }

    }

    @ViewBuilder
    func optionsSelectorView(_ preselectedColor: Color) -> some View {
        VStack(spacing: .themeSpacing * 5) {
            SheetHeaderView(title: String(localized: "Create your Avatar from"), onClose: {
                dismiss()
            })
           
            /// Grid Box View
            LazyVGrid(
                columns: Array(repeating: GridItem(), count: 3),
                spacing: .themeSpacing * 4) {
                ForEach(options, id: \.self) { option in
                    let isSelected = selectedOption?.associatedView == option.associatedView

                    VStack {
                        Group {
                            if option.associatedView == .GoogleAuth {
                                
                                Button {
                                    viewModel.selectedAvatarOptionView = option.associatedView
                                    viewModel.applyGoogleAvatar {
                                        dismiss()
                                    }
                                } label: {
                                    getGoogleAuthenticatorAvatar()
                                        .frame(width: 80, height: 80)
                                        
                                }
                                .buttonStyle(.glass)
                                .buttonBorderShape(.circle)
                                
                            }

                            if option.associatedView == .camera {

                                Button {
                                    viewModel.selectedAvatarOptionView = option.associatedView
                                    takePhotoUsingCamera { images in
                                        onSelect(images)
                                    }
                                } label: {
                                    Image(systemName: "camera")
                                        .font(.system(size: 36))
                                        .frame(width: 80, height: 80)
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color.white)
                                        .background(Color.theme.primary)
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.glass)
                                .buttonBorderShape(.circle)
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
                            }

                            if option.associatedView == .photo {

                                PhotosPicker(
                                    selection: $selectedPhotoItems,
                                    maxSelectionCount: 1,
                                    matching: .any(
                                        of: [
                                            .images,
                                            .panoramas,
                                            .screenshots,
                                            .not(.videos),
                                            .not(.screenRecordings),
                                            .not(.spatialMedia),
                                        ]
                                    )
                                ) {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.system(size: 36))
                                        .fontWeight(.medium)
                                        .frame(width: 80, height: 80)
                                        .foregroundStyle(Color.white)
                                        .background(Color.theme.primary)
                                        .clipShape(Circle())

                                }
                                .onChange(of: selectedPhotoItems) { _, newItems in
                                    guard !newItems.isEmpty else { return }
                                    viewModel.selectedAvatarOptionView = option.associatedView
                                    loadSelectedImages(from: newItems) { image in
                                        if let avatar = image {
                                            onSelect(avatar)
                                        }
                                       
                                    }
                                }
                                .buttonStyle(.glass)
                                .buttonBorderShape(.circle)
                            }

                            if option.associatedView == .initials {
                                Button {
                                    viewModel.selectedAvatarOptionView = option.associatedView
                                    
                                    withAnimation(animation) {
                                        currentView = .initials
                                    }
                                } label: {
                                    MonogramView(
                                        text: viewModel.getInitials(),
                                        backgroundColor: preselectedColor
                                    )
                                }
                                .buttonStyle(.glass)
                                .buttonBorderShape(.circle)

                            }

                            if option.associatedView == .monogram {
                                Button {
                                    viewModel.selectedAvatarOptionView = option.associatedView
                                    withAnimation(animation) {
                                        currentView = .monogram
                                    }
                                } label: {
                                    MonogramView(
                                        text: viewModel.getMonogram(),
                                        backgroundColor: preselectedColor
                                    )
                                }
                                .buttonStyle(.glass)
                                .buttonBorderShape(.circle)

                            }

                            if option.associatedView == .avatar {
                                Image("user_b")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            }
                        }
                        .overlay(alignment: .bottomTrailing) {
                            
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .symbolColorRenderingMode(.gradient)
                                    .foregroundColor(.green)
                                    .font(.system(size: 24, weight: .bold))
                                    .symbolEffect(.bounce.up.wholeSymbol, options: .nonRepeating)
                                   
                            }
                            
                        }

                        Text(option.title)
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.primary)
                            .opacity(isSelected ? 1 : 0.75)

                    }
                }
            }

        }
    }

    @ViewBuilder
    func editAvatarView() -> some View {
        VStack(spacing: .themeSpacing * 5) {
            
            SheetHeaderView(
                title: String(localized: "Edit your avatar"),
                onClose: {
                    currentView = .optionsSelector
                }
            )
            .padding(.bottom, 10)

            VStack {
                Text("Hello")
            }
        }
    }
    
    @ViewBuilder
    private func getGoogleAuthenticatorAvatar() -> some View {
        Group {
            if let url = UserRepository.shared.getProfilePictureURL() {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
               
            } else {
                Image("user_b")
                    .resizable()
            }
        }
        .clipShape(Circle())
        .aspectRatio(contentMode: .fill)
        .clipShape(Circle())
    }
    
    /// Transform Monogram into a image to sent it
    private func applyTextBasedAvatar(_ options: TextBasedAvatarOptions, _ color: Color) {

        let view = MonogramView(
            mode: .send,
            text: options == .initials
                ? viewModel.getInitials() : viewModel.getMonogram(),
            backgroundColor: color
        )
        
        Task {
            if let image = view.asImage() {
               
                viewModel.uploadProfilePicture(image, from: options == .initials ? .initials : .monogram)
                try? await Task.sleep(for: .milliseconds(128))
                dismiss()
                
            }
        }
    }

    private func takePhotoUsingCamera(onComplete: @escaping (UIImage) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
                
        cameraCompletion = onComplete
        isCameraPresented = true
    }

    private func onSelect(_ image: UIImage) {
        Task {
            viewModel.uploadProfilePicture(image, from: .photo)
            /// Lets wait to hide the sheet correctly
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

struct ProfileImage: View {

    @ObservedObject var viewModel: ProfileDataModel
    var body: some View {
        
        Group {
            
            if viewModel.isUploading {
                /// Lets show a progress view when the new image is uploading 
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.regular)
                
            } else if let image = viewModel.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                   
            } else if let url = viewModel.avatarURL ?? UserRepository.shared.getAvatar() {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .id(url)
                
            } else if viewModel.selectedAvatarOptionView == .GoogleAuth, let url = UserRepository.shared.getProfilePictureURL() {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .id(url)
                
            } else {
                Image("user_b")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 130, height: 130)
        .clipShape(Circle())
        .overlay(alignment: .bottomTrailing) {
            Button {
                viewModel.showPicker.toggle()
            } label: {
                Image(systemName: "pencil.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .symbolColorRenderingMode(.gradient)
                    .font(.system(size: 30))
                    .foregroundColor(viewModel.isGuest ? .accentColor.mix(with: .black, by: 0.5) : .accentColor)
            }
            .disabled(viewModel.isGuest)
        }
        .sheet(isPresented: $viewModel.showPicker) {
            let animation: Animation = .snappy(duration: 0.3, extraBounce: 0)
            DynamicSheet(animation: animation) {
                UserAvatarPersonalizationSheet(
                    animation: animation,
                    viewModel: viewModel
                )
                .presentationBackground(Color.theme.background)
            }
            .background(Color.theme.background)
            .interactiveDismissDisabled()

        }
        

    }
}

#Preview {
    @Previewable
    @ObservedObject var profile = ProfileDataModel()

    VStack {
        ProfileImage(viewModel: profile)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.theme.cardBackground)
}
