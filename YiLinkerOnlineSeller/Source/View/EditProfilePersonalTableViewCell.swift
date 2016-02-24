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
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, didTapChangePassword button: UIButton)
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, didTapUploadID button: UIButton)
}

class EditProfilePersonalTableViewCell: UITableViewCell {
    
    var delegate: EditProfilePersonalTableViewCellDelegate?

    @IBOutlet weak var personalInformationLabel: UILabel!
    @IBOutlet weak var mobilePhoneLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var tinLabel: UILabel!
    @IBOutlet weak var tinIDLabel: UILabel!
    @IBOutlet weak var remarksLabel: UILabel!
    
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var tinTextField: UITextField!
    
    @IBOutlet weak var sendVerificationButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var remarksButton: UIButton!
    @IBOutlet weak var uploadIDButton: UIButton!
    @IBOutlet weak var remarksConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var remarksView: UIView!
    @IBOutlet weak var uploadActivityIndicator: UIActivityIndicatorView!
    
    var storeInfo: StoreInfoModel?
    var isEmailVerified: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeViews()
    }
    
    func initializeViews() {
        self.uploadActivityIndicator.hidden = true
        
        self.mobilePhoneTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
//        self.emailTextField.delegate = self
        self.tinTextField.delegate = self
        
        //Set button to round rect
        self.remarksButton.layer.cornerRadius = 10
        self.sendVerificationButton.layer.cornerRadius = 5
        self.changePasswordButton.layer.cornerRadius = 5
        self.uploadIDButton.layer.cornerRadius = 5
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
        
        if storeInfo.isBusinessEditable {
            self.tinTextField.enabled = false
        } else {
            self.tinTextField.enabled = true
        }
        
        self.sendVerificationButton(storeInfo.isEmailVerified)
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
    
    func setRemarksStatusHidden(hide: Bool) {
        if hide {
            self.remarksLabel.text = ""
            self.remarksConstraint.constant = 0
            self.remarksView.hidden = hidden
        } else {
            self.remarksConstraint.constant = 20
            self.remarksView.hidden = hidden
        }
    }
    
    func setActivityIndicationHidden(hidden: Bool) {
        if hidden {
            self.uploadActivityIndicator.stopAnimating()
            self.uploadActivityIndicator.hidden = hidden
        } else {
            self.uploadActivityIndicator.startAnimating()
            self.uploadActivityIndicator.hidden = hidden
        }
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        if sender == self.sendVerificationButton {
            self.delegate?.editProfilePersonalCell(self, didTapSendVerification: sender)
        } else if sender == self.uploadIDButton {
            self.delegate?.editProfilePersonalCell(self, didTapUploadID: sender)
        } else if sender == self.changePasswordButton {
            self.delegate?.editProfilePersonalCell(self, didTapChangePassword: sender)
        }
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
