//
//  LoginTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 1/26/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol LoginTableViewCellDelegate {
    func loginTableViewCell(loginTableViewCell: LoginTableViewCell, textFieldShouldReturn textField: UITextField)
    func loginTableViewCell(loginTableViewCell: LoginTableViewCell, didTapSignIn signInButton: UIButton)
    func loginTableViewCell(loginTableViewCell: LoginTableViewCell, didTapSuccessOnFacebookSignIn facebookButton: UIButton)
    func loginTableViewCell(loginTableViewCell: LoginTableViewCell, didTapForgotPassword forgotPasswordButton: UIButton)
}

class LoginTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var siginInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var orLabel: UILabel!
    
    var delegate: LoginTableViewCellDelegate?
    
    var hud: MBProgressHUD?
    var mainController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.siginInButton.layer.cornerRadius = 5
        
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
        
        self.emailTextField.placeholder = LoginStrings.enterEmailAddress
        self.passwordTextField.placeholder = LoginStrings.enterPassword
        self.orLabel.text = LoginStrings.or
        self.forgotPasswordButton.setTitle(LoginStrings.forgotPasswordd, forState: UIControlState.Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - 
    //MARK: - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.loginTableViewCell(self, textFieldShouldReturn: textField)
        return true
    }
    
    //MARK: - 
    //MARK: - SignIn
    @IBAction func signIn(sender: UIButton) {
        self.delegate?.loginTableViewCell(self, didTapSignIn: sender)
    }
    
    
    //MARK: - 
    //MARK: - Forgot Password
    @IBAction func forgotPassword(sender: UIButton) {
        self.delegate?.loginTableViewCell(self, didTapForgotPassword: sender)
    }
}
