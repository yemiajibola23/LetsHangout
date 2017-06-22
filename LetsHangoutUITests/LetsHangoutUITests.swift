//
//  LetsHangoutUITests.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/22/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import XCTest

class LetsHangoutUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        
    }
    
}
