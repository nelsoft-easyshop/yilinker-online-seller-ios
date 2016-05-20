//
//  ProductCombination2TableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 4/21/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol ProductCombination2TableViewCellDelegate {
    func getText(view: ProductCombination2TableViewCell, section: Int, text: String, isOriginalPrice: Bool)
}

class ProductCombination2TableViewCell: UITableViewCell {

    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var originalTextField: UITextField!
    @IBOutlet weak var discountTextField: UITextField!
    
    var delegate: ProductCombination2TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ProductCombination2TableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == originalTextField {
            delegate?.getText(self, section: self.tag, text: textField.text, isOriginalPrice: true)
        } else {
            delegate?.getText(self, section: self.tag, text: textField.text, isOriginalPrice: false)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        
        return true
    }
}

