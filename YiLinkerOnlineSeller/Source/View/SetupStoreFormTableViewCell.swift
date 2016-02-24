//
//  SetupStoreFormTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol SetupStoreFormTableViewCellDelegate {
    func setupStoreFormTableViewCell(setupStoreFormTableViewCell: SetupStoreFormTableViewCell, didTapReturnInTextField textField: UITextField)
    func setupStoreFormTableViewCell(setupStoreFormTableViewCell: SetupStoreFormTableViewCell, didStartEditingAtTextField textField: UITextField)
    func setupStoreFormTableViewCell(setupStoreFormTableViewCell: SetupStoreFormTableViewCell, didTapReturnInTextViewtextField: UITextView)
    func setupStoreFormTableViewCell(setupStoreFormTableViewCell: SetupStoreFormTableViewCell, didTextFieldChange textField: UITextField)
    func setupStoreFormTableViewCell(setupStoreFormTableViewCell: SetupStoreFormTableViewCell, didTextViewChange textView: UITextView)
}

class SetupStoreFormTableViewCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var storeLinkTextField: UITextField!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var storeDescriptionTextView: UITextView!
    
    var delegate: SetupStoreFormTableViewCellDelegate?
    
    class func nibNameAndIdentifier() -> String {
        return "SetupStoreFormTableViewCell"
    }
    
    class func height() -> CGFloat {
        return 320.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.storeLinkTextField.delegate = self
        self.storeNameTextField.delegate = self
        self.storeDescriptionTextView.delegate = self
        
        self.storeDescriptionTextView.layer.cornerRadius = 5
        
        self.storeLinkTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    //MARK: - 
    //MARK: - Text Field Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate?.setupStoreFormTableViewCell(self, didStartEditingAtTextField: textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.setupStoreFormTableViewCell(self, didTapReturnInTextField: textField)
        return true
    }
    
    //MARK: -
    //MARK: - Text View Delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.delegate?.setupStoreFormTableViewCell(self, didTapReturnInTextViewtextField: textView)
            return false
        } else {
            return true
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        self.delegate?.setupStoreFormTableViewCell(self, didTextViewChange: textView)
    }
    
    //MARK: - 
    //MARK: - Text Field Did Change
    func textFieldDidChange(textField: UITextField) {
        self.delegate?.setupStoreFormTableViewCell(self, didTextFieldChange: textField)
    }
}
