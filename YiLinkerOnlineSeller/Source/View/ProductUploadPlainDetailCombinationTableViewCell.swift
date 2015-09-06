//
//  ProductUploadPlainDetailCombinationTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductUploadPlainDetailCombinationTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skuTextField: UITextField!
    @IBOutlet weak var retailPriceTextField: UITextField!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    var images: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.skuTextField.delegate = self
        self.retailPriceTextField.delegate = self
        self.discountedPriceTextField.delegate = self
        self.quantityTextField.delegate = self
        self.registerCell()
    }
    
    
    func registerCell() {
        let nib: UINib = UINib(nibName: ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductUploadImageCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadImageCollectionViewCell
        
        cell.imageView.image = self.images[indexPath.row]
        cell.closeButton.hidden = true
        cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    // Dealloc
    deinit {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
}
