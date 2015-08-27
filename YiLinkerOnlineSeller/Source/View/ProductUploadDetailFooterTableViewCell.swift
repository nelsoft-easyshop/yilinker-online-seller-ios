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
}

class ProductUploadDetailFooterTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var cellTextField: UITextField!
    var delegate: ProductUploadDetailFooterTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellTextField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func save(sender: UIButton) {
          self.delegate!.productUploadDetailFooterTableViewCell(self, didSelectButton: sender)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.productUploadDetailFooterTableViewCell(didPressDoneButton: self)
        return true
    }
}
