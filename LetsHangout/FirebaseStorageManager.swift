//
//  FirebaseStorageManager.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/11/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit
import FirebaseStorage

enum FirebaseStorageError: Error {
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
    
    var message: String {
        switch self {
        case .unknown: return "An unknown error occurred"
        case .objectNotFound: return "No object exists at the desired reference"
        case .bucketNotFound: return "No bucket was configured for Firebase Storage."
        case .projectNotFound: return "No project is configured for Firebase Storage."
        case .quotaExceeded: return "Quota on your Firebase Storage bucket has been exceeded."
        case .unauthenticated: return "User is unauthenticated. Authenticate and try again"
        case .unauthorized: return "User is unauthorized to perform the desired action"
        case .retryLimitExceeded: return "The maximum time limit on an operation has been exceeded."
        case .nonMatchingChecksum: return "File on client does not match checksum of the file received by the server."
        case .downloadSizeExceeeded: return "Size of the downloaded file exceeds the amount of memory allocated for the file."
        case .cancelled: return "User cancelled the operation."
        }
    }
}



class FirebaseStorageManager {
    static let sharedInstance =
        FirebaseStorageManager()
    
    typealias StorageReferenceResult = Result<String, FirebaseStorageError>
    typealias StorageDataResult = Result<Data, FirebaseStorageError>
    
    private init() {}
    
    private let storageRef = Storage.storage().reference()
    
    func save(photo: UIImage, with id: String, for path: StoragePath, completion: @escaping (StorageReferenceResult) -> Void) {
        
        guard let data = UIImageJPEGRepresentation(photo, 0.5) else { completion(.failure(FirebaseStorageError.unknown)); return}
        
        let imageReference = storageRef.child(path.rawValue).child(id)
        
        imageReference.putData(data, metadata: nil) { (metadata, error) in
            if let storageError = error {
                completion(StorageReferenceResult.failure(FirebaseStorageError(code: storageError._code)))
                return
            }
            
            guard let metadata = metadata else {  completion(.failure(FirebaseStorageError.unknown)); return }
            
            completion(StorageReferenceResult.success(metadata.path!))
        }
    }
    
    func createReferenceFrom(path: String) -> StorageReference? {
        return storageRef.child(path)
    }
    
    func downloadPhoto(from url: String, completion: @escaping (StorageDataResult) -> Void) {
        let imageReference = Storage.storage().reference(forURL: url)
        imageReference.getData(maxSize: INT64_MAX) { (data, error) in
            if let error = error {
                completion(StorageDataResult.failure(FirebaseStorageError(code: error._code)))
                return
            }
            
            if let data = data {
                completion(StorageDataResult.success(data))
                return
            }
            
            completion(StorageDataResult.failure(FirebaseStorageError.unknown))
        }
    }
}
