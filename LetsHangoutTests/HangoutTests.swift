//
//  HangoutTests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest
@testable import LetsHangout

class HangoutTests: XCTestCase {
    var hangout: Hangout!
    let dateFormatter = DateFormatter()
    let dateString = "May 23, 2017"
    
    override func setUp() {
        super.setUp()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        hangout = Hangout(name: "Test", date: dateFormatter.date(from: dateString), host: "Yemi", latitude: 25.034280, longitude: -77.396280, description: "Description", imageURL: nil, uid: "1234")
    }
    
    override func tearDown() {
        super.tearDown()
        hangout = nil
    }
    
    func testHangoutID() {
        XCTAssertNotNil(hangout.id)
    }
    
    func testHangoutName() {
        XCTAssertEqual(hangout.name, "Test")
    }
    
    func testHangoutDate() {
        let date = dateFormatter.date(from: dateString)
        XCTAssertEqual(hangout.date, date)
    }
    
    func testHangoutHost() {
        XCTAssertEqual(hangout.host, "Yemi")
    }
    
    func testHangoutLatitudeAndLongitude() {
        XCTAssertEqual(hangout.latitude, 25.034280)
        XCTAssertEqual(hangout.longitude, -77.396280)
    }
    
    func testHangoutDescription() {
        XCTAssertEqual(hangout.description, "Description")
    }
    
    func testHangoutImageURL() {
        XCTAssertNil(hangout.imageURL)
    }
    
    func testHangoutUID() {
        XCTAssertEqual(hangout.uid, "1234")
    }
}
