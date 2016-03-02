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
    
    @IBOutlet weak var categoryItemsLabel: UILabel!
    @IBOutlet weak var addNewItemButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        self.addNewItemButton.layer.cornerRadius = self.addNewItemButton.frame.size.height / 2
        self.editButton.layer.cornerRadius = self.editButton.frame.size.height / 2
        
        self.categoryItemsLabel.text = CategoryStrings.categoryItems
        self.addNewItemButton.setTitle(CategoryStrings.categoryNewItems, forState: .Normal)
    }
    
    // MARK: - Methods
    
    func setItemButtonTitle(title: String) {
        if title == CategoryStrings.categoryEdit {
            editButton.hidden = false
            addNewItemButton.hidden = true
        } else {
            editButton.hidden = true
            addNewItemButton.hidden = false
        }
        
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
