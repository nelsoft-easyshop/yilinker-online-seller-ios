//
//  ProductUploadUploadImageTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct ProductUploadUploadImageTableViewCellConstant {
    static let productUploadImageCollectionViewCellNibNameAndIdentifier = "ProductUploadImageCollectionViewCell"
}

protocol ProductUploadUploadImageTableViewCellDataSource {
    func productUploadUploadImageTableViewCell(numberOfCollectionViewRows cell: ProductUploadUploadImageTableViewCell) -> Int
    func productUploadUploadImageTableViewCell(images cell: ProductUploadUploadImageTableViewCell) -> [UIImage]
}

protocol ProductUploadUploadImageTableViewCellDelegate {
    func productUploadUploadImageTableViewCell(didSelecteRowAtIndexPath indexPath: NSIndexPath, cell: ProductUploadUploadImageTableViewCell)
    func productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath indexPath: NSIndexPath, collectionView: UICollectionView)
}

class ProductUploadUploadImageTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, ProductUploadImageCollectionViewCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productPhotosLabel: UILabel!
    
    var dataSource: ProductUploadUploadImageTableViewCellDataSource?
    var delegate: ProductUploadUploadImageTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCell()
        
        self.productPhotosLabel.text = ProductUploadStrings.productPhotos
        self.productPhotosLabel.required()
    }

    func registerCell() {
        let nib: UINib = UINib(nibName: ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource!.productUploadUploadImageTableViewCell(numberOfCollectionViewRows: self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductUploadImageCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadImageCollectionViewCell
        
        cell.imageView.image = self.dataSource!.productUploadUploadImageTableViewCell(images: self)[indexPath.row]
        
        if indexPath.row == self.dataSource!.productUploadUploadImageTableViewCell(numberOfCollectionViewRows: self) - 1 {
            cell.closeButton.hidden = true
            cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        } else {
            cell.closeButton.hidden = false
            cell.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate!.productUploadUploadImageTableViewCell(didSelecteRowAtIndexPath: indexPath, cell: self)
    }
    
    func productUploadImageCollectionViewCell(didTapDeleteButtonAtCell cell: ProductUploadImageCollectionViewCell) {
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
        self.delegate!.productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath: indexPath, collectionView: self.collectionView)
    }

    // Dealloc
    deinit {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
}
