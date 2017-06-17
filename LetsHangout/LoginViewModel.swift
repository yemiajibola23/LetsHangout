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
    var state: AuthenticationState = .notAuthenticated {
        didSet {
            switch state {
            case .authenticated(let uid):
                UserDefaults.standard.set(uid, forKey: "authenticated")
            case .notAuthenticated:
                UserDefaults.standard.set(nil, forKey: "authenticated")
            }
        }
    }
    
    init() {
        if let id = UserDefaults.standard.value(forKey: "authenticated") as? String {
            state = .authenticated(id)
        } else {
            state = .notAuthenticated
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
