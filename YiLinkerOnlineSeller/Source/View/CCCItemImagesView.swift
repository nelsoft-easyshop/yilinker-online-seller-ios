//
//  CCCItemImagesView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CCCItemImagesView: UIView, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var itemsModel: NSArray = []
    var productManagement: [ProductManagementProductsModel] = []
    var selectedItems: [Int] = []
    
    override func awakeFromNib() {
        let nib = UINib(nibName: "ItemImagesHorizontalCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "HorizontalCellIdentifier")
        self.collectionView.dataSource = self
    }

    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if productManagement.count  != 0 {
//            return productManagement.count
//        }
        return selectedItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: ItemImagesHorizontalCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("HorizontalCellIdentifier", forIndexPath: indexPath) as! ItemImagesHorizontalCollectionViewCell
        
        let index: Int = selectedItems[indexPath.row]
        cell.setItemImage(productManagement[index].image)
        
        return cell
    }
    
    // MARK: - 
    
//    func setProductsCategory(#category: [CategoryProductModel], selectedItems: NSArray) {
//        if category.count != 0 {
//            self.itemsModel = category
//        } else {
//            println("else in CCCItemImagesView")
//        }
//        
//        self.collectionView.reloadData()
//    }
    
    func setProductsManagement(#products: [ProductManagementProductsModel], selectedItems: [Int]) {

        self.selectedItems = selectedItems
        if products.count != 0 {
            self.productManagement = products
        }
        
        self.collectionView.reloadData()
    }
    
}
