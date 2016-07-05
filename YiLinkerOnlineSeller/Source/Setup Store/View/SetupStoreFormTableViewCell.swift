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
    
    @IBOutlet weak var baseUrlLabel: UILabel!
    @IBOutlet weak var storeLinkTextField: UITextField!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var storeDescriptionTextView: UITextView!
    
    @IBOutlet weak var storeInfoLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeDescriptionLabel: UILabel!
    @IBOutlet weak var storeLinkLabel: UILabel!
    
    
    var delegate: SetupStoreFormTableViewCellDelegate?
    
    class func nibNameAndIdentifier() -> String {
        return "SetupStoreFormTableViewCell"
    }
    
    class func height() -> CGFloat {
        return 330.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.storeLinkTextField.delegate = self
        self.storeNameTextField.delegate = self
        self.storeDescriptionTextView.delegate = self
        
        self.storeDescriptionTextView.layer.cornerRadius = 5
        
        self.storeLinkTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        self.storeInfoLabel.text = StringHelper.localizedStringWithKey("SETUP_STORE_INFORMATION_LOCALIZE_KEY")
        self.storeNameLabel.text = StringHelper.localizedStringWithKey("SETUP_STORE_NAME_LOCALIZE_KEY")
        self.storeDescriptionLabel.text = StringHelper.localizedStringWithKey("SETUP_STORE_DESCRIPTION_LOCALIZE_KEY")
        self.storeLinkLabel.text = StringHelper.localizedStringWithKey("SETUP_STORE_LINK_LOCALIZE_KEY")
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
        
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "\n" {
            self.delegate?.setupStoreFormTableViewCell(self, didTapReturnInTextViewtextField: textView)
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        self.delegate?.setupStoreFormTableViewCell(self, didTextViewChange: textView)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
         self.delegate?.setupStoreFormTableViewCell(self, didTextFieldChange: textField)
    }
    
    //MARK: - 
    //MARK: - Text Field Did Change
    func textFieldDidChange(textField: UITextField) {
        self.delegate?.setupStoreFormTableViewCell(self, didTextFieldChange: textField)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
       
        return true
    }
}
