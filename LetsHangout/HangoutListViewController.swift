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
    
    var currentUserViewModel: HangoutUserViewModel! {
        didSet {
            profileImageView.image = currentUserViewModel.image
        }
    }
    
    static var nibName: String { return "HangoutListViewController" }
    let firebaseDatabaseManager = FirebaseDatabaseManager.sharedInstance
    var loginViewModel: LoginViewModel!
    
    @IBOutlet weak var hangoutCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profileImageView: ProfileImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.delegate = self
        
        //hangoutCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HangoutCollectionViewCell")
        //        hangoutCollectionView.register(UINib(nibName: HangoutCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: HangoutCollectionViewCell.reuseIdentifier)
        //
        //        activityIndicator.startAnimating()
        //
        //        DispatchQueue.global().async {
        //            self.firebaseDatabaseManager.loadHangouts { [unowned self]  hangouts in
        //                DispatchQueue.main.async {
        //                    let viewModel = HangoutCollectionViewViewModel(hangouts: hangouts)
        //                    self.dataProvider = HangoutListDataProvider(viewModel: viewModel)
        //                    self.activityIndicator.stopAnimating()
        //                }
        //            }
        //        }
    }
    
    fileprivate func logoutUser() {
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
        present(controller, animated: true, completion: nil)
    }
    
    fileprivate func hangoutSettingsAlert() {
        let settingsAlert = UIAlertController(title: <#T##String?#>, message: <#T##String?#>, preferredStyle: .actionSheet)
        settingsAlert.addAction(UIAlertAction(title: "Logout", style: .default) { [unowned self] _ in
            self.logoutUser()
        })
        
        present(settingsAlert, animated: true, completion: nil)
    }
}

extension HangoutListViewController: HangoutImageViewDelegate {
    func imageViewWasTapped(_ imageView: HangoutImageView) {
        hangoutSettingsAlert()
    }
    
    
}
