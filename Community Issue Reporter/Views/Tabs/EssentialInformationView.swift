//
//  EssentialInformationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 30/5/26.
//

import SwiftUI

struct EssentialInformationView: View {
    @State private var triggerFeedBack: Bool = false
    var finalStep: () -> Void
    var body: some View {
        VStack {
            Text("Some information ")
            Spacer()
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {

            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .mask {
                        LinearGradient(
                            stops: [
                                .init(color: .black, location: 0),
                                .init(color: .clear, location: 1),
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    }
                    .ignoresSafeArea()

                VStack {
                    ThemedButton(
                        message: String(localized: "Report Problems"),
                        action: {
                            triggerFeedBack.toggle()
                            finalStep()
                         
                        },
                        type: .primary
                    )
                    .padding()
                    .padding(.top, 0)
                }
                .frame(maxWidth: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)

        }
        .sensoryFeedback(
            .impact(weight: .medium),
            trigger: triggerFeedBack
        )
        
    }
}

#Preview {
    EssentialInformationView(finalStep: {
        
    })
}
