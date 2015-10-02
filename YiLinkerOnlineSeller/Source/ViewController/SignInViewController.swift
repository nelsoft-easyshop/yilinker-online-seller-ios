//
//  SignInViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct SignInStrings {
    static let motto = StringHelper.localizedStringWithKey("MOTTO_LOCALIZE_KEY")
    static let emailPlaceholder = StringHelper.localizedStringWithKey("EMAIL_PLACEHOLDER_LOCALIZE_KEY")
    static let passwordPlaceholder = StringHelper.localizedStringWithKey("PASSWORD_PLACEHOLDER_LOCALIZE_KEY")
    static let rememberMe = StringHelper.localizedStringWithKey("REMEMBER_ME_LOCALIZE_KEY")
    static let forgot = StringHelper.localizedStringWithKey("FORGOT_LOCALIZE_KEY")
    static let signin = StringHelper.localizedStringWithKey("SIGN_IN_LOCALIZE_KEY")
    static let signingin = StringHelper.localizedStringWithKey("SIGNING_IN_LOCALIZE_KEY")
    static let welcome = StringHelper.localizedStringWithKey("WELCOME_LOCALIZE_KEY")
    static let please = StringHelper.localizedStringWithKey("PLEASE_INPUT_LOCALIZE_KEY")
    static let notMatch = StringHelper.localizedStringWithKey("NOT_MATCH_LOCALIZE_KEY")
    static let alertLogout = StringHelper.localizedStringWithKey("LOGOUT_LOCALIZE_KEY")
    static let alertLogoutMessage = StringHelper.localizedStringWithKey("LOGOUT_MESSAGE_LOCALIZE_KEY")
}

protocol SignInViewControllerDelegate{
    func passStoreInfoModel(storeInfoModel: StoreInfoModel)
}

class SignInViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    
    var delegate: SignInViewControllerDelegate?
    
    @IBOutlet weak var mottoLabel: UILabel!
    @IBOutlet weak var rememberMeLabel: UILabel!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeView: UIView!
    @IBOutlet weak var rememberMeImageContainerView: UIView!
    @IBOutlet weak var rememberMeImageView: UIImageView!
   
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var viewsContainer: UIView!
    
    var hud: MBProgressHUD?
    
    var storeInfoModel: StoreInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        costumizeViews()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard:"))
        //self.profileContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "instantSignin:"))
        self.rememberMeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "rememberMeAction:"))
        
        self.emailAddressTextField.addTarget(self, action: "emailDidTextChanged", forControlEvents: UIControlEvents.EditingChanged)
        self.passwordTextField.addTarget(self, action: "passwordDidTextChanged", forControlEvents: UIControlEvents.EditingChanged)
        self.addCheckInTextField(emailAddressTextField)
        self.addCheckInTextField(passwordTextField)
    }
    
    // Show hud
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    // MARK: - Methods
    
    func costumizeViews() {
        self.profileContainerView.layer.cornerRadius = self.profileContainerView.frame.size.height / 2
        
        self.rememberMeImageContainerView.layer.cornerRadius = 3.0
        self.rememberMeImageContainerView.layer.borderWidth = 0.5
        
        self.signInButton.layer.cornerRadius = 2.0
        
        self.mottoLabel.text = SignInStrings.motto
        self.emailAddressTextField.placeholder = SignInStrings.emailPlaceholder
        self.passwordTextField.placeholder = SignInStrings.passwordPlaceholder
        self.rememberMeLabel.text = SignInStrings.rememberMe
        self.forgotPasswordButton.setTitle(SignInStrings.forgot, forState: .Normal)
        self.signInButton.setTitle(SignInStrings.signin, forState: .Normal)
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
            if Reachability.isConnectedToNetwork() {
                self.signInButton.setTitle(SignInStrings.signingin, forState: .Normal)
                self.requestSignin()
            } else {
                showAlert(title: AlertStrings.failed, message: AlertStrings.checkInternet)
            }
        } else {
            showAlert(title: AlertStrings.error, message: SignInStrings.please)
        }
    }
    
    func rememberMeAction(gesture: UIGestureRecognizer) {
        if self.rememberMeImageView.image != nil {
            self.rememberMeImageView.image = nil
            self.rememberMeImageContainerView.backgroundColor = UIColor.clearColor()
        } else {
            self.rememberMeImageView.image = UIImage(named: "check")
            self.rememberMeImageContainerView.backgroundColor = HexaColor.colorWithHexa(0x54b6a7)
        }
    }
    
    func instantSignin(gesture: UIGestureRecognizer) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isSeller")
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["email": "reseller@easyshop.ph",
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
                self.signInButton.setTitle(SignInStrings.signin, forState: .Normal)
                
                if error.userInfo != nil {
                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                        if jsonResult["error_description"] != nil {
                            let errorDescription: String = jsonResult["error_description"] as! String
                            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorDescription)
                        } else {
                            self.showAlert(title: AlertStrings.error, message: AlertStrings.wentWrong)
                        }
                    }
                } else {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    if task.statusCode == 1011 {
                        self.showAlert(title: AlertStrings.error, message: SignInStrings.notMatch)
                    } else {
                        self.showAlert(title: AlertStrings.error, message: AlertStrings.wentWrong)
                    }
                }
                
                self.hud?.hide(true)
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
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isSeller")
        self.showHUD()
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
            self.signInButton.setTitle(SignInStrings.welcome, forState: .Normal)
            self.signinSuccessful()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.signInButton.setTitle("SIGN IN", forState: .Normal)
                
                if error.userInfo != nil {
                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                        let errorDescription: String = jsonResult["error_description"] as! String
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorDescription)
                    }
                } else {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    if task.statusCode == 1011 {
                        self.showAlert(title: AlertStrings.error, message: SignInStrings.notMatch)
                    } else {
                        self.showAlert(title: AlertStrings.error, message: AlertStrings.wentWrong)
                    }
                }
                
                self.hud?.hide(true)
        })
    }
    
    func signinSuccessful() {
        
//        if self.rememberMeImageView.image != nil {
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "rememberMe")
//        } else {
//            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "rememberMe")
//        }
//        NSUserDefaults.standardUserDefaults().synchronize()
        
        fireStoreInfo()
    }
    
    func setSellerImage(imgURL: NSURL) {
        
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    self.profileImageView.image = UIImage(data: data)
                    self.profileImageView.frame = self.profileContainerView.bounds
                    self.profileImageView.contentMode = .ScaleAspectFill

                    let delay = 1.0 * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    })
                }
        })
        
    }
    
    func fireStoreInfo() {
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.POST(APIAtlas.sellerStoreInfo, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.storeInfoModel = StoreInfoModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
            //self.populateData()
            
//            self.profileImageView.sd_setImageWithURL(self.storeInfoModel?.avatar, placeholderImage: UIImage(named: "dummy-placeholder"))
            self.setSellerImage(self.storeInfoModel!.avatar)
            
            self.hud?.hide(true)
            
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfoModel?.store_name, forKey: "storeName")
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfoModel?.store_address, forKey: "storeAddress")
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfoModel?.totalSales, forKey: "totalSales")
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfoModel?.productCount, forKey: "productCount")
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfoModel?.transactionCount, forKey: "transactionCount")
            
            
            NSUserDefaults.standardUserDefaults().synchronize()
            
//            let delay = 1.0 * Double(NSEC_PER_SEC)  // nanoseconds per seconds
//            var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
//                
//                self.dismissViewControllerAnimated(true, completion: nil)
//                
//            })
            
            self.delegate?.passStoreInfoModel(self.storeInfoModel!)
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error)
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
