//
//  EditProfileTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 2/17/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

enum EditProfileRequestType {
    case SendEmailVerification
    case SaveProfile
}

class EditProfileTableViewController: UITableViewController {
    
    let personalCellIdentifier: String = "EditProfilePersonalTableViewCell"
    let changeCellIdentifier: String = "EditProfileChangeTableViewCell"
    
    var hud: MBProgressHUD?
    
    var storeInfo: StoreInfoModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
        self.registerNibs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initializations
    func initializeViews() {
        self.view.backgroundColor = Constants.Colors.lightBackgroundColor
        
        //Add Back Button
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        //Set title
        self.title = "Edit Profile"
        
        //Add tap getsure to close keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func registerNibs() {
        let personalNib = UINib(nibName: self.personalCellIdentifier, bundle: nil)
        self.tableView.registerNib(personalNib, forCellReuseIdentifier: self.personalCellIdentifier)
        
        let changeNib = UINib(nibName: self.changeCellIdentifier, bundle: nil)
        self.tableView.registerNib(changeNib, forCellReuseIdentifier: self.changeCellIdentifier)
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Functions
    func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    //Loader function
    func showLoader() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.navigationController?.view!)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    //Hide loader
    func dismissLoader() {
        self.hud?.hide(true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    // MARK: - API Requests
    //MARK: -
    //MARK: - Fire Send Email Verification
    func fireSaveProfile(firstName: String, lastName: String, tin: String, email: String, isSent: String) {
        self.showLoader()
        WebServiceManager.fireSaveProfileWithUrl(APIAtlas.saveEditProfile, firstName: firstName, lastName: lastName, tin: tin, email: email, isSent: isSent, accessToken: SessionManager.accessToken(),  actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            println(responseObject)
            if successful {
                self.dismissLoader()
                let response: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                Toast.displayToastWithMessage(response.message, duration: 1.5, view: self.view)
            } else {
                self.dismissLoader()
                self.handleErrorWithType(requestErrorType, responseObject: responseObject, requestType: .SaveProfile, params: [firstName, lastName, tin, email, isSent])
            }
        })
    }
    
    //MARK: -
    //MARK: - Fire Save Profile
    func fireSendVerification(email: String) {
        self.showLoader()
        WebServiceManager.fireSendEmailVerificationRequestWithUrl(APIAtlas.sendEmailVerification, email: email, accessToken: SessionManager.accessToken(),  actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            println(responseObject)
            if successful {
                self.dismissLoader()
                let response: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                Toast.displayToastWithMessage(response.message, duration: 1.5, view: self.view)
            } else {
                self.dismissLoader()
                self.handleErrorWithType(requestErrorType, responseObject: responseObject, requestType: .SendEmailVerification, params: [email])
            }
        })
    }
    
    //MARK: - Handling of API Request Error
    /* Function to handle the error and proceed/do some actions based on the error type
    *
    * (Parameters) requestErrorType: RequestErrorType -- type of error being thrown by the web service. It is used to identify what specific action is needed to be execute based on the error type.
    *              responseObject: AnyObject -- response coming from the server. It is used to identify what specific error message is being thrown by the server
    *              params: TemporaryParameters -- collection of all params needed by all API request in the Wishlist.
    *
    * This function is for checking of 'requestErrorType' and proceed/do some actions based on the error type
    */
    func handleErrorWithType(requestErrorType: RequestErrorType, responseObject: AnyObject, requestType: EditProfileRequestType, params: [String]) {
        if requestErrorType == .ResponseError {
            //Error in api requirements
            let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
            Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
        } else if requestErrorType == .AccessTokenExpired {
            self.fireRefreshToken(params, requestType: requestType)
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
            Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
        }
    }
    
