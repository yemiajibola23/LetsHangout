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

@testable import LetsHangout

class FirebaseManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFirebaseManagerSaveHangoutSuccess() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        let hangout = Hangout(name: "Test", date: dateFormatter.date(from: "May 23, 2017"), host: "Yemi", latitude: 25.034280, longitude: -77.396280, description: "Description")
        var hangoutRef: DatabaseReference!
        
        let manager = FirebaseManager.sharedInstance
        
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
}
