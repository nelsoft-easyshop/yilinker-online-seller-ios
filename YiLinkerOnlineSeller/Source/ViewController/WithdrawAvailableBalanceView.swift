//
//  WithdrawAvailableBalanceView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol AvailableBalanceDelegate {
    func gotoPayoutSummary(view: WithdrawAvailableBalanceView)
}

class WithdrawAvailableBalanceView: UIView {

    @IBOutlet weak var availableBalanceLabel: UILabel!
    
    var delegate: AvailableBalanceDelegate?
    
    override func awakeFromNib() {
        self.frame.size.width = UIScreen.mainScreen().bounds.width
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "gotoPayoutSummary:"))
    }
    
    func gotoPayoutSummary(gesture: UIGestureRecognizer) {
        delegate?.gotoPayoutSummary(self)
    }
    
    func setAvailableBalance(balance: Int) {
        self.availableBalanceLabel.text = "P " + String(balance)
    }

}
