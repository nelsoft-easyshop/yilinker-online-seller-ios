//
//  SignInViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileImageView: UIView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeView: UIView!
    @IBOutlet weak var rememberMeImageView: UIImageView!
   
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var viewsContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        costumizeViews()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard:"))
        self.profileContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "instantSignin:"))
        self.rememberMeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "rememberMeAction:"))
        
        self.emailAddressTextField.addTarget(self, action: "emailDidTextChanged", forControlEvents: UIControlEvents.EditingChanged)
        self.passwordTextField.addTarget(self, action: "passwordDidTextChanged", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    // MARK: - Methods
    
    func costumizeViews() {
        self.profileContainerView.layer.cornerRadius = self.profileContainerView.frame.size.height / 2
        
        self.rememberMeImageView.layer.cornerRadius = 3.0
        self.rememberMeImageView.layer.borderWidth = 0.5
        self.rememberMeImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        self.signInButton.layer.cornerRadius = 2.0
    }
    
    // MARK: Actions
    
    @IBAction func forgotPasswordAction(sender: AnyObject) {
        
    }
    
    @IBAction func signInAction(sender: AnyObject) {
        self.signInButton.setTitle("SIGNING IN ....", forState: .Normal)
    }
    
    func rememberMeAction(gesture: UIGestureRecognizer) {
        if self.rememberMeImageView.image != nil {
            self.rememberMeImageView.image = nil
            self.rememberMeImageView.backgroundColor = UIColor.clearColor()
        } else {
            self.rememberMeImageView.image = UIImage(named: "check2")
            self.rememberMeImageView.backgroundColor = .lightGrayColor()
        }
    }
    
    func instantSignin(gesture: UIGestureRecognizer) {
        
    }
    
    func hideKeyboard(gesture: UIGestureRecognizer) {
        self.emailAddressTextField.endEditing(true)
        self.passwordTextField.endEditing(true)
        
        if self.view.frame.height <= 568 {
            self.viewsContainer.transform = CGAffineTransformMakeTranslation(0, 0)
            self.profileContainerView.hidden = false
        }
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if self.view.frame.height <= 568 {
            self.viewsContainer.transform = CGAffineTransformMakeTranslation(0, -135)
            self.profileContainerView.hidden = true
        }
    }
    
    func emailDidTextChanged() {
        
    }
    
    func passwordDidTextChanged() {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.Next {
            self.passwordTextField.becomeFirstResponder()
        } else if textField.returnKeyType == UIReturnKeyType.Done {
            self.passwordTextField.endEditing(true)
        }
        
        return true
    }
    
}
