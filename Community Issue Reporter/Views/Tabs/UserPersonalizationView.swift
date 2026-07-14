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
    @Binding var model: UserPersonalizationDataModel
   
    @State private var user: UserProfile?
    
    let appState = AuthViewModel()
    
    var nextStep: () -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: .themeSpacing * 4) {
                
                  
                VStack(spacing: .themeSpacing) {

                    ProfileImage(viewModel: profile)
                        .padding(.bottom, 8)
                        .padding(.top, .themePadding * 2)
                       
                    Text(model.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(userAlias(model.userName))
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
                                isValid: $model.isUserNameValid,
                                value: $model.userName,
                            )
                            .focused($isInputFocused)
                            .onChange(of: model.userName) { _, newValue in
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
                            isValid: $model.isEmailValid,
                            value: $model.email,
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
        .task(id: model.userName) {
        
        
           /// Check if conditions met
            if model.userName.count >= 3 && model.userName.count < 21 && model.userNameAvailabilityStatus != .available  {
               
               /// Debouncing time
               try? await Task.sleep(for: .milliseconds(400))
               
               /// Set loading state
                model.userNameAvailabilityStatus = .loading
               
               /// Check availability
              await UserRepository.shared.checkAvailability(
                    of: model.userName,
                    completion: { (result: Result<String, UserError>) in
                       
                       switch result {
                           case .success(let result):
                           print(result)
                              
                               /// Set available state to show that message
                           model.userNameAvailabilityStatus = .available
                           case .failure(let error):
                          
                           switch error {
                               case .taken:
                                    model.userNameAvailabilityStatus = .error
                                    model.userNameErrorMessage = String(localized: "User name is taken")
                                   
                               case .invalidUserName:
                                    model.userNameAvailabilityStatus = .error
                                    model.userNameErrorMessage = String(localized: "User name is invalid")
                                   
                               default:
                                    model.userNameAvailabilityStatus = .error
                           }
                       }
                   }
              )
           } else {
               
               /// Set Initial state
               model.userNameAvailabilityStatus = .untouched
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
                model.email = email
             }
             
             if let name = user.username {
                 model.name = name
                 profile.userName = name
                 model.userName = name
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
                    type: .primary,
                    isLoading: $model.isLoading
                )
                .disabled(!model.isFormValid)
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
            switch model.userNameAvailabilityStatus {
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
                Text(model.userNameErrorMessage)
                    .foregroundColor(Color.theme.destructive)
                    .font(.caption)
            }
        }
        .padding(.leading, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func updateUsername() -> Void {
        Task {
            model.isLoading.toggle()
            
            /// save userName into userDefault
            UserRepository.shared.setUsername(model.userName)
            await UserRepository.shared.change(model.userName, completion: { (result: Result<String, UserError>) in
                switch result {
                case .success(let message):
                    print(message)
                    model.isLoading.toggle()
                    nextStep()
                    
                    /// Error handling
                case .failure(let error):
                    
                    model.isLoading.toggle()
                    print("error from update user name")
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
    
}

#Preview {
    @Previewable
    @State var model = UserPersonalizationDataModel()
    UserPersonalizationView(model: $model, nextStep: {
        
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
