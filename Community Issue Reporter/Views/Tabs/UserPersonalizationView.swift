//
//  UserPersonalizationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 26/5/26.
//

import SwiftUI

struct CustomBlurryOverlay: View {
   @Binding var show: Bool
    
    init(show: Binding<Bool>) {
        self._show = show
    }
    
    var body: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .ignoresSafeArea()
            .onTapGesture {
                show.toggle()
            }
            .transition(.opacity)
            .zIndex(1)
    }
}

struct UserPersonalizationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isPresented: Bool = false
    @State private var triggerFeedBack: Bool = false
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var user: UserProfile?
    @ObservedObject var profile = ProfileDataModel()
    let appState = AuthViewModel()
    
    var nextStep: () -> Void
    
    var body: some View {
        VStack(spacing: .themeSpacing * 4) {
            
              
            VStack(spacing: .themeSpacing) {

                ProfileImage(viewModel: profile)
                    .padding(.bottom, 8)
                    .padding(.top, .themePadding * 2)

                Text(userName)
                    .font(.title3)
                    .fontWeight(.semibold)

                HStack {
                    
                    if let firstLevel = appState.selectedCity?.firstLevel,  let thirdLevel = appState.selectedCity?.thirdLevel {
                        Text("\(firstLevel), \(thirdLevel)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            VStack {
                VStack {
                    TextInput(
                        name: "John Doe",
                        label: String(localized: "User Name", comment: "User Name input"),
                        validators: userNameValidator,
                        value: $userName,
                    )
                    .onChange(of: userName) { _, newValue in
                        profile.userName = newValue
                    }
                    
                    TextInput(
                        name: "hello@reportamelo.app",
                        label: String(localized: "Email", comment: "Email input"),
                        regex: .email,
                        value: $email,
                        disabled: true,
                    )
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 24)
            .customCardStyle()
            .padding()
           
            
            Spacer()
        }
        .blur(radius: profile.showPicker ? 15 : 0)
        .overlay {
            if profile.showPicker {
                CustomBlurryOverlay(show: $profile.showPicker)
            }
        }
        .navigationTitle(Text("Personalize your profile"))
        .background(Color.theme.background)
        .task {
            user = UserRepository.shared.getPublicInformation()
            if let user = user {
               if let email = user.email {
                   self.email = email
                }
                
                if let name = user.username {
                    self.userName = name
                }
            }
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


struct CustomCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.theme.cardBackground)
            .cornerRadius(.themeRadius) // rounded-xl
            .overlay(
                RoundedRectangle(cornerRadius: .themeRadius * 2, style: .continuous)
                                   .stroke(Color.theme.border, lineWidth: 1)
            )
            .cornerRadius(.themeRadius * 2)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1) // shadow-sm
    }
}

extension View {
    func customCardStyle() -> some View {
        self.modifier(CustomCardModifier())
    }
}
