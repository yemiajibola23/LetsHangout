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
    var location: CLLocation?
    //var image: UIImage?
    
    init(name: String?, date: String?, host: String?, description: String?, location: CLLocation?) {
        self.name = name
        self.date = date
        self.host = host
        self.description = description
//        self.image = image
        self.location = location
        
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
       
        var newDate: Date?
        if let dateString = date {
             newDate = dateFormatter.date(from: dateString)
        }
        
        self.hangout = Hangout(name: name, date: newDate, host: host, latitude: latitude, longitude: longitude, description: description, imageURL: nil)
        
    }
}
