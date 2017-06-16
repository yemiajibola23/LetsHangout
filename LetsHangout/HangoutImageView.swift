//
//  HangoutImageView.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/16/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit

protocol HangoutImageViewDelegate: class {
    func imageViewWasTapped(_ imageView: HangoutImageView)
}


class HangoutImageView: UIImageView {
    weak var delegate: HangoutImageViewDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 25
        clipsToBounds = true
        isUserInteractionEnabled = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
    }
    
    func handleImageTap() {
        delegate?.imageViewWasTapped(self)
    }

}
