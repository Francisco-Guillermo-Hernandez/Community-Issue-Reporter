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
    @FocusState private var isInputFocused: Bool
    @State private var profile = ProfileDataModel()
    @State private var isPresented: Bool = false
    @State private var triggerFeedBack: Bool = false
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var isEmailValid: Bool = false
    @State private var isUserNameValid: Bool = false
    @State private var user: UserProfile?
    @State private var userNameAvailabilityStatus: UserNameAvailabilityStatus = .untouched
    @State private var userNameErrorMessage: String = ""
    @State private var isLoading: Bool = false
    
    let appState = AuthViewModel()
    
    var nextStep: () -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: .themeSpacing * 4) {
                
                  
                VStack(spacing: .themeSpacing) {

                    ProfileImage(viewModel: profile)
                        .padding(.bottom, 8)
                        .padding(.top, .themePadding * 2)
                       
                    Text(name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(userAlias(userName))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)


                }
                
                VStack {
                    VStack {
                        Group {
                            TextInput(
                                name: "John Doe",
                                label: String(localized: "User Name", comment: "User Name input"),
                                validators: userNameValidator,
                                regex: .customPattern(userNameRegex),
                                isValid: $isUserNameValid,
                                value: $userName,
                            )
                            .focused($isInputFocused)
                            .onChange(of: userName) { _, newValue in
                                profile.userName = newValue
                            }
                            .onChange(of: profile.showPicker) { oldValue, newValue in
                                if newValue {
                                    isInputFocused = false
                                }
                                
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
        
        
           /// Check if conditions met
           if userName.count >= 3 && userName.count < 21 {
               
               /// Debouncing time
               try? await Task.sleep(for: .milliseconds(400))
               
               /// Set loading state
              userNameAvailabilityStatus = .loading
               
               /// Check availability
              await UserRepository.shared.checkAvailability(
                   of: userName,
                   completion: { (result: Result<String, UserError>) in
                       
                       switch result {
                           case .success(let result):
                           print(result)
                              
                               /// Set available state to show that message
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
               
               /// Set Initial state
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
            
            guard let user = user else { return }
            
            if let email = user.email {
                self.email = email
             }
             
             if let name = user.username {
                 self.name = name
                 profile.userName = name
                 self.userName = name
                     .lowercased()
                     .split(separator: " ")
                     .joined(separator: ".")
             }
        }
        .safeAreaInset(edge: .bottom) {
            BottomFadedView {
                ThemedButton(
                    message: String(localized: "Next Step"),
                    action: {
                        triggerFeedBack.toggle()
                        updateUsername()
                    },
                    type: .primary
                )
                .disabled(!isFormValid)
                .padding()
                .padding(.top, 0)
            }
        }
        .sensoryFeedback(
            .impact(weight: .medium),
            trigger: triggerFeedBack
        )
        
    }
    
    /// State machine to handle different scenarios
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
    
    private func updateUsername() -> Void {
        Task {
            isLoading.toggle()
            
            /// save userName into userDefault
            UserRepository.shared.setUsername(userName)
            await UserRepository.shared.change(userName, completion: { (result: Result<String, UserError>) in
                switch result {
                case .success(let message):
                    print(message)
                    isLoading.toggle()
                    nextStep()
                    
                    /// Error handling
                case .failure(let error):
                    
                    isLoading.toggle()
                    print("error from update user name")
                    dump(error)
                    switch error {
                    case .serverError(let message):
                      print(message)
                    default:
                        break
                    }
                }
            })
        }
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
//            .cornerRadius(.themeRadius) // rounded-xl
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
