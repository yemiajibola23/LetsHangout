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
    var loginViewModel: LoginViewModel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginRegisterSegmentControl: UISegmentedControl!
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var profileImageView: ProfileImageView!
    
    static let nibName = "LoginViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.delegate = self
    }
    
    @IBAction func loginRegisterButtonWasTapped(_ sender: UIButton) {
        loginRegisterSegmentControl.selectedSegmentIndex == 0 ? login() : register()
    }
    
    func register() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let name = nameTextField.text, !name.isEmpty else {
            presentAlert(title: "An error occurred", message: "All fields must be filled in")
            return
        }
        
        loginViewModel.registerNewUser(email: email, password: password, name: name) { [unowned self] result in
            self.handle(result: result)
        }
    }
    
    func login() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            presentAlert(title: "An error occurred", message: "All fields must be filled in")
            return
        }
        loginViewModel.loginUser(email: email, password: password) { [unowned self] result in
            self.handle(result: result)
        }
    }
    
    private func handle(result: AuthenticationResult) {
        switch result {
        case .success(let newUser): self.hangoutListViewController(fetchedUser: newUser)
        case .failure(let authError): self.presentAlert(title: "An error occurred", message: authError.message)
        }
    }
    
    @IBAction func loginRegisterSegmentControlDidChange(_ sender: UISegmentedControl) {
        //  TODO: Hide name textfield if login
        profileImageView.isUserInteractionEnabled = sender.selectedSegmentIndex == 0 ? false : true
        let title = sender.selectedSegmentIndex == 0 ? "Login" : "Register"
        loginRegisterButton.setTitle(title, for: .normal)
    }
    
    private func hangoutListViewController(fetchedUser: HangoutUser) {
        loginViewModel.state = .authenticated(fetchedUser.uid)
        
        let controller = HangoutListViewController(nibName: HangoutListViewController.nibName, bundle: nil)
        controller.currentUserViewModel = HangoutUserViewModel(user: fetchedUser)
        controller.loginViewModel = loginViewModel
        
        self.present(controller, animated: true, completion: nil)
    }
}


extension LoginViewController: HangoutImageViewDelegate {}

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
