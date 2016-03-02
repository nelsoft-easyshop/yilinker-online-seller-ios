//
//  WithdrawContactCSR.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/9/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WithdrawContactCSR: UIView {

    @IBOutlet weak var contactCSR: UILabel!
    
    override func awakeFromNib() {
        self.frame.size.width = UIScreen.mainScreen().bounds.width
        
        self.contactCSR.text = PayoutStrings.withdrawalContactCSR
    }

}
