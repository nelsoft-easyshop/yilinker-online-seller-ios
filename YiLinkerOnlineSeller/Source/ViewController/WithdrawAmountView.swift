//
//  WithdrawAmountView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WithdrawAmountView: UIView {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var bottomLabel: UILabel!
    override func awakeFromNib() {
        self.frame.size.width = UIScreen.mainScreen().bounds.width
    }

}
