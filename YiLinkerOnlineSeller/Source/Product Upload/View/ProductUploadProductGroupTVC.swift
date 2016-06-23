//
//  ProductUploadProductGroupTVC.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 5/13/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

// MARK: Delegate
// ProductUploadProductGroupTVC Delegate method
protocol ProductUploadProductGroupTVCDelegate {
    func productUploadProductGroupTVC(didTapCell cell: ProductUploadProductGroupTVC, indexPath: NSIndexPath)
}

// MARK: Constant variable
struct PUPGConstant {
    static let productUploadProductGroupTVCNibNameAndIdentier = "ProductUploadProductGroupTVC"
}

class ProductUploadProductGroupTVC: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var productGroupLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // View Controller initialization
    var parentViewController: ProductUploadDetailTableViewController?
    
    // Global variable
    var attributes: [String] = []
    var productModel: ProductModel?
    
    // Initialized ProductUploadProductGroupTVCDelegate
    var delegate: ProductUploadProductGroupTVCDelegate?
    var cellProuctGroup: ProductUploadProductGroupCVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.registerCell()
        
        let flowLayout: UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        if IphoneType.isIphone4() || IphoneType.isIphone5() {
            flowLayout.itemSize = CGSizeMake(80, 40)
        } else if IphoneType.isIphone6Plus() {
            flowLayout.itemSize = CGSizeMake(108, 40)
        }
        
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: Private Methods
    func registerCell() {
        let nib: UINib = UINib(nibName: "ProductUploadProductGroupCVC", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "ProductUploadProductGroupCVC")
    }
    
    // MARK: Collecton view delegate methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.attributes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductUploadProductGroupCVC = self.collectionView.dequeueReusableCellWithReuseIdentifier("ProductUploadProductGroupCVC", forIndexPath: indexPath) as! ProductUploadProductGroupCVC
        
        cell.attributeLabel.text = self.attributes[indexPath.row]
        cell.attributeLabel.adjustsFontSizeToFitWidth = true
        cell.layer.cornerRadius = 5
        self.cellProuctGroup = cell
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapRecognizer:")
        cell.userInteractionEnabled = true
        cell.addGestureRecognizer(gestureRecognizer)
        //cell.deleteButton.addGestureRecognizer(gestureRecognizer)
        return cell
    }
    
    func collectionViewContentSize() -> CGSize {
        return self.collectionView.collectionViewLayout.collectionViewContentSize()
    }
    
    // MARK: Cell action
    func tapRecognizer(sender: UITapGestureRecognizer) {
        let cell: ProductUploadProductGroupCVC = sender.view as! ProductUploadProductGroupCVC
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
            self.delegate!.productUploadProductGroupTVC(didTapCell: self, indexPath: indexPath)
            self.attributes.removeAtIndex(indexPath.row)
            self.collectionView.deleteItemsAtIndexPaths([indexPath])
        } else {
            let alertController = UIAlertController(title: ProductUploadStrings.warning, message: ProductUploadStrings.warningRemoveAttribute, preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: Constants.Localized.no, style: .Cancel) { (action) in
                
            }
            
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: Constants.Localized.yes, style: .Default) { (action) in
                let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
                self.delegate!.productUploadProductGroupTVC(didTapCell: self, indexPath: indexPath)
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
