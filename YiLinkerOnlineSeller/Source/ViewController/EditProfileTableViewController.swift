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

struct EditProfileLocalizedStrings {
    static let editProfileLocalizeString = StringHelper.localizedStringWithKey("EDITPROFILE_LOCALIZE_KEY")
    static let editPhotoLocalizeString = StringHelper.localizedStringWithKey("EDITPHOTO_LOCALIZE_KEY")
    static let addPhotoLocalizeString = StringHelper.localizedStringWithKey("ADDPHOTO_LOCALIZE_KEY")
    static let selectPhotoLocalizeString = StringHelper.localizedStringWithKey("SELECTPHOTO_LOCALIZE_KEY")
    static let takePhotoLocalizeString = StringHelper.localizedStringWithKey("TAKEPHOTO_LOCALIZE_KEY")
    static let cancelLocalizeString = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
    static let copiedToClipBoard = StringHelper.localizedStringWithKey("COPY_LOCALIZE_KEY")
    static let successfullyUpdateProfile = StringHelper.localizedStringWithKey("UPDATE_PROF_LOCALIZE_KEY")
}

class EditProfileTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    let personalCellIdentifier: String = "EditProfilePersonalTableViewCell"
    let changeCellIdentifier: String = "EditProfileChangeTableViewCell"
    let buttonCellIdentifier: String = "EditProfileButtonTableViewCell"
    
    //Strings
    let copiedToClipBoard = StringHelper.localizedStringWithKey("COPY_LOCALIZE_KEY")
    
    var hud: MBProgressHUD?
    
    var storeInfo: StoreInfoModel?
    
    var personalInfoCell: EditProfilePersonalTableViewCell?
    
    //Value Holder
    var isSendVerificationSent: Bool = false
    var mobileNumber: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var emailAddress: String = ""
    var tin: String = ""
    var referrerCode: String = ""
    
    var dimView: UIView = UIView()
    
    //Image
    var validIDImage: UIImage?
    
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
        self.tableView.estimatedRowHeight = 190
        self.view.backgroundColor = Constants.Colors.lightBackgroundColor
        
        //Initialized dimView
        self.dimView = UIView(frame: UIScreen.mainScreen().bounds)
        self.dimView.backgroundColor=UIColor.blackColor()
        self.dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        self.dimView.hidden = true
        
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
        
        var referralCodeNibName = UINib(nibName: ReferralCodeTableViewCell.nibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(referralCodeNibName, forCellReuseIdentifier: ReferralCodeTableViewCell.nibNameAndIdentifier())
        
        var buttonNibName = UINib(nibName: self.buttonCellIdentifier, bundle: nil)
        self.tableView.registerNib(buttonNibName, forCellReuseIdentifier: self.buttonCellIdentifier)
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Functions
    func checkIfNewUser() -> Bool {
        if self.storeInfo != nil {
            if self.storeInfo!.firstName.isEmpty && self.storeInfo!.lastName.isEmpty && self.storeInfo!.email.isEmpty {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    func showView(){
        dimView.hidden = false
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0.5
            }, completion: { finished in
        })
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
        self.navigationController?.view!.addSubview(self.hud!)
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
        WebServiceManager.fireSaveProfileWithUrl(APIAtlas.saveEditProfileAffiliate, firstName: firstName, lastName: lastName, tin: tin, email: email, isSent: isSent, accessToken: SessionManager.accessToken(),  actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            println(responseObject)
            if successful {
                self.dismissLoader()
                let response: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                Toast.displayToastWithMessage(response.message, duration: 1.5, view: self.navigationController!.view!)
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
        WebServiceManager.fireSendEmailVerificationRequestWithUrl(APIAtlas.sendEmailVerificationAffiliate, email: email, accessToken: SessionManager.accessToken(),  actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            println(responseObject)
            if successful {
                self.isSendVerificationSent = true
                self.storeInfo?.isEmailVerified = false
                self.dismissLoader()
                let response: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                Toast.displayToastWithMessage(response.message, duration: 1.5, view: self.navigationController!.view!)
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
            Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.navigationController!.view!)
        } else if requestErrorType == .AccessTokenExpired {
            self.fireRefreshToken(params, requestType: requestType)
        } else if requestErrorType == .PageNotFound {
            //Page not found
            Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.navigationController!.view!)
        } else if requestErrorType == .NoInternetConnection {
            //No internet connection
            Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.navigationController!.view!)
        } else if requestErrorType == .RequestTimeOut {
            //Request timeout
            Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.navigationController!.view!)
        } else if requestErrorType == .UnRecognizeError {
            //Unhandled error
            Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.navigationController!.view!)
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
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: EditProfilePersonalTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.personalCellIdentifier, forIndexPath: indexPath) as! EditProfilePersonalTableViewCell
            cell.passValue(self.storeInfo!)
            cell.setRemarksStatusHidden(true)
            cell.delegate = self
            cell.selectionStyle = .None
            self.personalInfoCell = cell
            return cell
        } else if indexPath.row == 1 {
            let cell: EditProfileChangeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.changeCellIdentifier, forIndexPath: indexPath) as! EditProfileChangeTableViewCell
            //Todo Strings
            cell.setTitle("Store Address")
            cell.setValueChangeable(true)
            cell.delegate = self
            cell.setChangeButtonTitle("Change\nAddress")
            if (self.storeInfo?.store_address == nil) {
                if self.storeInfo!.store_address.isEmpty {
                    cell.setValue("No Address yet.", value: "")
                } else {
                    cell.setValue(self.storeInfo!.title, value: self.storeInfo!.store_address)
                }
            } else {
                cell.setValue(self.storeInfo!.title, value: self.storeInfo!.store_address)
            }
            
            cell.selectionStyle = .None
            return cell
        } else if indexPath.row == 2 {
            let cell: EditProfileChangeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.changeCellIdentifier, forIndexPath: indexPath) as! EditProfileChangeTableViewCell
            //Todo Strings
            cell.setTitle("Bank Account Information")
            if self.storeInfo?.isBankEditable != nil {
                cell.setValueChangeable(self.storeInfo!.isBankEditable)
            }
            cell.delegate = self
            cell.setChangeButtonTitle("Change\nAccount")
            if (self.storeInfo?.bankAccount != nil) {
                if self.storeInfo!.bankAccount.isEmpty {
                    cell.setValue("No Bank Account yet.", value: "")
                } else {
                    let accountInfo: String = self.storeInfo!.accountNumber + "\n" + self.storeInfo!.accountName + "\n" + self.storeInfo!.bankName
                    cell.setValue(self.storeInfo!.accountTitle, value: accountInfo)
                }
            } else {
                let accountInfo: String = self.storeInfo!.accountNumber + "\n" + self.storeInfo!.accountName + "\n" + self.storeInfo!.bankName
                cell.setValue(self.storeInfo!.accountTitle, value: accountInfo)
            }
            
            cell.selectionStyle = .None
            return cell
        } else if indexPath.row == 3 {
            let cell: ReferralCodeTableViewCell = tableView.dequeueReusableCellWithIdentifier(ReferralCodeTableViewCell.nibNameAndIdentifier(), forIndexPath: indexPath) as! ReferralCodeTableViewCell
            cell.delegate = self
            
            if self.storeInfo!.referralCode != "" {
                cell.setYourReferralCodeWithCode(self.storeInfo!.referralCode)
            }
            
            if self.storeInfo!.referrerCode != "" {
                cell.setReferrerCodeWithCode("\(self.storeInfo!.referrerCode) - \(self.storeInfo!.referrerName)")
            }
            
            cell.selectionStyle = .None
            cell.clipsToBounds = true
            return cell
        } else if indexPath.row == 4 {
            let cell: EditProfileButtonTableViewCell = tableView.dequeueReusableCellWithIdentifier(self.buttonCellIdentifier, forIndexPath: indexPath) as! EditProfileButtonTableViewCell
            if self.checkIfNewUser() {
                cell.setButtonTitle("SAVE AND SETUP STORE")
            } else {
                cell.setButtonTitle("SAVE")
            }
            cell.delegate = self
            cell.clipsToBounds = true
            cell.selectionStyle = .None
            return cell
        } else {
            let cell: EditProfilePersonalTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.personalCellIdentifier, forIndexPath: indexPath) as! EditProfilePersonalTableViewCell
            cell.delegate = self
            cell.selectionStyle = .None
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        } else if indexPath.row == 1 || indexPath.row == 2 {
            return 155
        } else if indexPath.row == 3 {
            return 190
        } else if indexPath.row == 4 {
            return 55
        } else {
            return 155
        }
    }
}

