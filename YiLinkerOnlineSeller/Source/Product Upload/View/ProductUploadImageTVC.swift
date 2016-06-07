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
    static let productUploadImageTVCNibNameAndIdentifier = "ProductUploadImageTVC"
    static var uploadImages: [Int] = []
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
    func productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath indexPath: NSIndexPath, cell: ProductUploadImageTVC, collectionView: UICollectionView)
    
    func productUploadUploadImageTableViewCell(didTapStarAtRowIndexPath indexPath: NSIndexPath, cell: ProductUploadImageCollectionViewCell, collectionView: UICollectionView, primaryPhoto: String)
    func productUploadUploadImageTableViewCell(didTapReuploadAtRowIndexPath indexPath: NSIndexPath, cell: ProductUploadImageCollectionViewCell, collectionView: UICollectionView)
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
    
    // Model
    var productModel: ProductModel?
    
    // Variables
    var selectedPrimaryPhoto: [String] = []
    var successfulUploadedImagesIndex: [Int] = []
    
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
        self.delegate!.productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath: indexPath, cell: self, collectionView: self.collectionView)
    }
    
    // MARK: -
    // MARK: - Tap the star button
    // TODO: - Add action to set the button checked
    
    func productUploadImageCollectionViewCell(didTapStarButtonAtCell cell: ProductUploadImageCollectionViewCell) {
        cell.starButton.setBackgroundImage(UIImage(named: "active2"), forState: UIControlState.Normal)
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
        
        self.selectedPrimaryPhoto.removeAll(keepCapacity: false)
        
        self.productModel!.isPrimaryPhoto = []
        
        if cell.starButton.tag != 1001 {
            self.selectedPrimaryPhoto.append("\(cell.starButton.tag)")
            self.delegate!.productUploadUploadImageTableViewCell(didTapStarAtRowIndexPath: indexPath, cell: cell, collectionView: self.collectionView, primaryPhoto: self.selectedPrimaryPhoto[0])
        }
  
        self.collectionView.reloadData()
    }
    
    func productUploadImageCollectionViewCell(didTapReuploadButtonAtCell cell: ProductUploadImageCollectionViewCell) {
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
        self.delegate?.productUploadUploadImageTableViewCell(didTapReuploadAtRowIndexPath: indexPath, cell: cell, collectionView: self.collectionView)
    }
    
    // MARK: -
    // MARK: - Collection view delegate methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource!.productUploadUploadImageTableViewCell(numberOfCollectionViewRows: self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductUploadImageCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(ProductUploadImageTVCConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadImageCollectionViewCell
        cell.starButton.tag = indexPath.row
        cell.imageView.image = self.dataSource!.productUploadUploadImageTableViewCell(images: self)[indexPath.row]
        
        if indexPath.row == self.dataSource!.productUploadUploadImageTableViewCell(numberOfCollectionViewRows: self) - 1 {
            cell.closeButton.hidden = true
            cell.starButton.hidden = true
            cell.tapToReuploadButton.hidden = true
            cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        } else {
            if self.productModel?.mainImagesName.count != 0 {
                if self.productModel?.productMainImagesModel[indexPath.row].imageStatus == true && self.productModel?.productMainImagesModel[indexPath.row].imageFailed == false {
                    cell.imageView.alpha = 1.0
                    cell.tapToReuploadButton.hidden = true
                } else if self.productModel?.productMainImagesModel[indexPath.row].imageStatus == false && self.productModel?.productMainImagesModel[indexPath.row].imageFailed == false {
                    cell.imageView.alpha = 0.5
                    cell.tapToReuploadButton.hidden = true
                } else if self.productModel?.productMainImagesModel[indexPath.row].imageStatus == false && self.productModel?.productMainImagesModel[indexPath.row].imageFailed == true  {
                    cell.imageView.alpha = 0.5
                    cell.tapToReuploadButton.hidden = false
                }
            } else {
                cell.tapToReuploadButton.hidden = true
            }
            
            if self.productModel?.isPrimaryPhoto.count != 0 {
                for (index, isPrimary) in enumerate(self.productModel!.isPrimaryPhoto) {
                    if isPrimary {
                        self.selectedPrimaryPhoto.append("\(index)")
                    }
                }
            }
            
            if contains(self.selectedPrimaryPhoto, "\(indexPath.row)") && cell.starButton.tag != 1001{
                cell.starButton.setImage(UIImage(named:"ic_selected_as_primary"), forState: UIControlState.Normal)
                cell.starButton.tag = 1001
            } else {
                cell.starButton.setImage(UIImage(named:"ic_unselected_as_primary"), forState: UIControlState.Normal)
            }
            
            cell.closeButton.hidden = false
            cell.starButton.hidden = false
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
