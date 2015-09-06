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
    var selectedItems: [Int] = []
    
    override func awakeFromNib() {
        let nib = UINib(nibName: "ItemImagesHorizontalCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "HorizontalCellIdentifier")
        self.collectionView.dataSource = self
    }

    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println(">> \(categoryProducts.count)")
        if categoryProducts.count != 0 {
            return categoryProducts.count
        } else if selectedItems.count != 0 {
            return selectedItems.count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: ItemImagesHorizontalCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("HorizontalCellIdentifier", forIndexPath: indexPath) as! ItemImagesHorizontalCollectionViewCell
        
        if categoryProducts.count != 0 {
            cell.setItemImage(categoryProducts[indexPath.row].image)
        } else if selectedItems.count != 0 {
            let index: Int = selectedItems[indexPath.row]
            cell.setItemImage(productManagement[index].image)

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
    
    func setProductsManagement(#products: [ProductManagementProductsModel], selectedItems: [Int]) {

        self.selectedItems = selectedItems
        if products.count != 0 {
            self.productManagement = products
        }
        
        self.collectionView.reloadData()
    }
    
}
