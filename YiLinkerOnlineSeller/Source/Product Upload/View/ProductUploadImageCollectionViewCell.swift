//
//  ProductUploadImageCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Delegate
// ProductUploadImageCollectionViewCell delegate methods
protocol ProductUploadImageCollectionViewCellDelegate {
    func productUploadImageCollectionViewCell(didTapDeleteButtonAtCell cell: ProductUploadImageCollectionViewCell)
}

class ProductUploadImageCollectionViewCell: UICollectionViewCell {
    
    // Custom buttons
    @IBOutlet weak var closeButton: DynamicRoundedButton!
    
    // Imageviews
    @IBOutlet weak var imageView: UIImageView!
    
    // Initialize ProductUploadImageCollectionViewCellDelegate
    var delegate: ProductUploadImageCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = 5
        self.imageView.clipsToBounds = true
    }
    
    // MARK: Button actions
    @IBAction func close(sender: AnyObject) {
        self.delegate!.productUploadImageCollectionViewCell(didTapDeleteButtonAtCell: self)
    }
}
