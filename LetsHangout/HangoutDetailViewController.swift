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
    static var nibName: String { return "HangoutDetailViewController" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }


    private func setupUI() {
        profileImageView.image = userViewModel.image
        
        nameTextField.text = viewModel.name
        dateTextField.text = viewModel.date
        hostTextField.text = viewModel.host
        
        guard let locationCoordinate = viewModel.locationCoordinate else { return }
        
        mapView.centerCoordinate = locationCoordinate
        mapView.region = MKCoordinateRegion(center: locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
    }
}
