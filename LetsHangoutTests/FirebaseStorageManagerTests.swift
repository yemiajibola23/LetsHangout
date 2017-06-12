//
//  FirebaseStorageManagerTests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/11/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest
import FirebaseStorage
@testable import LetsHangout

class FirebaseStorageManagerTests: XCTestCase {
    var manager: FirebaseStorageManager!
    var authManager: FirebaseAuthenticationManager!
    
    var storageReference: StorageReference?
    var storageError: FirebaseStorageError?
    
    override func setUp() {
        super.setUp()
        authManager = FirebaseAuthenticationManagerMock.sharedInstance
    }
    
    override func tearDown() {
        deleteCurrentUserAndStorage()
        super.tearDown()
    }
    
    private func login(completion: @escaping () -> Void) {
        let emailArray = ["fake@gmail.com", "fake@gmail1.com","fake@gmail2.com"]
        
        let userEmail = emailArray[Int(arc4random_uniform(3))]
        let userPassword = "dummy1"
        let userName = "Test Dummy 1"
        
        authManager.registerWithCredentials(userEmail, userPassword, userName) {[unowned self] result in
            switch result {
            case .failure(let authError):
                print(authError.message)
                return
            case .success(_):
                self.manager = FirebaseStorageManagerMock.sharedInstance
            }
            
            completion()
        }
    }
    
    private func logout(completion: @escaping (FirebaseAuthenticationError?) -> Void) {
        authManager.logout(completion: completion)
    }
    
    private func deleteCurrentUserAndStorage() {
        guard let currentUser = authManager.currentUser, let userRef = authManager.currentUserRef else { return }
        userRef.removeValue()
        
        storageReference?.delete(completion: nil)
        currentUser.delete { XCTAssertNil($0) }
    }
    
    func testSavePhoto() {
        var newPhotoReference: StorageReference?
        var saveError: FirebaseStorageError?
        let storageExpectation = expectation(description: "A new photo should be stored")
        let id = singleHangout().id
        let image = #imageLiteral(resourceName: "friends")
        
        login { [unowned self] _ in
            self.manager.save(photo: image, with: id) { result in
                switch result {
                case let .success(reference):
                    newPhotoReference = reference
                case let .failure(storageError):
                    saveError = storageError
                }
                storageExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNil(saveError)
            XCTAssertNotNil(newPhotoReference)
        }
    }
    
}

extension FirebaseStorageManagerTests {
    class FirebaseStorageManagerMock: FirebaseStorageManager {
        var storageResult: StorageResult?
//        var storageReference: StorageReference?
//        var storageError: FirebaseStorageError?
        
        override func save(photo: UIImage, with id: String, completion: @escaping (FirebaseStorageManager.StorageResult) -> Void) {
            super.save(photo: photo, with: id) {[unowned self] result  in
                self.storageResult = result
//                switch result {
//                case .success(let reference): self.storageReference = reference
//                case .failure(let error): self.storageError = error
//                }
                
//                completion(result)
            }
        }
    }
}
