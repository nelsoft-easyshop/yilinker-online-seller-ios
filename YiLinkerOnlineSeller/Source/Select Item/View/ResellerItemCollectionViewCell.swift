//
//  ResellerItemCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 10/12/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ResellerItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Set Cell With Reseller Item Model
    func setCellWithResellerItemModel(resellerItemModel: ResellerItemModel) {
        self.productImageView.sd_setImageWithURL(NSURL(string: resellerItemModel.imageUrl), placeholderImage: UIImage(named: "dummy-placeholder"))
        self.productNameLabel.text = resellerItemModel.productName
    }
}
