//
//  ProductUploadDetailHeaderViewCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadDetailHeaderViewCollectionViewCellDelegate {
    func productUploadDetailHeaderViewCollectionViewCell(editingCellTextFieldWithText text: String)
}

class ProductUploadDetailHeaderViewCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellTextField: UITextField!
    
    var delegate: ProductUploadDetailHeaderViewCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellTextField.delegate = self
    }
    
    func trackEditingText() {
        self.cellTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func textFieldDidChange(sender: UITextField) {
        self.delegate!.productUploadDetailHeaderViewCollectionViewCell(editingCellTextFieldWithText: sender.text)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
}
