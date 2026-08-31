//
//  UserPersonalizationDataModel.swift
//  Community Issue Reporter
//
//  Created by Francisco Hernandez on 14/7/26.
//

import Foundation
import Observation

@Observable
final class UserPersonalizationDataModel {
    var userName: String
    var userNameAvailabilityStatus: UserNameAvailabilityStatus
    
    var email: String
    var name: String
    
    var isEmailValid: Bool
    var isUserNameValid: Bool
    var usernameState: UserNameState
    
    var userNameErrorMessage: String = ""
    var isLoading: Bool = false
    var isSubmitting: Bool = false
    
    var showErrorAlert: Bool = false
    private(set) var messageError: String = ""
    init() {
        userName = ""
        userNameAvailabilityStatus = .untouched
        email = ""
        name = ""
        
        isEmailValid = false
        isUserNameValid = false
        usernameState = .unTouched
    }
    
    var isFormValid: Bool {
        isUserNameValid && userNameAvailabilityStatus == .available || usernameState == .updated
    }
    
    func show(error: String) {
        messageError = error
        showErrorAlert = true
    }
}
