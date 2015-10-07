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
    
    
    @IBOutlet weak var shipItem2View: UIView!
    @IBOutlet weak var shiptItem2Label: UILabel!
    @IBOutlet weak var cancelOrder2View: UIView!
    @IBOutlet weak var cancelOrder2Label: UILabel!
    
    override func awakeFromNib() {
        initializesViews()
        intializeLocalizedStrings()
    }
    
    func initializesViews() {
        shipItemView.layer.cornerRadius = shipItemView.frame.height / 2
        cancelOrderView.layer.cornerRadius = cancelOrderView.frame.height / 2
        
        var shipItem = UITapGestureRecognizer(target:self, action:"shipItemAction")
        shipItemView.addGestureRecognizer(shipItem)
        shipItem2View.addGestureRecognizer(shipItem)
        
        var cancelOrder = UITapGestureRecognizer(target:self, action:"cancelOrderAction")
        cancelOrderView.addGestureRecognizer(cancelOrder)
        cancelOrder2View.addGestureRecognizer(cancelOrder)
    }
    
    func intializeLocalizedStrings() {
        shipItemLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_SHIP_ITEM_LOCALIZE_KEY")
        shiptItem2Label.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_SHIP_ITEM_LOCALIZE_KEY")
        cancelOrderLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_CANCEL_ORDER_LOCALIZE_KEY")
        cancelOrder2Label.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_CANCEL_ORDER_LOCALIZE_KEY")
    }
    
    func shipItemAction() {
        delegate?.shipItemAction()
    }

    func cancelOrderAction() {
        delegate?.cancelOrderAction()
    }
    
    func setStatus(isShippable: Bool, isCancellable: Bool){
        if isShippable && isCancellable {
            shipItemView.hidden = false
            cancelOrderView.hidden = false
            shipItem2View.hidden = true
            cancelOrder2View.hidden = true
        } else if !isShippable && !isCancellable {
            shipItemView.hidden = false
            cancelOrderView.hidden = false
            shipItem2View.hidden = false
            cancelOrder2View.hidden = false
        } else if !isShippable && isCancellable {
            shipItemView.hidden = false
            cancelOrderView.hidden = false
            shipItem2View.hidden = false
            cancelOrder2View.hidden = true
        } else if isShippable && !isCancellable {
            shipItemView.hidden = false
            cancelOrderView.hidden = false
            shipItem2View.hidden = true
            cancelOrder2View.hidden = false
        }
    }
}
