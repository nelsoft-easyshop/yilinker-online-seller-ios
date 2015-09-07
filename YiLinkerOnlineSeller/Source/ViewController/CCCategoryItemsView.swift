//
//  CCCategoryItems.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol CCCategoryItemsViewDelegate {
    func gotoAddItem()
    func gotoEditItem()
}

class CCCategoryItemsView: UIView {

    var delegate: CCCategoryItemsViewDelegate?
    
    @IBOutlet weak var addNewItemButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        self.addNewItemButton.layer.cornerRadius = self.addNewItemButton.frame.size.height / 2
    }
    
    // MARK: - Methods
    
    func setItemButtonTitle(title: String) {
        self.addNewItemButton.setTitle(title, forState: .Normal)
    }
    
    // MARK: - Actions
    
    @IBAction func addNewItemAction(sender: AnyObject) {
        if sender.titleLabel!!.text == "EDIT" {
            delegate?.gotoEditItem()
        } else {
            delegate?.gotoAddItem()
        }
    }

}
