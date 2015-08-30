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
    @IBOutlet weak var profileImageView: UIImageView!
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
        self.addCheckInTextField(emailAddressTextField)
        self.addCheckInTextField(passwordTextField)
    }
    
    // MARK: - Methods
    
    func costumizeViews() {
        self.profileContainerView.layer.cornerRadius = self.profileContainerView.frame.size.height / 2
        
        self.rememberMeImageView.layer.cornerRadius = 3.0
        self.rememberMeImageView.layer.borderWidth = 0.5
        self.rememberMeImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        self.signInButton.layer.cornerRadius = 2.0
    }
    
    func addCheckInTextField(field: UITextField) {
        var check = UIImageView(image: UIImage(named: "valid"))
        check.frame = CGRectMake(0.0, 0.0, check.image!.size.width + 10.0, check.image!.size.height)
        check.contentMode = UIViewContentMode.Center
        field.rightView = check
        field.rightViewMode = UITextFieldViewMode.Always
        field.rightView?.hidden = true
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func forgotPasswordAction(sender: AnyObject) {
        
    }
    
    @IBAction func signInAction(sender: AnyObject) {
        if self.emailAddressTextField.rightView?.hidden == false && self.passwordTextField.rightView?.hidden == false {
            self.signInButton.setTitle("SIGNING IN ....", forState: .Normal)
            self.requestSignin()
        } else {
            showAlert(title: "Error", message: "Please input valid email and password.")
        }
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
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["email": "seller@easyshop.ph",
            "password": "password",
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantSeller]
        
        manager.POST(APIAtlas.loginUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.signinSuccessful()
            self.dismissViewControllerAnimated(true, completion: nil)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.signInButton.setTitle("SIGN IN", forState: .Normal)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 1011 {
                    self.showAlert(title: "Error", message: "Email and Password did not match.")
                } else {
                    self.showAlert(title: "Error", message: "Something went wrong")
                }
                SVProgressHUD.dismiss()
        })
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
        
        if textField == self.emailAddressTextField {
            textField.layer.borderWidth = 1.0
            textField.layer.cornerRadius = 3.0
        } else if textField == self.passwordTextField {
            textField.layer.borderWidth = 1.0
            textField.layer.cornerRadius = 3.0
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.emailAddressTextField {
            textField.layer.borderWidth = 0.0
        } else if textField == self.passwordTextField {
            textField.layer.borderWidth = 0.0
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.Next {
            self.passwordTextField.becomeFirstResponder()
        } else if textField.returnKeyType == UIReturnKeyType.Done {
            self.passwordTextField.endEditing(true)
            if self.view.frame.height <= 568 {
                self.viewsContainer.transform = CGAffineTransformMakeTranslation(0, 0)
                self.profileContainerView.hidden = false
            }
        }
        
        return true
    }
    
    func emailDidTextChanged() {
        if self.emailAddressTextField.isValidEmail() {
            self.emailAddressTextField.rightView?.hidden = false
        } else {
            self.emailAddressTextField.rightView?.hidden = true
        }
    }
    
    func passwordDidTextChanged() {
        if self.passwordTextField.isAlphaNumeric() && count(self.passwordTextField.text) > 5 {
            self.passwordTextField.rightView?.hidden = false
        } else {
            self.passwordTextField.rightView?.hidden = true
        }
    }
    
    // MARK: - Requests
    
    func requestSignin() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["email": self.emailAddressTextField.text,
            "password": self.passwordTextField.text,
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantSeller]
        
        manager.POST(APIAtlas.loginUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            
            self.hideKeyboard(UIGestureRecognizer())
            self.signInButton.setTitle("Welcome to YiLinker!", forState: .Normal)
            SVProgressHUD.dismiss()
            self.signinSuccessful()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.signInButton.setTitle("SIGN IN", forState: .Normal)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 1011 {
                    self.showAlert(title: "Error", message: "Email and Password did not match.")
                } else {
                    self.showAlert(title: "Error", message: "Something went wrong")
                }
                SVProgressHUD.dismiss()
        })
    }
    
    func signinSuccessful() {
        
        if self.rememberMeImageView.image != nil {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "rememberMe")
        } else {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "rememberMe")
        }
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let imageUrl: NSURL = NSURL(string: "http://cdn-www.xda-developers.com/wp-content/uploads/2011/10/beats-by_dr_dre-04.jpg")!
        self.profileImageView.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "dummy-placeholder"))
        self.profileImageView.frame = self.profileContainerView.bounds
        self.profileImageView.contentMode = .ScaleAspectFill

        SVProgressHUD.dismiss()
        
        let delay = 1.0 * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })

    }
    
}

extension UITextField {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self.text)
    }
    
    func isAlphaNumeric() -> Bool {
        let passwordRegEx = "[A-Za-z0-9_]*"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluateWithObject(self.text)
    }
}
