//
//  AddHangoutViewModel.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation


struct AddHangoutViewModel {
    func createHangout(name: String?, date: String?, host: String?, description: String?, latitude: Double?, longitude: Double?, imageURL: String?) -> Hangout {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        var dateAsDate: Date? = nil
        if let date = date { dateAsDate = dateFormatter.date(from: date) }
        
        return Hangout(name: name, date: dateAsDate, host: host, latitude: latitude, longitude:longitude, description: description, imageURL: imageURL)
    }
}
