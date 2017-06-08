//
//  AddHangoutViewModelTests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest
@testable import LetsHangout

class AddHangoutViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddHangoutViewModelCreateHangout() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        let addHangoutViewModel = AddHangoutViewModel()
        let hangout = addHangoutViewModel.createHangout(name: "Test", date: "May 23, 2017", host: "Yemi", description: "Description", latitude: 25.034280, longitude: -77.396280)
        
        XCTAssertEqual(hangout.name, "Test")
        XCTAssertEqual(hangout.date, dateFormatter.date(from: "May 23, 2017"))
        XCTAssertEqual(hangout.host, "Yemi")
        XCTAssertEqual(hangout.description, "Description")
        XCTAssertEqual(hangout.latitude, 25.034280)
        XCTAssertEqual(hangout.longitude, -77.396280)
    }
}
