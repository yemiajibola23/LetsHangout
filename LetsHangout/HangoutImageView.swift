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
        let profilePictureAlert = UIAlertController(title: "Choose a source type", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            profilePictureAlert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                (self as! UIViewController).choosePhotoWith(sourceType: .camera)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            profilePictureAlert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
                (self as! UIViewController).choosePhotoWith(sourceType: .photoLibrary)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            profilePictureAlert.addAction(UIAlertAction(title: "Saved Photos", style: .default) { _ in
                (self as! UIViewController).choosePhotoWith(sourceType: .savedPhotosAlbum)
            })
        }
        
        profilePictureAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        (self as! UIViewController).present(profilePictureAlert, animated: true, completion: nil)
    }
}
