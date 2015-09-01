//
//  CCCategoryItems.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CCCategoryItemsView: UIView {

    @IBOutlet weak var addNewItemButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        self.addNewItemButton.layer.cornerRadius = self.addNewItemButton.frame.size.height / 2
    }
    
    // MARK: - Actions
    
    @IBAction func addNewItemAction(sender: AnyObject) {
    }

}
