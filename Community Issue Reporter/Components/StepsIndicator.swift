////
////  StepsIndicator.swift
////  Community Issue Reporter
////
////  Created by Francisco Hernandez on 10/6/26.
////
//
//import SwiftUI
//
//struct StepsIndicator: View {
//    @State var numberOfSteps: Int
//    @Binding var currentStep: Int
//    var body: some View {
//        VStack {
//            Gauge(value: Float(currentStep), in: 0...Float(numberOfSteps)) {
//            } currentValueLabel: {
//                Text(String(localized: "Step \(currentStep) of \(numberOfSteps)"))
//                   
//            }
//            .gaugeStyle(.accessoryLinearCapacity)
//        }
//        .padding(.top)
//        .padding(.horizontal)
//    }
//}
//
//struct StyledGauge: View {
//    @State private var current = 67.0
//    @State private var minValue = 50.0
//    @State private var maxValue = 170.0
//    let gradient = Gradient(colors: [.green, .yellow, .orange, .red])
//
//
//    var body: some View {
//        Gauge(value: current, in: minValue...maxValue) {
//            Image(systemName: "heart.fill")
//                .foregroundColor(.red)
//        } currentValueLabel: {
//            Text("\(Int(current))")
//                .foregroundColor(Color.green)
//        } minimumValueLabel: {
//            Text("\(Int(minValue))")
//                .foregroundColor(Color.green)
//        } maximumValueLabel: {
//            Text("\(Int(maxValue))")
//                .foregroundColor(Color.red)
//        }
//        .gaugeStyle(.accessoryCircular)
//    }
//}
//
//
//#Preview {
//    
//    @Previewable
//    @State var numberOfSteps: Int = 3
//    @Previewable
//    @State var currentStep: Int = 1
//    StepsIndicator(numberOfSteps: numberOfSteps, currentStep: $currentStep)
//    
//    StyledGauge()
////
//    
//    
//    HStack {
//        Button("Previous") {
//            currentStep -= 1
//        }
//        .buttonStyle(.glass)
//        .disabled(currentStep <= 1)
//        
//        Button("Next") {
//            currentStep += 1
//        }
//        .buttonStyle(.glass)
//        .disabled(currentStep == numberOfSteps)
//    }
//}


//
//  StepsIndicator.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 10/6/26.
//

import SwiftUI

struct StepsIndicator: View {
    let numberOfSteps: Int
    @Binding var currentStep: Int
    
    var body: some View {
        VStack(spacing: 8) {
            // Label placed above or below for cleaner alignment with a thicker bar
            Text(String(localized: "Step \(currentStep) of \(numberOfSteps)"))
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                // Animates text content shifts gently if numbers change length
                .contentTransition(.numericText())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Gauge(value: Double(currentStep), in: 0...Double(numberOfSteps)) {
//                Text("Progress")
            }
            .gaugeStyle(.accessoryLinearCapacity)
            // Increase thickness vertically without stretching the whole layout
            .scaleEffect(x: 1.0, y: 2.0, anchor: .center)
            // Tint color to make it pop (Optional)
            .tint(.accentColor)
        }
        .padding(.top)
        .padding(.horizontal)
        // Animates both the gauge fill and the label transitions smoothly
        .animation(.spring(response: 0.1, dampingFraction: 0.55), value: currentStep)
    }
}

#Preview {
    PreviewWrapper()
}

// Extracted Preview wrapper to cleanly manage the shared state between indicator and buttons
struct PreviewWrapper: View {
    @State private var numberOfSteps: Int = 3
    @State private var currentStep: Int = 1
    
    var body: some View {
        VStack(spacing: 20) {
            StepsIndicator(numberOfSteps: numberOfSteps, currentStep: $currentStep)
            
            HStack(spacing: 20) {
                Button("Previous") {
                    if currentStep > 0 { currentStep -= 1 }
                }
                .buttonStyle(.bordered)
                .disabled(currentStep <= 0)
                
                Button("Next") {
                    if currentStep < numberOfSteps { currentStep += 1 }
                }
                .buttonStyle(.borderedProminent)
                .disabled(currentStep == numberOfSteps)
            }
        }
    }
}
