//
//  WithdrawMobileNoView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WithdrawMobileNoView: UIView {

    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        self.frame.size.width = UIScreen.mainScreen().bounds.width
    }

}
