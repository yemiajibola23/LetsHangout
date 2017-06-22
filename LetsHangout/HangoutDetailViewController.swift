//
//  HangoutDetailViewController.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/17/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HangoutDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var viewModel: HangoutViewModel!
    var userViewModel: HangoutUserViewModel!
    var loginViewModel: LoginViewModel!
    var isEditModeActive = false
    
    static var nibName: String { return "HangoutDetailViewController" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupMap()
        textChangeListenters()
    }
    
    private func setupUI() {
        profileImageView.image = viewModel.image
        profileImageView.delegate = self
        
        nameTextField.text = viewModel.name
        dateTextField.text = viewModel.date
        hostTextField.text = viewModel.host
    }
    
    private func setupMap() {
        guard let locationCoordinate = viewModel.locationCoordinate else { return }
        
        mapView.centerCoordinate = locationCoordinate
        mapView.region = MKCoordinateRegion(center: locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }
    
    private func textChangeListenters() {
        nameTextField.addTarget(self, action: #selector(HangoutDetailViewController.textFieldChanged(_:)), for: .editingChanged)
        dateTextField.addTarget(self, action: #selector(HangoutDetailViewController.textFieldChanged(_:)), for: .editingChanged)
        locationTextField.addTarget(self, action: #selector(HangoutDetailViewController.textFieldChanged(_:)), for: .editingChanged)
        hostTextField.addTarget(self, action: #selector(HangoutDetailViewController.textFieldChanged(_:)), for: .editingChanged)
    }
    
    fileprivate func hangoutSettingsAlert() {
        let settingsAlert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
       
        settingsAlert.addAction(UIAlertAction(title: "Logout", style: .default) { [unowned self] _ in
            self.logoutUser()
        })
        
        settingsAlert.addAction(UIAlertAction(title: isEditModeActive ? "Save Hangout" : "Edit Hangout", style: .default) { [unowned self] _ in
            self.toggleEdit(on: !self.isEditModeActive)
        })
        
        settingsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(settingsAlert, animated: true, completion: nil)
    }
    
    private func logoutUser() {
        loginViewModel.logout {[unowned self] error in
            if let authError = error {
                self.presentAlert(title: "An error occurred", message: authError.message)
            } else {
                self.loginViewModel.state = .notAuthenticated
                self.loginViewController()
            }
            
        }
    }
    
    private func loginViewController() {
        let controller = LoginViewController(nibName: LoginViewController.nibName, bundle: nil)
        controller.loginViewModel = loginViewModel
        
        present(controller, animated: true, completion: nil)
    }
    
    private func toggleEdit(on: Bool) {
        isEditModeActive = on
        
        saveButton.isHidden = !on
        
        nameTextField.isUserInteractionEnabled = on
        dateTextField.isUserInteractionEnabled = on
        hostTextField.isUserInteractionEnabled = on
        locationTextField.isUserInteractionEnabled = on
        
        // Text View
        descriptionTextView.isSelectable = !on
        descriptionTextView.dataDetectorTypes = on ? [] : [.link, .address, .calendarEvent, .phoneNumber]
        descriptionTextView.isEditable = on
    }
    
    @objc private func textFieldChanged(_ textField: UITextField) {
        saveButton.setTitle("Save", for: .normal)
    }
    
    private func saveHangoutChanges() {
        
    }
    
    @IBAction func onSaveButtonTapped(_ sender: UIButton) {
        guard  sender.currentTitle == "Save" else { toggleEdit(on: false); return }
        saveHangoutChanges()
        
    }
}

extension HangoutDetailViewController: HangoutImageViewDelegate {
    func imageViewWasTapped(_ imageView: HangoutImageView) {
        hangoutSettingsAlert()
    }
}

extension HangoutDetailViewController: UITextFieldDelegate, UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let title = textView.text == descriptionTextView.text ? "Cancel": "Save"
        saveButton.setTitle(title, for: .normal)
    }
}