    //MARK: - Fire Refresh Token
    /* Function called when access_token is already expired.
    * (Parameter) params: TemporaryParameters -- collection of all params
    * needed by all API request in the Wishlist.
    *
    * This function is for requesting of access token and parse it to save in SessionManager.
    * If request is successful, it will check the requestType and redirect/call the API request
    * function based on the requestType.
    * If the request us unsuccessful, it will forcely logout the user
    */
    func fireRefreshToken(params: [String], requestType: EditProfileRequestType) {
        self.showLoader()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.dismissLoader()
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                
                switch requestType {
                case .SendEmailVerification:
                    self.fireSendVerification(params[0])
                case .SaveProfile:
                    self.fireSaveProfile(params[0], lastName: params[1], tin: params[2], email: params[3], isSent: params[4])
                }
                
            } else {
                UIAlertController.displaySomethingWentWrongError(self)
            }
        })
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: EditProfilePersonalTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.personalCellIdentifier, forIndexPath: indexPath) as! EditProfilePersonalTableViewCell
            cell.passValue(self.storeInfo!)
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell: EditProfileChangeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.changeCellIdentifier, forIndexPath: indexPath) as! EditProfileChangeTableViewCell
            //Todo Strings
            cell.setTitle("Store Address")
            cell.setValueChangeable(true)
            cell.setValue(self.storeInfo!.title, value: self.storeInfo!.address)
            return cell
        } else if indexPath.row == 2 {
            let cell: EditProfileChangeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.changeCellIdentifier, forIndexPath: indexPath) as! EditProfileChangeTableViewCell
            //Todo Strings
            cell.setTitle("Bank Account Information")
            cell.setValueChangeable(true)
            let accountInfo: String = "\(self.storeInfo?.accountNumber)\n\(self.storeInfo?.accountName)\n\(self.storeInfo?.bankName)"
            cell.setValue(self.storeInfo!.accountTitle, value: accountInfo)
            return cell
        } else {
            let cell: EditProfilePersonalTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.personalCellIdentifier, forIndexPath: indexPath) as! EditProfilePersonalTableViewCell
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 405
        } else if indexPath.row == 1 {
            return 155
        } else {
            return 155
        }
    }
}

// MARK: - Delegates
// MARK: - Edit Profile Personal TableViewCell Delegate
extension EditProfileTableViewController: EditProfilePersonalTableViewCellDelegate {
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, textFieldShouldReturn textField: UITextField) {
        if textField == editProfilePersonalCell.mobilePhoneTextField {
            editProfilePersonalCell.firstNameTextField.becomeFirstResponder()
        } else if textField == editProfilePersonalCell.firstNameTextField {
            editProfilePersonalCell.lastNameTextField.becomeFirstResponder()
        } else if textField == editProfilePersonalCell.lastNameTextField {
            editProfilePersonalCell.emailLabel.becomeFirstResponder()
        } else if textField == editProfilePersonalCell.emailTextField {
            editProfilePersonalCell.tinTextField.becomeFirstResponder()
        } else if textField == editProfilePersonalCell.tinTextField {
            self.closeKeyboard()
        } else {
            self.closeKeyboard()
        }
    }
    
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, didTapSendVerification button: UIButton) {
        self.fireSendVerification(editProfilePersonalCell.emailTextField.text)
    }
}

// MARK: - Edit Profile Address TableViewCell Delegate
extension EditProfileTableViewController: EditProfileAddressTableViewCellDelegate {
    func editProfileAddressCell(editProfileAddressCell: EditProfileAddressTableViewCell, didTapChangeAddress view: UIView) {
        var changeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        changeAddressViewController.delegate = self
        self.navigationController?.pushViewController(changeAddressViewController, animated:true)
    }
    
    func editProfileAddressCell(editProfileAddressCell: EditProfileAddressTableViewCell, didTapSave button: UIButton) {
        
    }
}

// MARK: - Change Address ViewController Delegate
extension EditProfileTableViewController: ChangeAddressViewControllerDelegate {
    func updateStoreAddressDetail(title: String, storeAddress: String) {
        self.storeInfo?.title = title
        self.storeInfo?.store_address = storeAddress
        self.tableView.reloadData()
    }
    
    func dismissView() {
        
    }
}
