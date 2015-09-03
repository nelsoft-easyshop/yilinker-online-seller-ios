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
    
    var itemsModel: [CategoryProductModel]!
    
    override func awakeFromNib() {
        let nib = UINib(nibName: "ItemImagesHorizontalCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "HorizontalCellIdentifier")
        self.collectionView.dataSource = self
    }

    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if itemsModel != nil {
            return itemsModel.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: ItemImagesHorizontalCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("HorizontalCellIdentifier", forIndexPath: indexPath) as! ItemImagesHorizontalCollectionViewCell
        
        return cell
    }
    
    // MARK: - 
    
    func setItemsImages(model: [CategoryProductModel]) {
        self.itemsModel = model
        
        self.collectionView.reloadData()
    }
}
