//
//  LoginViewController.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/9/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let firebaseManager = FirebaseManager.sharedInstance
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginRegisterSegmentControl: UISegmentedControl!
    @IBOutlet weak var loginRegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginRegisterButtonWasTapped(_ sender: UIButton) {
        loginRegisterSegmentControl.selectedSegmentIndex == 1 ? loginUser() : registerNewUser()
    }
    
    @IBAction func loginRegisterSegmentControlDidChange(_ sender: UISegmentedControl) {
        //  TODO: Hide name textfield if login
    }
    
    func loginUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            // TODO: Error Alert
            return
        }
        
        //firebaseManager.loginWithCredentials(email, password, completion: <#(User?, Error?) -> Void#>)
    }

    func registerNewUser() {
        
    }
}
