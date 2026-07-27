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
                                                ReportsChooser()
                                            case .signatures:
                                                PetitionSignaturesConfigurator()
                                            case .confirmation:
                                                PetitionConfirmationView()
                                                
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
    
    func done() {
        controller.doneTrigger.toggle()
        dismiss()
    }
}

#Preview {
    
    @Previewable @State var controller = PetitionController()
    @State var isPresented: Bool = true
    
    NavigationStack {
        Button("Open") {
            isPresented.toggle()
        }
        .sheet(isPresented: $isPresented) {
            PetitionWizardContainer(controller: controller)
        }
    }
}
