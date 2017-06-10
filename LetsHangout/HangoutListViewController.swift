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
            // TODO: Update profile pic
        }
    }
    
    static var nibName: String { return "HangoutListViewController" }
    var firebaseDatabaseManager = FirebaseDatabaseManager.sharedInstance
    
    @IBOutlet weak var hangoutCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //hangoutCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HangoutCollectionViewCell")
        hangoutCollectionView.register(UINib(nibName: HangoutCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: HangoutCollectionViewCell.reuseIdentifier)
        
        activityIndicator.startAnimating()
        
        DispatchQueue.global().async {
            self.firebaseDatabaseManager.loadHangouts { [unowned self]  hangouts in
                DispatchQueue.main.async {
                    let viewModel = HangoutCollectionViewViewModel(hangouts: hangouts)
                    self.dataProvider = HangoutListDataProvider(viewModel: viewModel)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
