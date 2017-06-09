//
//  HangoutUser.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/9/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation

struct HangoutUser {
    var name: String
    var email: String
    var profilePictureURL: String?
    
    init(dict: [String: Any]) {
        name = dict["name"] as! String
        email = dict["email"] as! String
        profilePictureURL = dict["profilePictureURL"] as? String
    }
}
