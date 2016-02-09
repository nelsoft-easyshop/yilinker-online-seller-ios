//
//  WithdrawAmountView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol WithdrawAmountViewDelegate {
    func amountDidChanged(view: WithdrawAmountView)
}

class WithdrawAmountView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var aboveLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var delegate: WithdrawAmountViewDelegate?
    
    var availableBalanceView: WithdrawAvailableBalanceView!
    
    override func awakeFromNib() {
        self.frame.size.width = UIScreen.mainScreen().bounds.width
        amountTextField.delegate = self
        
        var leftPadding: UIView = UIView(frame: CGRectMake(0, 0, 12, 0))
        leftPadding.backgroundColor = .whiteColor()
        amountTextField.leftView = leftPadding
        amountTextField.leftViewMode = UITextFieldViewMode.Always
        amountTextField.layer.cornerRadius = 3.0
        amountTextField.addTarget(self, action: "amountDidTextChanged", forControlEvents: UIControlEvents.EditingChanged)
        amountTextField.addToolBarWithDoneTarget(self, done: "keyboardDoneAction")
        
        aboveLabel.text = PayoutStrings.withdrawalAmount + ":"
        bottomLabel.text = PayoutStrings.withdrawalAmountCharge
        aboveLabel.required()
    }
    
    func amountDidTextChanged() {
        delegate?.amountDidChanged(self)
    }
    
    func keyboardDoneAction() {
        amountTextField.resignFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let countdots = textField.text.componentsSeparatedByString(".").count - 1
        
        if countdots > 0 && string == "." {
            return false
        }
        
        return true
    }
    
}
