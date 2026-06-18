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
    
    // Form Data State held at the container level
    @State private var selectedLocation: String = ""
    @State private var attachedMedia: [UIImage] = []
    @State private var detailsName: String = ""
    @State private var detailsEmail: String = ""
    @State private var detailsDescription: String = ""
    @State private var doneTrigger: Bool = false
    
    
    var showCancelButton: Bool = false
    var onCompletion: (String, AlertType) -> Void
    
    init(model: ReportDataModel, onCompletion: @escaping (String, AlertType) -> Void, showCancelButton: Bool = false) {
        self.model = model
        self.onCompletion = onCompletion
        self.showCancelButton = showCancelButton
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
                                            MediaStepView(media: $attachedMedia)
                                        case .details:
                                            DetailsView(name: $detailsName, email: $detailsEmail, description: $detailsDescription)
                                        case .confirmation:
                                            ConfirmationView()
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
                
                Spacer()
                
                /// FIXED FOOTER
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
    
    
    private func wizardFooter() -> some View {
        HStack {
            if currentStep < .confirmation {
                Button(action: { goNext() }) {
                    Text(currentStep == .details ? "Submit" : "Next")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(currentStep.color)
                        .foregroundColor(.white)
                        .contentShape(Capsule())
                        .clipShape(Capsule())
                    
                }
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
}


#Preview() {
    let model: ReportDataModel = ReportDataModel.shared
    model.setMatterToSolve(mattersToResolve.first!)
    return NavigationStack {
        ReportWizardContainer(model: model, onCompletion: { data, type in
            
        }, showCancelButton: true)
    }
}
