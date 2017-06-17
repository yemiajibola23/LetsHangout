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

extension HangoutImageViewDelegate {
    func imageViewWasTapped(_ imageView: HangoutImageView) {
        let hangoutImageAlert = UIAlertController(title: "Choose a source type", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            hangoutImageAlert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                (self as! UIViewController).choosePhotoWith(sourceType: .camera)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            hangoutImageAlert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
                (self as! UIViewController).choosePhotoWith(sourceType: .photoLibrary)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            hangoutImageAlert.addAction(UIAlertAction(title: "Saved Photos", style: .default) { _ in
                (self as! UIViewController).choosePhotoWith(sourceType: .savedPhotosAlbum)
            })
        }
        
        hangoutImageAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        (self as! UIViewController).present(hangoutImageAlert, animated: true, completion: nil)
    }
}
