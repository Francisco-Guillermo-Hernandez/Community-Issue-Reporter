//
//  ReportWizardContainer.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI


// MARK: - Main Container

struct ReportWizardContainer: View {
    @Bindable var model: ReportDataModel
    @Environment(\.dismiss) private var dismiss
    @State private var controller: ReportController
    @FocusState private var focusedField: WizardElements?
    
    var showCancelButton: Bool = false
    var onCompletion: (String, AlertType) -> Void
    var reportToModify: Report? = nil
    
    init(
        model: ReportDataModel,
        onCompletion: @escaping (String, AlertType) -> Void,
        showCancelButton: Bool = false,
        reportToModify: Report? = nil
    ) {
        self.model = model
        self.onCompletion = onCompletion
        self.showCancelButton = showCancelButton
        self.reportToModify = reportToModify
        self.controller = ReportController()
        
        print("Report state: ")
        print(model.report.reportState )
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            /// Screen Background
            Color.theme.background
                .ignoresSafeArea()
           
            /// Top Glow Gradient representing the active step color
            controller.currentStep.color
                .opacity(0.12)
                .frame(height: 280)
                .mask(
                    LinearGradient(
                        colors: [.white, .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .blur(radius: 20)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                /// FIXED HEADER
//                wizardHeader()
//                    .padding()
                
                /// STEP FLOW
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(ReportStep.allCases, id: \.self) { step in
                                StepCardView(
                                    step: step,
                                    currentStep: controller.currentStep,
                                    metadata: stepsMetadata[step.metadataKey]
                                ) {
                                    Group {
                                        switch step {
                                        case .location:
                                            LocationStepView(model)
                                        case .media:
                                            MediaStepView(model, $model.uploadTrackers)
                                        case .details:
                                            DetailsView(model, $focusedField)
                                        case .confirmation:
                                            ConfirmationView(
                                                id: $controller.reportId,
                                                url: $controller.shareableLink
                                            )
                                        }
                                    }
                                }
                                .id(step)
                                .onTapGesture {
                                    guard controller.currentStep != .confirmation, step != .confirmation else { return }
                                    
                                    if model.report.reportState == .modifying || step < controller.currentStep {
                                        withAnimation(.snappy(duration: 0.45, extraBounce: 0.08)) {
                                            controller.currentStep = step
                                        }
                                    }
                                }
                                /// Smoothly animate the transitions of layout changes and background gradient
                                .animation(.snappy(duration: 0.45, extraBounce: 0.08), value: controller.currentStep)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                    .onChange(of: controller.currentStep) { _, newValue in
                        if newValue == .confirmation {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.snappy(duration: 0.45, extraBounce: 0.08)) {
                                    proxy.scrollTo(WizardElements.final, anchor: .bottom)
                                }
                            }
                        } else {
                            withAnimation(.snappy(duration: 0.45, extraBounce: 0.08)) {
                                proxy.scrollTo(newValue, anchor: .center)
                            }
                        }
                    }
                    .onChange(of: focusedField) { _, newField in
                           if let fieldToScroll = newField {
                               /// Slight delay allows the keyboard to present fully before calculating the scroll geometry
                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                                   withAnimation(.snappy(duration: 0.45, extraBounce: 0.08)) {
                                      
                                    proxy.scrollTo(fieldToScroll, anchor: .center)
                                }
                            }
                        }
                    }
                }
            
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            
            wizardFooter()
                .padding(.horizontal)
                .padding(.top, 0)
                .padding(.bottom)
        }
        .navigationTitle("Create a Report")
        .navigationSubtitle(String(localized: "Step \(controller.currentStep.rawValue) of 4"))
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.impact(weight: .light, intensity: 0.6), trigger: controller.currentStep) { oldValue, newValue in
            return newValue > oldValue
        }
//        .toolbarTitleDisplayMode(.inline)
//        .toolbarVisibility(.hidden, for: .navigationBar)
        .enableInteractivePopGesture()
        .sensoryFeedback(.success, trigger: controller.doneTrigger)
        .task {
            if let reportToModify {
                model.prepareForModification(reportToModify)
                if let matter = mattersToResolve.first(where: { $0.id == reportToModify.matterToSolveId }) {
                    model.setMatterToSolve(matter)
                }
            }
            
            await self.controller.startRePorting(model)
            
            if model.report.reportState == .modifying {
                model.uploadTrackers = model.getAttachmentsAsTrackers()
            }
        }
        .alert("Status Update", isPresented: $controller.presentAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(controller.alertMessage)
        }
    }
    
    // MARK: - Subviews
    @ViewBuilder
    private func wizardHeader() -> some View {
        VStack(spacing: .themeSpacing * 3) {
            
            HStack {
                Text(String(localized: "Step \(controller.currentStep.rawValue) of 4"))
                    .font(.headline)
                    .foregroundColor(Color.theme.foreground)
            }
            
            ProgressView(value: Double(controller.currentStep.rawValue), total: 4)
                .shimmering()
                .tint(controller.currentStep.color)
                .background(Color.theme.inputBorder)
                .scaleEffect(x: 1, y: 1.2, anchor: .center)
        }
    }
    
    @ViewBuilder
    private func wizardFooter() -> some View {
        HStack {
            if controller.currentStep < .confirmation {
                
                ThemedButton(
                    message: controller.buttonMessage,
                    action: {
                        controller.submit(model, model.uploadTrackers)
                    },
                    type: .primary,
                    style: .prominent,
                    icon: "",
                    isLoading: $controller.isLoading
                )
                .disabled(disableButton)
                .accessibilityIdentifier("Report\(controller.currentStep.rawValue)Button")
                
            } else {
                ThemedButton(
                    message: String(localized: "Done"),
                    action: done,
                    type: .secondary,
                    style: .prominent
                )
                .accessibilityIdentifier("ReportDoneButton")
               
            }
        }
    }
  
    
    // MARK: - validations
    
    var isLocationStepReadyToContinue: Bool {
        model.isDifferentLocation
    }
 
    var isReadyToContinue: Bool {
        !model.uploadTrackers.isEmpty && model.uploadTrackers.allSatisfy { $0.phase == .success }
    }
    
    var areDetailsValid: Bool {
        model.isTitleValid && model.isDescriptionValid && model.isAddressValid
    }
    
    var disableButton: Bool {
        switch controller.currentStep {
            case .location: return !isLocationStepReadyToContinue
            case .details: return !areDetailsValid
            case .media: return !isReadyToContinue
            case .confirmation: return false
        }
    }
    
    func done() {
        controller.doneTrigger.toggle()
        model.clear()
        dismiss()
    }
}


#Preview() {
    let model: ReportDataModel = ReportDataModel.shared
    model.setMatterToSolve(mattersToResolve.first!)
    return NavigationStack {
        ReportWizardContainer(model: model, onCompletion: { data, type in
            
        }, showCancelButton: true)
        .environment(SettingsStore())
    }
}
