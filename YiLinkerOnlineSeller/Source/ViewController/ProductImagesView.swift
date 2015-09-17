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
   
    var images: [ProductImagesModel] = []
    
    override func awakeFromNib() {
        let nib = UINib(nibName: "ProductImagesCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "ProductImagesIdentifier")
        
        self.collectionView.dataSource = self
    }
    
    // MARK: - Methods
    
    func setDetails(product: ProductDetailsModel, images: [ProductImagesModel]) {
        
        self.titleLabel.text = product.title
        self.subTitleLabel.text = product.fullDescription
        
        self.images = images
        self.collectionView.reloadData()
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count == 0 {
            return 5
        }
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductImagesCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductImagesIdentifier", forIndexPath: indexPath) as! ProductImagesCollectionViewCell
        
        if images.count != 0 {
            cell.setItemImage(images[indexPath.row].imageLocation)
        }
        
        return cell
    }

}
