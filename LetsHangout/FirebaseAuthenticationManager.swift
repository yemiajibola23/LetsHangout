//
//  FirebaseAuthenticationManager.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/10/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

enum FirebaseAuthenticationErrorType: Error {
    case invalidPassword
    case userDisabled
    case emailAlreadyInUse
    case invalidEmail
    case wrongPassword
    case userNotFound
    case accountExistsWithDifferentCredential
    case networkError
    case credentialAlreadyInUse
    case unknown
    
    init(rawValue: Int) {
        switch rawValue {
        case 17005: self = .userDisabled
        case 17007: self = .emailAlreadyInUse
        case 17008: self = .invalidEmail
        case 17009: self = .wrongPassword
        case 17011: self = .userNotFound
        case 17012: self = .accountExistsWithDifferentCredential
        case 17020: self = .networkError
        case 17025: self = .credentialAlreadyInUse
        case 17026: self = .invalidPassword
        default: self = .unknown
        }
    }
}

struct FirebaseAuthenticationError {
    var type: FirebaseAuthenticationErrorType
    var message: String
    
    init(type: FirebaseAuthenticationErrorType) {
        self.type = type
        
        switch type {
        case .userDisabled: message = "User was disabled"
        case .emailAlreadyInUse: message = "Email already in use."
        case .invalidEmail: message = "Email is invalid."
        case .wrongPassword: message = "Password is incorrect."
        case .userNotFound: message = "User not found."
        case .accountExistsWithDifferentCredential: message = "Account already exits with different credentials"
        case .networkError: message = "Network error"
        case .credentialAlreadyInUse: message = "Credential is already in use"
        case .invalidPassword: message = "Password is invalid"
        case .unknown: message = "An unknown error occurred"
        }
    }
}




typealias AuthenticationResult = Result<HangoutUser, FirebaseAuthenticationError>

class FirebaseAuthenticationManager {
    static let sharedInstance = FirebaseAuthenticationManager()
    private let authHandler = Auth.auth()
    private let databaseReference = Database.database().reference()
    var currentUserRef: DatabaseReference?
    var currentUser: User?
    
    private init() {}
    
    private func setCurrentUser() {
        guard let currentUser = authHandler.currentUser else { return }
        self.currentUser = currentUser
        currentUserRef =  databaseReference.child(DatabasePath.users.rawValue).child(currentUser.uid)
    }
    
    func registerWithCredentials(_ email: String, _ password: String, _ name: String, completion:@escaping (AuthenticationResult) -> Void) {
        authHandler.createUser(withEmail: email, password: password) {[unowned self] (user, error) in
            if let error = error {
                let result = AuthenticationResult.failure(FirebaseAuthenticationError(type: FirebaseAuthenticationErrorType(rawValue: error._code)))
                completion(result)
                return
            }
            
            if let newUser = user {
                self.setCurrentUser()
                self.createUser(user: newUser, email: email, name: name, completion: completion)
            }
        }
    }
    
    
    func loginWithCredentials(_ email: String, _ password: String, completion: @escaping (AuthenticationResult) -> Void) {
        authHandler.signIn(withEmail: email, password: password) {[unowned self] (user, error) in
            if let error = error {
                let result = AuthenticationResult.failure(FirebaseAuthenticationError(type: FirebaseAuthenticationErrorType(rawValue: error._code)))
                completion(result)
                return
            }
            
            
            if let loggedInUser = user {
                self.setCurrentUser()
                self.fetchUser(uid: loggedInUser.uid, completion: completion)
            }
        }
    }
    
    private func createUser(user: User, email: String, name: String, completion:@escaping (AuthenticationResult) -> Void) {
        let reference = databaseReference.child(DatabasePath.users.rawValue).child(user.uid)
        let userDictionary = generateHangoutUserDictionary(id: user.uid, email: email, name: name)
        
        reference.updateChildValues(userDictionary) {[unowned self] _, _ in
            let result = AuthenticationResult.success(self.generateHangoutUser(id: user.uid, email: email, name: name))
            completion(result)
        }
    }
    
    private func fetchUser(uid: String, completion: @escaping(AuthenticationResult) -> Void) {
        let reference = databaseReference.child(DatabasePath.users.rawValue).child(uid)
        
        reference.observeSingleEvent(of: .value, with: {[unowned self] snapshot in
            if let userDictionary = snapshot.value as? [String: Any] {
                completion(Result.success(self.generateHangoutUser(dictionary: userDictionary)))
            }
        })
    }
    
    private func generateHangoutUser(dictionary: [String: Any]) -> HangoutUser {
        return HangoutUser(dict: dictionary)
    }
    
    private func generateHangoutUser(id: String, email: String, name: String) -> HangoutUser {
        return HangoutUser(name: name, email: email, profilePictureURL: nil)
    }
    
    private func generateHangoutUserDictionary(id: String, email: String, name: String) -> [String: Any] {
        return ["uid": id, "email": email, "name": name]
    }
}
