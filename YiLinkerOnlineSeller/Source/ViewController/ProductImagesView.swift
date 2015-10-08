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
   
    var imagesUrls: [String] = []
    
    override func awakeFromNib() {
        let nib = UINib(nibName: "ProductImagesCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "ProductImagesIdentifier")
        
        self.collectionView.dataSource = self
    }
    
    // MARK: - Methods
    
    func setDetails(product: ProductModel) {
        
        self.titleLabel.text = product.name
        self.subTitleLabel.text = product.shortDescription
        
//        self.collectionView.transform = CGAffineTransformMakeTranslation(0.0, 20.0)
//        self.frame.size.height = self.frame.size.height + (self.subTitleLabel.frame.size.height - 38)
        self.imagesUrls = product.imageUrls
        self.collectionView.reloadData()
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imagesUrls.count == 0 {
            return 5
        }
        return imagesUrls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductImagesCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductImagesIdentifier", forIndexPath: indexPath) as! ProductImagesCollectionViewCell
        
        if imagesUrls.count != 0 {
            cell.setItemImage(imagesUrls[indexPath.row])
        }
        
        return cell
    }
}
