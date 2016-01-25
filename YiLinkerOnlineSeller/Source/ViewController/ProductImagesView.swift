//
//  ProductImagesView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductImagesView: UIView, UICollectionViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var productModel: ProductModel?
    var uploadType: UploadType?
    var images: [UIImage] = []
    var imagesUrls: [String] = []
    
    override func awakeFromNib() {
        let nib = UINib(nibName: "ProductImagesCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "ProductImagesIdentifier")
        
        self.collectionView.dataSource = self
    }
    
    // MARK: - Methods
    
    func setDetails(product: ProductModel, uploadType: UploadType, images: [UIImage]) {
        self.uploadType = uploadType
        self.images = images
        self.productModel = product
        self.titleLabel.text = product.name
        self.subTitleLabel.text = product.shortDescription
        
        if !ProductUploadEdit.isPreview {
            self.imagesUrls = product.imageUrls
        }

        self.collectionView.reloadData()
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  ProductUploadEdit.isPreview {
            if self.uploadType == UploadType.EditProduct {
                if self.productModel!.editedImage.count == 0 {
                    return 5
                }
                return self.productModel!.editedImage.count
            } else {
                if self.images.count == 0 {
                    return 5
                }
                return self.images.count
            }
        } else {
            if imagesUrls.count == 0 {
                return 5
            }
            return imagesUrls.count
        }

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductImagesCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductImagesIdentifier", forIndexPath: indexPath) as! ProductImagesCollectionViewCell
        
        if ProductUploadEdit.isPreview {
            if self.uploadType == UploadType.EditProduct {
                if self.productModel!.editedImage.count != 0 {
                    cell.setLocalImage(self.productModel!.editedImage[indexPath.row])
                }
            } else {
                if self.images.count != 0 {
                    cell.setLocalImage(self.images[indexPath.row])
                }
            }
        } else {
            if imagesUrls.count != 0 {
                cell.setItemImage(imagesUrls[indexPath.row])
            }
        }
        
        return cell
    }
}
