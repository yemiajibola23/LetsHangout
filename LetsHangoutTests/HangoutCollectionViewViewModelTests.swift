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
    var viewModel: HangoutCollectionViewViewModel!
    
    override func setUp() {
        super.setUp()
       viewModel = HangoutCollectionViewViewModel(hangouts: multipleHangouts())
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testHangoutCollectionViewViewModelNumberOfRows() {
        XCTAssertEqual(viewModel.numberOfHangouts, 2)
    }
    
    func testHangoutCollectionViewViewModelViewModelForIndex() {
        let hangoutViewModel = viewModel.viewModelFor(index: 1)
        
        XCTAssertEqual(hangoutViewModel.name, "Test 2")
    }
    
}
