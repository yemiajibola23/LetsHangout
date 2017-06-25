//
//  HangoutListViewController.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/8/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit

class HangoutListViewController: UIViewController {
    
    var dataProvider: HangoutListDataProvider! {
        didSet {
            hangoutCollectionView.delegate = dataProvider
            hangoutCollectionView.dataSource = dataProvider
        }
    }
    
    var currentUserViewModel: HangoutUserViewModel!
    static var nibName: String { return "HangoutListViewController" }
    let firebaseDatabaseManager = FirebaseDatabaseManager.sharedInstance
    var loginViewModel: LoginViewModel!
    
    @IBOutlet weak var hangoutCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profileImageView: ProfileImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.delegate = self
        currentUserViewModel.image = profileImageView.image
        
        hangoutCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HangoutCollectionViewCell")
        hangoutCollectionView.register(UINib(nibName: HangoutCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: HangoutCollectionViewCell.reuseIdentifier)
        
        activityIndicator.startAnimating()
        
        self.firebaseDatabaseManager.loadHangouts { [unowned self]  hangouts in
            let viewModel = HangoutCollectionViewViewModel(hangouts: hangouts)
            self.dataProvider = HangoutListDataProvider(viewModel: viewModel)
            self.dataProvider.delegate = self
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func loginViewController() {
        let controller = LoginViewController(nibName: LoginViewController.nibName, bundle: nil)
        controller.loginViewModel = loginViewModel
        
        present(controller, animated: true, completion: nil)
    }
    
    fileprivate func detailViewController(viewModel: HangoutViewModel) {
        let controller = HangoutDetailViewController(nibName: HangoutDetailViewController.nibName, bundle: nil)
        controller.viewModel = viewModel
        controller.userViewModel = currentUserViewModel
        controller.loginViewModel = loginViewModel
        
        present(controller, animated: true, completion: nil)
    }
    
    private func addHangoutViewController(viewModel: HangoutUserViewModel) {
        let controller = AddHangoutViewController(nibName: AddHangoutViewController.nibName, bundle: nil)
        controller.currentUserViewModel = viewModel
        
        present(controller, animated: true, completion: nil)
    }
    
    fileprivate func hangoutSettingsAlert() {
        let settingsAlert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        settingsAlert.addAction(UIAlertAction(title: "Logout", style: .default) { [unowned self] _ in
            self.logoutUser()
        })
        
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
    
}

extension HangoutListViewController: HangoutImageViewDelegate {
    func imageViewWasTapped(_ imageView: HangoutImageView) {
        hangoutSettingsAlert()
    }
}

extension HangoutListViewController: HangoutListDataProviderDelegate {
    func cellWasSelected(with viewModel: HangoutViewModel) {
        detailViewController(viewModel: viewModel)
    }
}
