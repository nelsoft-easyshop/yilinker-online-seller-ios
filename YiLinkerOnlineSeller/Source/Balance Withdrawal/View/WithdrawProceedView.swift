//
//  WithdrawProceedView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol WithdrawProceedViewDelegate {
    func proceedAction(view: WithdrawProceedView)
}

class WithdrawProceedView: UIView {

    @IBOutlet weak var proceedButton: UIButton!
    
    var delegate: WithdrawProceedViewDelegate?
    
    override func awakeFromNib() {
        self.frame.size.width = UIScreen.mainScreen().bounds.width
        self.proceedButton.layer.cornerRadius = 5.0
        self.proceedButton.setTitle(PayoutStrings.withdrawalProceed, forState: .Normal)
    }

    @IBAction func proceedAction(sender: AnyObject) {
        if proceedButton.backgroundColor != UIColor.lightGrayColor() {
            delegate?.proceedAction(self)
        }
    }

}
