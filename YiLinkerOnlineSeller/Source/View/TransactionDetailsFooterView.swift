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
    
    var shipItem: UITapGestureRecognizer?
    var cancelOrder: UITapGestureRecognizer?
    override func awakeFromNib() {
        initializesViews()
        intializeLocalizedStrings()
    }
    
    func initializesViews() {
        shipItemView.layer.cornerRadius = shipItemView.frame.height / 2
        cancelOrderView.layer.cornerRadius = cancelOrderView.frame.height / 2
        shipItem2View.layer.cornerRadius = shipItemView.frame.height / 2
        cancelOrder2View.layer.cornerRadius = cancelOrderView.frame.height / 2
        
        shipItem = UITapGestureRecognizer(target:self, action:"shipItemAction")
        shipItem2View.addGestureRecognizer(shipItem!)
        shipItemView.addGestureRecognizer(shipItem!)
        
        cancelOrder = UITapGestureRecognizer(target:self, action:"cancelOrderAction")
        cancelOrder2View.addGestureRecognizer(cancelOrder!)
        cancelOrderView.addGestureRecognizer(cancelOrder!)
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
            
            self.bringSubviewToFront(shipItemView)
            self.bringSubviewToFront(cancelOrderView)
            shipItemView.addGestureRecognizer(shipItem!)
            cancelOrderView.addGestureRecognizer(cancelOrder!)
        } else if !isShippable && !isCancellable {
            shipItemView.hidden = true
            cancelOrderView.hidden = true
            shipItem2View.hidden = true
            cancelOrder2View.hidden = true
        } else if !isShippable && isCancellable {
            shipItemView.hidden = true
            cancelOrderView.hidden = true
            shipItem2View.hidden = true
            cancelOrder2View.hidden = false
            
            self.bringSubviewToFront(cancelOrder2View)
            cancelOrder2View.addGestureRecognizer(cancelOrder!)
        } else if isShippable && !isCancellable {
            shipItemView.hidden = true
            cancelOrderView.hidden = true
            shipItem2View.hidden = false
            cancelOrder2View.hidden = true
            
            self.bringSubviewToFront(shipItem2View)
            shipItem2View.addGestureRecognizer(shipItem!)
        }
    }
}
