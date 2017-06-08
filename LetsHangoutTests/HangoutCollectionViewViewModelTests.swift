//
//  HangoutCollectionViewViewModelTests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/8/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest
@testable import LetsHangout

class HangoutCollectionViewViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHangoutCollectionViewViewModelNumberOfRows() {
        let viewModel = HangoutCollectionViewViewModel(hangouts: fakeHangouts())
        
        XCTAssertEqual(viewModel.numberOfHangouts, 2)
    }
    
    
}
