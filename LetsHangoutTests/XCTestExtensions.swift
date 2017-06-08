//
//  XCTestExtensions.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/8/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit
import XCTest
@testable import LetsHangout

extension XCTest {
    func fakeHangouts() -> [Hangout] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        return [Hangout(name: "Test", date: dateFormatter.date(from: "May 22, 2017"), host: "Yemi", latitude: nil, longitude: nil, description: "Description"), Hangout(name: "Test 2", date: dateFormatter.date(from: "March 31, 2017"), host: "Jocelyn", latitude: 21.161908, longitude: -86.851528, description: "Description 2")]
    }
}
