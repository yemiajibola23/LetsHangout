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
        
        firebaseManager.loginWithCredentials(email, password) { [unowned self] user, error in
            if let _ = error { /*TODO: Handle error */ return }
            self.hangoutListViewController()
        }
    }
    
    func registerNewUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            //TODO: Error Alert
            return
        }
        
        firebaseManager.registerWithCredentials(email, password, name) {[unowned self] (newUser, error) in
            if let error = error { /* TODO: Handle error */ return }
            self.hangoutListViewController()
        }
    }
    
    func hangoutListViewController() {
        firebaseManager.fetchCurrentUserInfo { (error, fetchedUser) in
            if let _ = error { /*TODO: Handle error */ return }
            
            guard let fetchedUser = fetchedUser else { /*TODO: Handle error */ return }
            
            let controller = HangoutListViewController(nibName: HangoutListViewController.nibName, bundle: nil)
            controller.currentUserViewModel = HangoutUserViewModel(user: fetchedUser)
            
            self.present(controller, animated: true, completion: nil)
        }
    }
}
