//
//  HangoutUserViewModel.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/9/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit


class HangoutUserViewModel {
    private var user: HangoutUser
    
    var name: String { return user.name }
    var uid: String { return user.uid }
    var image: UIImage? = #imageLiteral(resourceName: "defaultprofile")
    
    init(user: HangoutUser) {
        self.user = user
    }
    
    func setprofilePicture(completion: @escaping (UIImage, FirebaseStorageError?) -> Void) {
        let storageManager = FirebaseStorageManager.sharedInstance
        guard let profileURL = user.profilePictureURL else { completion(#imageLiteral(resourceName: "defaultprofile"), nil); return }
        storageManager.downloadPhoto(from: profileURL) { result in
            switch result {
            case .failure(let error):
                print(error.message)
                completion(#imageLiteral(resourceName: "defaultprofile"), error)
            case .success(let data):
                self.image = UIImage(data: data)!
                completion(UIImage(data: data)!, nil)
            }
        }
    }
}