//MARK: - Delegates
//MARK: - UIImagePickerControllerDelegate, UIActionSheetDelegate
extension EditProfileTableViewController: UIImagePickerControllerDelegate, UIActionSheetDelegate {
    func openImageActionSheet(){
        if(self.checkIfUIAlertControllerIsAvailable()){
            self.handleIOS8()
        } else {
            var actionSheet:UIActionSheet
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                actionSheet = UIActionSheet(title: EditProfileLocalizedStrings.addPhotoLocalizeString, delegate: self, cancelButtonTitle: EditProfileLocalizedStrings.cancelLocalizeString, destructiveButtonTitle: nil,otherButtonTitles: EditProfileLocalizedStrings.selectPhotoLocalizeString, EditProfileLocalizedStrings.takePhotoLocalizeString)
            } else {
                actionSheet = UIActionSheet(title: EditProfileLocalizedStrings.addPhotoLocalizeString, delegate: self, cancelButtonTitle: EditProfileLocalizedStrings.cancelLocalizeString, destructiveButtonTitle: nil,otherButtonTitles: EditProfileLocalizedStrings.selectPhotoLocalizeString)
            }
            actionSheet.delegate = self
            actionSheet.showInView(self.view)
        }
    }
    
    //Method for
    func handleIOS8(){
        let imageController = UIImagePickerController()
        imageController.editing = false
        imageController.delegate = self
        let alert = UIAlertController(title: EditProfileLocalizedStrings.addPhotoLocalizeString, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: EditProfileLocalizedStrings.selectPhotoLocalizeString, style: UIAlertActionStyle.Default) { (alert) -> Void in
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imageController, animated: true, completion: nil)
        }
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: EditProfileLocalizedStrings.takePhotoLocalizeString, style: UIAlertActionStyle.Default) { (alert) -> Void in
                imageController.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imageController, animated: true, completion: nil)
                
            }
            alert.addAction(cameraButton)
        } else {
            
        }
        let cancelButton = UIAlertAction(title: EditProfileLocalizedStrings.cancelLocalizeString, style: UIAlertActionStyle.Cancel) { (alert) -> Void in
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.validIDImage = image
        self.personalInfoCell?.setActivityIndicationHidden(false)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let imageController = UIImagePickerController()
        imageController.editing = false
        imageController.delegate = self;
        if buttonIndex == 1 {
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        } else if buttonIndex == 2 {
            imageController.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            
        }
        self.presentViewController(imageController, animated: true, completion: nil)
    }
    
    func checkIfUIAlertControllerIsAvailable() -> Bool {
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            return true;
        }
        else {
            return false;
        }
    }
}

