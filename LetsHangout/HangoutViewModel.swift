//
//  HangoutViewModel.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit
import CoreLocation

struct HangoutViewModel {
    private let hangout: Hangout
    
    var name: String? { return hangout.name }
    var host: String? { return hangout.host }
    var description: String? { return hangout.description }
    
    var date: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        
        if let date = hangout.date { return formatter.string(from: date) }
        
        return nil
    }
    
    var locationCoordinate: CLLocationCoordinate2D? {
        guard let latitude = hangout.latitude, let longitude = hangout.longitude else { return nil }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var image: UIImage? {
        return nil
    }
    
    init(hangout: Hangout) {
        self.hangout = hangout
    }
}
