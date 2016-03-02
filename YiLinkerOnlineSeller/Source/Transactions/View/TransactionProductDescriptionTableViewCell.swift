//
//  TransactionProductDescriptionTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol TransactionProductDescriptionTableViewCellDelegate {
    func seeMoreAction()
}

class TransactionProductDescriptionTableViewCell: UITableViewCell {

    var delegate: TransactionProductDescriptionTableViewCellDelegate?
    
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var seeMoreView: UIView!
    @IBOutlet weak var seeMoreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeLocalizedStrings()
        
        var seeMore = UITapGestureRecognizer(target:self, action:"tapSeeMoreAction")
        seeMoreView.addGestureRecognizer(seeMore)
    }

    func initializeLocalizedStrings() {
        seeMoreLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_SEE_MORE_LOCALIZE_KEY")
    }
    
    func tapSeeMoreAction() {
        delegate?.seeMoreAction()
    }
}
