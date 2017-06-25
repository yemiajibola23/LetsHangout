//
//  FirebaseDatabaseManager.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/10/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

enum FirebaseDatabaseError: Error {
    case unknown
    case disconnected
    case expiredToken
    case invalidToken
    case maxRetries
    case networkError
    case operationFailed
    case overriddenBySet
    case permissionDenied
    case unavailable
    case userCodeException
    
    init(rawValue: Int) {
        switch rawValue {
        case -4: self = .disconnected
        case -6: self = .expiredToken
        case -7: self = .invalidToken
        case -8: self = .maxRetries
        case -24: self = .networkError
        case -2: self = .operationFailed
        case -9: self = .overriddenBySet
        case -3: self = .permissionDenied
        case -10: self = .unavailable
        case -11: self = .userCodeException
        default: self = .unknown
        }
    }
    
    var message: String {
        switch self {
        case .disconnected: return ""
        case .expiredToken: return ""
        case .invalidToken: return  ""
        case .maxRetries: return ""
        case .networkError: return ""
        case .operationFailed: return ""
        case .overriddenBySet: return ""
        case .permissionDenied: return ""
        case .unavailable: return ""
        case .userCodeException: return ""
        case .unknown: return ""
        }
    }
}



class FirebaseDatabaseManager {
    private let userRef = Database.database().reference().child(DatabasePath.users.rawValue)
    private let hangoutsRef = Database.database().reference().child(DatabasePath.hangouts.rawValue)
    private var currentUserRef: DatabaseReference!
    
    typealias DatabaseReferenceResult = Result<DatabaseReference, FirebaseDatabaseError>
    
    static let sharedInstance = FirebaseDatabaseManager()
    private init() {
        guard let currentUser = Auth.auth().currentUser else { fatalError() }
        currentUserRef = userRef.child(currentUser.uid)
    }
    
    func save(hangout: Hangout, completion: @escaping (DatabaseReferenceResult) -> Void) {
        let hangoutDictionary = generateHangoutDictionary(hangout: hangout)
        
        hangoutsRef.child(hangout.id).setValue(hangoutDictionary, withCompletionBlock: { [unowned self] error, ref in
            if let databaseError = error {
                let result = DatabaseReferenceResult.failure(FirebaseDatabaseError(rawValue: databaseError._code))
                completion(result)
                return
            }
            
            self.currentUserRef.child(DatabasePath.hangouts.rawValue).child(ref.key).setValue(["key": 1])
            
            let result = DatabaseReferenceResult.success(ref)
            completion(result)
        })
    }
    
    func loadHangouts(completion: @escaping ([Hangout]) -> Void) {
        /*let handle: DatabaseHandle =*/ self.currentUserRef.child(DatabasePath.hangouts.rawValue).observe(.value, with: { [unowned self] snapshot in
            var count = 0
            var flag = true
            var hangouts: [Hangout] = []
            
            guard snapshot.childrenCount > 0 else { completion(hangouts); return }
            
            for snap in snapshot.children.allObjects {
                self.hangoutsRef.child((snap as? DataSnapshot)!.key).observeSingleEvent(of: .value, with: { hangoutSnap in
                    if let dict = hangoutSnap.value as? [String: Any] {
                        hangouts.append(Hangout(dict: dict))
                        count += 1
                        if count == Int(snapshot.childrenCount) && flag {
                            flag = false
                            completion(hangouts)
                        }
                    }
                })
            }
            
//            completion(hangouts)
        })
    }
    
    func deleteHangout(_ reference: DatabaseReference, completion:@escaping (DatabaseReferenceResult) -> Void) {
        var result: DatabaseReferenceResult?
        
        reference.removeValue { (error, ref) in
            if let databaseError = error {
                result = DatabaseReferenceResult.failure(FirebaseDatabaseError(rawValue: databaseError._code))
            } else {
                self.currentUserRef.child(DatabasePath.hangouts.rawValue).child(ref.key).removeValue()
                result = DatabaseReferenceResult.success(ref)
            }
            
            completion(result!)
        }
    }
    
    func observeAddedHangouts(completion:@escaping ([Hangout]) -> Void) {
        self.currentUserRef.child(DatabasePath.hangouts.rawValue).observe(.childAdded, with: { snapshot in
            print(snapshot.value ?? "N/A")
            completion([])
        })
    }
    
    
    private func generateHangoutDictionary(hangout: Hangout) -> [String: Any] {
        return ["ID": hangout.id, "name": hangout.name ?? "N/A", "date": hangout.date?.timeIntervalSince1970 ?? "N/A", "host": hangout.host ?? "N/A", "description": hangout.description ?? "N/A", "latitude": hangout.latitude ?? "N/A", "longitude": hangout.longitude ?? "N/A", "uid": Auth.auth().currentUser!.uid]
    }
}
