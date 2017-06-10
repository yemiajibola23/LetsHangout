//
//  LoginViewController.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/9/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    let firebaseAuthenticationManager = FirebaseAuthenticationManager.sharedInstance
    
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
        
        firebaseAuthenticationManager.loginWithCredentials(email, password) { [unowned self] result in
            switch result {
            case .success(let loggedInUser):
                self.hangoutListViewController(fetchedUser: loggedInUser)
            case .failure(let authError):
                //TODO: Handle error
                break
            }
            
        }
    }
    
    func registerNewUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            //TODO: Error Alert
            return
        }
        
        firebaseAuthenticationManager.registerWithCredentials(email, password, name) {[unowned self] result in
            switch result {
            case .success(let newUser):
                self.hangoutListViewController(fetchedUser: newUser)
                break
            case .failure(let authError): break
                //TODO: Error Alert
            }
            
            
        }
    }
    
    func hangoutListViewController(fetchedUser: HangoutUser) {
        let controller = HangoutListViewController(nibName: HangoutListViewController.nibName, bundle: nil)
        controller.currentUserViewModel = HangoutUserViewModel(user: fetchedUser)
        
        self.present(controller, animated: true, completion: nil)
    }
}
