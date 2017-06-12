//
//  FirebaseStorageManager.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/11/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit
import FirebaseStorage

enum FirebaseStorageErrorType: Error {
    case unknown
    case objectNotFound
    case bucketNotFound
    case projectNotFound
    case quotaExceeded
    case unauthenticated
    case unauthorized
    case retryLimitExceeded
    case nonMatchingChecksum
    case downloadSizeExceeeded
    case cancelled
    
    init(code: Int) {
        switch code {
        case -13000: self = .unknown
        case -13010: self = .objectNotFound
        case -13011: self = .bucketNotFound
        case -13012: self = .projectNotFound
        case -13013: self = .quotaExceeded
        case -13020: self = .unauthenticated
        case -13021: self = .unauthorized
        case -13030: self = .retryLimitExceeded
        case -13031: self = .nonMatchingChecksum
        case -13032: self = .downloadSizeExceeeded
        case -13040: self = .cancelled
        default: self = .unknown
        }
    }
}

struct FirebaseStorageError {
    var type: FirebaseStorageErrorType
    var message: String
    
    init(type: FirebaseStorageErrorType) {
        self.type = type
        
        switch type {
        case .unknown: message = "An unknown error occurred"
        case .objectNotFound: message = "No object exists at the desired reference"
        case .bucketNotFound: message = "No bucket was configured for Firebase Storage."
        case .projectNotFound: message = "No project is configured for Firebase Storage."
        case .quotaExceeded: message = "Quota on your Firebase Storage bucket has been exceeded."
        case .unauthenticated: message = "User is unauthenticated. Authenticate and try again"
        case .unauthorized: message = "User is unauthorized to perform the desired action"
        case .retryLimitExceeded: message = "The maximum time limit on an operation has been exceeded."
        case .nonMatchingChecksum: message = "File on client does not match checksum of the file received by the server."
        case .downloadSizeExceeeded: message = "Size of the downloaded file exceeds the amount of memory allocated for the file."
        case .cancelled: message = "User cancelled the operation."
        }
    }
}


class FirebaseStorageManager {
    static let sharedInstance =
        FirebaseStorageManager()
    private let hangoutsRef = Storage.storage().reference().child(StoragePath.hangouts.rawValue)
    private let profilesRef = Storage.storage().reference().child(StoragePath.profiles.rawValue)
    
    typealias StorageResult = Result<StorageReference, FirebaseStorageError>
    
    private init() {}
    
    func save(photo: UIImage, with id: String, completion: @escaping (StorageResult) -> Void) {
        
        guard let data = UIImageJPEGRepresentation(photo, 0.5) else { fatalError() }
        
        let imageReference = hangoutsRef.child(id)
        
        imageReference.child(id).putData(data, metadata: nil) { (metadata, error) in
            if let storageError = error {
                completion(StorageResult.failure(FirebaseStorageError(type: FirebaseStorageErrorType(code: storageError._code))))
                return
            }
            
            completion(StorageResult.success(imageReference))
        }
    }
    
}
