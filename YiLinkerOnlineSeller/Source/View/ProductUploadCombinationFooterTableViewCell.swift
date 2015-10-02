//
//  ProductUploadCombinationFooterTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadCombinationFooterTableViewCellDelegate {
    func productUploadCombinationFooterTableViewCell(didClickDoneButton cell: ProductUploadCombinationFooterTableViewCell, sku: String, quantity: String, discountedPrice: String, retailPrice: String, uploadImages: [UIImage])
    func productUploadCombinationFooterTableViewCell(didClickUploadImage cell: ProductUploadCombinationFooterTableViewCell)
    func productUploadCombinationFooterTableViewCell(didDeleteUploadImage cell: ProductUploadCombinationFooterTableViewCell, indexPath: NSIndexPath)
    
    func productUploadCombinationFooterTableViewCell(textFieldDidChange textField: UITextField, text: String, cell: ProductUploadCombinationFooterTableViewCell)
}

class ProductUploadCombinationFooterTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, ProductUploadImageCollectionViewCellDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: ProductUploadCombinationFooterTableViewCellDelegate?
    var images: [UIImage] = []
    var viewController: UIViewController?

    @IBOutlet weak var retailPriceTextField: UITextField!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var skuTextField: UITextField!

    @IBOutlet weak var retailPriceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCell()
        
        self.retailPriceTextField.delegate = self
        self.retailPriceTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.discountedPriceTextField.delegate = self
        self.discountedPriceTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.quantityTextField.delegate = self
        self.quantityTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.skuTextField.delegate = self
        self.skuTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        self.skuLabel.required()
        self.retailPriceLabel.required()
        self.quantityLabel.required()
        
        self.retailPriceLabel.text = ProductUploadStrings.retailPrice
        self.discountedPriceLabel.text = ProductUploadStrings.discountedPrice
        self.quantityLabel.text = ProductUploadStrings.quantity
        self.skuLabel.text = ProductUploadStrings.sku
    }
    
    func textFieldDidChange(sender: UITextField) {
        self.delegate!.productUploadCombinationFooterTableViewCell(textFieldDidChange: sender, text: sender.text, cell: self)
    }
    
    // MARK: - Images
    func uploadedImages() -> [UIImage] {
        self.images.removeLast()
        return self.images
    }
    
    @IBAction func save(sender: AnyObject) {
        //if self.images.last == UIImage(named: "addPhoto") {
            self.images.removeLast()
        //}
        
        if self.retailPriceTextField.text == "" {
            UIAlertController.displayErrorMessageWithTarget(viewController!, errorMessage: ProductUploadStrings.retailPriceRequired, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.quantityTextField.text == "" {
            UIAlertController.displayErrorMessageWithTarget(viewController!, errorMessage: ProductUploadStrings.quantityRequired, title: ProductUploadStrings.incompleteProductDetails)
        } else if (self.retailPriceTextField.text as NSString).doubleValue < (self.discountedPriceTextField.text as NSString).doubleValue {
            UIAlertController.displayErrorMessageWithTarget(viewController!, errorMessage: ProductUploadStrings.retailMustBeGreater, title: ProductUploadStrings.incompleteProductDetails)
        } else if(quantityTextField.text as NSString).doubleValue == 0 {
            UIAlertController.displayErrorMessageWithTarget(viewController!, errorMessage: ProductUploadStrings.quantityRequired, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.skuTextField.text == "" {
            UIAlertController.displayErrorMessageWithTarget(viewController!, errorMessage: ProductUploadStrings.skuRequried, title: ProductUploadStrings.incompleteProductDetails)
        } else {
            if self.viewController != nil {
                viewController!.view.endEditing(true)
            }
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.delegate!.productUploadCombinationFooterTableViewCell(didClickDoneButton: self, sku: self.skuTextField.text, quantity: self.quantityTextField.text, discountedPrice: self.discountedPriceTextField.text, retailPrice: self.retailPriceTextField.text, uploadImages: self.images)
            }
        }
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
        cell.delegate = self
        cell.imageView.image = self.images[indexPath.row]
        
        if indexPath.row == self.images.count - 1 {
            cell.closeButton.hidden = true
            cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        } else {
            cell.closeButton.hidden = false
            cell.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        }
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.images.count - 1 {
            self.delegate?.productUploadCombinationFooterTableViewCell(didClickUploadImage: self)
        }
    }
    
    func productUploadImageCollectionViewCell(didTapDeleteButtonAtCell cell: ProductUploadImageCollectionViewCell) {
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
        self.images.removeAtIndex(indexPath.item)
        self.collectionView.deleteItemsAtIndexPaths([indexPath])
        self.delegate!.productUploadCombinationFooterTableViewCell(didDeleteUploadImage: self, indexPath: indexPath)
        //self.delegate!.productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath: indexPath, collectionView: self.collectionView)
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
