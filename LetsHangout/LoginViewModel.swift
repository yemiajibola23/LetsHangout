//
//  LoginViewModel.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/17/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation

class LoginViewModel {
    let authenticationManager = FirebaseAuthenticationManager.sharedInstance
    
    
    func loginUser(email: String, password: String, completion: @escaping (AuthenticationResult) -> Void) {
        authenticationManager.loginWithCredentials(email, password, completion: completion)
    }
    
    func registerNewUser(email: String, password: String, name: String, completion: @escaping (AuthenticationResult) -> Void) {
        authenticationManager.registerWithCredentials(email, password, name, completion: completion)
    }
    
    
}
