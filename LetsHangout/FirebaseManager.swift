//
//  FirebaseManager.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

enum FirebaseError: Error {
    case unknownError
    case noUser
    case userCreationError
}

enum FirebaseAuthenticationError: Error {
    case invalidName
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

enum FirebaseResult<T, Error> {
    case success(T)
    case failure(Error)
    
}

typealias AuthenticationResult = FirebaseResult<User, FirebaseAuthenticationError>


class FirebaseManager {
    static let sharedInstance = FirebaseManager()
    
    private let authHandler = Auth.auth()
    
    private let hangoutsRef = Database.database().reference().child("hangouts")
    private let usersRef = Database.database().reference().child("users")
    var currentUserRef: DatabaseReference! = Database.database().reference(withPath: "users").child("quRhBuH1aBSr9GMeAhqKTMdZNfK2")
    
    private init() {}
    
    func save(hangout: Hangout, completion: @escaping (Error?, DatabaseReference?) -> Void) {
        let dict: [String: Any] = ["ID": hangout.id, "name": hangout.name ?? "N/A", "date": hangout.date?.timeIntervalSince1970 ?? "N/A", "host": hangout.host ?? "N/A", "description": hangout.description ?? "N/A", "latitude": hangout.latitude ?? "N/A", "longitude": hangout.longitude ?? "N/A"]
        
        hangoutsRef.child(hangout.id).setValue(dict, withCompletionBlock: { [unowned self] error, ref in
            self.currentUserRef.child("hangouts").child(ref.key).setValue(["key": 1])
            completion(error, ref)
        })
    }
    
    func loadHangouts(completion: @escaping ([Hangout]) -> Void) {
        self.currentUserRef.child("hangouts").observe(.value, with: { [unowned self] snapshot in
            var count = 0
            var flag = true
            var hangouts: [Hangout] = []
            for snap in snapshot.children.allObjects {
                self.hangoutsRef.child((snap as? DataSnapshot)!.key).observeSingleEvent(of: .value, with: { (hangoutSnap) in
                    if let dict = hangoutSnap.value as? [String: Any] {
                        hangouts.append(Hangout(dict: dict))
                        count += 1
                        if count == Int(snapshot.childrenCount) && flag {
                            completion(hangouts)
                            flag = false
                        }
                    }
                })
            }
        })
    }
    
    func loginWithCredentials(_ email: String, _ password: String, completion:@escaping (AuthenticationResult) -> Void) {
        authHandler.signIn(withEmail: email, password: password) {[unowned self] (user, error) in
           
            if let authError = error {
                let result = AuthenticationResult.failure(FirebaseAuthenticationError(rawValue: authError._code))
                completion(result)
                return
            }
            
            guard let user = user else {
                let result = AuthenticationResult.failure(FirebaseAuthenticationError.unknown)
                completion(result)
                return
            }
            
            self.currentUserRef = self.usersRef.child(user.uid)
            let result = AuthenticationResult.success(user)
            completion(result)
        }
    }
    
    func fetchCurrentUserInfo(completion:@escaping (FirebaseError?, HangoutUser?) -> Void) {
        currentUserRef.observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                completion(nil, HangoutUser(dict: dict))
            } else {
                // TODO: Handle error
                completion(.noUser, nil)
            }
        })
    }
    
    func registerWithCredentials(_ email: String, _ password: String, _ name: String, completion:@escaping (User?, FirebaseError?) -> Void) {
        authHandler.createUser(withEmail: email, password: password) { [unowned self] (newUser, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, .userCreationError)
                return
            }
            
            guard let newUser = newUser else {
                completion(nil, .unknownError)
                return
            }
            
            self.currentUserRef = self.usersRef.child(newUser.uid)
            self.usersRef.child(newUser.uid).setValue(["email": email, "name": name])
            
        }
    }
    
    
}
