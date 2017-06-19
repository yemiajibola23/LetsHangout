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
        
        hangout = Hangout(name: "Test", date: dateFormatter.date(from: "May 23, 2017"), host: "Yemi", latitude: 25.034280, longitude: -77.396280, description: "Description", imageURL: nil, uid: "1234")
        hangoutViewModel = HangoutViewModel(hangout: hangout)
    }
    
    override func tearDown() {
        hangoutViewModel = nil
        super.tearDown()
    }
    
    func testHangoutViewModelName() {
        XCTAssertEqual(hangoutViewModel.name, hangout.name)
    }
    
    func testHangoutViewModelDate() {
        XCTAssertEqual(hangoutViewModel.date, dateFormatter.string(from: hangout.date!))
    }
    
    func testHangoutViewModelHost() {
        XCTAssertEqual(hangoutViewModel.host, hangout.host)
    }
    
    func testHangoutViewModelLocationCoordinate() {
       XCTAssertNotNil(hangoutViewModel.locationCoordinate)
    }
    
    func testHangoutViewModelDescription() {
        XCTAssertEqual(hangoutViewModel.description, hangout.description)
    }
    
    func testHangoutViewModelImageNil() {
        XCTAssertNil(hangoutViewModel.image)
    }
    
    func testHangoutViewModelUID() {
        XCTAssertEqual(hangoutViewModel.uid, hangout.uid)
    }
}
