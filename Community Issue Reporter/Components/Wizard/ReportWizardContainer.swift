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
    @State private var currentStep: ReportStep = .location
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var uploadTrackers: [PhotoUploadTracker] = []
    @State private var doneTrigger: Bool = false
    @StateObject private var controller: ReportController
    
    var showCancelButton: Bool = false
    var onCompletion: (String, AlertType) -> Void
    
    init(model: ReportDataModel, onCompletion: @escaping (String, AlertType) -> Void, showCancelButton: Bool = false) {
        self.model = model
        self.onCompletion = onCompletion
        self.showCancelButton = showCancelButton
        self._controller = StateObject(wrappedValue: ReportController())
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            /// Screen Background
            Color.theme.background
                .ignoresSafeArea()
           
            /// Top Glow Gradient representing the active step color
            currentStep.color
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
                wizardHeader()
                    .padding()
                
                /// STEP FLOW
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(ReportStep.allCases, id: \.self) { step in
                                StepCardView(
                                    step: step,
                                    currentStep: currentStep,
                                    metadata: stepsMetadata[step.metadataKey]
                                ) {
                                    Group {
                                        switch step {
                                        case .location:
                                            LocationStepView(model)
                                        case .media:
                                            MediaStepView(model, $uploadTrackers)
                                        case .details:
                                            DetailsView(model)
                                        case .confirmation:
                                            ConfirmationView(id: $controller.reportId)
                                        }
                                    }
                                }
                                .id(step)
                                .onTapGesture {
                                    if step < currentStep {
                                        withAnimation(.snappy(duration: 0.45, extraBounce: 0.08)) {
                                            currentStep = step
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                    .onChange(of: currentStep) { _, newValue in
                        withAnimation(.snappy(duration: 0.45, extraBounce: 0.08)) {
                            proxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }
            
            }
            .ignoresSafeArea(edges: .init(arrayLiteral: .bottom) )
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomFadedView {
                wizardFooter()
                    .padding()
            }
        }
        /// Smoothly animate the transitions of layout changes and background gradient
        .animation(.snappy(duration: 0.45, extraBounce: 0.08), value: currentStep)
        .sensoryFeedback(.impact(weight: .light, intensity: 0.6), trigger: currentStep) { oldValue, newValue in
            return newValue > oldValue
        }
        .toolbarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .navigationBar)
        .sensoryFeedback(.success, trigger: doneTrigger)
        .task {
            await self.controller.startRePorting(model)
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
                Text("Step \(currentStep.rawValue) of 4")
                    .font(.headline)
                    .foregroundColor(Color.theme.foreground)
            }
            
            ProgressView(value: Double(currentStep.rawValue), total: 4)
                .tint(currentStep.color)
                .background(Color.gray.opacity(0.2))
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
        }
    }
    
    @ViewBuilder
    private func wizardFooter() -> some View {
        HStack {
            if currentStep < .confirmation {
                
                ThemedButton(
                    message: buttonMessage,
                    action: {
                       
                        if currentStep == .media && isReadyToContinue {
                            controller.submitGroupedAttachments(attachments: uploadTrackers, using: model)
                            goNext()
                        }
                        
                        if currentStep == .details {
                           
                            controller.submitReport(model)
                            goNext()
                           
                        } else {
                            goNext()
                        }
                        
                    },
                    type: .primary,
                    style: .prominent,
                    icon: ""
                )
                .disabled(disableButton)
                
            } else {
                Button(action: { doneTrigger.toggle(); dismiss() }) {
                    Text("Done")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(currentStep.color)
                        .foregroundColor(.white)
                        .contentShape(Capsule())
                        .clipShape(Capsule())
                    
                }
               
            }
        }
    }
  
    
    // MARK: - Logic
    private var disableButton: Bool {
        switch currentStep {
            case .media: return !isReadyToContinue
            default: return false
        }
    }
    
    private var isReadyToContinue: Bool {
        !uploadTrackers.isEmpty && uploadTrackers.allSatisfy { $0.phase == .success }
    }
    
  
    private func goNext() {
        if let next = ReportStep(rawValue: currentStep.rawValue + 1) {
            currentStep = next
        }
    }
    
    private func goBack() {
        if let prev = ReportStep(rawValue: currentStep.rawValue - 1) {
            currentStep = prev
        }
    }
    
    private var buttonMessage: String {
        currentStep == .details ? String(localized: "Submit") : String(localized: "Next")
    }
}


#Preview() {
    let model: ReportDataModel = ReportDataModel.shared
    model.setMatterToSolve(mattersToResolve.first!)
    return NavigationStack {
        ReportWizardContainer(model: model, onCompletion: { data, type in
            
        }, showCancelButton: true)
    }
}
