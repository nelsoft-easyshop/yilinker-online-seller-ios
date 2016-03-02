//
//  TransactionCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var pageImageView: UIImageView!
    @IBOutlet weak var pageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTextColor(color: UIColor) {
        self.pageLabel.textColor = color
    }
    
    func setImage(name: String) {
        self.pageImageView.image = UIImage(named: name)
    }
    
}
