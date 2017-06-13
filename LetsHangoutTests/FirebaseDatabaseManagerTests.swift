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
    
    private let userEmail = "fake@gmail.com"
    private let userPassword = "dummy1"
    private let userName = "Test Dummy 1"
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
        authManager.registerWithCredentials(userEmail, userPassword, userName) { [unowned self] _ in
            self.authManager.loginWithCredentials(self.userEmail, self.userPassword, completion: {[unowned self] _ in
                self.manager = FirebaseDatabaseManagerMock.sharedInstance
                completion()
            })
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
    
    private func readHangout(ref: DatabaseReference, completion: (([String: Any]?) -> Void)?) {
         ref.observe(.value, with: { snapshot in
            completion?(snapshot.value as? [String: Any])
        })
    }
    
    func testSaveHangoutResultReference() {
        var newHangoutReference: DatabaseReference?
        var saveError: FirebaseDatabaseError?
        let saveExpectation = expectation(description: "A new hangout should be saved")
        let hangout = singleHangout()
        
        self.login { [unowned self] in
            self.manager.save(hangout: hangout) { [unowned self] result in
                switch result {
                case let .success(reference):
                    newHangoutReference = reference
                    self.readHangout(ref: reference) { [unowned self] dictionary in
                        guard let dictionary = dictionary else { return }
                        self.hangoutName = dictionary["name"] as? String
                        self.hangoutHost = dictionary["host"] as? String
                        self.hangoutDescription = dictionary["description"] as? String
                        if let date = dictionary["date"] as? Double { self.hangoutDate = Date(timeIntervalSince1970: date) }
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
            guard newHangoutReference != nil else { return }
            XCTAssertEqual(self.hangoutName, hangout.name)
            XCTAssertEqual(self.hangoutDate, hangout.date)
            XCTAssertEqual(self.hangoutHost, hangout.host)
            XCTAssertEqual(self.hangoutDescription, hangout.description)
        }
        
    }
    
    func testLoadHangoutsSuccess() {
        var loadedHangouts:[Hangout]?
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
            XCTAssertEqual(loadedHangouts.first?.name, "Test")
            XCTAssertEqual(loadedHangouts.first?.host, "Brian")
            XCTAssertNil(loadedHangouts.first?.latitude)
            XCTAssertNil(loadedHangouts.first?.longitude)
            XCTAssertEqual(loadedHangouts.first?.description, "Description")
        }
    }
    
    func testDeleteHangoutSuccess() {
        var deleteError: FirebaseDatabaseError?
        let deleteExpecation = expectation(description: "Hangout should be deleted")
        let hangout = singleHangout()
        var deletedHangout: [String: Any]?
        
        login { [unowned self] in
            self.manager.save(hangout: hangout) { (result) in
                var addedReference: DatabaseReference?
                switch result {
                case .success(let reference):
                    addedReference = reference
                case .failure(_):
                    break
                }
                guard let addReference = addedReference else { XCTFail("No Reference saved"); return }
                
                self.manager.deleteHangout(addReference) { [unowned self] result in
                    switch result {
                    case .success(let reference):
                        self.readHangout(ref: reference) { deletedHangout = $0 }
                    case .failure(let databaseError): deleteError = databaseError
                    }
                    
                    deleteExpecation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(error, error!.localizedDescription)
            XCTAssertNil(deleteError)
            XCTAssertNil(deletedHangout)
        }
    }
}

extension FirebaseDatabaseManagerTests {
    class FirebaseDatabaseManagerMock: FirebaseDatabaseManager {
        var databaseResult: DatabaseReferenceResult?
        var databaseReference: DatabaseReference?
        var databaseError: FirebaseDatabaseError?
        
        override func save(hangout: Hangout, completion: @escaping (FirebaseDatabaseManager.DatabaseReferenceResult) -> Void) {
            super.save(hangout: hangout) { [unowned self] result in
                self.databaseResult = result
                
                switch result {
                case let .success(savedReference): self.databaseReference = savedReference
                case let .failure(dataError): self.databaseError = dataError
                }
            }
        }
    }
}
