//
//  HangoutUser.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/9/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation

class HangoutUser {
    var name: String
    var email: String
    var profilePictureURL: String?
    var uid: String
    
    init(dict: [String: Any]) {
        name = dict["name"] as! String
        email = dict["email"] as! String
        profilePictureURL = dict["profilePictureURL"] as? String
        uid = dict["uid"] as! String
    }
    
    init(name: String, email: String, profilePictureURL: String?, uid: String) {
        self.name = name
        self.email = email
        self.profilePictureURL = profilePictureURL
        self.uid = uid
    }
}
