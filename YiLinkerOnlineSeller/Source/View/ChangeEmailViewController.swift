//
//  ChangeEmailViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

//MARK: Delegate
//ChangeEmailViewController Delegate Method
protocol ChangeEmailViewControllerDelegate {
    func dismissView()
}

class ChangeEmailViewController: UIViewController, UITextFieldDelegate {
    
    //Constraints
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    //Custom Buttond
    @IBOutlet weak var submitEmailAddressButton: DynamicRoundedButton!
    
    //Buttons
    @IBOutlet weak var closeButton: UIButton!
    
    //Labels
    @IBOutlet weak var confirmEmailLabel: UILabel!
    @IBOutlet weak var newEmailLabel: UILabel!
    @IBOutlet weak var oldEmailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    //Textfields
    @IBOutlet weak var confirmEmailAddressTextField: UITextField!
    @IBOutlet weak var newEmailAddressTextField: UITextField!
    @IBOutlet weak var oldEmailAddressTextField: UITextField!
    
    //Views
    @IBOutlet weak var mainView: UIView!
    
    //Strings
    let passwordTitle: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_TITLE_LOCALIZE_KEY")
    let oldPassword: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_OLD_PASSWORD_LOCALIZE_KEY")
    let enterOldPassword: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_ENTER_OLD_LOCALIZE_KEY")
    let newPassword: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_NEW_PASSWORD_LOCALIZE_KEY")
    let enterNewPassword: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_ENTER_NEW_LOCALIZE_KEY")
    let confirmPassword: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_CONFIRM_PASSWORD_LOCALIZE_KEY")
    let confirmNewPassword: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_CONFIRM_NEW_LOCALIZE_KEY")
    let submit: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_SUBMIT_LOCALIZE_KEY")
    
    //Global variables declarations
    var type: String = ""
    var hud : MBProgressHUD?
    
    //Initialized ChangeEmailViewControllerDelegate
    var delegate: ChangeEmailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set labels and button text
        self.titleLabel.text = self.passwordTitle
        self.oldEmailLabel.text = self.oldPassword
        self.newEmailLabel.text = self.newPassword
        self.confirmEmailLabel.text = self.confirmPassword
        self.submitEmailAddressButton.setTitle(self.submit, forState: UIControlState.Normal)
        
        //Set textfields placeholder
        self.oldEmailAddressTextField.placeholder = self.enterOldPassword
        self.newEmailAddressTextField.placeholder = self.enterNewPassword
        self.confirmEmailAddressTextField.placeholder = self.confirmNewPassword
        
        //Set security type of textfield - make entered text bulleted eg. password to ********
        self.oldEmailAddressTextField.secureTextEntry = true
        self.newEmailAddressTextField.secureTextEntry = true
        self.confirmEmailAddressTextField.secureTextEntry = true
        
        self.oldEmailAddressTextField.delegate = self
        self.newEmailAddressTextField.delegate = self
        self.confirmEmailAddressTextField.delegate = self
        
        //Add tap gesture recognizer to self
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "mainViewTapped")
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button methods
    @IBAction func closeAction(sender: AnyObject){
        self.delegate?.dismissView()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sumbitAction(sender: AnyObject) {

        if type == "email" {
            
        } else {
            //Password validation
            if oldEmailAddressTextField.text.isEmpty ||  newEmailAddressTextField.text.isEmpty || confirmEmailAddressTextField.text.isEmpty {
                var completeLocalizeString = StringHelper.localizedStringWithKey("COMPLETEFIELDS_LOCALIZE_KEY")
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: completeLocalizeString, title: Constants.Localized.error)
            } else if newEmailAddressTextField.text != confirmEmailAddressTextField.text {
                var passwordLocalizeString = StringHelper.localizedStringWithKey("PASSWORDMISMATCH_LOCALIZE_KEY")
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: passwordLocalizeString, title: Constants.Localized.error)
            } else {
                
                self.mainViewTapped()
                
                if count(confirmEmailAddressTextField.text) >= 8 && count(newEmailAddressTextField.text) >= 8 {
                    if confirmEmailAddressTextField.text.isValidPassword() && newEmailAddressTextField.text.isValidPassword(){
                        self.showHUD()
                        self.fireChangePassword()
                    } else {
                        var passwordAlpha = StringHelper.localizedStringWithKey("PASSWORD_ALPHA_LOCALIZE_KEY")
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: passwordAlpha, title: Constants.Localized.error)
                    }
                } else {
                    var passwordChar = StringHelper.localizedStringWithKey("PASSWORD_CHAR_LOCALIZE_KEY")
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: passwordChar, title: Constants.Localized.error)
                }
            }
        }
    }
    
    //MARK: Textfiel methods
    @IBAction func textFieldDidBegin(sender: AnyObject) {
        if IphoneType.isIphone4() {
            topConstraint.constant = 20
        } else if IphoneType.isIphone5() {
            topConstraint.constant = 40
        } else {
            topConstraint.constant = 100
        }
    }
    
    //MARK: Private Methods
    func mainViewTapped() {
        self.oldEmailAddressTextField.resignFirstResponder()
        self.newEmailAddressTextField.resignFirstResponder()
        self.confirmEmailAddressTextField.resignFirstResponder()
    }
    
    //MARK: Alert view
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.dismissView()
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    //Show loader
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
    
    //MARK: Textfield delegate method
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.oldEmailAddressTextField {
            self.newEmailAddressTextField.becomeFirstResponder()
        } else {
            self.confirmEmailAddressTextField.becomeFirstResponder()
        }
        return true
    }

    //MARK: -
    //MARK: - REST API request
    //MARK: POST METHOD - Change Password
    /*
    *
    * (Parameters) - access_token, oldPassword, newPassword, newPasswordConfirm
    *
    * Function to change the password
    *
    */
    func fireChangePassword(){
        
        self.showHUD()
        
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "oldPassword" : self.oldEmailAddressTextField.text, "newPassword" : self.newEmailAddressTextField.text, "newPasswordConfirm" : self.confirmEmailAddressTextField.text]
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.sellerChangePassword, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                var success = StringHelper.localizedStringWithKey("PASSWORD_SUCCESS_CHANGE_LOCALIZE_KEY")
                
                self.showAlert(Constants.Localized.error, message: success)
                
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    //Call method 'requestRefreshToken' if the token is expired
                    self.requestRefreshToken()
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                    self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                }
            }
        })
        
        /*
        let manager = APIManager.sharedInstance
        
        manager.POST(APIAtlas.sellerChangePassword, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
           
            var success = StringHelper.localizedStringWithKey("PASSWORD_SUCCESS_CHANGE_LOCALIZE_KEY")
            
            if responseObject["isSuccessful"] as! Bool {
                self.showAlert(Constants.Localized.success, message: success)
            } else {
                self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
            }
            
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
    
                //Catch unsuccessful return from the API
                if task.statusCode == 401 {
                    //Call method 'requestRefreshToken' if the token is expired
                    self.requestRefreshToken()
                } else {
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        //Parsed error message return from the API
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.error)
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error )
                    }
                }
                
                self.hud?.hide(true)
        })*/
    }
    
    //MARK: POST METHOD - Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    *Function to refresh token to get another access token
    *
    */
    func requestRefreshToken() {
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        
        //Set parameters of POST Method
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if responseObject["isSuccessful"] as! Bool {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                
                self.fireChangePassword()
            } else {
                self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.error)
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error )
                }
                self.hud?.hide(true)
        })
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
