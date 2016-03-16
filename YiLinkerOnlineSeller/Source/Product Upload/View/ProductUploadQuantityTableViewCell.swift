//
//  ProductUploadQuantityTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Delegate
// ProductUploadQuantityTableViewCell Delegate methods
protocol ProductUploadQuantityTableViewCellDelegate {
    func productUploadQuantityTableViewCell(textFieldDidChange text: String, cell: ProductUploadQuantityTableViewCell)
}

class ProductUploadQuantityTableViewCell: UITableViewCell, UITextFieldDelegate {

    // Textfields
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var cellLabel: UILabel!
    
    // Initialize ProductUploadQuantityTableViewCellDelegate
    var delegate: ProductUploadQuantityTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialize cell's textfield
        self.cellTextField.delegate = self
        self.cellTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.cellLabel.text = ProductUploadStrings.quantity
        
        // Append asterisk (*) in label's text
        self.cellLabel.required()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Textfield delegate methods
    func textFieldDidChange(sender: UITextField) {
        self.delegate!.productUploadQuantityTableViewCell(textFieldDidChange: sender.text, cell: self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.cellTextField.endEditing(true)
        return true
    }
}
