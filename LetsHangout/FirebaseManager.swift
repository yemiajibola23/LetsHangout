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

class FirebaseManager {
    static let sharedInstance = FirebaseManager()
    
    private let hangoutsRef = Database.database().reference().child("hangouts")
    
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
}
