//
//  FirebaseStorageManagerTests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/11/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest
import FirebaseStorage
import FirebaseAuth
@testable import LetsHangout

class FirebaseStorageManagerTests: XCTestCase {
    var manager: FirebaseStorageManager!
    var authManager: FirebaseAuthenticationManager!
    
    var storagePath: String?
    var storageError: FirebaseStorageError?
    
    override func setUp() {
        super.setUp()
        authManager = FirebaseAuthenticationManagerMock.sharedInstance
    }
    
    override func tearDown() {
        deleteCurrentUserAndStorage()
        super.tearDown()
    }
    
    var previousRandomNumber: UInt32?
    
    private func randomNumber() -> Int {
        var randomNumber = arc4random_uniform(5)
        while previousRandomNumber == randomNumber {
            randomNumber = arc4random_uniform(5)
        }
        previousRandomNumber = randomNumber
        return Int(randomNumber)
    }
    
    
    private func login(completion: @escaping () -> Void) {
        let emailArray = ["fake@gmail.com", "fake2@gmail.com","fake3@gmail.com", "fake1@gmail.com", "fake4@gmail.com"]
        
        let userEmail = emailArray[randomNumber()]
        let userPassword = "dummy1"
        let userName = "Test Dummy 1"
        
        authManager.registerWithCredentials(userEmail, userPassword, userName) {[unowned self] result in
            switch result {
            case .failure(_):
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
        if let storagePath = storagePath {
            Storage.storage().reference(withPath: storagePath).delete(completion: nil)
        }
        currentUser.delete { XCTAssertNil($0) }
    }
    
    func testSavePhotoResultStorageReference() {
        let storageExpectation = expectation(description: "A new photo should be stored")
        let id = singleHangout().id
        let image = #imageLiteral(resourceName: "friends")
        
        login { [unowned self] _ in
            self.manager.save(photo: image, with: id, for: .hangouts) { result in
                switch result {
                case let .success(path):
                    self.storagePath = path
                case let .failure(error):
                    self.storageError = error
                }
                storageExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNil(self.storageError)
            XCTAssertNotNil(self.storagePath)
        }
    }
  
    func testDownloadPhotoResultImage() {
          let storageExpectation = expectation(description: "A new photo should be stored")
        let id = singleHangout().id
        let image = #imageLiteral(resourceName: "friends")
        var imageData: Data?
        var downloadError: FirebaseStorageError?
        
        login { [unowned self] _ in
            self.manager.save(photo: image, with: id, for: .hangouts, completion: { result in
                switch result {
                case .success(let path): self.storagePath = path
                case .failure(let err): XCTFail(err.message)
                }
                guard let storagePath = self.storagePath else { XCTFail("No image path"); return }
                guard let imageReference = self.manager.createReferenceFrom(path: storagePath) else { XCTFail("Couldn't create reference"); return }
                self.manager.downloadPhoto(from: imageReference.description, completion: { imageResult in
                    switch(imageResult) {
                    case .success(let data): imageData = data
                    case .failure(let error): downloadError = error
                    }
                    
                    storageExpectation.fulfill()
                })
            })
        }
        
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNil(downloadError)
            XCTAssertNotNil(imageData)
        }
    }
}

extension FirebaseStorageManagerTests {
    class FirebaseStorageManagerMock: FirebaseStorageManager {
        var storageReferenceResult: StorageReferenceResult?
        //        var storageReference: StorageReference?
        //        var storageError: FirebaseStorageError?
        
        override func save(photo: UIImage, with id: String, for path: StoragePath, completion: @escaping (FirebaseStorageManager.StorageReferenceResult) -> Void) {
            super.save(photo: photo, with: id, for: path) {[unowned self] result  in
                self.storageReferenceResult = result
            }
        }
    }
}
