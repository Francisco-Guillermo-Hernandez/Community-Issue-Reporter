//
//  Community_Issue_ReporterApp.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 18/2/26.
//

import SwiftUI
import GoogleSignIn
import AppIntents
import WidgetKit

@main
struct Community_Issue_ReporterApp: App {
    
    @StateObject private var authViewModel = AuthViewModel()
    @State private var store = Store()
    @AppStorage("selectedLanguage") private var languageCode = "es-419"
    
    init() {
        copyDatabaseIfNeeded()
        AppShortcuts.updateAppShortcutParameters()
    }
    
    var body: some Scene {
        WindowGroup {
//            WelcomeView()
            SwiftUIView()
                .environmentObject(authViewModel)
                .environment(\.mySettings, store)
                .environment(\.locale, .init(identifier: languageCode))
                .onOpenURL { url in
                    deepLinkHandler(url)
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
    
    
}

//func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
//    return imageSelection.loadTransferable(type: Image.self) { result in
//        DispatchQueue.main.async {
//            guard imageSelection == self.imageSelection else { return }
//            switch result {
//            case .success(let image?):
//                // Handle the success case with the image.
//            case .success(nil):
//                // Handle the success case with an empty value.
//            case .failure(let error):
//                // Handle the failure case with the provided error.
//            }
//        }
//    }
//}


//@State private var selectedItems: [PhotosPickerItem] = []
//
//PhotosPicker(
//    selection: $selectedItems,
//    maxSelectionCount: 5,
//    selectionBehavior: .ordered,
//    matching: .images
//) {
//    Text("Select up to 5 photos")
//}


//
//import SwiftUI
//import PhotosUI
//
//struct SinglePhotoPicker: View {
//    @State private var selectedItem: PhotosPickerItem?
//    @State private var selectedImage: Image?
//
//    var body: some View {
//        VStack {
//            // Display the selected image if it exists
//            selectedImage?
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300, height: 300)
//
//            // The PhotosPicker view
//            PhotosPicker(selection: $selectedItem, matching: .images) {
//                Label("Select a photo", systemImage: "photo")
//            }
//            .onChange(of: selectedItem) { _ in
//                Task {
//                    // Load the selection as a SwiftUI Image
//                    if let image = try? await selectedItem?.loadTransferable(type: Image.self) {
//                        selectedImage = image
//                    }
//                }
//            }
//        }
//    }
//
//}

//https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-select-pictures-using-photospicker
