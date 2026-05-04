//
//  CustomCameraView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 29/4/26.
//

import SwiftUI
import UIKit

struct CustomCameraView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    var onImageCaptured: ((UIImage) -> Void)?
    var onVideoCaptured: ((URL) -> Void)?

    func makeUIViewController(context: Context) -> CustomCameraViewController {
        let controller = CustomCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CustomCameraViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CustomCameraDelegate {
        var parent: CustomCameraView
        
        init(_ parent: CustomCameraView) {
            self.parent = parent
        }
        
        func didCaptureImage(_ image: UIImage) {
            parent.onImageCaptured?(image)
            parent.dismiss()
        }
        
        func didCaptureVideo(_ videoURL: URL) {
            parent.onVideoCaptured?(videoURL)
            parent.dismiss()
        }
        
        func didTapClose() {
            parent.dismiss()
        }
    }
}

protocol CustomCameraDelegate: AnyObject {
    func didCaptureImage(_ image: UIImage)
    func didCaptureVideo(_ videoURL: URL)
    func didTapClose()
}

#Preview {
    CustomCameraView()
}


import UIKit
import AVFoundation

class CustomCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {

    weak var delegate: CustomCameraDelegate?
    
    // MARK: - UI Elements
    private let captureButton = UIButton()
    private let modeSegmentedControl = UISegmentedControl(items: ["PHOTO", "VIDEO"])
    private let cameraView = UIView() // The live camera preview
    private let closeButton = UIButton()
    private let flipCameraButton = UIButton()
    private let zoomLevelStackView = UIStackView() // Placeholder for .5x, 1x, 3x labels

    // MARK: - AVFoundation Properties
    private var captureSession: AVCaptureSession!
    private var photoOutput: AVCapturePhotoOutput!
    private var movieFileOutput: AVCaptureMovieFileOutput!
    private var activeOutput: AVCaptureOutput? // Track whether photo or video is active
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkCameraPermissions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Start the capture session in the background
        if captureSession?.isRunning == false {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black

        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraView)

        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.backgroundColor = .white
        captureButton.layer.cornerRadius = 35 // Circle shape
        captureButton.layer.borderWidth = 5
        captureButton.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        captureButton.addTarget(self, action: #selector(didTapCapture), for: .touchUpInside)
        view.addSubview(captureButton)

        modeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        modeSegmentedControl.selectedSegmentIndex = 0 // PHOTO is default
        modeSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        modeSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.yellow], for: .selected)
        modeSegmentedControl.addTarget(self, action: #selector(didChangeMode), for: .valueChanged)
        view.addSubview(modeSegmentedControl)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        view.addSubview(closeButton)
        
        flipCameraButton.translatesAutoresizingMaskIntoConstraints = false
        flipCameraButton.setImage(UIImage(systemName: "camera.rotate"), for: .normal)
        flipCameraButton.tintColor = .white
        flipCameraButton.addTarget(self, action: #selector(didTapFlip), for: .touchUpInside)
        view.addSubview(flipCameraButton)

        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            
            modeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modeSegmentedControl.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -20),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            flipCameraButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            flipCameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            flipCameraButton.widthAnchor.constraint(equalToConstant: 44),
            flipCameraButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - AVFoundation Setup
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                }
            }
        default:
            break
        }
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()

        // 1. Setup Input (Back Camera)
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        guard let input = try? AVCaptureDeviceInput(device: backCamera) else { return }
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        // 2. Setup Outputs (Both Photo and Video)
        photoOutput = AVCapturePhotoOutput()
        movieFileOutput = AVCaptureMovieFileOutput()

        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        if captureSession.canAddOutput(movieFileOutput) {
            captureSession.addOutput(movieFileOutput)
        }

        // Initially set PHOTO as the default output
        activeOutput = photoOutput
        captureSession.sessionPreset = .photo // Optimal for initial mode

        captureSession.commitConfiguration()

        // 3. Setup Preview Layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = view.bounds
        cameraView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }

    // MARK: - Interaction
    @objc private func didChangeMode(_ sender: UISegmentedControl) {
        captureSession.beginConfiguration()

        if sender.selectedSegmentIndex == 0 { // PHOTO Mode
            activeOutput = photoOutput
            captureSession.sessionPreset = .photo
        } else { // VIDEO Mode
            activeOutput = movieFileOutput
            captureSession.sessionPreset = .high // Example video preset
        }

        captureSession.commitConfiguration()
    }

    @objc private func didTapCapture() {
        if activeOutput == photoOutput {
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        } else if activeOutput == movieFileOutput {
            if !movieFileOutput.isRecording {
                let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
                movieFileOutput.startRecording(to: tempURL, recordingDelegate: self)
                captureButton.backgroundColor = .red
            } else {
                movieFileOutput.stopRecording()
                captureButton.backgroundColor = .white
            }
        }
    }
    
    @objc private func didTapClose() {
        delegate?.didTapClose()
    }
    
    @objc private func didTapFlip() {
        guard let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput else { return }
        captureSession.beginConfiguration()
        captureSession.removeInput(currentInput)
        
        let newPosition: AVCaptureDevice.Position = currentInput.device.position == .back ? .front : .back
        guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition),
              let newInput = try? AVCaptureDeviceInput(device: newDevice) else {
            captureSession.addInput(currentInput)
            captureSession.commitConfiguration()
            return
        }
        
        if captureSession.canAddInput(newInput) {
            captureSession.addInput(newInput)
        } else {
            captureSession.addInput(currentInput)
        }
        captureSession.commitConfiguration()
    }
    
    // MARK: - Photo Capture Delegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else { return }
        delegate?.didCaptureImage(image)
    }
    
    // MARK: - File Output Recording Delegate
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording video: \(error.localizedDescription)")
            return
        }
        delegate?.didCaptureVideo(outputFileURL)
    }
}

// Ensure delegates (AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate) are implemented.
