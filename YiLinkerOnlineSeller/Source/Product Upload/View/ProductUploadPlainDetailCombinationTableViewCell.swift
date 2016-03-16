//
//  ProductUploadPlainDetailCombinationTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductUploadPlainDetailCombinationTableViewCell: UITableViewCell, UITextFieldDelegate {

    // Collection view
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Labels
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var retailPriceLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var retailPriceTextField: UITextField!
    @IBOutlet weak var skuTextField: UITextField!
    
    // Global variables
    var images: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set textfields delegates
        self.skuTextField.delegate = self
        self.retailPriceTextField.delegate = self
        self.discountedPriceTextField.delegate = self
        self.quantityTextField.delegate = self
        
        // Set labels texts
        self.retailPriceLabel.text = ProductUploadStrings.retailPrice
        self.discountLabel.text = ProductUploadStrings.discountedPrice
        self.quantityLabel.text = ProductUploadStrings.quantity
        self.skuLabel.text = ProductUploadStrings.sku
        self.skuTextField.placeholder = ProductUploadStrings.sku
        
        self.registerCell()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    // MARK: Private methods
    // Register collection view cells
    func registerCell() {
        let nib: UINib = UINib(nibName: ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier)
    }
    
    // MARK: Collection view data source methods
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

    // MARK: Textfield delegate method
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
