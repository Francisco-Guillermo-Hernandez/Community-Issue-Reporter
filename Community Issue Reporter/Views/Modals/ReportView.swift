//
//  ReportView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 20/2/26.
//

import SwiftUI
import UIKit
import MapKit

struct Option: Hashable {
    var icon: String
    var text: String
}


struct ReportLocationView: View {
    @Bindable var model: ReportDataModel
    var numberOfSteps: Int
    @Binding var currentStep: Int
    @Binding var path: [ReportNavigationDestination]
    @State private var showMapPickerSheet: Bool = false
    var body: some View {
        VStack {
            SettingsHeaderView("Location")
            VStack {
                MiniMapLocator(
                    coordinate: $model.report.coordinate,
                    locator: $model.locator,
                    onExpandMap: { _ in
                        showMapPickerSheet.toggle()
                    }
                )
            }
            .overlay(
                RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous)
                                   .stroke(Color.theme.border, lineWidth: 1)
            )
            .cornerRadius(.themeRadius * 2)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1) // shadow-sm
            .sheet(isPresented: $showMapPickerSheet)  {
                MapPickerView(
                    coordinate: $model.report.coordinate,
                    locator: $model.locator,
                    onConfirm: { coordinate, locator in
                        model.updateCoordinate(coordinate)
                        model.updateLocator(with: locator)
                        self.showMapPickerSheet = false
                    }
                )
            }
            .frame(maxHeight: .infinity)
            
            Spacer()
        }
        .padding()
        .safeAreaInset(edge: .bottom, spacing: 16) {
            ThemedButton(message: "Next Step", action: {
                path.append(.attachMedia)
            }, type: .primary, style: .prominent)
                .padding()
        }
    }
}

struct AttachMediaView: View {
    @Bindable var model: ReportDataModel
    var numberOfSteps: Int
    @Binding var currentStep: Int
    @Binding var path: [ReportNavigationDestination]
    var body: some View {
        VStack {
            Text("Attach media")
            Spacer()
        }
        .safeAreaInset(edge: .bottom, spacing: 16) {
            ThemedButton(message: "Next Step", action: {
                path.append(.addInformation)
            }, type: .primary, style: .prominent)
                .padding()
        }
    }
}

struct AddInformationView: View {
    @Bindable var model: ReportDataModel
    var numberOfSteps: Int
    @Binding var currentStep: Int
    @Binding var path: [ReportNavigationDestination]
    var body: some View {
        ScrollView {
            VStack {
                SettingsGroup(title: "Details") {
                    TextInput(
                        name: "Address",
                        label: String(localized: "Please tell us where is the issue", comment: "ReportView: Please tell us where is the issue"),
                        axis: .vertical,
                        isValid: $model.isAddressValid,
                        value: $model.report.address
                    )
             
                    TextInput(
                        name: "Title",
                        label: String(localized: "Title of the issue", comment: "ReportView: Title of the issue"),
                        isValid: .constant(true),
                        value: $model.report.title
                    )
                }
                .padding()
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 16) {
            ThemedButton(message: "Next Step", action: {
                path.append(.finalStep)
            }, type: .primary, style: .prominent)
                .padding()
        }
    }
}

struct FinalStepView: View {
    @Bindable var model: ReportDataModel
    var numberOfSteps: Int
    @Binding var currentStep: Int
    var onFinish: () -> Void
    var body: some View {
        VStack {
            Text("Final Step")
            Spacer()
        }
        .safeAreaInset(edge: .bottom, spacing: 16) {
            ThemedButton(message: "Close", action: {
                onFinish()
            }, type: .outline, style: .prominent)
                .padding()
        }
    }
}


struct ReportWizardView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var model: ReportDataModel
    @State private var path: [ReportNavigationDestination] = []
    @State private var showDiscardAlert: Bool = false
    @State private var isSubmitting: Bool = false
    @State private var selectedImages: [MediaResources] = []
    @State private var numberOfSteps: Int = 4
    
    @State private var textInput: String = ""

    var showCancelButton: Bool = false
    var onCompletion: (String, AlertType) -> Void
    
    init(model: ReportDataModel, onCompletion: @escaping (String, AlertType) -> Void, showCancelButton: Bool = false) {
        self.model = model
        self.onCompletion = onCompletion
        self.showCancelButton = showCancelButton
    }
    
    private var isFormFilled: Bool {
        return true
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ReportLocationView(model: model, numberOfSteps: numberOfSteps, currentStep: .constant(1), path: $path)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        StepsIndicator(numberOfSteps: numberOfSteps, currentStep: .constant(1))
                            .frame(maxWidth: .infinity)
                    }
                    if showCancelButton {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                    }
                }
                .background(Color.theme.background)
                .navigationDestination(for: ReportNavigationDestination.self) { destination in
                    switch destination {
                    case .reportWizard:
                        EmptyView()
                    case .reportLocation:
                        ReportLocationView(model: model, numberOfSteps: numberOfSteps, currentStep: .constant(1), path: $path)
                    case .attachMedia:
                        AttachMediaView(model: model, numberOfSteps: numberOfSteps, currentStep: .constant(2), path: $path)
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    StepsIndicator(numberOfSteps: numberOfSteps, currentStep: .constant(2))
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .background(Color.theme.background)
                    case .addInformation:
                        AddInformationView(model: model, numberOfSteps: numberOfSteps, currentStep: .constant(3), path: $path)
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    StepsIndicator(numberOfSteps: numberOfSteps, currentStep: .constant(3))
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .background(Color.theme.background)
                    case .finalStep:
                        FinalStepView(model: model, numberOfSteps: numberOfSteps, currentStep: .constant(4), onFinish: {
                            performActions()
                        })
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                StepsIndicator(numberOfSteps: numberOfSteps, currentStep: .constant(4))
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .background(Color.theme.background)
                    }
                }
        }
    }
    
    private func performActions() -> Void {
        Task {
            print("on create:")
            dump(model.locator)
            
            if model.report.reportState == .inProgress || model.report.reportState == .new {
                model.report.id = await ReportRepository
                    .shared
                    .create(
                        report: model.report,
                        locator: model.locator,
                        onError: { error in
                            print("error: \(error)")
                        }
                    )
            }
            
            if model.report.reportState == .modifying {
                await ReportRepository
                    .shared
                    .update(
                        report: model.report,
                        locator: model.locator,
                        onComplete: { result in
                            print(result)
                        },
                        onError: { error in
                            print("error: \(error)")
                        }
                    )
            }
            
            if selectedImages.count > 0 {
                await ImageEncoderService().prepareAndSend(
                    reportId: model.report.id!,
                    images: selectedImages
                )
            }
            
            await MainActor.run {
                if model.report.id != "-1" {
                    dismiss()
                    onCompletion("Report submitted successfully.", .success)
                } else {
                    dismiss()
                    onCompletion("Error submitting report.", .error)
                }
            }
        }
    }
}

#Preview {
    let model: ReportDataModel = ReportDataModel.shared
    model.setMatterToSolve(mattersToResolve.first!)
    
    return ReportWizardView(model: model, onCompletion: { data, type in
            
    }, showCancelButton: true)
}

#Preview ("Final step") {
    let model: ReportDataModel = ReportDataModel.shared
    FinalStepView(model: model, numberOfSteps: 4, currentStep: .constant(4), onFinish: {})
}
