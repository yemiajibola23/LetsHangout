//
//  LoginViewModel.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/17/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation

enum AuthenticationState {
    case authenticated(String)
    case notAuthenticated
}


class LoginViewModel {
    private let authenticationManager = FirebaseAuthenticationManager.sharedInstance
    var state: AuthenticationState? = .notAuthenticated {
        didSet {
            //TODO: Save in user defaults
        }
    }
    
    
    func loginUser(email: String, password: String, completion: @escaping (AuthenticationResult) -> Void) {
        authenticationManager.loginWithCredentials(email, password, completion: completion)
    }
    
    func registerNewUser(email: String, password: String, name: String, completion: @escaping (AuthenticationResult) -> Void) {
        authenticationManager.registerWithCredentials(email, password, name, completion: completion)
    }
    
    func logout(completion: (FirebaseAuthenticationError?) -> Void) {
        authenticationManager.logout(completion: completion)
    }
    
}
