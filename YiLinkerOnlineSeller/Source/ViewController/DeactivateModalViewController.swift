//
//  DeactivateModalViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol DeactivateModalViewControllerDelegate {
    func closeDeactivateModal()
    func submitDeactivateModal(password: String)
}

class DeactivateModalViewController: UIViewController {
    
    var delegate: DeactivateModalViewControllerDelegate?
    
    let manager = APIManager.sharedInstance

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    var mainViewOriginalFrame: CGRect?
    var screenHeight: CGFloat?
    
    var hud: MBProgressHUD?
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    var connectionLocalizeString: String = ""
    var connectionMessageLocalizeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        initializeLocalizedString()
    }

    func initializeViews() {
        mainView.layer.cornerRadius = 8
        submitButton.layer.cornerRadius = 5
        mainViewOriginalFrame = mainView.frame
        
        var view = UITapGestureRecognizer(target:self, action:"tapMainAction")
        self.mainView.addGestureRecognizer(view)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenHeight = screenSize.height
        
        topConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
        connectionLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONUNREACHABLE_LOCALIZE_KEY")
        connectionMessageLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONERRORMESSAGE_LOCALIZE_KEY")

        titleLabel.text = StringHelper.localizedStringWithKey("DEACTIVATE_ACCOUNT_LOCALIZED_KEY")
        passwordLabel.text = StringHelper.localizedStringWithKey("PASSWORD_LOCALIZED_KEY")
        submitButton.setTitle(StringHelper.localizedStringWithKey("SUBMIT_LOCALIZED_KEY"), forState: UIControlState.Normal)
    }
    
    func tapMainAction() {
        passwordTextField.resignFirstResponder()
        topConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    @IBAction func editBegin(sender: AnyObject) {
        if IphoneType.isIphone4() {
            topConstraint.constant = screenHeight! / 5
        }
    }

    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.closeDeactivateModal()
        } else if sender as! UIButton == submitButton {
            tapMainAction()
            if passwordTextField.isNotEmpty() {
                fireDeactivate(APIAtlas.deactivate, params: NSDictionary(dictionary: ["access_token": SessionManager.accessToken(), "password": passwordTextField.text]))
            } else {
                let passwordRequiredString = StringHelper.localizedStringWithKey("PASSWORD_REQUIRED_LOCALIZED_KEY")
                showAlert(title: self.errorLocalizeString, message: passwordRequiredString)
            }
        }
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okString = StringHelper.localizedStringWithKey("OKBUTTON_LOCALIZE_KEY")
        let defaultAction = UIAlertAction(title: okString, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Loader function
    func showLoader() {
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
    
    func dismissLoader() {
        self.hud?.hide(true)
    }
    
    func fireDeactivate(url: String, params: NSDictionary!) {
        showLoader()
        
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            if responseObject.objectForKey("error") != nil {
                self.requestRefreshToken(url, params: params)
            } else {
                if responseObject["isSuccessful"] as! Bool {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.dismissLoader()
                    self.delegate?.submitDeactivateModal(self.passwordTextField.text)
                } else {
                    self.showAlert(title: self.errorLocalizeString, message: responseObject["message"] as! String)
                    self.dismissLoader()
                }
            }
            println(responseObject)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.showAlert(title: self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                self.dismissLoader()
                println(error)
        })
        
    }
    
    func requestRefreshToken(url: String, params: NSDictionary!) {
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.dismissLoader()
            
            if (responseObject["isSuccessful"] as! Bool) {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireDeactivate(url, params: params)
            } else {
                self.showAlert(title: self.errorLocalizeString, message: responseObject["message"] as! String)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.dismissLoader()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                self.showAlert(title: self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                
        })
    }


}
