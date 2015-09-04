//
//  ProductUploadImageCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadImageCollectionViewCellDelegate {
    func productUploadImageCollectionViewCell(didTapDeleteButtonAtCell cell: ProductUploadImageCollectionViewCell)
}

class ProductUploadImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: DynamicRoundedButton!
    
    var delegate: ProductUploadImageCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = 5
        self.imageView.clipsToBounds = true
    }
    
    @IBAction func close(sender: AnyObject) {
        self.delegate!.productUploadImageCollectionViewCell(didTapDeleteButtonAtCell: self)
    }
}
