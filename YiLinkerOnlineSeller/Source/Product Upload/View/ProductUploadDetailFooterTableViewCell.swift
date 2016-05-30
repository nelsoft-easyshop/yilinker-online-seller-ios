//
//  ProductUploadDetailFooterTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Delegate
// ProductUploadDetailFooterTableViewCell Delegate methods
protocol ProductUploadDetailFooterTableViewCellDelegate {
    func productUploadDetailFooterTableViewCell(cell: ProductUploadDetailFooterTableViewCell, didSelectButton button: UIButton)
    func productUploadDetailFooterTableViewCell(didPressDoneButton cell: ProductUploadDetailFooterTableViewCell)
    func productUploadDetailFooterTableViewCell(didPressSaveButton cell: ProductUploadDetailFooterTableViewCell)
    func productUploadDetailFooterTableViewCell(didPressCancelButton cell: ProductUploadDetailFooterTableViewCell)
}

class ProductUploadDetailFooterTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    // Custom buttons
    @IBOutlet weak var cellButton: DynamicRoundedButton!
    @IBOutlet weak var saveButton: DynamicRoundedButton!
    @IBOutlet weak var cancelButton: DynamicRoundedButton!
    
    // Labels
    @IBOutlet weak var valuesLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var cellTextField: UITextField!
    
    // Initialize ProductUploadDetailFooterTableViewCellDelegate
    var delegate: ProductUploadDetailFooterTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellTextField.delegate = self
        
        self.cellButton.setTitle(ProductUploadStrings.save, forState: UIControlState.Normal)
        self.valuesLabel.text = ProductUploadStrings.values
        self.cellTextField.placeholder = ProductUploadStrings.valuesPlaceholder
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Button actions
    @IBAction func save(sender: UIButton) {
          self.delegate!.productUploadDetailFooterTableViewCell(didPressSaveButton: self)
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.delegate!.productUploadDetailFooterTableViewCell(didPressCancelButton: self)
    }
    
    // MARK: Textfield data source method
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if self.cellTextField.isNotEmpty() {
            self.delegate?.productUploadDetailFooterTableViewCell(didPressDoneButton: self)
        } else {
            self.cellTextField.endEditing(true)
        }

        return true
    }
}
