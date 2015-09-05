//
//  CCSubCategoriesView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol CCSubCategoriesViewDelegate {
    func gotoEditSubCategories()
}

class CCSubCategoriesView: UIView {

    var delegate: CCSubCategoriesViewDelegate?
    var sampleButton: UIButton!
    
    @IBOutlet weak var addSubCategoryButton: UIButton!
  
    override func awakeFromNib() {
        
        self.addSubCategoryButton.layer.cornerRadius = self.addSubCategoryButton.frame.size.height / 2
        self.addSubCategoryButton.sizeToFit()
    }

    func setTitle(title: String) {
        self.addSubCategoryButton.setTitle(title, forState: .Normal)
//        self.addSubCategoryButton.sizeToFit()
//        self.addSubCategoryButton.setTitle(title, forState: .Normal)
//        self.addSubCategoryButton.sizeToFit()
    }
    
    @IBAction func addSubCategoryAction(sender: AnyObject) {
        delegate!.gotoEditSubCategories()
        
    }
}
