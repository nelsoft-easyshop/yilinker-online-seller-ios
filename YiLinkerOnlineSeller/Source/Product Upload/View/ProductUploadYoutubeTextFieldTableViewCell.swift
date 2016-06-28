//
//  ProductUploadYoutubeTextFieldTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Yhel on 6/28/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadYoutubeTextFieldTableViewCellDelegate {
    func productUploadYoutubeTextFieldTableViewCell(textFieldDidChange text: String, cell: ProductUploadYoutubeTextFieldTableViewCell)
}

class ProductUploadYoutubeTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
   
    // Labels
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var cellTexField: UITextField!
    
    // Initialize ProductUploadTextFieldTableViewCellDelegate
    var delegate: ProductUploadYoutubeTextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTextFieldDelegate()
        self.cellTexField.delegate = self
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: -
    // MARK: - Private methods
    // MARK: - Add textfield action
    
    func addTextFieldDelegate() {
        self.cellTexField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    // MARK: -
    // MARK: - Add arrow in textfield
    
    func addArrow() {
        self.cellTexField.enabled = false
        self.cellTexField.rightViewMode = UITextFieldViewMode.Always
    }
    
    func textFieldDidChange(sender: UITextField) {
        self.delegate!.productUploadYoutubeTextFieldTableViewCell(textFieldDidChange: sender.text, cell: self)
    }
    
    // MARK: -
    // MARK: - Textfield delegate methods
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.cellTexField.endEditing(true)
        return true
    }

}