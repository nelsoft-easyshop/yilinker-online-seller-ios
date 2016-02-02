//
//  WithdrawConfirmationCodeView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol WithdrawConfirmationCodeViewDelegate {
    func getCodeAction(view: WithdrawConfirmationCodeView)
    func codeDidChanged(view: WithdrawConfirmationCodeView)
}

class WithdrawConfirmationCodeView: UIView {

    @IBOutlet weak var confirmationCodeLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var getCodeButton: UIButton!
    
    var delegate: WithdrawConfirmationCodeViewDelegate?
    
    override func awakeFromNib() {
        self.frame.size.width = UIScreen.mainScreen().bounds.width
        self.codeTextField.layer.cornerRadius = 3.0
        self.getCodeButton.layer.cornerRadius = 3.0
        
        codeTextField.addToolBarWithDoneTarget(self, done: "keyboardDoneAction")
        
        var leftPadding: UIView = UIView(frame: CGRectMake(0, 0, 12, 0))
        leftPadding.backgroundColor = .whiteColor()
        codeTextField.leftView = leftPadding
        codeTextField.leftViewMode = UITextFieldViewMode.Always
        
        codeTextField.addTarget(self, action: "codeDidTextChanged", forControlEvents: UIControlEvents.EditingChanged)
        
        confirmationCodeLabel.required()
    }

    @IBAction func getCodeAction(sender: AnyObject) {
        delegate?.getCodeAction(self)
    }
    
    func keyboardDoneAction() {
        if getCodeButton.backgroundColor != UIColor.lightGrayColor() {
            codeTextField.resignFirstResponder()
        }
    }
    
    func codeDidTextChanged() {
        delegate?.codeDidChanged(self)
    }
}
