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

class FirebaseManager {
    static let sharedInstance = FirebaseManager()
    
    private let authHandler = Auth.auth()
    
    private let hangoutsRef = Database.database().reference().child("hangouts")
    private let usersRef = Database.database().reference().child("users")
    var currentUserRef: DatabaseReference!
    
    private init() {}
    
    func save(hangout: Hangout, completion: @escaping (Error?, DatabaseReference?) -> Void) {
        let dict: [String: Any] = ["ID": hangout.id, "name": hangout.name ?? "N/A", "date": hangout.date?.timeIntervalSince1970 ?? "N/A", "host": hangout.host ?? "N/A", "description": hangout.description ?? "N/A", "latitude": hangout.latitude ?? "N/A", "longitude": hangout.longitude ?? "N/A"]
        
        hangoutsRef.child(hangout.id).setValue(dict, withCompletionBlock: { error, ref in
            completion(error, ref)
        })
    }
    
    func loadHangouts(completion:@escaping ([Hangout], Error?) -> Void) {
        hangoutsRef.observe(.value, with: { snapshot in
            var hangouts: [Hangout] = []
            
            for snap in snapshot.children.allObjects {
                if let dict = (snap as? DataSnapshot)?.value as? [String: Any] {
                    hangouts.append(Hangout(dict: dict))
                }
            }
            
            if hangouts.count == 0 { /*TODO: Handle Error */ return }
            
            completion(hangouts, nil)
        })
    }
    
    func loginWithCredentials(_ email: String, _ password: String, completion:@escaping (User?, Error?) -> Void) {
        authHandler.signIn(withEmail: email, password: password) {[unowned self] (user, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let user = user else { /*TODO: Error occurred*/
                completion(nil, nil)
                return
            }
            
            self.currentUserRef = self.usersRef.child(user.uid)
            completion(user, error)
        }
    }
    
    func fetchCurrentUserInfo(completion:@escaping (Error?, HangoutUser?) -> Void) {
        currentUserRef.observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                completion(nil, HangoutUser(dict: dict))
            } else {
                // TODO: Handle error 
                completion(nil, nil)
            }
        })
    }
}
