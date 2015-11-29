//
//  ChangeEmailViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ChangeEmailViewControllerDelegate {
    func dismissView()
}

class ChangeEmailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitEmailAddressButton: DynamicRoundedButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var oldEmailAddressTextField: UITextField!
    @IBOutlet weak var newEmailAddressTextField: UITextField!
    @IBOutlet weak var confirmEmailAddressTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var oldEmailLabel: UILabel!
    @IBOutlet weak var newEmailLabel: UILabel!
    @IBOutlet weak var confirmEmailLabel: UILabel!
    
    var type: String = ""
    
    var hud : MBProgressHUD?
    
    var delegate: ChangeEmailViewControllerDelegate?
    
    let passwordTitle: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_TITLE_LOCALIZE_KEY")
    let oldPassword: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_OLD_PASSWORD_LOCALIZE_KEY")
    let enterOldPassword: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_ENTER_OLD_LOCALIZE_KEY")
    let newPassword: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_NEW_PASSWORD_LOCALIZE_KEY")
    let enterNewPassword: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_ENTER_NEW_LOCALIZE_KEY")
    let confirmPassword: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_CONFIRM_PASSWORD_LOCALIZE_KEY")
    let confirmNewPassword: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_CONFIRM_NEW_LOCALIZE_KEY")
    let submit: String = StringHelper.localizedStringWithKey("CHANGE_PASSWORD_SUBMIT_LOCALIZE_KEY")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = self.passwordTitle
        self.oldEmailLabel.text = self.oldPassword
        self.newEmailLabel.text = self.newPassword
        self.confirmEmailLabel.text = self.confirmPassword
        self.oldEmailAddressTextField.placeholder = self.enterOldPassword
        self.newEmailAddressTextField.placeholder = self.enterNewPassword
        self.confirmEmailAddressTextField.placeholder = self.confirmNewPassword
        self.oldEmailAddressTextField.secureTextEntry = true
        self.newEmailAddressTextField.secureTextEntry = true
        self.confirmEmailAddressTextField.secureTextEntry = true
        self.submitEmailAddressButton.setTitle(self.submit, forState: UIControlState.Normal)
        self.oldEmailAddressTextField.delegate = self
        self.newEmailAddressTextField.delegate = self
        self.confirmEmailAddressTextField.delegate = self
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "mainViewTapped")
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mainViewTapped() {
        self.oldEmailAddressTextField.resignFirstResponder()
        self.newEmailAddressTextField.resignFirstResponder()
        self.confirmEmailAddressTextField.resignFirstResponder()
    }
    
    @IBAction func closeAction(sender: AnyObject){
        self.delegate?.dismissView()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sumbitAction(sender: AnyObject) {
        
        if type == "email" {
            println("Submit email")
        } else {
            println("Submit password")
            if oldEmailAddressTextField.text.isEmpty ||  newEmailAddressTextField.text.isEmpty || confirmEmailAddressTextField.text.isEmpty {
                var completeLocalizeString = StringHelper.localizedStringWithKey("COMPLETEFIELDS_LOCALIZE_KEY")
                //showAlert(Constants.Localized.error, message: completeLocalizeString)
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: completeLocalizeString, title: Constants.Localized.error)
            } else if newEmailAddressTextField.text != confirmEmailAddressTextField.text {
                var passwordLocalizeString = StringHelper.localizedStringWithKey("PASSWORDMISMATCH_LOCALIZE_KEY")
                //showAlert(Constants.Localized.error, message: passwordLocalizeString)
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: passwordLocalizeString, title: Constants.Localized.error)
            } else {
                //self.showHUD()
                //self.fireChangePassword()
                self.newEmailAddressTextField.resignFirstResponder()
                self.oldEmailAddressTextField.resignFirstResponder()
                self.confirmEmailAddressTextField.resignFirstResponder()
                println(confirmEmailAddressTextField.text.isValidPassword())
                if count(confirmEmailAddressTextField.text) >= 8 && count(newEmailAddressTextField.text) >= 8 {
                    if confirmEmailAddressTextField.text.isValidPassword() && newEmailAddressTextField.text.isValidPassword(){
                        self.showHUD()
                        self.fireChangePassword()
                    } else {
                        var passwordAlpha = StringHelper.localizedStringWithKey("PASSWORD_ALPHA_LOCALIZE_KEY")
                        //showAlert(Constants.Localized.error, message: passwordAlpha)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: passwordAlpha, title: Constants.Localized.error)
                    }
                } else {
                    var passwordChar = StringHelper.localizedStringWithKey("PASSWORD_CHAR_LOCALIZE_KEY")
                    //showAlert(Constants.Localized.error, message: passwordChar)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: passwordChar, title: Constants.Localized.error)
                }

               
            }
            
        }
       
    }
    
    func fireChangePassword(){
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "oldPassword" : self.oldEmailAddressTextField.text, "newPassword" : self.newEmailAddressTextField.text, "newPasswordConfirm" : self.confirmEmailAddressTextField.text];
        self.showHUD()
        manager.POST(APIAtlas.sellerChangePassword, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println("SUCCESS!")
           
            var success = StringHelper.localizedStringWithKey("PASSWORD_SUCCESS_CHANGE_LOCALIZE_KEY")
            //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: success, title: Constants.Localized.success)
            self.showAlert(Constants.Localized.success, message: success)
            //self.view.makeToast(success, duration: 3.0, position: CSToastPositionBottom)
            /*
            let seconds = 2.0
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                //self.dismissViewControllerAnimated(true, completion: nil)
                //self.delegate?.dismissView()
                // here code perfomed with delay
            })
            */
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401{
                    self.requestRefreshToken()
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Error Refreshing Token", title: "Refresh Token Error")
                    self.hud?.hide(true)
                    //self.dismissViewControllerAnimated(true, completion: nil)
                } else if task.statusCode == 404 || task.statusCode == 400 {
                    let data = error.userInfo as! Dictionary<String, AnyObject>
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: data["message"] as! String, title: "Error")
                    self.hud?.hide(true)
                    //self.dismissViewControllerAnimated(true, completion: nil)
                }else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Error", title: Constants.Localized.someThingWentWrong )
                    self.hud?.hide(true)
                    //self.dismissViewControllerAnimated(true, completion: nil)
                }
               //self.delegate?.dismissView()
        })
        
    }
    
    //MARK: Alert view
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.dismissView()
            //alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    func requestRefreshToken() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.fireChangePassword()
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.showAlert(Constants.Localized.someThingWentWrong, message: "")
                self.hud?.hide(true)
        })
        
    }

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
    
    @IBAction func textFieldDidBegin(sender: AnyObject) {
        if IphoneType.isIphone4() {
            topConstraint.constant = 20
        } else if IphoneType.isIphone5() {
            topConstraint.constant = 40
        } else {
            topConstraint.constant = 100
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.oldEmailAddressTextField {
            self.newEmailAddressTextField.becomeFirstResponder()
        } else {
            self.confirmEmailAddressTextField.becomeFirstResponder()
        }
        return true
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
