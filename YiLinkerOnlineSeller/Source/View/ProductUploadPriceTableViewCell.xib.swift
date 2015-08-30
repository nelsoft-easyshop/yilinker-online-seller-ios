//
//  ProductUploadTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadPriceTableViewCellDelegate {
    func productUploadPriceTableViewCell(textFieldDidChange text: String, cell: ProductUploadPriceTableViewCell, textFieldType: ProductTextFieldType)
}

class ProductUploadPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    var delegate: ProductUploadPriceTableViewCellDelegate?
    var textFieldType: ProductTextFieldType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTextFieldDelegate()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addTextFieldDelegate() {
        self.cellTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func textFieldDidChange(sender: UITextField) {
        self.delegate!.productUploadPriceTableViewCell(textFieldDidChange: sender.text, cell: self, textFieldType: self.textFieldType!)
    }
    
}
