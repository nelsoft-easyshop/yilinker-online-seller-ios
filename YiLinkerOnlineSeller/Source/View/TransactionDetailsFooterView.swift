//
//  TransactionDetailsFooterView.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol TransactionDetailsFooterViewDelegate {
    func shipItemAction()
    func cancelOrderAction()
}

class TransactionDetailsFooterView: UIView {

    var delegate: TransactionDetailsFooterViewDelegate?
    
    @IBOutlet weak var shipItemView: UIView!
    @IBOutlet weak var cancelOrderView: UIView!
    @IBOutlet weak var shipItemLabel: UILabel!
    @IBOutlet weak var cancelOrderLabel: UILabel!
    
    override func awakeFromNib() {
        initializesViews()
        intializeLocalizedStrings()
    }
    
    func initializesViews() {
        shipItemView.layer.cornerRadius = shipItemView.frame.height / 2
        cancelOrderView.layer.cornerRadius = cancelOrderView.frame.height / 2
        
        var shipItem = UITapGestureRecognizer(target:self, action:"shipItemAction")
        shipItemView.addGestureRecognizer(shipItem)
        
        var cancelOrder = UITapGestureRecognizer(target:self, action:"cancelOrderAction")
        cancelOrderView.addGestureRecognizer(cancelOrder)
    }
    
    func intializeLocalizedStrings() {
        shipItemLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_SHIP_ITEM_LOCALIZE_KEY")
        cancelOrderLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_CANCEL_ORDER_LOCALIZE_KEY")
    }
    
    func shipItemAction() {
        delegate?.shipItemAction()
    }

    func cancelOrderAction() {
        delegate?.cancelOrderAction()
    }
}
