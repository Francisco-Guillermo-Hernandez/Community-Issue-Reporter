//
//  MediaStepView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI

struct MediaStepView: View {
    @Bindable var model: ReportDataModel
    @Binding var uploadTrackers: [PhotoUploadTracker]
    
    init(_ model: ReportDataModel, _ uploadTrackers: Binding<[PhotoUploadTracker]>) {
        self.model = model
        self._uploadTrackers = uploadTrackers
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .themeSpacing * 3) {
            #if DEBUG
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                Text("Image Picker Placeholder for Preview")
            } else {
                PhotoChooser(
                    reportContainer: model.reportSession.reportContainer,
                    uploadTrackers: $uploadTrackers
                )
            }
            #else
            #endif
            
        }
        .padding(.top, 4)
    }
}


#Preview {
    
    @Previewable @State var model = ReportDataModel.shared
    NavigationStack {
        VStack {
            MediaStepView(model, .constant([]))
        }
        .padding()
        .background(Color.theme.background)
    }
    
}
