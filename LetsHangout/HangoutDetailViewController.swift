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
    
    var viewModel: HangoutViewModel!
    var userViewModel: HangoutUserViewModel!
    var loginViewModel: LoginViewModel!
    
    static var nibName: String { return "HangoutDetailViewController" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        profileImageView.image = userViewModel.image
        profileImageView.delegate = self
        
        nameTextField.text = viewModel.name
        dateTextField.text = viewModel.date
        hostTextField.text = viewModel.host
        
        guard let locationCoordinate = viewModel.locationCoordinate else { return }
        
        mapView.centerCoordinate = locationCoordinate
        mapView.region = MKCoordinateRegion(center: locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
    }
    
    fileprivate func hangoutSettingsAlert() {
        let settingsAlert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
       
        settingsAlert.addAction(UIAlertAction(title: "Logout", style: .default) { [unowned self] _ in
            self.logoutUser()
        })
        
        //settingsAlert.addAction()
        
        present(settingsAlert, animated: true, completion: nil)
    }
    
    private func logoutUser() {
        loginViewModel.logout {[unowned self] error in
            if let authError = error {
                self.presentAlert(title: "An error ocurred", message: authError.message)
                return
            }
            
            self.loginViewModel.state = .notAuthenticated
            self.loginViewController()
        }
    }
    
    private func loginViewController() {
        let controller = LoginViewController(nibName: LoginViewController.nibName, bundle: nil)
        controller.loginViewModel = loginViewModel
        
        present(controller, animated: true, completion: nil)
    }
    
    private func activateEditMode(on: Bool) {
        
    }
}

extension HangoutDetailViewController: HangoutImageViewDelegate {
    func imageViewWasTapped(_ imageView: HangoutImageView) {
        hangoutSettingsAlert()
    }
}
