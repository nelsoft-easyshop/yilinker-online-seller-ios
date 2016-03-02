//
//  ProductUploadFooterView.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Delegate
// ProductUploadFooterView Delegate methods
protocol ProductUploadFooterViewDelegate {
    func productUploadFooterView(didClickUpload view: ProductUploadFooterView)
}

class ProductUploadFooterView: UIView {
    
    // Custom buttons
    @IBOutlet weak var uploadProductButton: DynamicRoundedButton!
    
    // Initialize ProductUploadFooterViewDelegate
    var delegate: ProductUploadFooterViewDelegate?
    
    override func awakeFromNib() {
        self.uploadProductButton.setTitle(ProductUploadStrings.uploadItem, forState: UIControlState.Normal)
    }
    
    // MARK: Button actions
    @IBAction func productUpload(sender: AnyObject) {
        self.delegate!.productUploadFooterView(didClickUpload: self)
    }

}
