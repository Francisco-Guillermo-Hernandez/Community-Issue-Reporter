//
//  PetitionSignaturesConfigurator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 25/7/26.
//

import SwiftUI

struct PetitionSignaturesConfigurator: View {
    @State private var voteThreshold: Double = 100.0
    @Bindable var controller: PetitionController
   
    init(_ controller: PetitionController) {
        self.controller = controller
    }
    
    var body: some View {
        VStack(spacing: .themeSpacing * 6) {
            
            VStack(spacing: .themeSpacing * 2) {
                
                Stepper(value: $controller.petition.targetSignatures, in: controller.minimumSignatures...1000, step: 1) {
                    AnimatedText(text: "\( controller.petition.targetSignatures)")
                }
                .onChange(of: controller.petition.targetSignatures) { oldValue, newValue in
                
                    if newValue > oldValue {
                        controller.stepperAction = "Increase"
                    } else if newValue < oldValue {
                        controller.stepperAction = "Decrease"
                    }
                }
                .sensoryFeedback(.increase, trigger: controller.petition.targetSignatures) { oldValue, newValue in
                    return newValue > oldValue
                }
                .sensoryFeedback(.decrease, trigger: controller.petition.targetSignatures) { oldValue, newValue in
                    return newValue < oldValue
                }
                
                Text("Set the amount of signatures needed")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("The minimum amount of signatures depends of the category.")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("For the chosen category, the minimum amount of signatures is \(controller.minimumSignatures) ")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: .themeSpacing * 2) {
                Slider(value: $voteThreshold, in: 85...100, step: 1.0) {
                    Text("Threshold of votes")
                } minimumValueLabel: {
                    Text("85")
                } maximumValueLabel: {
                    Text("100")
                }
                
                Text("Set the threshold of votes needed to pass the petition.")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    @Previewable @State var controller = PetitionController()
    PetitionSignaturesConfigurator(controller)
}
