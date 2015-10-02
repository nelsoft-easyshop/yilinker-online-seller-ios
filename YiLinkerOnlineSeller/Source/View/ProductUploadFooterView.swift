//
//  ProductUploadFooterView.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadFooterViewDelegate {
    func productUploadFooterView(didClickUpload view: ProductUploadFooterView)
}

class ProductUploadFooterView: UIView {
    var delegate: ProductUploadFooterViewDelegate?
    
    @IBOutlet weak var uploadProductButton: DynamicRoundedButton!
    
    override func awakeFromNib() {
        self.uploadProductButton.setTitle(ProductUploadStrings.uploadItem, forState: UIControlState.Normal)
    }
    
    @IBAction func productUpload(sender: AnyObject) {
        self.delegate!.productUploadFooterView(didClickUpload: self)
    }

}
