//
//  ProductUploadTextFieldTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadTextFieldTableViewCellDelegate {
    func productUploadTextFieldTableViewCell(textFieldDidChange text: String)
}

class ProductUploadTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellTexField: UITextField!
    
    var delegate: ProductUploadTextFieldTableViewCellDelegate?
    var textFieldType: ProductTextFieldType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addTextFieldDelegate() {
        self.cellTexField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func addArrow() {
        self.cellTexField.enabled = false
        self.cellTexField.rightViewMode = UITextFieldViewMode.Always
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldDidChange(sender: UITextField) {
        if self.textFieldType == ProductTextFieldType.Category {
            self.delegate!.productUploadTextFieldTableViewCell(textFieldDidChange: sender.text)
        }
    }
}
