//
//  AddHangoutViewController.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/7/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit

class AddHangoutViewController: UIViewController {
    
    @IBOutlet weak var hangoutImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    static var nibName: String { return "AddHangoutViewController" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSaveButtonTapped(_ sender: UIButton) {
        let addViewModel = AddHangoutViewModel(name: nameTextField.text, date: dateTextField.text, host: hostTextField.text, description: descriptionTextView.text, location: nil)
        
        let databaseManager = FirebaseDatabaseManager.sharedInstance
        let storageManager = FirebaseStorageManager.sharedInstance
        
        guard let hangout = addViewModel.hangout else { return }
        
        databaseManager.save(hangout: hangout) { result in
            switch result {
            case .success(let reference):
                if self.hangoutImageView.image != nil && self.hangoutImageView.image != #imageLiteral(resourceName: "noimage") {
                    storageManager.save(photo: self.hangoutImageView.image!, with: reference.key, for: .hangouts, completion: { storageResult in
                        switch storageResult {
                        case .success(let path): reference.updateChildValues(["imageURL": path])
                        case .failure(let storError):
                            self.presentAlert(title: "An error ocurred", message: storError.message)
                        }
                    })
                }
                
            case .failure(let saveError):
                self.presentAlert(title: "An error occurred", message: saveError.message)
                break
            }
        }
        
        
    }
    
}
