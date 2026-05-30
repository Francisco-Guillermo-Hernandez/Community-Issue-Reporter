//
//  LoginView.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 9/4/26.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @Environment(\.colorScheme) private var colorScheme
    let onTokenReceived: (String) -> Void
    var body: some View {
//        VStack {
//            
//        }
        ZStack(alignment: .bottom) {
            
            Image("Login_background")
                .resizable()
//                .frame(width: .infinity)
//                .aspectRatio(9/16, contentMode: .fill)
//                .scaledToFit()
//                .edgesIgnoringSafeArea(.all)
                .backgroundExtensionEffect()
            
    
            
            VStack(spacing: .themeSpacing * 6) {
               
                
               
                GooglePillButton(action: loginWithGoogle)
                    .padding(.top, 16)
                        
                Button {
                    onTokenReceived("guest")
                } label: {
                    Text("Login as a guest")
                }
                .buttonSizing(.flexible)
               
                
                LinksView()

            }
            .padding(.horizontal, .themeSpacing * 8)
            .padding(.top, .themeSpacing * 4)
            .padding(.bottom, .themeSpacing * 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: .themeRadius * 4, style: .continuous)
                    .fill(.white)
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    func loginWithGoogle() {
        // Find the current window scene.
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("There is no active window scene")
            return
        }
        
        // Get the root view controller from the window scene.
        guard
            let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?
                .rootViewController
        else {
            print("There is no key window or root view controller")
            return
        }
        
        // Start the sign-in process.
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            
            guard let result = signInResult else {
                // Inspect error
                print("Error signing in: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            onTokenReceived(result.user.idToken?.tokenString ?? "")
        }
    }

}

#Preview {
    LoginView() { token in
        print(token)
    }
}


struct LinksView: View {
    var underlinedMarkdown: AttributedString {
        let rawMarkdown = String(localized: "By continuing, you agree to our [Terms of Service](https://reportamelo.app/legal/terms) and [Privacy Policy](https://reportamelo.app/legal/privacy).")
        
        // Parse the raw Markdown string
        guard var attributedString = try? AttributedString(markdown: rawMarkdown) else {
            return AttributedString(rawMarkdown)
        }
        
        // Loop through all segments to find links
        for run in attributedString.runs {
            if run.link != nil {
                // Apply the underline style to the link range
                attributedString[run.range].underlineStyle = .single
            }
        }
        
        return attributedString
    }

    var body: some View {
        Text(underlinedMarkdown)
            .font(.footnote)
            .foregroundColor(.secondary)
            .tint(Color.theme.primary.mix(with: .white, by: 0.1))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
