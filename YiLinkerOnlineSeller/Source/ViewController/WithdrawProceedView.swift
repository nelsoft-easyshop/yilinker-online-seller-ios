//
//  WithdrawProceedView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WithdrawProceedView: UIView {

    @IBOutlet weak var proceedButton: UIButton!
    
    override func awakeFromNib() {
        self.frame.size.width = UIScreen.mainScreen().bounds.width
        self.proceedButton.layer.cornerRadius = 5.0
    }

    @IBAction func proceedAction(sender: AnyObject) {
    
    }

}
