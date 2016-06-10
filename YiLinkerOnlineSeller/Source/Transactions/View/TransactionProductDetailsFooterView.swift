//
//  TransactionProductDetailsFooterView.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/17/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol TransactionProductDetailsFooterViewDelegate {
    func cancelButtonOrderAction()
}

class TransactionProductDetailsFooterView: UIView {

    var delegate: TransactionProductDetailsFooterViewDelegate?
    
    @IBOutlet weak var cancelOrderView: UIView!
    @IBOutlet weak var cancelOrderLabel: UILabel!
    
    override func awakeFromNib() {
        initializesViews()
        initializeLocalizedStrings()
    }
    
    func initializesViews() {
        cancelOrderView.layer.cornerRadius = cancelOrderView.frame.height / 2
        var cancelOrder = UITapGestureRecognizer(target:self, action:"cancelOrderAction")
        cancelOrderView.addGestureRecognizer(cancelOrder)
    }
    
    func initializeLocalizedStrings() {
        cancelOrderLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_CANCEL_ORDER_LOCALIZE_KEY")
    }
    
    func cancelOrderAction() {
        delegate?.cancelButtonOrderAction()
    }


}
