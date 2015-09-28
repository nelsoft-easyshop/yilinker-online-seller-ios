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

    var delegate: ProductDescriptionViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var seeMoreView: UIView!
    @IBOutlet weak var seeMoreLabel: UILabel!
    
    override func awakeFromNib() {
        seeMoreView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "seeMoreAction:"))
    }
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    func seeMoreAction(gesture: UIGestureRecognizer) {
        self.delegate?.gotoDescriptionViewController(self)
    }
}
