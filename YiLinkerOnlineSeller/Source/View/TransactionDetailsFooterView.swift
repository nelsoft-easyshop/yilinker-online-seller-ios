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
    
    override func awakeFromNib() {
        initializesViews()
    }
    
    func initializesViews() {
        shipItemView.layer.cornerRadius = shipItemView.frame.height / 2
        cancelOrderView.layer.cornerRadius = cancelOrderView.frame.height / 2
        
        let shipItem = UITapGestureRecognizer(target:self, action:"shipItemAction")
        shipItemView.addGestureRecognizer(shipItem)
        
        let cancelOrder = UITapGestureRecognizer(target:self, action:"cancelOrderAction")
        cancelOrderView.addGestureRecognizer(cancelOrder)
    }
    
    func shipItemAction() {
        delegate?.shipItemAction()
    }

    func cancelOrderAction() {
        delegate?.cancelOrderAction()
    }
}
