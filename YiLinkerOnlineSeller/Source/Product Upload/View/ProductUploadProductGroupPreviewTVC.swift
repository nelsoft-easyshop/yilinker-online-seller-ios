//
//  ProductUploadProductGroupPreviewTVC.swift
//  YiLinkerOnlineSeller
//
//  Created by Yhel on 6/16/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

// MARK: Constant variable
struct PUPGPreviewConstant {
    static let productUploadProductGroupTVCNibNameAndIdentier = "ProductUploadProductGroupPreviewTVC"
}

class ProductUploadProductGroupPreviewTVC: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // Global variable
    var attributes: [String] = []
    var productModel: ProductModel?
    var isPreview: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
        if self.isPreview {
            cell.deleteButton.hidden = true
        } else {
            cell.deleteButton.hidden = false
        }
        
        cell.attributeLabel.text = self.attributes[indexPath.row]
        cell.attributeLabel.adjustsFontSizeToFitWidth = true
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionViewContentSize() -> CGSize {
        return self.collectionView.collectionViewLayout.collectionViewContentSize()
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
