//
//  AddHangoutViewModel.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit
import CoreLocation


class AddHangoutViewModel {
    var hangout: Hangout?
    var name: String?
    var date: String?
    var host: String?
    var description: String?
    var locationCoordinate: CLLocationCoordinate2D?
    var uid: String
    
    init(name: String?, date: String?, host: String?, description: String?, location: CLLocationCoordinate2D?, uid: String) {
        self.name = name
        self.date = date
        self.host = host
        self.description = description
//        self.image = image
        self.locationCoordinate = location
        self.uid = uid
        
        let latitude = location?.latitude
        let longitude = location?.longitude
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
       
        var newDate: Date?
        if let dateString = date {
             newDate = dateFormatter.date(from: dateString)
        }
        
        self.hangout = Hangout(name: name, date: newDate, host: host, latitude: latitude, longitude: longitude, description: description, imageURL: nil, uid: uid)
        
    }
}
