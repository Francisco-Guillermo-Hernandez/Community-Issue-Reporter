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

enum UserNameAvailabilityStatus {
    case available
    case error
    case loading
    case untouched
}

struct UserPersonalizationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isPresented: Bool = false
    @State private var triggerFeedBack: Bool = false
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var isEmailValid: Bool = false
    @State private var isUserNameValid: Bool = false
    @State private var user: UserProfile?
    @State private var userNameAvailabilityStatus: UserNameAvailabilityStatus = .untouched
    @State private var userNameErrorMessage: String = ""
    @ObservedObject var profile = ProfileDataModel()
    let appState = AuthViewModel()
    
    var nextStep: () -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
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
                        Group {
                            TextInput(
                                name: "John Doe",
                                label: String(localized: "User Name", comment: "User Name input"),
                                validators: userNameValidator,
                                isValid: $isUserNameValid,
                                value: $userName,
                            )
                            .onChange(of: userName) { _, newValue in
                                profile.userName = newValue
                            }
                            
                            showUserNameStates()
                           
                        }
                        
                        TextInput(
                            name: "hello@reportamelo.app",
                            label: String(localized: "Email", comment: "Email input"),
                            regex: .email,
                            isValid: $isEmailValid,
                            value: $email,
                            disabled: true,
                        )
                    }
                    .padding(.horizontal, 24)
                }
                
                .padding(.vertical, 24)
                .customCardStyle()
                .padding()
               
                
            }
        }
        .task(id: userName) {
        
        
                            
           if userName.count >= 3 {
               try? await Task.sleep(for: .milliseconds(400))
              userNameAvailabilityStatus = .loading
              await UserRepository.shared.checkAvailability(
                   of: userName,
                   completion: { (result: Result<String, UserError>) in
                       
                       switch result {
                           case .success(let result):
                           print(result)
                              
                               userNameAvailabilityStatus = .available
                           case .failure(let error):
                          
                           switch error {
                               case .taken:
                                   userNameAvailabilityStatus = .error
                                   userNameErrorMessage = String(localized: "User name is taken")
                                   
                               case .invalidUserName:
                                   userNameAvailabilityStatus = .error
                                   userNameErrorMessage = String(localized: "User name is invalid")
                                   
                               default:
                                   userNameAvailabilityStatus = .error
                           }
                       }
                   }
              )
           } else {
               userNameAvailabilityStatus = .untouched
           }
        }
        .blur(radius: profile.showPicker ? .themeRadius * 2 : 0)
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
        .safeAreaInset(edge: .bottom) {

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
                            print("hello")
                         
                        },
                        type: .primary
                    )
                    .disabled(!isFormValid)
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
    
    @ViewBuilder
    private func showUserNameStates() -> some View {
        Group {
            switch userNameAvailabilityStatus {
            case .available:
                Text(String(localized: "Available"))
                    .foregroundColor(Color.green)
                    .font(.caption)
            case .untouched:
                EmptyView()
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.small)
            case .error:
                Text(userNameErrorMessage)
                    .foregroundColor(Color.theme.destructive)
                    .font(.caption)
            }
        }
        .padding(.leading, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var isFormValid: Bool {
        isUserNameValid && isEmailValid && userNameAvailabilityStatus == .available
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
