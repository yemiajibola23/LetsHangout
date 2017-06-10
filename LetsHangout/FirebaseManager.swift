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
    
    func loginWithCredentials(_ email: String, _ password: String, completion:@escaping (User?, FirebaseError?) -> Void) {
        authHandler.signIn(withEmail: email, password: password) {[unowned self] (user, error) in
            if let _ = error {
                completion(nil, .unknownError)
                return
            }
            guard let user = user else {
                completion(nil, .noUser)
                return
            }
            
            self.currentUserRef = self.usersRef.child(user.uid)
            completion(user, nil)
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
