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
    func productUploadImageCollectionViewCell(didTapStarButtonAtCell cell: ProductUploadImageCollectionViewCell)
}

class ProductUploadImageCollectionViewCell: UICollectionViewCell {
    
    // Custom buttons
    @IBOutlet weak var closeButton: DynamicRoundedButton!
    
    // Buttons
    @IBOutlet weak var starButton: UIButton!
    
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
    
    // MARK: Button actions
    @IBAction func star(sender: AnyObject) {
        println("star clicked")
        self.starButton.setBackgroundImage(UIImage(named: "active2"), forState: UIControlState.Normal)
        self.delegate?.productUploadImageCollectionViewCell(didTapStarButtonAtCell: self)
    }
}
