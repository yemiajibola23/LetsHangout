//
//  Hangout.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation

struct Hangout {
    var id: String
    var name: String?
    var date: Date?
    var host: String?
    var latitude: Double?
    var longitude: Double?
    var description: String?
    
    init(name: String?, date: Date?, host: String?, latitude: Double?, longitude: Double?, description: String?) {
        id = UUID().uuidString
        self.name = name
        self.date = date
        self.host = host
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
    }
    
    init(dict: [String: Any]) {
        id = dict["ID"] as! String
        name = dict["name"] as? String
        date = Date(timeIntervalSince1970: dict["date"] as! Double)
        host = dict["host"] as? String
        latitude = dict["latitude"] as? Double
        longitude = dict["longitude"] as? Double
        description = dict["description"] as? String
    }
}
