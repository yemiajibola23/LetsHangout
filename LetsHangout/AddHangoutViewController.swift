//
//  AddHangoutViewController.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddHangoutViewController: UIViewController {
    
    @IBOutlet weak var hangoutImageView: HangoutImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    static var nibName: String { return "AddHangoutViewController" }
    
    var currentUserViewModel: HangoutUserViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hangoutImageView.delegate = self
    }
    
    @IBAction func onSaveButtonTapped(_ sender: UIButton) {
        let databaseManager = FirebaseDatabaseManager.sharedInstance
        
        let addViewModel = AddHangoutViewModel(name: nameTextField.text, date: dateTextField.text, host: hostTextField.text, description: descriptionTextView.text, location: nil, uid: currentUserViewModel.uid)
        
        guard let hangout = addViewModel.hangout else { return }
        
        databaseManager.save(hangout: hangout) { result in
            switch result {
            case .success(let reference):
                self.saveHangoutImage(with: reference)
            case .failure(let saveError):
                self.presentAlert(title: "An error occurred", message: saveError.message)
            }
        }
    }
    
    
    private func saveHangoutImage(with ref: DatabaseReference) {
        let storageManager = FirebaseStorageManager.sharedInstance
        
        if self.hangoutImageView.image != #imageLiteral(resourceName: "noimage") {
            storageManager.save(photo: self.hangoutImageView.image!, with: ref.key, for: .hangouts, completion: { storageResult in
                switch storageResult {
                case .success(let path):
                    ref.updateChildValues(["imageURL": path])
                    self.presentAlert(title: "Hangout Saved", message: nil)
                    self.dismiss(animated: true, completion: nil)
                case .failure(let storError):
                    self.presentAlert(title: "An error ocurred", message: storError.message)
                }
            })
        }
    }
    
}

extension AddHangoutViewController: HangoutImageViewDelegate {}

extension AddHangoutViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            hangoutImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            hangoutImageView.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
