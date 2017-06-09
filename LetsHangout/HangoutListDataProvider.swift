//
//  HangoutListDataProvider.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/8/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit

class HangoutListDataProvider: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var viewModel: HangoutCollectionViewViewModel!
    
    init(viewModel: HangoutCollectionViewViewModel) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfHangouts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HangoutCollectionViewCell.reuseIdentifier, for: indexPath) as! HangoutCollectionViewCell
        cell.setupWith(viewModel: viewModel.viewModelFor(index: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 50, bottom: 50, right: 20)
    }
}
