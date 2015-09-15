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
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var parentCategoryLabel: UILabel!

    override func awakeFromNib() {
        self.parentCategoryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "parentCategoryAction:"))
//        self.categoryNameTextField.addTarget(self, action: "textDidChanged", forControlEvents: UIControlEvents.EditingChanged)
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
