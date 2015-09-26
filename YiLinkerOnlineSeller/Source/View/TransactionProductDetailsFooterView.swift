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
    
    override func awakeFromNib() {
        initializesViews()
    }
    
    func initializesViews() {
        cancelOrderView.layer.cornerRadius = cancelOrderView.frame.height / 2
        var cancelOrder = UITapGestureRecognizer(target:self, action:"cancelOrderAction")
        cancelOrderView.addGestureRecognizer(cancelOrder)
    }
    
    func cancelOrderAction() {
        delegate?.cancelButtonOrderAction()
    }


}
