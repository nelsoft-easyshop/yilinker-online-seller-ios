//
//  ProductUploadDetailHeaderViewTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductUploadDetailHeaderViewTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellTextField.becomeFirstResponder()
        self.cellTextField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
}
