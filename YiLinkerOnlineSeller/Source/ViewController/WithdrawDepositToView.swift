//
//  WithdrawDepositToView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WithdrawDepositToView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var chequeLabel: UILabel!
    @IBOutlet weak var depositToTextLabel: UILabel!
    
    override func awakeFromNib() {
        self.frame.size.width = UIScreen.mainScreen().bounds.width
        
        self.depositToTextLabel.text = PayoutStrings.withdrawalDepositTo
    }

}
