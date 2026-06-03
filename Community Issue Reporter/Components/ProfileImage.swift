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

import SwiftUI

// MARK: - Custom SheetHeader to be used with the custom SheetView
struct SheetHeaderView: View {
    let title: String
    let onClose: () -> Void
    var body: some View {
        HStack {
            Button(role: .close, action: onClose) {
               Image(systemName: "xmark")
                    .font(.system(size: 23, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .lineHeight(.multiple(factor: 1.5))
                    .padding(.all, 4)
           }
           .buttonBorderShape(.circle)
           .contentShape(.circle)
           .buttonStyle(.glass)
           .frame(maxWidth: 45)
           
           Text(title)
                .font(.headline)
               .frame(maxWidth: .infinity)
               .foregroundStyle(.primary)
            
           Spacer()
               .frame(maxWidth: 45)
        }
    }
}


// MARK: - Color Grid
struct ColorGrid: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedColor: Color
    var colors: [Color]

    var body: some View {
        LazyVGrid(columns: columns, spacing: .themeSpacing * 4) {
            ForEach(colors, id: \.self) { color in
                Circle()
//                    .fill(selectedColor == color ? color : color.mix(with: .white, by: 0.4))
                    .fill(color.opacity(isSelected(color) ? 1 : 0.75))
                    .scaleEffect(isSelected(color) ? 1.15 : 1)
                    .frame(width: 40, height: 40)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected(color))
                    .overlay {
                        if selectedColor == color {
                            
                            ZStack {
                                Circle()
                                    .stroke(Color.theme.border, lineWidth: 2 )
                                
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.caption.bold())
                            }
                            
                        }
                        
                        
                    }
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
    
    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.fixed(40), spacing: 15),
            count: 6
        )
    }
    
    private func isSelected(_ color: Color) -> Bool {
        selectedColor == color
    }
}

struct MonogramView: View {
    var mode: MonogramMode = .preview
    var text: String
    var backgroundColor: Color
    var body: some View {
        ZStack {
            backgroundColor
            Text(text)
                .font(.system(size: mode == .preview ? 36 : 90, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(
            width: mode == .preview ? 80 : 200,
            height: mode == .preview ? 80 : 200
        )
        .clipShape(Circle())
    }
}

extension View {
    func asImage() -> UIImage? {
        let controller = UIHostingController(
            rootView: self.edgesIgnoringSafeArea(.all)
        )
        let view = controller.view

        let targetSize = CGSize(width: 200, height: 200)  // Fixed size for avatars
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(
                in: CGRect(origin: .zero, size: targetSize),
                afterScreenUpdates: true
            )
        }
    }
}

struct AvatarOption: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var associatedView: CurrentView
    var image: Image?
}

// MARK: - Options
let options: [AvatarOption] = [
    .init(title: String(localized: "Google Auth"), associatedView: .google),
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
    @State private var currentView: CurrentView = .optionsSelector
    @State private var selectedPeriod: AvatarOption?
    @State private var duration: String = ""
    @State private var selectedColor: Color = .orange
    @State var orientation = UIDevice.current.orientation

    @State private var selectedImages: UIImage? = nil
    @State private var cameraCompletion: ((UIImage) -> Void)? = nil
    @State private var isCameraPresented: Bool = false

    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: .themeSpacing * 5) {
            ZStack {
                switch currentView {

                case .optionsSelector:
                    optionsSelectorView()
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

                case .initials:
                    textBasedAvatarView(.initials)

                case .google:
                    Text("Google auth")
                }
            }
            .geometryGroup()
        }
        //        .presentationBackground(Color.white)
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
                backgroundColor: selectedColor
            )

            ColorGrid(
                selectedColor: $selectedColor,
                colors: viewModel.backgroundColors
            )

            ThemedButton(
                message: String(localized: "Save"),
                action: {
                    applyTextBasedAvatar(option, selectedColor)
                },
                type: .outline
            )
            .padding(.horizontal)
            .padding(.top, .themePadding)
        }

    }

    @ViewBuilder
    func optionsSelectorView() -> some View {
        VStack(spacing: .themeSpacing * 5) {
            SheetHeaderView(title: String(localized: "Create your Avatar from"), onClose: {
                dismiss()
            })
           
            /// Grid Box View
            LazyVGrid(
                columns: Array(repeating: GridItem(), count: 3),
                spacing: .themeSpacing * 4
            ) {
                ForEach(options) { option in
                    let isSelected = selectedPeriod?.id == option.id

                    VStack {
                        Group {
                            if option.associatedView == .google {
                                Image("user_b")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())

                            }

                            if option.associatedView == .camera {

                                Button {
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
                                .buttonStyle(.borderless)
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
                                .buttonStyle(.borderless)
                                .onChange(of: selectedPhotoItems) { _, newItems in
                                    guard !newItems.isEmpty else { return }
                                    loadSelectedImages(from: newItems) { image in
                                        if let avatar = image {
                                            onSelect(avatar)
                                        }
                                       
                                    }
                                }
                            }

                            if option.associatedView == .initials {
                                MonogramView(
                                    text: viewModel.getInitials(),
                                    backgroundColor: .purple
                                )

                            }

                            if option.associatedView == .monogram {
                                MonogramView(
                                    text: viewModel.getMonogram(),
                                    backgroundColor: .purple
                                )

                            }

                            if option.associatedView == .avatar {
                                Image("user_b")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            }
                        }

//                        .opacity(isSelected ? 1 : 0.72)
                        .onTapGesture {
                            withAnimation(animation) {
                                if option.associatedView == .google
                                    || option.associatedView == .photo
                                {
                                    selectedPeriod = isSelected ? nil : option
                                } else {
                                    currentView = option.associatedView
                                }

                                if option.associatedView == .photo {
                                    currentView = .camera
                                }

                            }
                        }

                        Text(option.title)
                            .fontWeight(.semibold)
                            .font(.footnote)

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

    /// Transform Monogram into a image to sent it
    private func applyTextBasedAvatar(_ options: TextBasedAvatarOptions, _ color: Color) {

        let view = MonogramView(
            mode: .send,
            text: options == .initials
                ? viewModel.getInitials() : viewModel.getMonogram(),
            backgroundColor: color
        )
        if let image = view.asImage() {
            viewModel.uploadProfilePicture(image)
            dismiss()
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
        viewModel.uploadProfilePicture(image)
        dismiss()
    }
    
    private func loadSelectedImages(from items: [PhotosPickerItem], onComplete: @escaping (UIImage?) -> Void) {
        Task {
            var image: UIImage?
           
            /// To UIImage
            if let data = try? await items[0].loadTransferable(type: Data.self){
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
            if let image = viewModel.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            } else if let url = UserRepository.shared.getProfilePictureURL() {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)
                .clipShape(Circle())
            } else {
                Image("user_b")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())

            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                viewModel.showPicker.toggle()
            } label: {
                Image(systemName: "pencil.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 30))
                    .foregroundColor(.accentColor)
            }
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

    ProfileImage(viewModel: profile)
}
