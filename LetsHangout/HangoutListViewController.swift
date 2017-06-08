//
//  HangoutListViewController.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/8/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit

class HangoutListViewController: UIViewController {
    @IBOutlet weak var hangoutCollectionView: UICollectionView!
    var dataProvider: HangoutListDataProvider!
    static var nibName: String { return "HangoutListViewController" }
    var firebaseManager = FirebaseManager.sharedInstance
    
    override func loadView() {
        super.loadView()
        
        firebaseManager.loadHangouts { (hangouts, error) in
            if let error = error {
                // TODO: Handle error
                return
            }
            
            let viewModel = HangoutCollectionViewViewModel(hangouts: hangouts)
            self.dataProvider = HangoutListDataProvider(viewModel: viewModel)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hangoutCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HangoutCollectionViewCell")
        
        hangoutCollectionView.delegate = dataProvider
        hangoutCollectionView.dataSource = dataProvider
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
