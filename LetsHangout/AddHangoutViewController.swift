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
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSaveButtonTapped(_ sender: UIButton) {
    }

}
