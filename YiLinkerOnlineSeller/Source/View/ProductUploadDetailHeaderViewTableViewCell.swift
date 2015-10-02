//
//  ProductUploadDetailHeaderViewTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadDetailHeaderViewTableViewCellDelegate {
    func productUploadDetailHeaderViewTableViewCell(didEndEditing productUploadDetailHeaderViewTableViewCell: ProductUploadDetailHeaderViewTableViewCell, text: String)
}

class ProductUploadDetailHeaderViewTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellTextField: UITextField!
    
    @IBOutlet weak var detailNameLabel: UILabel!
    var delegate: ProductUploadDetailHeaderViewTableViewCellDelegate?
    var edited: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellTextField.becomeFirstResponder()
        self.cellTextField.delegate = self
        
        self.detailNameLabel.text = ProductUploadStrings.detailName
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if !edited {
            self.delegate?.productUploadDetailHeaderViewTableViewCell(didEndEditing: self, text: self.cellTextField.text)
        }
    }
}
