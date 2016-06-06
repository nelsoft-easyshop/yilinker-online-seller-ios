//
//  ProductImagesCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setItemImage(image: String) {
        self.itemImageView.sd_setImageWithURL(NSURL(string: image), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func setLocalImage(image: UIImage) {
        self.itemImageView.image = image
    }
    
    func setDefaultImage() {
        self.itemImageView.image = UIImage(named: "dummy-placeholder")
    }

}
