//
//  ProductUploadProductGroupTextFieldTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 6/3/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

// Constant 
struct ProductUploadProductGroupTextFieldTableViewCellConstant {
    static let productUploadProductGroupTextFieldTableViewCellNibAndIdentifier = "ProductUploadProductGroupTextFieldTableViewCell"
}

// Delegate
protocol ProductUploadProductGroupTextFieldTableViewCellDelegate {
    func productUploadTextFieldTableViewCell(textFieldDidChange text: String, cell: ProductUploadProductGroupTextFieldTableViewCell)
}

class ProductUploadProductGroupTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var productGroupTextField: UITextField!
    @IBOutlet weak var toolTipLabel: UILabel!
    
    var delegate: ProductUploadProductGroupTextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.productGroupTextField.delegate = self
        self.toolTipLabel.text = StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_PRODUCT_GROUP_TOOLTIP_LOCALIZE_KEY")
        self.productGroupTextField.placeholder = StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_PRODUCT_GROUP_LOCALIZE_KEY")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate!.productUploadTextFieldTableViewCell(textFieldDidChange: textField.text, cell: self)
        self.productGroupTextField.text = ""
        self.productGroupTextField.becomeFirstResponder()
        return true
    }
    
}
