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
    static let forgot = StringHelper.localizedStringWithKey("FORGOT_LOCALIZE_KEY")
    static let signin = StringHelper.localizedStringWithKey("SIGN_IN_LOCALIZE_KEY")
    static let signingin = StringHelper.localizedStringWithKey("SIGNING_IN_LOCALIZE_KEY")
    static let welcome = StringHelper.localizedStringWithKey("WELCOME_LOCALIZE_KEY")
    static let please = StringHelper.localizedStringWithKey("PLEASE_INPUT_LOCALIZE_KEY")
    static let notMatch = StringHelper.localizedStringWithKey("NOT_MATCH_LOCALIZE_KEY")
    static let alertLogout = StringHelper.localizedStringWithKey("LOGOUT_LOCALIZE_KEY")
    static let alertLogoutMessage = StringHelper.localizedStringWithKey("LOGOUT_MESSAGE_LOCALIZE_KEY")
    static let sheetAccountType = StringHelper.localizedStringWithKey("ACCOUNT_TYPE_LOCALIZE_KEY")
    static let sheetMerchant = StringHelper.localizedStringWithKey("MERCHANT_LOCALIZE_KEY")
    static let sheetAffiliate = StringHelper.localizedStringWithKey("AFFILIATE_LOCALIZE_KEY")
    
}

protocol SignInViewControllerDelegate{
    func passStoreInfoModel(storeInfoModel: StoreInfoModel)
}

class SignInViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    
    var delegate: SignInViewControllerDelegate?
    
    @IBOutlet weak var mottoLabel: UILabel!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var viewsContainer: UIView!
    
    var hud: MBProgressHUD?
    
    var storeInfoModel: StoreInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard:"))
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
    
    func setupViews() {
        self.profileContainerView.layer.cornerRadius = self.profileContainerView.frame.size.height / 2
        
        self.signInButton.layer.cornerRadius = 2.0
        
        self.mottoLabel.text = SignInStrings.motto
        self.emailAddressTextField.placeholder = SignInStrings.emailPlaceholder
        self.passwordTextField.placeholder = SignInStrings.passwordPlaceholder
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
    
//    func showAlert(#title: String!, message: String!) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
//        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//        alertController.addAction(defaultAction)
//        presentViewController(alertController, animated: true, completion: nil)
//    }
    
    func signinSuccessful() {
        self.view.userInteractionEnabled = false
        self.hideKeyboard(UIGestureRecognizer())
        self.signInButton.setTitle(SignInStrings.welcome, forState: .Normal)
        fireStoreInfo()
        self.fireCreateRegistration(SessionManager.gcmToken())
    }
    
    func loadUserImage() {
        self.profileImageView.sd_setImageWithURL(self.storeInfoModel?.avatar, placeholderImage: UIImage(named: "dummy-placeholder"))
        self.profileImageView.frame = self.profileContainerView.bounds
        self.profileImageView.contentMode = .ScaleAspectFill
    }
    
    func fireStoreInfo() {
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.POST(APIAtlas.sellerStoreInfo, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.storeInfoModel = StoreInfoModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
            
            // loads user image
            self.loadUserImage()
            
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfoModel?.store_name, forKey: "storeName")
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfoModel?.store_address, forKey: "storeAddress")
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfoModel?.totalSales, forKey: "totalSales")
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfoModel?.productCount, forKey: "productCount")
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfoModel?.transactionCount, forKey: "transactionCount")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            // wait 3 seconds before going to dashboard
            let delay = 3.0 * Double(NSEC_PER_SEC)
            var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            self.delegate?.passStoreInfoModel(self.storeInfoModel!)
            self.hud?.hide(true)
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                self.signInButton.setTitle(SignInStrings.signin, forState: .Normal)
                
                if error.userInfo != nil {
                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                        let errorDescription: String = jsonResult["error_description"] as! String
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorDescription)
                    } else {
                        
                    }
                }
        })
    }
    
    // MARK: Actions
    
    @IBAction func forgotPasswordAction(sender: AnyObject) {
        var alert = UIAlertController(title: SignInStrings.sheetAccountType, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: AlertStrings.cancel, style: UIAlertActionStyle.Cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: SignInStrings.sheetMerchant, style: UIAlertActionStyle.Default) { UIAlertAction in
            var url: String = APIEnvironment.baseUrl() + "/forgot-password-request"
            url = url.stringByReplacingOccurrencesOfString("api/v1/", withString: "", options: nil, range: nil)
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        })
        
        alert.addAction(UIAlertAction(title: SignInStrings.sheetAffiliate, style: UIAlertActionStyle.Default) { UIAlertAction in
            var url: String = APIEnvironment.baseUrl() + "/affiliate-program/forgot-password-request"
            url = url.stringByReplacingOccurrencesOfString("api/v1/", withString: "", options: nil, range: nil)
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func signInAction(sender: AnyObject) {
        if self.emailAddressTextField.rightView?.hidden == false && self.passwordTextField.rightView?.hidden == false {
            if Reachability.isConnectedToNetwork() {
                self.signInButton.setTitle(SignInStrings.signingin, forState: .Normal)
                self.fireSignin()
            } else {
                UIAlertController.showAlert(self, title: AlertStrings.failed, message: AlertStrings.checkInternet)
//                showAlert(title: AlertStrings.failed, message: AlertStrings.checkInternet)
            }
        } else {
            UIAlertController.showAlert(self, title: AlertStrings.error, message: SignInStrings.please)
//            showAlert(title: AlertStrings.error, message: SignInStrings.please)
        }
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
    
    // checks if what textfield is currently editing
    // increase border of the current textfield
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
    
    // deacrese border
    func textFieldDidEndEditing(textField: UITextField) {
        textField.layer.borderWidth = 0.0
    }
    
    // change return key's action
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
    
    // checks if email is valid while typing
    func emailDidTextChanged() {
        if self.emailAddressTextField.isValidEmail() {
            self.emailAddressTextField.rightView?.hidden = false
        } else {
            self.emailAddressTextField.rightView?.hidden = true
        }
    }

    // checks if password is valid while typing
    func passwordDidTextChanged() {
        if self.passwordTextField.isAlphaNumeric() && count(self.passwordTextField.text) > 5 {
            self.passwordTextField.rightView?.hidden = false
        } else {
            self.passwordTextField.rightView?.hidden = true
        }
    }
    
    // MARK: - Requests
    
    func fireSignin() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isSeller")
        self.showHUD()
        WebServiceManager.fireLoginRequestWithUrl(APIAtlas.loginUrl, emailAddress: self.emailAddressTextField.text!, password: self.passwordTextField.text!, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.signinSuccessful()
            } else {
                self.hud?.hide(true)
                self.signInButton.setTitle(SignInStrings.signin, forState: .Normal)
                if requestErrorType == .ResponseError {
//                    self.showAlert(title: AlertStrings.error, message: responseObject["error_description"] as! String)
                    UIAlertController.showAlert(self, title: AlertStrings.error, message: responseObject["error_description"] as! String)
                } else if requestErrorType == .PageNotFound {
                    Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
        })
    }
    
    func fireCreateRegistration(registrationID : String) {
        println("fireCreateRegistration")
        if(SessionManager.isLoggedIn()){
            
            let manager: APIManager = APIManager.sharedInstance
            //seller@easyshop.ph
            //password
            let parameters: NSDictionary = [
                "registrationId": "\(registrationID)",
                "access_token"  : SessionManager.accessToken(),
                "deviceType"    : "1"
                ]   as Dictionary<String, String>
            
            let url = APIAtlas.baseUrl + APIAtlas.ACTION_GCM_CREATE
            
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                println("Registration successful!")
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    
                    println("Registration unsuccessful!")
            })
        }
    }
    
}
