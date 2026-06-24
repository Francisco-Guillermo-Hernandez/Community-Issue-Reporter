//
//  Share.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 7/6/26.
//

import UIKit

func shareFromClosure(item: Any) {
       guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
             let rootViewController = windowScene.windows.first?.rootViewController else {
           return
       }
       
       let activityVC = UIActivityViewController(activityItems: [item], applicationActivities: nil)
       
       // Needed for iPad compatibility to prevent crashing
       if let popoverController = activityVC.popoverPresentationController {
           popoverController.sourceView = rootViewController.view
           popoverController.sourceRect = CGRect(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY, width: 0, height: 0)
           popoverController.permittedArrowDirections = []
       }
       
       rootViewController.present(activityVC, animated: true)
   }
