//
//  VideoChooser.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/4/26.
//

import SwiftUI
import UIKit
import MobileCoreServices

struct VideoChooser: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

class VideoPickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func openVideoPicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        
        // This is crucial: enables video mode
        picker.mediaTypes = ["public.movie"]
        
        // Optional video settings
        picker.videoQuality = .typeHigh
        picker.videoMaximumDuration = 60 // seconds
        
        present(picker, animated: true)
    }
}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    // Dismiss the picker
    picker.dismiss(animated: true, completion: nil)
    
    // Retrieve the video URL
    if let videoURL = info[.mediaURL] as? URL {
        print("Video URL: \(videoURL)")
        // You can now play this URL or upload it
    }
}



// MARK: - Preview
#Preview {
    VideoChooser()
}
