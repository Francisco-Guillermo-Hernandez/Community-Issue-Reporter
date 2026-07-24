//
//  StepCardView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 15/6/26.
//

import SwiftUI

// MARK: - Card Container for each Step

struct StepCardView<Content: View>: View {
    let step: ReportStep
    let currentStep: ReportStep
    let metadata: StepsMetadata?
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: .themeSpacing * 1) {
            if step == currentStep {
                /// Active State (Expanded)
                VStack(alignment: .leading, spacing: .themeSpacing * 2) {
                    HStack(alignment: .center, spacing: .themeSpacing * 2) {
                        Image(systemName: metadata?.icon ?? "")
                            .font(.system(size: 26, weight: .bold))
                            .symbolRenderingMode(.palette)
                            .symbolColorRenderingMode(.gradient)
                            .foregroundStyle(
                                Color.theme.primary,
                                Color.theme.foreground.opacity(0.8),
                                Color.theme.foreground.opacity(0.8)
                            )

                        VStack(alignment: .leading) {
                            Text(metadata?.title ?? "")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(metadata?.description ?? "")
                                .font(.subheadline)
                                .foregroundColor(Color.theme.foreground.opacity(0.8))
                        }
                    }
                    
                    
                    content
                        .padding(.top, 6)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .opacity
                        ))
                }
                .transition(.opacity)
            } else {
                /// Collapsed State (Completed or Upcoming)
                HStack(spacing: .themeSpacing * 2) {
                    Image(systemName: metadata?.icon ?? "")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(step < currentStep ? Color.theme.foreground : Color.theme.foreground.opacity(0.7))
                        .frame(width: 24, height: 24)
                    
                    Text(metadata?.title ?? "")
                        .font(.headline)
                        .foregroundColor(step < currentStep ? Color.theme.foreground : Color.theme.foreground.opacity(0.7))
                    
                    Spacer()
                    
                    if step < currentStep {
                        Image(systemName: "checkmark.circle.fill")
                            .symbolRenderingMode(.palette)
                            .symbolColorRenderingMode(.gradient)
                            .foregroundStyle(
                                Color.white,
                                Color.green,
                                Color.green
                            )
                            .font(.system(size: 20))
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle())
                .transition(.opacity)
            }
        }
        .scaleEffect(step == currentStep ? 1.0 : (step < currentStep ? 0.96 : 0.98))
        .opacity(step == currentStep ? 1.0 : (step < currentStep ? 0.75 : 0.55))
    }
}

#Preview {
    
    
    StepCardView(step: .details, currentStep: .confirmation, metadata: stepsMetadata["Details"]) {
        
    }
}
