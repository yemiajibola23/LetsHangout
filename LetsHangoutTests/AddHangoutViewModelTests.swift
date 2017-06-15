//
//  AddHangoutViewModelTests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest
import CoreLocation
@testable import LetsHangout

class AddHangoutViewModelTests: XCTestCase {
    var viewModel: AddHangoutViewModel!
    
    override func setUp() {
        super.setUp()
        
        viewModel = AddHangoutViewModel(name: "Test", date: "May 23, 2017", host: "Yemi", description: "Description", location: CLLocation(latitude: 25.034280, longitude: -77.396280))
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    
    func testAddHangoutViewModelName() {
        XCTAssertEqual(viewModel.name, "Test")
    }
    
    func testAddHangoutViewModelDate() {
        XCTAssertEqual(viewModel.date, "May 23, 2017")
    }
    
    func testAddHangoutViewModelHost() {
        XCTAssertEqual(viewModel.host, "Yemi")
    }
    
    func testAddHangoutViewModelDescription() {
        XCTAssertEqual(viewModel.description, "Description")
    }
    
    func testAddHangoutViewModelLocation() {
        XCTAssertNotNil(viewModel.location)
    }
    
    func testAddHangoutViewModelHangout() {
        XCTAssertNotNil(viewModel.hangout)
    }
    
}
