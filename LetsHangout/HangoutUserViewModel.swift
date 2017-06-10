//
//  HangoutUserViewModel.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/9/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import Foundation


struct HangoutUserViewModel {
    private let user: HangoutUser
    
    var name: String { return user.name }
    
    
    init(user: HangoutUser) {
        self.user = user
    }
}