//MARK: - Edit Profile Personal TableViewCell Delegate
extension EditProfileTableViewController: EditProfilePersonalTableViewCellDelegate {
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, textFieldShouldReturn textField: UITextField) {
        if textField == editProfilePersonalCell.mobilePhoneTextField {
            self.mobileNumber = editProfilePersonalCell.mobilePhoneTextField.text
            editProfilePersonalCell.firstNameTextField.becomeFirstResponder()
        } else if textField == editProfilePersonalCell.firstNameTextField {
            self.firstName = editProfilePersonalCell.firstNameTextField.text
            editProfilePersonalCell.lastNameTextField.becomeFirstResponder()
        } else if textField == editProfilePersonalCell.lastNameTextField {
            self.lastName = editProfilePersonalCell.lastNameTextField.text
            editProfilePersonalCell.emailLabel.becomeFirstResponder()
        } else if textField == editProfilePersonalCell.emailTextField {
            self.emailAddress = editProfilePersonalCell.emailTextField.text
            editProfilePersonalCell.tinTextField.becomeFirstResponder()
        } else if textField == editProfilePersonalCell.tinTextField {
            self.tin = editProfilePersonalCell.tinTextField.text
            self.closeKeyboard()
        } else {
            self.closeKeyboard()
        }
    }
    
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, didTapSendVerification button: UIButton) {
        let email: String = editProfilePersonalCell.emailTextField.text
        self.closeKeyboard()
        if email.isEmpty {
            Toast.displayToastWithMessage(LoginStrings.emailIsRequired, duration: 1.5, view: self.navigationController!.view!)
        } else if !email.isValidEmail() {
            Toast.displayToastWithMessage(LoginStrings.emailIsRequired, duration: 1.5, view: self.navigationController!.view!)
        } else {
            self.fireSendVerification(email)
        }
    }
    
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, didTapChangePassword button: UIButton){
        var changeEmailViewController = ChangeEmailViewController(nibName: "ChangeEmailViewController", bundle: nil)
        changeEmailViewController.delegate = self
        changeEmailViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        changeEmailViewController.providesPresentationContextTransitionStyle = true
        changeEmailViewController.definesPresentationContext = true
        changeEmailViewController.view.frame.origin.y = changeEmailViewController.view.frame.size.height
        
        changeEmailViewController.type = "password"
        self.tabBarController?.presentViewController(changeEmailViewController, animated:true, completion: nil)
        self.showView()
    }
    
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, didTapUploadID button: UIButton) {
        self.openImageActionSheet()
    }
}

