//
//  CameraView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/4/26.
//

import SwiftUI
import Photos

enum CameraActions: String, CaseIterable, Identifiable {
    case takePhoto = "takePhoto"
    case takeVideo = "takeVideo"
    
    var description: String {
        switch self {
            case .takePhoto: return String(localized: "Photo")
            case .takeVideo: return String(localized: "Video")
        }
    }
    
    var id: String { self.rawValue }
}

struct CameraView: View {
    @State private var orientation = UIDeviceOrientation.portrait
    @State private var model = DataModel()
    @State private var constantColorEnabled = false
    @State private var fallbackPhotoDeliveryEnabled = false
    @State private var flashEnabled = false
    @State private var showFlashError = false
    @State private var showFallbackPhotoDeliveryError = false
    @Environment(\.scenePhase) var scenePhase
    @State private var selection: CameraActions = .takePhoto
   
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                Image("pothole")
                    .resizable()
                    .scaledToFit()
//               if !isCameraAuthorized() {
//                   
//                   ContentUnavailableView {
//                       Label("You haven't authorized  to use the camera", systemImage: "lock.trianglebadge.exclamationmark.fill")
//                           .symbolRenderingMode(.palette)
//                           .foregroundStyle(
//                                Color.theme.foreground.opacity(0.7),
//                                Color.theme.primary,
//                                Color.theme.foreground.opacity(0.7)
//                           )
//                   } description: {
//                       Text("Change these settings in Settings.")
//                           .foregroundStyle(Color.theme.primary)
//                   } actions: {
//                      
//                       ThemedButton(message: "Open Settings", action: openSettings, type: .primary)
//                   }
//                   .background(Color.theme.background)
//                   
//                } else {
//                    ViewFinderView(image: $model.viewfinderImage)
//                        
//                        .fullScreenCover(isPresented: $model.camera.photosViewVisible) {
//                            PhotosTabView(
//                                normalPhoto: model.camera.normalPhoto,
//                                constantColorImage: model.camera.constantColorPhoto,
//                            )
//                        }
//                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
           
            .foregroundStyle(Color.black)
            .task {
                await model.camera.start()
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    Task { await model.camera.checkCameraAuthorization() }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation = UIDevice.current.orientation
            }
            .onAppear {
                orientation = UIDevice.current.orientation
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .statusBar(hidden: true)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if isCameraAuthorized() {
                bottomBarView
            }
        }
    }
     

    var bottomBarView: some View {
        VStack {
            
            ShutterButton(action: takePhoto)
                .padding(.top, 24)
            
//            CustomSegmentedControl()

        }
        .frame(maxWidth: .infinity)
        .disabled(!model.camera.shutterButtonAvailable)
        .background(Color.init(hex: "1a181b"))

    }
    
    private func takePhoto() {
        model.camera.constantColorEnabled = false
        model.camera.fallBackPhotoDeliveryEnabled = true
        model.camera.flashEnabled = false
        model.camera.takePhoto()
    }
}

func openSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url)
    }
}

func isCameraAuthorized() -> Bool {
    return true// AVCaptureDevice.authorizationStatus(for: .video) == .authorized
}

struct ShutterButton: View {
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            Label {
                Text("Take Photo")
            } icon: {
                ZStack {
                    Circle()
                        .strokeBorder(
                            Color.white,
                            lineWidth: !isEnabled ? 3 : 1
                        )
                        .frame(width: !isEnabled ? 65 : 62, height: !isEnabled ? 65 : 62)
                        .animation(.interpolatingSpring(mass: 2.0, stiffness: 100.0, damping: 10, initialVelocity: 0), value: !isEnabled)
                    Circle()
                        .fill(Color.white)
                        .frame(width: !isEnabled ? 55 : 50, height: !isEnabled ? 55 : 50)
                        .animation(.interpolatingSpring(mass: 2.0, stiffness: 100.0, damping: 10, initialVelocity: 0), value: !isEnabled)
                }
            }
        }
        .glassEffect(in: .circle)
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
    }
}


#Preview {
    CameraView()
}


class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

