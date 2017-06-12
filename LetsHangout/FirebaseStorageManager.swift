//
//  FirebaseStorageManager.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/11/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit
import FirebaseStorage


class FirebaseStorageManager {
    static let sharedInstance =
        FirebaseStorageManager()
    private let hangoutsRef = Storage.storage().reference().child(StoragePath.hangouts.rawValue)
    private let profilesRef = Storage.storage().reference().child(StoragePath.profiles.rawValue)
    
    private init() {}
    
    func savePhoto(_ photo: UIImage, completion: () -> Void) {
        
    }
}
