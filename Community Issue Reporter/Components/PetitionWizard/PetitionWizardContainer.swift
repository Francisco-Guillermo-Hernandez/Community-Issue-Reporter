//
//  PetitionWizardContainer.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 24/7/26.
//

import SwiftUI

struct PetitionWizardContainer: View {
    
    @Environment(\.dismiss) private var dismiss
    @Bindable var controller: PetitionController
    @FocusState private var focusedField: PetitionWizardElements?
    @State private var deepLinkRouter = DeepLinkRouter.shared
    @State private var profileRouter = ProfileRouter.shared
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                /// Screen Background
                Color.theme.background
                    .ignoresSafeArea()
                
                // Top Glow Gradient representing the active step color
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
                    
                    /// STEP FLOW
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(PetitionStep.allCases, id: \.self) { step in
                                    PetitionStepCardView(
                                        step: step,
                                        currentStep: controller.currentStep,
                                        metadata: petitionStepsMetadata[step.metadataKey]
                                    ) {
                                        Group {
                                            switch step {
                                                case .details:
                                                    PetitionDetailsView(controller, $focusedField)
                                                case .reports:
                                                    ReportsChooserView(
                                                        reports: controller.reports,
                                                        selectedReports: $controller.petition.reportsIds
                                                    )
                                                case .signatures:
                                                    PetitionSignaturesConfigurator(controller)
                                                case .confirmation:
                                                    PetitionConfirmationView(url: $controller.shareUrl) {
                                                        goToPetitions()
                                                    }
                                                
                                            }
                                        }
                                    }
                                    .id(step)
                                    .onTapGesture {
                                        guard controller.currentStep != .confirmation, step != .confirmation else { return }
                                        
                                        withAnimation(.snappy(duration: 0.45, extraBounce: 0.08)) {
                                            controller.currentStep = step
                                        }
                                    }
                                    
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        }
                        .animation(.snappy(duration: 0.45, extraBounce: 0.08), value: controller.currentStep)
                        .onChange(of: controller.currentStep) { _, newValue in
                            
                            proxy.scrollTo(newValue, anchor: .top)
                            print(newValue)
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "Create a Petition"))
            .navigationSubtitle(String(localized: "Step \(controller.currentStep.rawValue) of 4"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { 
                
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    }
                }
            }
            .task {
                /// Let's cancel the task if the user change the view
                guard !Task.isCancelled else { return }
                
                /// list reports for the creation of the petition
                await controller.fetchReports()
            }
            .sensoryFeedback(.success, trigger: controller.doneTrigger)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                BottomFadedView {
                    wizardFooter()
                        .padding()
                }
            }
           
        }
    }
    
    @ViewBuilder
    private func wizardFooter() -> some View {
        HStack {
            
            if controller.currentStep < .confirmation {
                ThemedButton(
                    message: controller.buttonMessage,
                    action: {
                        controller.submit()
                    },
                    type: .primary,
                    style: .prominent,
                    isLoading: .constant(false)
                )
                .disabled(disableButton)
                .accessibilityIdentifier("Petition\(controller.currentStep.rawValue)Button")
                
            } else {
                
                ThemedButton(
                    message: String(localized: "Done"),
                    action: done,
                    type: .secondary,
                    style: .prominent
                )
                .accessibilityIdentifier("PetitionDoneButton")
            }
            
        }
    }
    
    // MARK: validations
    
    
    var areDetailsValid: Bool {
        controller.isTitleValid && controller.isDescriptionValid
    }
    
    var areReportsValid: Bool {
        controller.reports.count > 0 && controller.reports.count <= 6
    }
    
    var disableButton: Bool {
        switch controller.currentStep {
            case .details: return !areDetailsValid
            case .reports: return !areReportsValid
            case .signatures: return false
            case .confirmation: return false
        }
    }
    
    func done() {
        controller.doneTrigger.toggle()
        dismiss()
    }
    
    func goToPetitions() {
        Task {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
               
            dismiss()
            
            try? await Task.sleep(for: .milliseconds(128))
            
            deepLinkRouter.activeTab = 4
            
            try? await Task.sleep(for: .milliseconds(64))
            
            profileRouter.goTo(.signPetitions)
        }
    }
}

#Preview {
    @Previewable @State var controller = PetitionController()
    @State var isPresented: Bool = true
    
    Button("Open") {
        isPresented.toggle()
    }
    .sheet(isPresented: $isPresented) {
        PetitionWizardContainer(controller: controller)
    }
}
