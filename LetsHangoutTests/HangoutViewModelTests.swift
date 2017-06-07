//
//  HangoutViewModelTests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest
import CoreLocation
@testable import LetsHangout

class HangoutViewModelTests: XCTestCase {
    let dateFormatter = DateFormatter()
    var hangoutViewModel: HangoutViewModel!
    var hangout: Hangout!
    
    override func setUp() {
        super.setUp()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        hangout = Hangout(name: "Test", date: dateFormatter.date(from: "May 23, 2017"), host: "Yemi", latitude: 25.034280, longitude: -77.396280, description: "Description")
        hangoutViewModel = HangoutViewModel(hangout: hangout)
    }
    
    override func tearDown() {
        hangoutViewModel = nil
        super.tearDown()
    }
    
    func testHangoutViewModelName() {
        XCTAssertEqual(hangoutViewModel.name, "Test")
    }
    
    func testHangoutViewModelDate() {
        XCTAssertEqual(hangoutViewModel.date, "May 23, 2017")
    }
    
    func testHangoutViewModelHost() {
        XCTAssertEqual(hangoutViewModel.host, "Yemi")
    }
    
    func testHangoutViewModelLocationCoordinate() {
       XCTAssertNotNil(hangoutViewModel.locationCoordinate)
    }
    
    func testHangoutViewModelDescription() {
        XCTAssertEqual(hangoutViewModel.description, "Description")
    }
}
