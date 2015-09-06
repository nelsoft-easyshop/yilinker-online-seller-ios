//
//  PUAttributeAddFooterView.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol PUAttributeAddFooterViewDelegate {
    func PUAttributeAddFooterView(didSelectAddMore view: UIView)
}

class PUAttributeAddFooterView: UIView {

    var delegate: PUAttributeAddFooterViewDelegate?
    
    @IBAction func addMore(sender: AnyObject) {
        self.delegate!.PUAttributeAddFooterView(didSelectAddMore: self)
    }
}
