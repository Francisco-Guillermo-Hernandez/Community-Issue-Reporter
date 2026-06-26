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
            PhotoChooser(
                reportContainer: model.reportSession.reportContainer,
                uploadTrackers: $uploadTrackers
            )
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
