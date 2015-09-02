//
//  ProductUploadAttributeTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadAttributeTableViewCellDelegate {
    func productUploadAttributeTableViewCell(didTapCell cell: ProductUploadAttributeTableViewCell, indexPath: NSIndexPath)
}

struct PUAConstant {
    static let productUploadAttributeCollectionViewCellNibNameAndIdentier = "ProductUploadAttributeCollectionViewCell"
}

class ProductUploadAttributeTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var attributes: [String] = []
    @IBOutlet weak var colectionViewHeightConstraint: NSLayoutConstraint!
    
    var delegate: ProductUploadAttributeTableViewCellDelegate?
    var parentViewController: ProductUploadDetailTableViewController?
    
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
    
    func registerCell() {
        let nib: UINib = UINib(nibName: PUAConstant.productUploadAttributeCollectionViewCellNibNameAndIdentier, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: PUAConstant.productUploadAttributeCollectionViewCellNibNameAndIdentier)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.attributes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductUploadAttributeCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(PUAConstant.productUploadAttributeCollectionViewCellNibNameAndIdentier, forIndexPath: indexPath) as! ProductUploadAttributeCollectionViewCell

        cell.attributeLabel.text = self.attributes[indexPath.row]
        cell.layer.cornerRadius = 5
        
       /* let imageView: UIImageView = UIImageView(frame: CGRectMake(cell.frame.size.width - 20, (cell.frame.size.height / 2) - 7.5 , 15, 15))
        imageView.image = UIImage(named: "close")
        cell.addSubview(imageView)*/
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapRecognizer:")
        cell.userInteractionEnabled = true
        cell.addGestureRecognizer(gestureRecognizer)
        
        return cell
    }
    
    func tapRecognizer(sender: UITapGestureRecognizer) {
        let cell: ProductUploadAttributeCollectionViewCell = sender.view as! ProductUploadAttributeCollectionViewCell
        
        var isValidToDelete: Bool = true
        var combinationNumber: Int = 0
        
        let attributeValue: String = cell.attributeLabel.text!
        
        if self.parentViewController!.productModel != nil {
            for (index, combination) in enumerate(self.parentViewController!.productModel!.validCombinations){
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
            let alertController = UIAlertController(title: "Warning", message: "This attribute item has an existing combination. Continue removing this item?", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "NO", style: .Cancel) { (action) in
                
            }
            
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "YES", style: .Default) { (action) in
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
    
    func collectionViewContentSize() -> CGSize {
        return self.collectionView.collectionViewLayout.collectionViewContentSize()
    }
    
    // Dealloc
    deinit {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
}
