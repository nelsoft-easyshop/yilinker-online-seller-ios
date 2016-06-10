//
//  ProductUploadAddFooterView.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Delegate
// ProductUploadAddFooterView delegate method
protocol ProductUploadAddFooterViewDelegate {
    func productUploadAddFooterView(didSelectAddMore view: UIView)
}

class ProductUploadAddFooterView: UIView {
    
    // Buttons
    @IBOutlet weak var addMoreButton: UIButton!
    
    // Initialized ProductUploadAddFooterViewDelegate
    var delegate: ProductUploadAddFooterViewDelegate?
    
    override func awakeFromNib() {
        self.addMoreButton.setTitle(ProductUploadStrings.addMore, forState: UIControlState.Normal)
    }
    
    // MARK: Button action
    @IBAction func addMore(sender: AnyObject) {
        self.delegate!.productUploadAddFooterView(didSelectAddMore: self)
    }
}
