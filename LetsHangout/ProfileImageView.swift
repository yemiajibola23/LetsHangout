//
//  ProfileImageView.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/16/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit

class ProfileImageView: HangoutImageView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 0.5 * self.frame.height
    }

}
