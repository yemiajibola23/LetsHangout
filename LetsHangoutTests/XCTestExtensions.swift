//
//  XCTExtensions.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/10/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation
import XCTest
import FirebaseAuth

@testable import LetsHangout

extension XCTest {
    func singleHangout() -> Hangout {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        return Hangout(name: "Test", date: dateFormatter.date(from: "May 31, 2017"), host: "Brian", latitude: nil, longitude: nil, description: "Description")
    }
    
    func multipleHangouts() -> [Hangout] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        return [Hangout(name: "Test", date: dateFormatter.date(from: "May 22, 2017"), host: "Yemi", latitude: nil, longitude: nil, description: "Description"), Hangout(name: "Test 2", date: dateFormatter.date(from: "March 31, 2017"), host: "Jocelyn", latitude: 21.161908, longitude: -86.851528, description: "Description 2")]
    }
    
    
    class FirebaseAuthenticationManagerMock: FirebaseAuthenticationManager {
        var authenticationResult: AuthenticationResult?
        var authenticatedUser: HangoutUser?
        var authenticationError: FirebaseAuthenticationError?
     
        override func registerWithCredentials(_ email: String, _ password: String, _ name: String, completion: @escaping (AuthenticationResult) -> Void) {
            super.registerWithCredentials(email, password, name) {[unowned self] result in
                self.authenticationResult = result
                
                switch result {
                case .success(let newUser): self.authenticatedUser = newUser
                case .failure(let authError): self.authenticationError = authError
                }
            }
        }
        
        override func loginWithCredentials(_ email: String, _ password: String, completion: @escaping (AuthenticationResult) -> Void) {
            super.loginWithCredentials(email, password) {[unowned self] (result) in
                self.authenticationResult = result
                
                switch result {
                case .success(let user): self.authenticatedUser = user
                case .failure(let error): self.authenticationError = error
                }
            }
        }
    }
}
