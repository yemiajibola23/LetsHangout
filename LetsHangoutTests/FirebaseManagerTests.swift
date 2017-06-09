//
//  FirebaseManagerTests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest
import Firebase
import FirebaseDatabase
import FirebaseAuth

@testable import LetsHangout

class FirebaseManagerTests: XCTestCase {
    var manager: FirebaseManager!
    
    override func setUp() {
        super.setUp()
        manager = FirebaseManager.sharedInstance
    }
    
    override func tearDown() {
        manager = nil
        super.tearDown()
    }
    
    func testFirebaseManagerSaveHangoutSuccess() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        let hangout = Hangout(name: "Test", date: dateFormatter.date(from: "May 23, 2017"), host: "Yemi", latitude: 25.034280, longitude: -77.396280, description: "Description")
        var hangoutRef: DatabaseReference!
        
       
        
        let saveExpectation = expectation(description: "Hangout should be saved")
        
        manager.save(hangout: hangout) { (error, ref) in
            if let error = error { XCTFail(error.localizedDescription) }
            
            hangoutRef = ref
            saveExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            
            XCTAssertEqual(hangoutRef.key, hangout.id)
        }
    }
    
    func testFirebaseManagerLoginUserSuccess() {
        let email = "test1@gmail.com"
        let password = "dummy1"
        
        let loginExpectation = expectation(description: "A user should be returned")
        
        var loggedInUser: User!
        
        manager.loginWithCredentials(email, password) { user, error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            loggedInUser = user
            loginExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 40) { error in
            if let _ = error {
                XCTFail("Error occurred")
                return
            }
            
            XCTAssertNotNil(loggedInUser)
        }
    }
}
