//
//  ProductUploadAttributeTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct PUAConstant {
    static let productUploadAttributeCollectionViewCellNibNameAndIdentier = "ProductUploadAttributeCollectionViewCell"
}

class ProductUploadAttributeTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var attributes: [String] = []
    @IBOutlet weak var colectionViewHeightConstraint: NSLayoutConstraint!
    
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
        
        return cell
    }
    
    func collectionViewContentSize() -> CGSize {
        return self.collectionView.collectionViewLayout.collectionViewContentSize()
    }
    
}
