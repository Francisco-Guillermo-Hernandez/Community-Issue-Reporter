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
        
        .safeAreaInset(edge: .bottom, spacing: 16) {
            ThemedButton(message: "Next Step", action: {
                currentStep += 1
            }, type: .primary, style: .prominent)
//                .disabled(nextButtonValidator)
                .padding()
        }
        
    }
}

struct AttachMediaView:View {
    var body: some View {
        Text("Attach media")
    }
}


struct AddInformationView: View {
    @Bindable var model: ReportDataModel
    var body: some View {
        VStack {
            SettingsGroup(title: "Details") {
                TextInput(
                    name: "Address",
                    label: String(localized: "Please tell us where is the issue", comment: "ReportView: Please tell us where is the issue"),
                    axis: .vertical,
                    isValid: $model.isAddressValid,
                    value: $model.report.address,
                    
                )
         
                TextInput(
                                            name: "Title",
                                            label: String(localized: "Title of the issue", comment: "ReportView: Title of the issue"),
                                            isValid: .constant(true),
                                            value: $model.report.title,
                                        )
                             
            }
            .padding()
        }
    }
}



struct FinalStepView: View {
    var body: some View {
        Text("Final Step")
    }
}


struct ReportWizardView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var path: [ReportNavigationDestination]
    @Bindable var model: ReportDataModel
    @State private var showDiscardAlert: Bool = false
    @State private var isSubmitting: Bool = false
    @State private var selectedImages: [MediaResources] = []
    @State private var numberOfSteps: Int = 4
    @State private var currentStep: Int = 1
    
    
    @State private var textInput: String = ""

    
    var showCancelButton: Bool = false
    
    var onCompletion: (String, AlertType) -> Void
    
    
    
    init(path: Binding<[ReportNavigationDestination]>, model: ReportDataModel, onCompletion: @escaping (String, AlertType) -> Void, showCancelButton: Bool = false) {
        self._path = path
        self.model = model
        self.onCompletion = onCompletion
        self.showCancelButton = showCancelButton
    }
    
    private var isFormFilled: Bool {
        return true
    }
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: .themeSpacing * 1.5) {
                
                ReportLocationView(model: model, numberOfSteps: numberOfSteps, currentStep: $currentStep)
                
                
            }
            .padding(.top, 8)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                

                
                ToolbarItem(placement: .title) {
                    StepsIndicator(numberOfSteps: numberOfSteps, currentStep: $currentStep)
                        .frame(maxWidth: .infinity)
                }
                
                
                
                
//                ToolbarItem(placement: .confirmationAction) {
//                    Button {
//                        isSubmitting = true
//                        performActions()
//                        
//                    } label: {
//                        if isSubmitting {
//                            ProgressView()
//                                .progressViewStyle(.circular)
//                        } else {
//                            Label("Submit", systemImage: "checkmark")
//                        }
//                    }
//                    .disabled(isSubmitting)
//                }
            }
            .interactiveDismissDisabled(isFormFilled)
        }
        
        .background(Color.theme.background)
        
    }
    
    private func performActions() -> Void {
        Task {
            
            print("on create:")
            dump(model.locator)
            
            //
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
            
            // update when a user is modifying the report
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
            
            
            //
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
    
    
    var nextButtonValidator: Bool {
        currentStep == numberOfSteps
    }
}



#Preview {
    @Previewable
    @State  var path: [ReportNavigationDestination] = []
    
    
    let model: ReportDataModel = ReportDataModel.shared
    model.setMatterToSolve(mattersToResolve.first!)
    
    return NavigationStack {
        ReportWizardView(path: $path, model: model, onCompletion: { data, type in
            
        }, showCancelButton: true)
    }
}
