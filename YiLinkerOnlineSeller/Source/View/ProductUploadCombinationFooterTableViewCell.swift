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

    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCell()
        
        self.retailPriceTextField.delegate = self
        self.discountedPriceTextField.delegate = self
        self.quantityTextField.delegate = self
        self.skuTextField.delegate = self
    }
    
    @IBAction func save(sender: AnyObject) {
        if self.images.last == UIImage(named: "addPhoto") {
            self.images.removeLast()
        }
        
        if self.retailPriceTextField.text == "" {
            UIAlertController.displayErrorMessageWithTarget(viewController!, errorMessage: "Please insert Retail Price.", title: "Incomplete Product Details")
        } else if self.quantityTextField.text == "" {
            UIAlertController.displayErrorMessageWithTarget(viewController!, errorMessage: "Please insert quantity.", title: "Incomplete Product Details")
        } else if (self.retailPriceTextField.text as NSString).doubleValue < (self.discountedPriceTextField.text as NSString).doubleValue {
            UIAlertController.displayErrorMessageWithTarget(viewController!, errorMessage: "Retail price must be greater than discount price.", title: "Incomplete Product Details")
        } else if(quantityTextField.text as NSString).doubleValue == 0 {
            UIAlertController.displayErrorMessageWithTarget(viewController!, errorMessage: "Please insert quanity.", title: "Incomplete Product Details")
        } else {
            if self.viewController != nil {
                viewController!.view.endEditing(true)
            }
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
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
}
