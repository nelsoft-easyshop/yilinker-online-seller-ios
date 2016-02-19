//
//  SelectProductCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/17/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class SelectProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var discountPercentageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: DiscountLabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var earningTitleLabel: UILabel!
    @IBOutlet weak var earningLabel: UILabel!
    
    class func nibNameAndIdentifier() -> String {
        return "SelectProductCollectionViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.originalPriceLabel.drawDiscountLine(false)
        
        self.discountPercentageLabel.layer.cornerRadius = 5
    }
    
}
