//
//  HangoutCollectionViewCell.swift
//  LetsHangout
//
//  Created by Yemi Ajibola on 6/8/17.
//  Copyright © 2017 Yemi Ajibola. All rights reserved.
//

import UIKit

class HangoutCollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier: String { return "HangoutCell" }
    static var nibName: String { return "HangoutCollectionViewCell" }
    
    
    @IBOutlet weak var hangoutImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWith(viewModel: HangoutViewModel) {
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
    }

}
  
