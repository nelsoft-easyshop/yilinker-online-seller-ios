//
//  ResellerCollectionReusableView.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/7/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ResellerCollectionReusableViewDelegate {
    func resellerCollectionReusableView(didClickAddItemButton  resellerCollectionReusableView: ResellerCollectionReusableView)
}

class ResellerCollectionReusableView: UICollectionReusableView {

    var delegate: ResellerCollectionReusableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addItems(sender: AnyObject) {
        self.delegate!.resellerCollectionReusableView(didClickAddItemButton: self)
    }
}
