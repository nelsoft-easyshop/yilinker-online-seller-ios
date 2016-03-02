//
//  TransactionProductDetailsHeaderView.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionProductDetailsHeaderView: UIView, UICollectionViewDataSource {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [String] = []
    
    override func awakeFromNib() {
        var nib = UINib(nibName: "TransactionImageCollectionViewCell", bundle:nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "TransactionImageCollectionViewCell")
        
        self.collectionView.dataSource = self
    }
    
    
    // MARK: - Collection View Data Source

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: TransactionImageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("TransactionImageCollectionViewCell", forIndexPath: indexPath) as! TransactionImageCollectionViewCell
        cell.productImageView.sd_setImageWithURL(NSURL(string: images[indexPath.row]), placeholderImage: UIImage(named: "dummy-placeholder"))
        return cell
    }

    
}
