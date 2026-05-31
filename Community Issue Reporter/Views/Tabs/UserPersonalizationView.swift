//
//  UserPersonalizationView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 26/5/26.
//

import SwiftUI
import WebKit


struct AvatarOption: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var value: Int
    var image: Image?
}

let periods: [AvatarOption] = [
    .init(title: String(localized: "Avatar"), value: 0),
    .init(title: String(localized: "Monogram"), value: 1),
    .init(title: String(localized: "Initials"), value: 2),
    .init(title: String(localized: "Photo"), value: 3),
    .init(title: String(localized: "Camera"), value: 4),
    .init(title: String(localized: "Emoji"), value: 5),
]

/// View 3 Mock Data
struct KeyPad: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var value: Int
    var isBack: Bool = false
}

enum CurrentView {
    case optionsSelector
    case avatar
//    case camera
//    case photo
//    case initials
//    case monogram
//    case emoji
}

struct UserProfileSheet: View {
    var animation: Animation
   
    @State private var currentView: CurrentView = .optionsSelector
    @State private var selectedPeriod: AvatarOption?
    @State private var duration: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                switch currentView {
               
                case .optionsSelector: optionsSelectorView()
                        .geometryGroup()
                        .transition(
                            .blurReplace(.downUp)
                        )
                case .avatar: editAvatarView()
                        .geometryGroup()
                        .transition(.blurReplace(.upUp))
                }
            }
            .geometryGroup()
        }
        .presentationBackground(Color.white)
        .padding([.horizontal, .top], 20)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    @ViewBuilder
    func optionsSelectorView() -> some View {
        VStack(spacing: .themeSpacing * 5) {
            HStack {
                Text(String(localized: "Edit your avatar"))
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation(animation) {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray, Color.primary.opacity(0.1))
                }
            }
            
            /// Grid Box View
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: .themeSpacing * 4) {
                ForEach(periods) { period in
                    let isSelected = selectedPeriod?.id == period.id
                    
                    VStack {
                        VStack(spacing: 6) {
                            Text("sample")
                          
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background {
                            Circle()
                                .fill((isSelected ? Color.blue : Color.gray).opacity(isSelected ? 0.2 : 0.1))
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            withAnimation(animation) {
                                if period.value == 0 {
                                    /// Go To Custom Keypad View (View 3)
                                    currentView = .avatar
                                } else {
                                    selectedPeriod = isSelected ? nil : period
                                }
                            }
                        }
                        
                        
                        Text(period.title)
                            .fontWeight(.semibold)
                            .font(.footnote)
                        
                    }
                }
            }
            
        }
    }
    
    @ViewBuilder
    func editAvatarView() -> some View {
        VStack(spacing: .themeSpacing * 5) {
            HStack {
                Text(String(localized: "Personalize your avatar"))
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation(animation) {
                        currentView = .optionsSelector
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray, Color.primary.opacity(0.1))
                }
            }
            .padding(.bottom, 10)
            
           
        }
    }
}

struct UserPersonalizationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isPresented: Bool = false
    @State private var triggerFeedBack: Bool = false
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var user: UserProfile?
    
    var nextStep: () -> Void
    
//    init(nextStep: @escaping () -> Void) {
//        
//        self.nextStep = nextStep
//        
//    }
    
    var body: some View {
        VStack(spacing: .themeSpacing * 4) {
            
            ProfileImage()
                .padding(.bottom, 8)
            VStack {
                VStack {
                    TextInput(
                        name: "John Doe",
                        label: String(localized: "User Name", comment: "User Name input"),
                        value: $userName,
                    )
                    
                    TextInput(
                        name: "John@doe.com",
                        label: String(localized: "Email", comment: "Email input"),
                        value: $email,
                        disabled: true,
                    )
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 24)
            .tailwindCardStyle()
            .padding()
           
            
            Spacer()
        }
        .navigationTitle(Text("Personalize your profile"))
        .sheet(isPresented: $isPresented) {
            let animation: Animation = .snappy(duration: 0.3, extraBounce: 0)
            DynamicSheet(animation: animation) {
                UserProfileSheet(animation: animation)
            }
            .presentationBackground(.background)
           
        }
        .task {
            user = UserRepository.getPublicInformation()
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


struct TailwindCardModifier: ViewModifier {
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
    func tailwindCardStyle() -> some View {
        self.modifier(TailwindCardModifier())
    }
}
