//
//  ProductManagementCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductManagementCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTextColor(color: UIColor) {
        self.titleLabel.textColor = color
    }
    
    func setImage(name: String) {
        self.titleImageView.image = UIImage(named: name)
    }
}
