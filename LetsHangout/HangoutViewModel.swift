//
//  HangoutViewModel.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit
import CoreLocation

class HangoutViewModel {
    private var hangout: Hangout
    
    var name: String? { return hangout.name }
    var host: String? { return hangout.host }
    var description: String? { return hangout.description }
    var image: UIImage?
    
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
    
    init(hangout: Hangout) {
        self.hangout = hangout
        fetchImage(url: hangout.imageURL) {(image) in
            self.image = image
        }
    }

    private func fetchImage(url: String?, completion:@escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        
        let storageManager = FirebaseStorageManager.sharedInstance
    
        storageManager.downloadPhoto(from: url) { result in
            switch result {
            case .success(let imageData): completion(UIImage(data: imageData))
            case .failure(_):
                completion(nil)
            }
        }
    }
}
