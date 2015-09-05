//
//  ProductUploadDetailFooterTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadDetailFooterTableViewCellDelegate {
    func productUploadDetailFooterTableViewCell(cell: ProductUploadDetailFooterTableViewCell, didSelectButton button: UIButton)
    func productUploadDetailFooterTableViewCell(didPressDoneButton cell: ProductUploadDetailFooterTableViewCell)
    func productUploadDetailFooterTableViewCell(didPressSaveButton cell: ProductUploadDetailFooterTableViewCell)
}

class ProductUploadDetailFooterTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var cellTextField: UITextField!
    var delegate: ProductUploadDetailFooterTableViewCellDelegate?
    @IBOutlet weak var cellButton: DynamicRoundedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellTextField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func save(sender: UIButton) {
          self.delegate!.productUploadDetailFooterTableViewCell(didPressSaveButton: self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.cellTextField.isNotEmpty() {
            self.delegate?.productUploadDetailFooterTableViewCell(didPressDoneButton: self)
        } else {
            self.cellTextField.endEditing(true)
        }

        return true
    }
}
