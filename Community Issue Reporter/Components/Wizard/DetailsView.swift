//
//  DetailsView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI

// MARK: - Definitions
enum WizardElements: nonisolated Hashable, Sendable {
    case reportTitle
    case reportDescription
    case reportAddress
    
    case shareButton
    case copyCodeButton
    
    case final
}

// MARK: - View
struct DetailsView: View {
    @Bindable var model: ReportDataModel
    @FocusState.Binding var focusedField: WizardElements?
    
    init(_ model: ReportDataModel, _ focusedField: FocusState<WizardElements?>.Binding) {
        self.model = model
        self._focusedField = focusedField
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            /// Text field to give a tittle to the report
            TextInput(
                name: model.titlePlaceholder,
                label: String(
                    localized: "Title of the issue", 
                    comment: "ReportView: Title of the issue"
                ),
                validators: titleValidator,
                isValid: $model.isTitleValid,
                value: $model.report.title,
            )
            .id(WizardElements.reportTitle)
            .focused($focusedField, equals: .reportTitle)
            
            /// Text field to describe what occurred
            TextInput(
                name: model.descriptionPlaceholder,
                label: String(
                    localized: "Please describe the issue", 
                    comment: "ReportView: Please describe the issue"
                ),
                validators: descriptionValidator,
                axis: .vertical,
                isValid: $model.isDescriptionValid,
                value: $model.report.description,
            )
            .id(WizardElements.reportDescription)
            .focused($focusedField, equals: .reportDescription)
            
            /// Text field to type address of the place where the problem occurred
            TextInput(
                name: "Address",
                label: String(
                    localized: "Please tell us where is the issue",
                    comment: "ReportView: Please tell us where is the issue"
                ),
                validators: addressValidator,
                regex: .customPattern(addressRegex),
                axis: .vertical,
                isValid: $model.isAddressValid,
                value: $model.report.address,
            )
            .id(WizardElements.reportAddress)
            .focused($focusedField, equals: .reportAddress)
        }
        .task {
            focusedField = .reportTitle
        }
        .padding(.top, 4)
    }
}

// MARK: - Preview
#Preview {
    @Previewable @FocusState var focusedField: WizardElements?
    let model: ReportDataModel = ReportDataModel.shared
    model.setMatterToSolve(mattersToResolve.first!)
    return DetailsView(model, $focusedField)
}
