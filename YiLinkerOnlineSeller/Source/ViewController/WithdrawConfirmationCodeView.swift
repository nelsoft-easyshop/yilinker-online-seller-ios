//
//  WithdrawConfirmationCodeView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WithdrawConfirmationCodeView: UIView {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var getCodeButton: UIButton!
    
    override func awakeFromNib() {
        self.frame.size.width = UIScreen.mainScreen().bounds.width
        self.codeTextField.layer.cornerRadius = 3.0
        self.getCodeButton.layer.cornerRadius = 3.0
    }

    @IBAction func getCodeAction(sender: AnyObject) {
    }
}
