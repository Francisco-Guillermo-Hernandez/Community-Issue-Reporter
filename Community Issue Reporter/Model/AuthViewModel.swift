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
    @Published var isCheckingStatus = true

    func checkStatus() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
           DispatchQueue.main.async {
               self.isCheckingStatus = false
               if let user = user {
                   self.user = user
                   self.isLoggedIn = true
               } else {
                   self.user = nil
               }
            }
        }
    }
    
    func logout() {
        GIDSignIn.sharedInstance.signOut()
        
        DispatchQueue.main.async {
            self.user = nil
            self.isLoggedIn = false
            
            _ = KeychainService.deleteToken(key: .query)
            _ = KeychainService.deleteToken(key: .mutation)
        }
    }
    
}
