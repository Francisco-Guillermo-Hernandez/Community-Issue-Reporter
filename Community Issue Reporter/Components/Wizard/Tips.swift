//
//  Tips.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 4/7/26.
//

import SwiftUI
import TipKit

struct TipsDemo: View {
    let takeAPhotoTip = TakeAPhotoTip()
    var body: some View {
        Text("Demo")
            .popoverTip(takeAPhotoTip, arrowEdge: .top)
        
        Button {
            Task {
                await takeAPhotoTip.resetEligibility()
            }
        } label: {
            Text("Hello")
        }
    }
}

#Preview {
    TipsDemo()
}

struct TakeAPhotoTip: Tip {
    @State private var numberOfPhotos: Int = 6
    
    var title: Text {
        Text(String(localized: "Attach photos"))
    }
    
    var message: Text? {
        Text(String(localized: "You can take up to \(numberOfPhotos) photos"))
    }
    
    var image: Image? {
        Image(systemName: "camera")
    }
}
