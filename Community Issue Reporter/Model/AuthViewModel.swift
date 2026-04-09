//
//  AuthViewModel.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 5/4/26.
//

import Foundation
internal import Combine
import GoogleSignIn

class AuthViewModel: ObservableObject {
    @Published var user: GIDGoogleUser?
    @Published var isLoggedIn = false

    func checkStatus() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let user = user {
                self.user = user
                self.isLoggedIn = true
            }
        }
    }
}
