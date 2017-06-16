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
    @IBOutlet weak var profileImageView: ProfileImageView!
    
    static let nibName = "LoginViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        profileImageView.delegate = self
    }
    
    @IBAction func loginRegisterButtonWasTapped(_ sender: UIButton) {
        loginRegisterSegmentControl.selectedSegmentIndex == 1 ? loginUser() : registerNewUser()
    }
    
    @IBAction func loginRegisterSegmentControlDidChange(_ sender: UISegmentedControl) {
        //  TODO: Hide name textfield if login
        profileImageView.isUserInteractionEnabled = sender.selectedSegmentIndex == 0 ? false : true
        let title = sender.selectedSegmentIndex == 0 ? "Login" : "Register"
        loginRegisterButton.setTitle(title, for: .normal)
    }
    
    private func loginUser() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            presentAlert(title: "An error occurred", message: "All fields must be filled in")
            return
        }
        
        firebaseAuthenticationManager.loginWithCredentials(email, password) { [unowned self] result in
            switch result {
            case .success(let loggedInUser):
                self.hangoutListViewController(fetchedUser: loggedInUser)
            case .failure(let authError):
                self.presentAlert(title: "An error occurred", message: authError.message)
                break
            }
        }
    }
    
    private func registerNewUser() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let name = nameTextField.text, !name.isEmpty else {
            presentAlert(title: "An error occurred", message: "All fields must be filled in")
            return
        }
        
        firebaseAuthenticationManager.registerWithCredentials(email, password, name) {[unowned self] result in
            switch result {
            case .success(let newUser):
                self.hangoutListViewController(fetchedUser: newUser)
            case .failure(let authError):
              self.presentAlert(title: "An error occurred", message: authError.message)
            }
        }
    }
    
    private func hangoutListViewController(fetchedUser: HangoutUser) {
        let controller = HangoutListViewController(nibName: HangoutListViewController.nibName, bundle: nil)
        controller.currentUserViewModel = HangoutUserViewModel(user: fetchedUser)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    
    fileprivate func choosePhotoWith(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController(rootViewController: self)
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
}


extension LoginViewController: HangoutImageViewDelegate {
    func imageViewWasTapped(_ imageView: HangoutImageView) {
       let profilePictureAlert = UIAlertController(title: "Choose a source type", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            profilePictureAlert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                self.choosePhotoWith(sourceType: .camera)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            profilePictureAlert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
                self.choosePhotoWith(sourceType: .photoLibrary)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            profilePictureAlert.addAction(UIAlertAction(title: "Saved Photos", style: .default) { _ in
                self.choosePhotoWith(sourceType: .savedPhotosAlbum)
            })
        }
        
        profilePictureAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(profilePictureAlert, animated: true, completion: nil)
    }
}
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
