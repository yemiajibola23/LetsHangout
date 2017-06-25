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
        
        self.setprofilePicture {[unowned self] profileImage in
            self.image = profileImage
        }
    }
    
    private func setprofilePicture(completion: @escaping (UIImage) -> Void) {
        let storageManager = FirebaseStorageManager.sharedInstance
        guard let profileURL = user.profilePictureURL else { completion(#imageLiteral(resourceName: "defaultprofile")); return }
        storageManager.downloadPhoto(from: profileURL) { result in
            switch result {
            case .failure(_):
                completion(#imageLiteral(resourceName: "defaultprofile"))
            case .success(let data):
                completion(UIImage(data: data)!)
            }
        }
    }
}
