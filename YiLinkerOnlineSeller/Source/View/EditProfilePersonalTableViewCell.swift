//
//  EditProfilePersonalTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 2/17/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol EditProfilePersonalTableViewCellDelegate {
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, textFieldShouldReturn textField: UITextField)
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, didTapSendVerification button: UIButton)
}

class EditProfilePersonalTableViewCell: UITableViewCell {
    
    var delegate: EditProfilePersonalTableViewCellDelegate?

    @IBOutlet weak var personalInformationLabel: UILabel!
    @IBOutlet weak var mobilePhoneLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tinLabel: UILabel!
    @IBOutlet weak var tinIDLabel: UILabel!
    
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var tinTextField: UITextField!
    
    @IBOutlet weak var sendVerificationButton: UIButton!
    
    var storeInfo: StoreInfoModel?
    var isEmailVerified: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeViews()
    }
    
    func initializeViews() {
        self.mobilePhoneTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
//        self.emailTextField.delegate = self
        self.tinTextField.delegate = self
        
        //Set button to round rect
        self.sendVerificationButton.layer.cornerRadius = 5
    }
    
    func passValue(storeInfo: StoreInfoModel) {
        self.storeInfo = storeInfo
        
        if storeInfo.contact_number.isNotEmpty() {
            self.mobilePhoneTextField.text = storeInfo.contact_number
            self.mobilePhoneTextField.enabled = false
            self.mobilePhoneTextField.alpha = 0.8
        }
        
        self.firstNameTextField.text = storeInfo.firstName
        self.lastNameTextField.text = storeInfo.lastName
        self.emailTextField.text = storeInfo.email
        self.tinTextField.text = storeInfo.tin
        
        self.sendVerificationButton(self.isEmailVerified)
    }
    
    func sendVerificationButton(isVerified: Bool) {
        if isVerified {
            self.sendVerificationButton.enabled = false
            self.sendVerificationButton.backgroundColor = Constants.Colors.uploadViewColor
            self.sendVerificationButton.setTitle("VERIFIED", forState: .Normal)
        } else {
            self.sendVerificationButton.enabled = true
            self.sendVerificationButton.backgroundColor = Constants.Colors.grayText
            self.sendVerificationButton.setTitle("SEND VERIFICATION", forState: .Normal)
        }
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        self.delegate?.editProfilePersonalCell(self, didTapSendVerification: sender)
    }
    
    @IBAction func textFieldAction(sender: UITextField) {
        if sender == self.emailTextField {
            if sender.text != self.storeInfo?.email {
                self.sendVerificationButton(false)
            } else {
                if self.isEmailVerified {
                    self.sendVerificationButton(true)
                }
            }
        }
    }
}

//MARK: -
//MARK: - TextField Delegate
extension EditProfilePersonalTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.editProfilePersonalCell(self, textFieldShouldReturn: textField)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == self.emailTextField {
            if textField.text != self.storeInfo?.email {
                self.sendVerificationButton(false)
            } else {
                if self.isEmailVerified {
                    self.sendVerificationButton(true)
                }
            }
        }
        return true
    }
}
