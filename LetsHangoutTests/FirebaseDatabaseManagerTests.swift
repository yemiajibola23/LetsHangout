//
//  FirebaseDatabaseManagerTests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/10/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest
import FirebaseDatabase
import FirebaseAuth
import Firebase
@testable import LetsHangout


class FirebaseDatabaseManagerTests: XCTestCase {
    var manager: FirebaseDatabaseManager!
    var authManager: FirebaseAuthenticationManager!
    
    var hangoutName: String?
    var hangoutDate: Date?
    var hangoutDescription: String?
    var hangoutHost: String?
    
    

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        
        return formatter
    }()
    
    override func setUp() {
        super.setUp()
        authManager = FirebaseAuthenticationManagerMock.sharedInstance
    }
    
    override func tearDown() {
        deleteCurrentUserAndHangouts()
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
                self.manager = FirebaseDatabaseManagerMock.sharedInstance
            }
            
            completion()
        }
    }
    
    private func logout(completion: @escaping (FirebaseAuthenticationError?) -> Void) {
        authManager.logout(completion: completion)
    }
    
    private func deleteCurrentUserAndHangouts() {
        guard let currentUser = authManager.currentUser else { return }
        let userRef = Database.database().reference().child(DatabasePath.users.rawValue)
        
        userRef.removeValue()
        currentUser.delete { XCTAssertNil($0) }
        Database.database().reference().child(DatabasePath.hangouts.rawValue).removeValue()
    }
    
    
    private func readHangout(ref: DatabaseReference, completion: @escaping ([String: Any]) -> Void) {
        ref.observe(.value, with: { snapshot in
            if let dictionary = snapshot.value as? [String: Any] {
                completion(dictionary)
            }
        })
    }
    
    func testSaveHangoutResultReference() {
        var newHangoutReference: DatabaseReference?
        var saveError: FirebaseDatabaseError?
        let saveExpectation = expectation(description: "A new hangout should be saved")
        let hangout = singleHangout()
        
        login { [unowned self] in
            self.manager.save(hangout: hangout) { [unowned self] result in
                switch result {
                case let .success(reference):
                    newHangoutReference = reference
                    self.readHangout(ref: newHangoutReference!) { [unowned self] dict in
                        self.hangoutName = dict["name"] as? String
                        self.hangoutHost = dict["host"] as? String
                        self.hangoutDescription = dict["description"] as? String
                        self.hangoutDate = Date(timeIntervalSince1970: dict["date"] as! Double)
                        saveExpectation.fulfill()
                    }
                case let .failure(databaseError):
                    saveError = databaseError
                    saveExpectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 30) { [unowned self] error in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNil(saveError)
            XCTAssertNotNil(newHangoutReference)
            guard let hangoutName = self.hangoutName else { return }
            XCTAssertEqual(hangoutName, hangout.name)
            XCTAssertEqual(self.hangoutDate, hangout.date)
            XCTAssertEqual(self.hangoutHost, hangout.host)
            XCTAssertEqual(self.hangoutDescription, hangout.description)
        }
    }
    
    func testLoadHangoutsSuccess() {
        var loadedHangouts: [Hangout]?
        let hangoutsExpecation = expectation(description: "There should be hangouts")
        let hangout = singleHangout()
        
       login { [unowned self] in
            self.manager.save(hangout: hangout) { [unowned self] _ in
                self.manager.loadHangouts(completion: { (fetchedHangouts) in
                    loadedHangouts = fetchedHangouts
                    hangoutsExpecation.fulfill()
                })
            }
        }
        
        waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNotNil(loadedHangouts)
            guard let loadedHangouts = loadedHangouts else { return }
            XCTAssertEqual(loadedHangouts.count, 1)
            XCTAssertEqual(loadedHangouts.first!.name, "Test")
            XCTAssertEqual(loadedHangouts.first!.host, "Brian")
            XCTAssertNil(loadedHangouts.first?.latitude)
            XCTAssertNil(loadedHangouts.first?.longitude)
            XCTAssertEqual(loadedHangouts.first?.description, "Description")
        }
    }
    
    //    func testSaveHangoutResultErrorPermissionDenied() {
    //        var newHangoutReference: DatabaseReference?
    //        var saveError: FirebaseDatabaseError?
    //        let saveExpectation = expectation(description: "A database error should occur")
    //        let hangout = singleHangout()
    //
    //        login {
    //            self.logout { [unowned self] _ in
    //                self.manager.save(hangout: hangout) { result in
    //                    switch result {
    //                    case let .success(reference): newHangoutReference = reference
    //                    case let .failure(databaseError):
    //                        saveError = databaseError
    //                    }
    //                    saveExpectation.fulfill()
    //                }
    //            }
    //        }
    //
    //
    //        waitForExpectations(timeout: 30) { error in
    //            XCTAssertNil(error, error!.localizedDescription)
    //            XCTAssertNotNil(saveError)
    //            XCTAssertNil(newHangoutReference)
    //            XCTAssertEqual(saveError?.type, .permissionDenied)
    //        }
    //    }
    
}

extension FirebaseDatabaseManagerTests {
    class FirebaseDatabaseManagerMock: FirebaseDatabaseManager {
        var databaseResult: DatabaseReferenceResult?
//        var databaseReference: DatabaseReference?
//        var databaseError: FirebaseDatabaseError?
        
        override func save(hangout: Hangout, completion: @escaping (FirebaseDatabaseManager.DatabaseReferenceResult) -> Void) {
            super.save(hangout: hangout) { [unowned self] result in
                self.databaseResult = result
//                
//                switch result {
//                case let .success(savedReference): self.databaseReference = savedReference
//                case let .failure(dataError): self.databaseError = dataError
//                }
            }
        }
    }
}
