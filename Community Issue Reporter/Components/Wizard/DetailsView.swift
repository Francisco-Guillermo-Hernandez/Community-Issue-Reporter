//
//  DetailsView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI

struct DetailsView: View {
    @Bindable var model: ReportDataModel
    
    init(_ model: ReportDataModel) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextInput(
                name: "Title",
                label: String(localized: "Title of the issue", comment: "ReportView: Title of the issue"),
                isValid: .constant(true),
                value: $model.report.title,
            )
            
            TextInput(
                name: "Description",
                label: String(localized: "Please describe the issue", comment: "ReportView: Please describe the issue"),
                axis: .vertical,
                isValid: .constant(true),
                value: $model.report.description,
                
            )
        }
        .padding(.top, 4)
    }
}


#Preview {
    let model: ReportDataModel = ReportDataModel.shared
    model.setMatterToSolve(mattersToResolve.first!)
    return DetailsView(model)
}
