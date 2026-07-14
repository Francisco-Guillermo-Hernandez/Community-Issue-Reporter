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
    
    var userNameErrorMessage: String = ""
    var isLoading: Bool = false
    var isSubmitting: Bool = false
    init() {
        userName = ""
        userNameAvailabilityStatus = .untouched
        email = ""
        name = ""
        
        isEmailValid = false
        isUserNameValid = false
    }
    
    var isFormValid: Bool {
        isUserNameValid && isEmailValid && userNameAvailabilityStatus == .available
    }
}
