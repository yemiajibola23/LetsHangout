//
//  FirebaseDatabaseManager.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/10/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

enum FirebaseDatabaseErrorType: Error {
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
}

struct FirebaseDatabaseError {
    var type: FirebaseDatabaseErrorType
    var message: String
    
    init(type: FirebaseDatabaseErrorType) {
        self.type = type
        
        switch type {
        case .disconnected: message = ""
        case .expiredToken: message = ""
        case .invalidToken: message = ""
        case .maxRetries: message = ""
        case .networkError: message = ""
        case .operationFailed: message = ""
        case .overriddenBySet: message = ""
        case .permissionDenied: message = ""
        case .unavailable: message = ""
        case .userCodeException: message = ""
        case .unknown: message = ""
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
                let result = DatabaseReferenceResult.failure(FirebaseDatabaseError(type: FirebaseDatabaseErrorType(rawValue: databaseError._code)))
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
            for snap in snapshot.children.allObjects {
                self.hangoutsRef.child((snap as? DataSnapshot)!.key).observeSingleEvent(of: .value, with: { (hangoutSnap) in
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
        })
    }
    
    func deleteHangout(_ reference: DatabaseReference, completion:@escaping (DatabaseReferenceResult) -> Void) {
        var result: DatabaseReferenceResult?
        
        reference.removeValue { (error, ref) in
            if let databaseError = error {
                result = DatabaseReferenceResult.failure(FirebaseDatabaseError.init(type: FirebaseDatabaseErrorType(rawValue: databaseError._code)))
            } else {
                self.currentUserRef.child(DatabasePath.hangouts.rawValue).child(ref.key).removeValue()
                result = DatabaseReferenceResult.success(ref)
            }
            
            completion(result!)
        }
    }
    
    
    private func generateHangoutDictionary(hangout: Hangout) -> [String: Any] {
        return ["ID": hangout.id, "name": hangout.name ?? "N/A", "date": hangout.date?.timeIntervalSince1970 ?? "N/A", "host": hangout.host ?? "N/A", "description": hangout.description ?? "N/A", "latitude": hangout.latitude ?? "N/A", "longitude": hangout.longitude ?? "N/A"]
    }
}
