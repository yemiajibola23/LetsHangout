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
        let addHangoutVieModel = AddHangoutViewModel()
        let firebaseManager = FirebaseManager.sharedInstance
        let hangout = addHangoutVieModel.createHangout(name: nameTextField.text, date: dateTextField.text, host: hostTextField.text, description: descriptionTextView.text, latitude: nil, longitude: nil)
        firebaseManager.save(hangout: hangout) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }

}
