//
//  UserPersonalizationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 26/5/26.
//

import SwiftUI
import WebKit

struct UserPersonalizationView: View {
    
    
    @State private var triggerFeedBack: Bool = false
    var nextStep: () -> Void
    var body: some View {
        VStack {
            Text("Personalize user information ")
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
                        message: String(localized: "Next Step"),
                        action: {
                            triggerFeedBack.toggle()
                            nextStep()
                         
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
    UserPersonalizationView(nextStep: {
        
    })
}