extension EditProfileTableViewController: ChangeEmailViewControllerDelegate {
    func dismissView() {
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0
            }, completion: { finished in
                self.dimView.hidden = true
        })
    }
}

//MARK: - Change Address ViewController Delegate
extension EditProfileTableViewController: EditProfileChangeTableViewCellDelegate {
    func editProfileChangeCell(editProfileChangeCell: EditProfileChangeTableViewCell, didTapSendButton sendButton: UIButton) {
        if sendButton.titleLabel?.text == "Change\nAddress" {
            var changeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
            changeAddressViewController.delegate = self
            self.navigationController?.pushViewController(changeAddressViewController, animated:true)
        } else if sendButton.titleLabel?.text == "Change\nAccount" {
            var changeBankAccountViewController = ChangeBankAccountViewController(nibName: "ChangeBankAccountViewController", bundle: nil)
            changeBankAccountViewController.delegate = self
            self.navigationController?.pushViewController(changeBankAccountViewController, animated:true)
        }
    }
}

//MARK: - Change Address ViewController Delegate
extension EditProfileTableViewController: ChangeAddressViewControllerDelegate {
    func updateStoreAddressDetail(title: String, storeAddress: String) {
        self.storeInfo?.title = title
        self.storeInfo?.store_address = storeAddress
        self.tableView.reloadData()
    }
}

//MARK: - Change Bank Account ViewController Delegate
extension EditProfileTableViewController: ChangeBankAccountViewControllerDelegate {
    func updateBankDetail(accountTitle: String, accountName: String, accountNumber: String, bankName: String) {
        self.storeInfo?.accountTitle = accountTitle
        self.storeInfo?.bankAccount = accountName + "\n" + accountNumber + "\n" + bankName
        self.storeInfo?.accountNumber = accountNumber
        self.storeInfo?.accountName = accountName
        self.storeInfo?.bankName = bankName
        self.tableView.reloadData()
    }
}

extension EditProfileTableViewController: ReferralCodeTableViewCellDelegate {
    func referralCodeTableViewCell(referralCodeTableViewCell: ReferralCodeTableViewCell, didClickCopyButtonWithString yourReferralCodeTextFieldText: String) {
        UIPasteboard.generalPasteboard().string = yourReferralCodeTextFieldText
        Toast.displayToastWithMessage(self.copiedToClipBoard, duration: 2.0, view: self.navigationController!.view)
    }
    
    func referralCodeTableViewCell(referralCodeTableViewCell: ReferralCodeTableViewCell, didTappedReturn textField: UITextField) {
        self.tableView.endEditing(true)
    }
    
    func referralCodeTableViewCell(referralCodeTableViewCell: ReferralCodeTableViewCell, didChangeValueAtTextField textField: UITextField, textValue: String) {
        self.referrerCode = textValue
    }
}

extension EditProfileTableViewController: EditProfileButtonTableViewCellDelegate {
    func editProfileButtonCell(editProfileButtonCell: EditProfileButtonTableViewCell, didTapButton button: UIButton) {
        self.fireSaveProfile(self.personalInfoCell!.firstNameTextField.text, lastName: self.personalInfoCell!.lastNameTextField.text, tin: self.personalInfoCell!.tinTextField.text, email: self.personalInfoCell!.emailTextField.text, isSent: "false")
    }
}
