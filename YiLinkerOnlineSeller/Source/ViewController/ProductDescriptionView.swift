//
//  ProductDescriptionView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductDescriptionViewDelegate {
    func gotoDescriptionViewController(view: ProductDescriptionView)
}

class ProductDescriptionView: UIView {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var seeMoreView: UIView!
    
    var delegate: ProductDescriptionViewDelegate?
    
    override func awakeFromNib() {
        seeMoreView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "seeMoreAction:"))
    }
    
    // MARK: - Actions
    
    func seeMoreAction(gesture: UIGestureRecognizer) {
        self.delegate?.gotoDescriptionViewController(self)
    }
}
