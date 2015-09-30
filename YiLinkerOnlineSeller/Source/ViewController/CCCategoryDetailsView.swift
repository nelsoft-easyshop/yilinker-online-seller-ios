//
//  CCCategoryDetailsView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol CCCategoryDetailsViewDelegate {
    func gotoParentCategory()
}

class CCCategoryDetailsView: UIView {

    var delegate: CCCategoryDetailsViewDelegate?
    
    @IBOutlet weak var categoryDetailsLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var parentCategoryTextLabel: UILabel!
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var parentCategoryLabel: UILabel!

    override func awakeFromNib() {
        self.parentCategoryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "parentCategoryAction:"))

        
        self.categoryDetailsLabel.text = CategoryStrings.details
        self.categoryNameLabel.text = CategoryStrings.categoryName
        self.parentCategoryTextLabel.text = CategoryStrings.categoryParent
        self.parentCategoryLabel.text = CategoryStrings.none
    }
    
    // MARK: - Actions
    
    @IBAction func arrowAction(sender: AnyObject) {
        
    }
    
    func updateParentText(text: String) {
        self.parentCategoryLabel.text = text
    }
    
    func parentCategoryAction(gesture: UIGestureRecognizer) {
        self.delegate?.gotoParentCategory()
    }
    
}
