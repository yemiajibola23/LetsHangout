//
//  FirebaseAuthenticationManager.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/10/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

enum FirebaseAuthenticationError: Error {
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
    
    var message: String {
        switch self {
        case .userDisabled: return "User was disabled"
        case .emailAlreadyInUse: return "Email already in use."
        case .invalidEmail: return "Email is invalid."
        case .wrongPassword: return "Password is incorrect."
        case .userNotFound: return "User not found."
        case .accountExistsWithDifferentCredential: return "Account already exists with different credentials"
        case .networkError: return "Network error"
        case .credentialAlreadyInUse: return "Credential is already in use"
        case .invalidPassword: return "Password is invalid"
        case .unknown: return "An unknown error occurred"
        }
    }
}



typealias AuthenticationResult = Result<HangoutUser, FirebaseAuthenticationError>

class FirebaseAuthenticationManager {
    static let sharedInstance = FirebaseAuthenticationManager()
    private let authHandler = Auth.auth()
    private let databaseReference = Database.database().reference()
    private let storageManager = FirebaseStorageManager.sharedInstance
    var currentUserRef: DatabaseReference?
    var currentUser: User?
    
    private init() {}
    
    private func setCurrentUser() {
        guard let currentUser = authHandler.currentUser else { return }
        self.currentUser = currentUser
        currentUserRef =  databaseReference.child(DatabasePath.users.rawValue).child(currentUser.uid)
    }
    
    func registerWithCredentials(_ email: String, _ password: String, _ name: String, _ profileImage: UIImage?, completion:@escaping (AuthenticationResult) -> Void) {
        authHandler.createUser(withEmail: email, password: password) {[unowned self] (user, error) in
            if let error = error {
                let result = AuthenticationResult.failure(FirebaseAuthenticationError(rawValue: error._code))
                completion(result)
                return
            }
            
            if let newUser = user {
                self.setCurrentUser()
                self.createUser(user: newUser, email: email, name: name, image: profileImage, completion: completion)
            }
        }
    }
    
    func loginWithCredentials(_ email: String, _ password: String, completion: @escaping (AuthenticationResult) -> Void) {
        authHandler.signIn(withEmail: email, password: password) {[unowned self] (user, error) in
            if let error = error {
                let result = AuthenticationResult.failure(FirebaseAuthenticationError(rawValue: error._code))
                completion(result)
                return
            }
            
            if let loggedInUser = user {
                self.setCurrentUser()
                self.fetchUser(uid: loggedInUser.uid, completion: completion)
            }
        }
    }
    
    func logout(completion: (FirebaseAuthenticationError?) -> Void) {
        do {
            try authHandler.signOut()
        } catch (let signOutError) {
            completion(FirebaseAuthenticationError(rawValue: signOutError._code))
        }
        
        currentUserRef = nil
        currentUser = nil
        completion(nil)
    }
    
    private func createUser(user: User, email: String, name: String, image: UIImage?, completion:
        @escaping (AuthenticationResult) -> Void) {
        let reference = databaseReference.child(DatabasePath.users.rawValue).child(user.uid)
        var userDict: [String: Any]!
        var imagePath: String?
        if let image = image {
            storageManager.save(photo: image, with: user.uid, for: .profiles) { [unowned self] result in
                switch result {
                case .success(let reference):
                    imagePath = reference?.description
                    userDict = self.generateHangoutUserDictionary(id: user.uid, email: email, name: name, profilePictureURL: reference?.description)
                case .failure(_): break
                }
            
                reference.updateChildValues(userDict) { [unowned self] _, _ in
                    let result = AuthenticationResult.success(self.generateHangoutUser(id: user.uid, email: email, name: name, imagePath: imagePath))
                    completion(result)
                }
            }
        } else {
            userDict = generateHangoutUserDictionary(id: user.uid, email: email, name: name, profilePictureURL: nil)
            
            reference.updateChildValues(userDict) { [unowned self] _, _ in
                let result = AuthenticationResult.success(self.generateHangoutUser(id: user.uid, email: email, name: name, imagePath: imagePath))
                completion(result)
            }
        }
    }
    
    func fetchUser(uid: String, completion: @escaping(AuthenticationResult) -> Void) {
        let reference = databaseReference.child(DatabasePath.users.rawValue).child(uid)
        
        reference.observeSingleEvent(of: .value, with: { [unowned self] snapshot in
            if let userDictionary = snapshot.value as? [String: Any] {
                completion(Result.success(self.generateHangoutUser(dictionary: userDictionary)))
            }
        })
    }
    
    
    private func generateHangoutUser(dictionary: [String: Any]) -> HangoutUser {
        return HangoutUser(dict: dictionary)
    }
    
    private func generateHangoutUser(id: String, email: String, name: String, imagePath: String?) -> HangoutUser {
        return HangoutUser(name: name, email: email, profilePictureURL: imagePath, uid: id)
    }
    
    private func generateHangoutUserDictionary(id: String, email: String, name: String, profilePictureURL: String?) -> [String: Any] {
        return ["uid": id, "email": email, "name": name, "profilePictureURL": profilePictureURL ?? "N/A"]
    }
}
