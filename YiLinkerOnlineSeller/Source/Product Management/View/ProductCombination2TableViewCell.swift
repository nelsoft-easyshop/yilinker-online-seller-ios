//
//  ProductCombination2TableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 4/21/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol ProductCombination2TableViewCellDelegate {
    func getText(view: ProductCombination2TableViewCell, section: Int, text: String, id: Int)
}

class ProductCombination2TableViewCell: UITableViewCell {

    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var commissionLabel: UILabel!
    @IBOutlet weak var originalTextField: UITextField!
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var finalPriceTextField: UITextField!
    @IBOutlet weak var commissionTextField: UITextField!
    
    var delegate: ProductCombination2TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        originalTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        discountTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        finalPriceTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        commissionTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ProductCombination2TableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.getText(self, section: self.tag, text: textField.text, id: textField.tag)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        if textField == self.originalTextField || textField == self.discountTextField {
//            self.finalPriceTextField.text = "\(self.originalTextField.text.doubleValue * self.discountTextField.text.doubleValue / 100)"
            self.finalPriceTextField.text = "\(self.originalTextField.text.doubleValue - (self.originalTextField.text.doubleValue * (self.discountTextField.text.doubleValue / 100)))"
        }
        
        delegate?.getText(self, section: self.tag, text: textField.text, id: textField.tag)
        
    }
    
    func textField(textField: UITextField,shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool {
       
        let countdots = textField.text.componentsSeparatedByString(".").count - 1
        if countdots > 0 && string == "." {
            return false
        }
        
//        let decimalPlaces = textField.text.componentsSeparatedByString(".").count + 2
//        if decimalPlaces > 0 {
//            return false
//        }
        
        return true
    }
    
}

