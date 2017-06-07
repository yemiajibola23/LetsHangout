//
//  AddHangoutViewModel.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation


struct AddHangoutViewModel {
    func createHangout(name: String?, date: Date?, host: String?, description: String?, latitude: Double?, longitude: Double?) -> Hangout {
        return Hangout(name: name, date: date, host: host, latitude: latitude, longitude: longitude, description: description)
    }
}
