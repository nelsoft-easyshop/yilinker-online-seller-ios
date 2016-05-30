//
//  ProductUploadAttributeTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Delegate
// ProductUploadAttributeTableViewCell Delegate method
protocol ProductUploadAttributeTableViewCellDelegate {
    func productUploadAttributeTableViewCell(didTapCell cell: ProductUploadAttributeTableViewCell, indexPath: NSIndexPath)
}

// MARK: Constant variable
struct PUAConstant {
    static let productUploadAttributeCollectionViewCellNibNameAndIdentier = "ProductUploadAttributeCollectionViewCell"
}

class ProductUploadAttributeTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    // Collection view
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Constraints
    @IBOutlet weak var colectionViewHeightConstraint: NSLayoutConstraint!
    
    // View Controller initialization
    var parentViewController: ProductUploadAttributeListVC?
    
    // Global variable
    var attributes: [String] = []
    var productModel: ProductModel?
    
    // Initialized ProductUploadAttributeTableViewCellDelegate
    var delegate: ProductUploadAttributeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCell()
        
        let flowLayout: UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        if IphoneType.isIphone4() || IphoneType.isIphone5() {
            flowLayout.itemSize = CGSizeMake(80, 40)
        } else if IphoneType.isIphone6Plus() {
            flowLayout.itemSize = CGSizeMake(108, 40)
        }
        
        self.collectionView.collectionViewLayout = flowLayout
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Private Methods
    func registerCell() {
        let nib: UINib = UINib(nibName: PUAConstant.productUploadAttributeCollectionViewCellNibNameAndIdentier, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: PUAConstant.productUploadAttributeCollectionViewCellNibNameAndIdentier)
    }
    
    // MARK: Collecton view delegate methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.attributes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductUploadAttributeCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(PUAConstant.productUploadAttributeCollectionViewCellNibNameAndIdentier, forIndexPath: indexPath) as! ProductUploadAttributeCollectionViewCell

        cell.attributeLabel.text = self.attributes[indexPath.row]
        cell.layer.cornerRadius = 5
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapRecognizer:")
        cell.userInteractionEnabled = true
        cell.addGestureRecognizer(gestureRecognizer)
        
        return cell
    }
    
    func collectionViewContentSize() -> CGSize {
        return self.collectionView.collectionViewLayout.collectionViewContentSize()
    }
    
    // MARK: Cell action
    func tapRecognizer(sender: UITapGestureRecognizer) {
        let cell: ProductUploadAttributeCollectionViewCell = sender.view as! ProductUploadAttributeCollectionViewCell
        
        var isValidToDelete: Bool = true
        var combinationNumber: Int = 0
        
        let attributeValue: String = cell.attributeLabel.text!
        
        if self.productModel != nil {
            for (index, combination) in enumerate(self.productModel!.validCombinations){
                for dictionary in combination.attributes as [NSMutableDictionary] {
                    if attributeValue == dictionary["value"] as! String {
                        isValidToDelete = false
                        combinationNumber = index
                        break
                    }
                }
                
                if isValidToDelete == false {
                    break
                }
            }
        }
        
        if isValidToDelete {
            let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
            self.delegate!.productUploadAttributeTableViewCell(didTapCell: self, indexPath: indexPath)
            self.attributes.removeAtIndex(indexPath.row)
            self.collectionView.deleteItemsAtIndexPaths([indexPath])
        } else {
            let alertController = UIAlertController(title: ProductUploadStrings.warning, message: ProductUploadStrings.warningRemoveAttribute, preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: Constants.Localized.no, style: .Cancel) { (action) in
                
            }
            
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: Constants.Localized.yes, style: .Default) { (action) in
                let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
                self.delegate!.productUploadAttributeTableViewCell(didTapCell: self, indexPath: indexPath)
                self.attributes.removeAtIndex(indexPath.row)
                self.collectionView.deleteItemsAtIndexPaths([indexPath])
                println(self.parentViewController!.productModel!.validCombinations.count)
                self.parentViewController!.productModel!.validCombinations.removeAtIndex(combinationNumber)
                println(self.parentViewController!.productModel!.validCombinations.count)
            }
            
            alertController.addAction(OKAction)
            self.parentViewController!.presentViewController(alertController, animated: true) {
                
            }
        }
    }
    
    // Dealloc
    deinit {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
}
