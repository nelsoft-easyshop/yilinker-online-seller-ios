//
//  ProductUploadAddFooterView.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadAddFooterViewDelegate {
    func productUploadAddFooterView(didSelectAddMore view: UIView)
}

class ProductUploadAddFooterView: UIView {
    var delegate: ProductUploadAddFooterViewDelegate?
    @IBOutlet weak var addMoreButton: UIButton!
    
    override func awakeFromNib() {
        self.addMoreButton.setTitle(ProductUploadStrings.addMore, forState: UIControlState.Normal)
    }
    
    @IBAction func addMore(sender: AnyObject) {
        self.delegate!.productUploadAddFooterView(didSelectAddMore: self)
    }
}
