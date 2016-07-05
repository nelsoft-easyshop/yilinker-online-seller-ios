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
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, textFieldValueChanged textField: UITextField)
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
    @IBOutlet weak var uploadActivityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var uploadTinIdLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var uploadView: UIView!
    var storeInfo: StoreInfoModel?
    var isEmailVerified: Bool = true
    var isNewUpload: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeViews()
    }
    
    func initializeViews() {
        self.uploadActivityIndicator.hidden = true
        
        self.mobilePhoneTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.tinTextField.delegate = self
        
        //Set button to round rect
        self.remarksButton.layer.cornerRadius = 10
        self.sendVerificationButton.layer.cornerRadius = 5
        self.changePasswordButton.layer.cornerRadius = 5
        self.uploadIDButton.layer.cornerRadius = 5
        
        self.personalInformationLabel.text = EditProfileLocalizedStrings.personalInformation
        self.mobilePhoneLabel.text = EditProfileLocalizedStrings.mobileNumber
        self.firstNameLabel.text = EditProfileLocalizedStrings.firstName
        self.lastNameLabel.text = EditProfileLocalizedStrings.lastName
        self.emailLabel.text = EditProfileLocalizedStrings.emailAddress
        self.passwordLabel.text = EditProfileLocalizedStrings.password
        self.tinLabel.text = EditProfileLocalizedStrings.tin
        self.tinIDLabel.text = EditProfileLocalizedStrings.uploadId
        
        self.sendVerificationButton.setTitle(EditProfileLocalizedStrings.sendVerification.uppercaseString, forState: .Normal)
        self.changePasswordButton.setTitle(EditProfileLocalizedStrings.change.uppercaseString, forState: .Normal)
        self.uploadIDButton.setTitle(EditProfileLocalizedStrings.upload.uppercaseString, forState: .Normal)
        
        self.firstNameLabel.required()
        self.lastNameLabel.required()
        self.emailLabel.required()
        
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
        self.remarksLabel.text = storeInfo.validIdMessage
        
        self.tinTextField.enabled = storeInfo.isBusinessEditable
        
        self.sendVerificationButton(storeInfo.isEmailVerified)
        
        if storeInfo.validIdMessage.isEmpty && storeInfo.validId.isEmpty {
            self.setCheckIconHide(true)
        } else {
            self.setCheckIconHide(false)
        }
        
        if !storeInfo.validId.isEmpty && !storeInfo.validIdMessage.isEmpty {
            self.setUploadViewHidden(false)
            self.setCheckIconHide(true)
        }
        
        if storeInfo.isLegalDocsEditable {
            self.uploadView.hidden = false
            self.setUploadViewHidden(false)
        } else {
            self.uploadView.hidden = true
            self.remarksLabel.text = ""
            self.setUploadViewHidden(true)
        }
        
    }
    
    func setUploadSuccessful(isSuccessful: Bool) {
        self.setCheckIconHide(!isSuccessful)
        if isSuccessful {
            self.remarksLabel.text = EditProfileLocalizedStrings.uploadIdSuccess
        }
    }
    
    func setUploadViewHidden(hide: Bool) {
        if hide {
            self.uploadTinIdLabelConstraint.constant = 0
            self.uploadButtonHeightConstraint.constant = 0
            self.activityIndicatorHeightConstraint.constant = 0
        } else {
            self.uploadTinIdLabelConstraint.constant = 15
            self.uploadButtonHeightConstraint.constant = 30
            self.activityIndicatorHeightConstraint.constant = 20
        }
        self.setCheckIconHide(hide)
    }
    
    func setCheckIconHide(hide: Bool) {
        if hide {
            self.checkIconHeightConstraint.constant = 0
            self.checkIconWidthConstraint.constant = 0
            self.remarksLabel.textColor = UIColor.redColor()
        } else {
            self.checkIconHeightConstraint.constant = 20
            self.checkIconWidthConstraint.constant = 20
            self.remarksLabel.textColor = Constants.Colors.pmPurpleButtonColor
        }
    }
    
    func setUploadRemarksSuccessful(isSuccessful: Bool, text: String) {
        self.remarksLabel.text = text
        if isSuccessful {
            self.checkIconHeightConstraint.constant = 20
            self.checkIconWidthConstraint.constant = 20
        } else {
            self.checkIconHeightConstraint.constant = 0
            self.checkIconWidthConstraint.constant = 0
        }
    }
    
    func sendVerificationButton(isVerified: Bool) {
        if isVerified {
            self.sendVerificationButton.enabled = false
            self.sendVerificationButton.backgroundColor = Constants.Colors.uploadViewColor
            self.sendVerificationButton.setTitle(EditProfileLocalizedStrings.verified.uppercaseString, forState: .Normal)
        } else {
            self.sendVerificationButton.enabled = true
            self.sendVerificationButton.backgroundColor = Constants.Colors.grayText
            self.sendVerificationButton.setTitle(EditProfileLocalizedStrings.sendVerification.uppercaseString, forState: .Normal)
        }
    }
    
    func setActivityIndicationHidden(hidden: Bool) {
        if hidden {
            self.uploadIDButton.setTitle(EditProfileLocalizedStrings.upload.uppercaseString, forState: .Normal)
            self.uploadActivityIndicator.stopAnimating()
            self.uploadActivityIndicator.hidden = hidden
        } else {
            self.uploadIDButton.setTitle(EditProfileLocalizedStrings.uploading.uppercaseString, forState: .Normal)
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
                if self.storeInfo!.isEmailVerified {
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == self.emailTextField {
            if textField.text != self.storeInfo?.email {
                self.sendVerificationButton(false)
            } else {
                if self.isEmailVerified {
                    self.sendVerificationButton(true)
                }
            }
        }
        
        self.delegate?.editProfilePersonalCell(self, textFieldValueChanged: textField)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
        return true
    }
}
