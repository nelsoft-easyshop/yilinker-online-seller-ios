//
//  ProductUploadTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Delegate
// ProductUploadPriceTableViewCell Delegate methods
protocol ProductUploadPriceTableViewCellDelegate {
    func productUploadPriceTableViewCell(textFieldDidChange text: String, cell: ProductUploadPriceTableViewCell, textFieldType: ProductTextFieldType)
}

class ProductUploadPriceTableViewCell: UITableViewCell {

    // Labels 
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var cellTextField: UITextField!
    
    var textFieldType: ProductTextFieldType?
    
    var delegate: ProductUploadPriceTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTextFieldDelegate()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Private methods
    // Add textfield action
    func addTextFieldDelegate() {
        self.cellTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    // MARK: Textfield delegate method
    func textFieldDidChange(sender: UITextField) {
        self.delegate!.productUploadPriceTableViewCell(textFieldDidChange: sender.text, cell: self, textFieldType: self.textFieldType!)
    }
    
}
