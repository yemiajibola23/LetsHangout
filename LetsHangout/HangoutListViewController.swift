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
    static var nibName: String { return "HangoutListViewController" }
    var firebaseManager = FirebaseManager.sharedInstance
    
    @IBOutlet weak var hangoutCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        hangoutCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HangoutCollectionViewCell")
        
        activityIndicator.startAnimating()
        firebaseManager.loadHangouts { [unowned self] (hangouts, error) in
            if let error = error {
                // TODO: Handle error
                print(error.localizedDescription)
                return
            }
            
            let viewModel = HangoutCollectionViewViewModel(hangouts: hangouts)
            self.dataProvider = HangoutListDataProvider(viewModel: viewModel)
            self.activityIndicator.stopAnimating()
        }
    }

}
