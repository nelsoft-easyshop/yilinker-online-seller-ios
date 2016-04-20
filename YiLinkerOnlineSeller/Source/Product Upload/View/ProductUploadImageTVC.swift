//
//  ProductUploadImageTVC.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 4/18/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

// MARK: Constant variable declarations
struct ProductUploadImageTVCConstant {
    static let productUploadImageCollectionViewCellNibNameAndIdentifier = "ProductUploadImageCollectionViewCell"
}

// MARK: Data source
// ProductUploadUploadImageTVC Data source methods
protocol ProductUploadUploadImageTVCDataSource {
    func productUploadUploadImageTableViewCell(numberOfCollectionViewRows cell: ProductUploadImageTVC) -> Int
    func productUploadUploadImageTableViewCell(images cell: ProductUploadImageTVC) -> [UIImage]
}

// MARK: Delegate
// ProductUploadUploadImageTVC delegate methods
protocol ProductUploadUploadImageTVCDelegate {
    func productUploadUploadImageTableViewCell(didSelecteRowAtIndexPath indexPath: NSIndexPath, cell: ProductUploadImageTVC)
    func productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath indexPath: NSIndexPath, collectionView: UICollectionView)
    
    func productUploadUploadImageTableViewCell(didTapStarAtRowIndexPath indexPath: NSIndexPath, cell: ProductUploadImageCollectionViewCell, collectionView: UICollectionView)
}

class ProductUploadImageTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, ProductUploadImageCollectionViewCellDelegate {
    
    // Collection view
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Labels
    @IBOutlet weak var productPhotosLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    // Initialiaze ProductUploadImageTVCDataSource and ProductUploadImageTVCDelegate
    var dataSource: ProductUploadUploadImageTVCDataSource?
    var delegate: ProductUploadUploadImageTVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerNib()
        
        self.productPhotosLabel.text = ProductUploadStrings.productPhotos
        self.productPhotosLabel.required()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: -
    // MARK: - Local methods
    // MARK: - Register collection view cell
    
    func registerNib() {
        let nib: UINib = UINib(nibName: ProductUploadImageTVCConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: ProductUploadImageTVCConstant.productUploadImageCollectionViewCellNibNameAndIdentifier)
    }
    
    // MARK: -
    // MARK: - ProductUploadImageTVC delegate method
    // MARK: - Tap the Delete button
    
    func productUploadImageCollectionViewCell(didTapDeleteButtonAtCell cell: ProductUploadImageCollectionViewCell) {
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
        self.delegate!.productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath: indexPath, collectionView: self.collectionView)
    }
    
    // MARK: - Tap the star button
    
    func productUploadImageCollectionViewCell(didTapStarButtonAtCell cell: ProductUploadImageCollectionViewCell) {
        cell.starButton.setBackgroundImage(UIImage(named: "active2"), forState: UIControlState.Normal)
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
        self.delegate!.productUploadUploadImageTableViewCell(didTapStarAtRowIndexPath: indexPath, cell: cell, collectionView: self.collectionView)
        self.collectionView.reloadData()
    }
    
    // MARK: -
    // MARK: - Collection view delegate methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource!.productUploadUploadImageTableViewCell(numberOfCollectionViewRows: self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductUploadImageCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(ProductUploadImageTVCConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadImageCollectionViewCell
        
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
