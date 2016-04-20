//
//  ProductUploadUploadImageTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Constant variable declarations
struct ProductUploadUploadImageTableViewCellConstant {
    static let productUploadImageCollectionViewCellNibNameAndIdentifier = "ProductUploadImageCollectionViewCell"
}

// MARK: Data source
// ProductUploadUploadImageTableViewCell Data source methods
protocol ProductUploadUploadImageTableViewCellDataSource {
    func productUploadUploadImageTableViewCell(numberOfCollectionViewRows cell: ProductUploadUploadImageTableViewCell) -> Int
    func productUploadUploadImageTableViewCell(images cell: ProductUploadUploadImageTableViewCell) -> [UIImage]
}

// MARK: Delegate
// ProductUploadUploadImageTableViewCell delegate methods
protocol ProductUploadUploadImageTableViewCellDelegate {
    func productUploadUploadImageTableViewCell(didSelecteRowAtIndexPath indexPath: NSIndexPath, cell: ProductUploadUploadImageTableViewCell)
    func productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath indexPath: NSIndexPath, collectionView: UICollectionView)
    func productUploadUploadImageTableViewCell(didTapStarAtRowIndexPath indexPath: NSIndexPath, cell: ProductUploadImageCollectionViewCell)
}

class ProductUploadUploadImageTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, ProductUploadImageCollectionViewCellDelegate {

    // Collection view
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Labels
    @IBOutlet weak var productPhotosLabel: UILabel!
    
    // Initialiaze ProductUploadUploadImageTableViewCellDataSource and ProductUploadUploadImageTableViewCellDelegate
    var dataSource: ProductUploadUploadImageTableViewCellDataSource?
    var delegate: ProductUploadUploadImageTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCell()
        
        self.productPhotosLabel.text = ProductUploadStrings.productPhotos
        self.productPhotosLabel.required()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: Private methods
    // Register collection view cell
    func registerCell() {
        let nib: UINib = UINib(nibName: ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier)
    }
    
    // MARK: ProductUploadImageCollectionViewCell delegate method
    func productUploadImageCollectionViewCell(didTapDeleteButtonAtCell cell: ProductUploadImageCollectionViewCell) {
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
        self.delegate!.productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath: indexPath, collectionView: self.collectionView)
    }
    
    func productUploadImageCollectionViewCell(didTapStarButtonAtCell cell: ProductUploadImageCollectionViewCell) {
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
        self.delegate!.productUploadUploadImageTableViewCell(didTapStarAtRowIndexPath: indexPath, cell: cell)
    }
    
    // MARK: Collection view delegate methods
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
        
        if SessionManager.isSeller() {
            cell.userInteractionEnabled = true
        } else {
            cell.userInteractionEnabled = false
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate!.productUploadUploadImageTableViewCell(didSelecteRowAtIndexPath: indexPath, cell: self)
    }

    // Dealloc
    deinit {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
}
