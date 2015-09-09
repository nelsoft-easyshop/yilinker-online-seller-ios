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
    var categoryProducts: [CategoryProductModel] = []
    var productManagement: [ProductManagementProductsModel] = []
    var selectedItems: [ProductManagementProductsModel] = []
    
    override func awakeFromNib() {
        let nib = UINib(nibName: "ItemImagesHorizontalCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "HorizontalCellIdentifier")
        self.collectionView.dataSource = self
    }

    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoryProducts.count != 0 {
            return categoryProducts.count
        }
        println(selectedItems.count)
        return selectedItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: ItemImagesHorizontalCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("HorizontalCellIdentifier", forIndexPath: indexPath) as! ItemImagesHorizontalCollectionViewCell
        
        if categoryProducts.count != 0 {
            cell.setItemImage(categoryProducts[indexPath.row].image)
        } else {
            cell.setItemImage(selectedItems[indexPath.row].image)
        }
        
        return cell
    }
    
    // MARK: - 
    
    func setProductsCategory(#products: [CategoryProductModel]) {
        
        if products.count != 0 {
            self.categoryProducts = products
        }
        
        self.collectionView.reloadData()
    }
    
    func setProductsManagement(#products: [ProductManagementProductsModel], selectedItems: [ProductManagementProductsModel]) {

        self.selectedItems = selectedItems
        if products.count != 0 {
            self.productManagement = products
        }
        
        self.collectionView.reloadData()
    }
    
}
