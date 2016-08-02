//
//  StoreInfoViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit
import MessageUI

class StoreInfoViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, StoreInfoTableViewCellDelegate, StoreInfoSectionTableViewCellDelegate, StoreInfoBankAccountTableViewCellDelegate , StoreInfoAccountInformationTableViewCellDelegate, ChangeBankAccountViewControllerDelegate, ChangeAddressViewControllerDelegate, ChangeMobileNumberViewControllerDelegate, StoreInfoAddressTableViewCellDelagate, ChangeEmailViewControllerDelegate, VerifyViewControllerDelegate, CongratulationsViewControllerDelegate, UzysAssetsPickerControllerDelegate, StoreInfoQrCodeTableViewCellDelegate, MFMailComposeViewControllerDelegate, GPPSignInDelegate, ReferralCodeTableViewCellDelegate {
    
    //Global variables declarations
    //Variables that can be accessed inside the class
    let storeInfoHeaderTableViewCellIndentifier: String = "StoreInfoTableViewCell"
    let storeInfoSectionTableViewCellIndentifier: String = "StoreInfoSectionTableViewCell"
    let storeInfoQRCodeTableViewCellIndentifier: String = "StoreInfoQrCodeTableViewCell"
    let storeInfoAddressTableViewCellIdentifier: String = "StoreInfoAddressTableViewCell"
    let storeInfoBankAccountTableViewCellIdentifier: String = "StoreInfoBankAccountTableViewCell"
    let storeInfoAccountInformationTableViewCellIdentifier: String = "StoreInfoAccountInformationTableViewCell"
    let storeInfoPreferredCategoriesTableViewCellIdentifier: String = "StoreInfoPreferredCategoriesTableViewCell"
    let storeInfoReferralCodeTableViewCellIdentifier: String = "StoreInfoReferralCodeTableViewCell"
    
    let storeInfoTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_TITLE_LOCALIZE_KEY")
    let addPhoto: String = StringHelper.localizedStringWithKey("STORE_INFO_ADD_PHOTO_LOCALIZE_KEY")
    let editPhoto: String = StringHelper.localizedStringWithKey("STORE_INFO_EDIT_PHOTO_LOCALIZE_KEY")
    let addCover: String = StringHelper.localizedStringWithKey("STORE_INFO_ADD_COVER_LOCALIZE_KEY")
    let editCover: String = StringHelper.localizedStringWithKey("STORE_INFO_EDIT_COVER_LOCALIZE_KEY")
    let storeInfo: String = StringHelper.localizedStringWithKey("STORE_INFO_STORE_INFO_LOCALIZE_KEY")
    let storeName: String = StringHelper.localizedStringWithKey("STORE_INFO_STORE_NAME_LOCALIZE_KEY")
    let storeLink: String = StringHelper.localizedStringWithKey("STORE_INFO_STORE_LINK_LOCALIZE_KEY")
    let storeDesc: String = StringHelper.localizedStringWithKey("STORE_INFO_STORE_DESC_LOCALIZE_KEY")
    let mobilePhone: String = StringHelper.localizedStringWithKey("STORE_INFO_MOBILE_LOCALIZE_KEY")
    let changeTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_CHANGE_LOCALIZE_KEY")
    let qrCode: String = StringHelper.localizedStringWithKey("STORE_INFO_QR_LOCALIZE_KEY")
    let generate: String = StringHelper.localizedStringWithKey("STORE_INFO_GENERATE_LOCALIZE_KEY")
    let generateQRCodeTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_GENERATE_QR_LOCALIZE_KEY")
    let retryGenerate: String = StringHelper.localizedStringWithKey("STORE_INFO_RETRY_GENERATE_LOCALIZE_KEY")
    let cannotGenerate: String = StringHelper.localizedStringWithKey("STORE_INFO_CANNOT_GENERATE_LOCALIZE_KEY")
    let storeAddressTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_STORE_ADDRESS_LOCALIZE_KEY")
    let newAddress: String = StringHelper.localizedStringWithKey("STORE_INFO_NEW_ADDRESS_LOCALIZE_KEY")
    let changeAddress: String = StringHelper.localizedStringWithKey("STORE_INFO_CHANGE_ADDRESS_LOCALIZE_KEY")
    let bankAccountTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_BANK_ACCOUNT_LOCALIZE_KEY")
    let newAccount: String = StringHelper.localizedStringWithKey("STORE_INFO_NEW_ACCOUNT_LOCALIZE_KEY")
    let accountInfo: String = StringHelper.localizedStringWithKey("STORE_INFO_ACCOUNT_INFO_LOCALIZE_KEY")
    let password: String = StringHelper.localizedStringWithKey("STORE_INFO_PASSWORD_LOCALIZE_KEY")
    let save: String = StringHelper.localizedStringWithKey("STORE_INFO_SAVE_LOCALIZE_KEY")
    let error: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_ERROR_LOCALIZE_KEY")
    let ok: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_OK_LOCALIZE_KEY")
    let somethingWentWrong: String = StringHelper.localizedStringWithKey("ERROR_SOMETHING_WENT_WRONG_LOCALIZE_KEY")
    let invalid: String = StringHelper.localizedStringWithKey("VERIFY_NUMBER_INVALID_LOCALIZE_KEY")
    let success: String = StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_LOCALIZE_KEY")
    let info: String = StringHelper.localizedStringWithKey("STORE_INFO_INFORMATION_LOCALIZE_KEY")
    let empty: String = StringHelper.localizedStringWithKey("STORE_INFO_EMPTY_LOCALIZE_KEY")
    let emptyStoreName: String = StringHelper.localizedStringWithKey("STORE_INFO_STORE_NAME_EMPTY_LOCALIZE_KEY")
    let emptyStoreDesc: String = StringHelper.localizedStringWithKey("STORE_INFO_STORE_DESCRIPTION_EMPTY_LOCALIZE_KEY")
    let successTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_TITLE_LOCALIZE_KEY")
    let tinTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_TIN_LOCALIZE_KEY")
    let bankNotSet: String = StringHelper.localizedStringWithKey("STORE_INFO_NO_BANK_LOCALIZE_KEY")
    let addressNotSet: String = StringHelper.localizedStringWithKey("STORE_INFO_NO_ADDRESS_LOCALIZE_KEY")
    let copiedToClipBoard = StringHelper.localizedStringWithKey("COPY_LOCALIZE_KEY")
    let successfullyUpdateProfile = StringHelper.localizedStringWithKey("UPDATE_PROF_LOCALIZE_KEY")
    
    var hasQRCode: Bool = false
    var refresh: Bool = false
    var verifyOrChange: Int = 0
    var imageType: String = ""
    var mobileNumber: String = ""
    var newContactNumber: String = ""
    var qr: String = ""
    var qrUrl: String = ""
    
    //Array variables
    var selectedCategories: [Int] = []
    var uploadImages: [UIImage] = []
    var tableData: [StoreInfoPreferredCategoriesModel] = []
    
    //Google Plus Sign In
    //Get this from https://console.developers.google.com
    var kClientId = "120452328739-36rpdqne3pvgj21p7ptru7daqp0tgiik.apps.googleusercontent.com"
    var kShareURL = "https://yilinker.com/"
    
    var hud: MBProgressHUD?
    
    var index: NSIndexPath?
    var timer: NSTimer?
    
    var image: UIImage?
    var imageCover: UIImage?
    var imageToPost: UIImage?
    
    var dimView: UIView = UIView()
    
    var storeInfoModel: StoreInfoModel?
    var storeAddressModel: StoreAddressModel?
    
    var referrerCode: String = ""
    var isFail: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set navigation bar title
        self.title = storeInfoTitle
        self.edgesForExtendedLayout = .None
        
        self.initializeViews()
        self.registerNibs()
        self.backButton()
        self.fireStoreInfo()
        
        //Initialized dimView
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        self.hasQRCode = false
        
        //Added tap gesture recognizer in tableView
        var tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if refresh {
           self.fireStoreInfo()
        }
    }
    
    //MARK: Private Method
    func changeMobileNumber(){
        var changeMobileNumberViewController = ChangeMobileNumberViewController(nibName: "ChangeMobileNumberViewController", bundle: nil)
        changeMobileNumberViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        changeMobileNumberViewController.providesPresentationContextTransitionStyle = true
        changeMobileNumberViewController.definesPresentationContext = true
        let black = UIColor.blackColor()
        let transparent = black.colorWithAlphaComponent(0.5)
        changeMobileNumberViewController.view.backgroundColor = transparent
        changeMobileNumberViewController.view.frame.origin.y = changeMobileNumberViewController.view.frame.size.height
        self.tabBarController?.presentViewController(changeMobileNumberViewController, animated: true, completion:
            nil)
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        shareToGooglePlus()
    }
    
    //MARK: Initialize views
    func initializeViews() {
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func generateQRCode() {
        //Show dim background
        self.showView()
        self.generateQr()
    }
    
    //MARK: CongratulationsViewController Delegate method
    func getStoreInfo() {
        self.fireStoreInfo()
        self.tableView.reloadData()
    }
    
    //MARK: Register nib file
    func registerNibs() {
        
        let storeInfoHeader = UINib(nibName: storeInfoHeaderTableViewCellIndentifier, bundle: nil)
        self.tableView.registerNib(storeInfoHeader, forCellReuseIdentifier: storeInfoHeaderTableViewCellIndentifier)
        
        let storeInfoQrCode = UINib(nibName: storeInfoQRCodeTableViewCellIndentifier, bundle: nil)
        self.tableView.registerNib(storeInfoQrCode, forCellReuseIdentifier: storeInfoQRCodeTableViewCellIndentifier)
        
        var storeInfo = UINib(nibName: storeInfoSectionTableViewCellIndentifier, bundle: nil)
        self.tableView.registerNib(storeInfo, forCellReuseIdentifier: storeInfoSectionTableViewCellIndentifier)
        
        var storeInfoBankAccount = UINib(nibName: storeInfoBankAccountTableViewCellIdentifier, bundle: nil)
        self.tableView.registerNib(storeInfoBankAccount, forCellReuseIdentifier: storeInfoBankAccountTableViewCellIdentifier)
        
        var storeInfoAddress = UINib(nibName: storeInfoAddressTableViewCellIdentifier, bundle: nil)
        self.tableView.registerNib(storeInfoAddress, forCellReuseIdentifier: storeInfoAddressTableViewCellIdentifier)
        
        var storeInfoAccountInformation = UINib(nibName: storeInfoAccountInformationTableViewCellIdentifier, bundle: nil)
        self.tableView.registerNib(storeInfoAccountInformation, forCellReuseIdentifier: storeInfoAccountInformationTableViewCellIdentifier)
        
        var storeInfoPreferredCategories = UINib(nibName: storeInfoPreferredCategoriesTableViewCellIdentifier, bundle: nil)
        self.tableView.registerNib(storeInfoPreferredCategories, forCellReuseIdentifier: storeInfoPreferredCategoriesTableViewCellIdentifier)
        
        var referralCodeNibName = UINib(nibName: ReferralCodeTableViewCell.nibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(referralCodeNibName, forCellReuseIdentifier: ReferralCodeTableViewCell.nibNameAndIdentifier())
    }

    //MARK: Navigation bar
    //Add back button in navigation bar
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    //Navigation bar back button method
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //MARK: StoreInfoTableViewCell Delegate Method
    func callUzyPicker(imageType: String) {
        self.imageType = imageType
        let picker: UzysAssetsPickerController = UzysAssetsPickerController()
        let maxCount: Int = 6
        
        let imageLimit: Int = 1
        picker.delegate = self
        picker.maximumNumberOfSelectionVideo = 0
        picker.maximumNumberOfSelectionPhoto = 1
        UzysAssetsPickerController.setUpAppearanceConfig(self.uzyConfig())
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func storeInfoCopyToClipboard(link: String) {
        let board = UIPasteboard.generalPasteboard()
        board.string = link
        Toast.displayToastBottomWithMessage(StringHelper.localizedStringWithKey("STORE_INFO_COPIED_LOCALIZE_KEY"), duration: 1.5, view: self.tabBarController!.view)
    }
    
    func storeInfoVerify(mobile: String) {
        
        self.showView()
        
        if self.verifyOrChange == 1 {
            var verifyNumberViewController = VerifyNumberViewController(nibName: "VerifyNumberViewController", bundle: nil)
            verifyNumberViewController.delegate = self
            verifyNumberViewController.mobileNumber = mobile
            verifyNumberViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            verifyNumberViewController.providesPresentationContextTransitionStyle = true
            verifyNumberViewController.definesPresentationContext = true
            verifyNumberViewController.view.frame.origin.y = verifyNumberViewController.view.frame.size.height
            self.tabBarController?.presentViewController(verifyNumberViewController, animated: true, completion:
                nil)
            self.verifyOrChange = 2
        } else {
            var changeMobileNumber = ChangeMobileNumberViewController(nibName: "ChangeMobileNumberViewController", bundle: nil)
            changeMobileNumber.delegate = self
            changeMobileNumber.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            changeMobileNumber.providesPresentationContextTransitionStyle = true
            changeMobileNumber.definesPresentationContext = true
            changeMobileNumber.mobile = mobile
            changeMobileNumber.view.frame.origin.y = changeMobileNumber.view.frame.size.height
            self.tabBarController?.presentViewController(changeMobileNumber, animated: true, completion:
                nil)
            self.verifyOrChange = 2
        }
    }
    
    func storeNameAndDescription(storeName: String, storeDescription: String) {
        self.storeInfoModel!.store_name = storeName
        self.storeInfoModel!.store_description = storeDescription
    }
    
    func textViewScrollUp(textView: UITextView) {
        var scrollPt:CGPoint = CGPointMake(textView.bounds.origin.x, textView.bounds.origin.y)
        self.tableView.setContentOffset(scrollPt, animated: true)
    }
    
    //MARK: StoreInfoBankAccountTableViewCell Delegate Method
    func newBankAccount() {
        var changeBankAccountViewController = ChangeBankAccountViewController(nibName: "ChangeBankAccountViewController", bundle: nil)
        changeBankAccountViewController.delegate = self
        self.navigationController?.pushViewController(changeBankAccountViewController, animated:true)
    }
    
    //MARK: StoreInfoAddressTableViewCell Delegate Method
    func changeToNewAddress() {
        var changeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        changeAddressViewController.delegate = self
        self.navigationController?.pushViewController(changeAddressViewController, animated:true)
    }

    //MARK: StoreInfoAccountInformationTableViewCell Delegate Method
    func changePassword() {
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
    
    func saveAccountInfo() {
        
        if self.storeInfoModel!.isReseller {
            if self.selectedCategories.count != 0 {
                self.saveStoreInfo()
            } else {
                self.showAlert("Ooops!!", message: "Please select category.")
                self.hud?.hide(true)
            }
        } else {
            self.saveStoreInfo()
        }
    }
    
    //MARK: VerifyViewController Delegate method
    func congratulationsViewController(isSuccessful: Bool) {
        var congratulations = CongratulationsViewController(nibName: "CongratulationsViewController", bundle: nil)
        congratulations.delegate = self
        congratulations.isSuccessful = isSuccessful
        congratulations.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        congratulations.providesPresentationContextTransitionStyle = true
        congratulations.definesPresentationContext = true
        congratulations.view.frame.origin.y = congratulations.view.frame.size.height
        self.tabBarController?.presentViewController(congratulations, animated: true, completion:
            nil)
        self.showView()
    }
    
    //MARK: ChangeBankAccountViewController Delegate method
    func updateBankDetail(accountTitle: String, accountName: String, accountNumber: String, bankName: String) {
        self.storeInfoModel?.accountTitle = accountTitle
        self.storeInfoModel?.bankAccount = accountName + "\n" + accountNumber + "\n" + bankName
        self.tableView.reloadData()
    }
    
    //MARK: ChangeStoreAddressViewController Delegate method
    func updateStoreAddressDetail(title: String, storeAddress: String) {
        self.storeInfoModel?.title = title
        self.storeInfoModel?.store_address = storeAddress
        self.tableView.reloadData()
    }
    
    //MARK: StoreInfoQRCodeTableViewCell Delegate Method
    func shareEMAction(postImage: UIImageView, title: String) {
        if postImage.image != nil {
            imageToPost = postImage.image
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        } else {
            println("no qr code")
        }
    }
    
    func shareGPAction(postImage: UIImageView, title: String) {
        if postImage.image != nil {
            self.imageToPost = postImage.image
            self.googlePlusSignIn()
            self.shareToGooglePlus()
        } else {
            println("no qr code")
        }
    }
    
    func shareFBAction(postImage: UIImageView, title: String) {
        
        if postImage.image != nil {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            var socialVC :SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            socialVC.setInitialText("")
            let image = postImage.image
            socialVC.addImage(image)
            socialVC.completionHandler = {
                (result:SLComposeViewControllerResult) in
                if result == SLComposeViewControllerResult.Done {
                    Toast.displayToastBottomWithMessage(StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_FB_LOCALIZE_KEY"), duration: 1.5, view: self.tabBarController!.view)
                    //self.showAlert(self.successTitle, message: StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_FB_LOCALIZE_KEY"))
                } else {
                    Toast.displayToastBottomWithMessage("Failed to share qr code.", duration: 1.5, view: self.tabBarController!.view)
                    //self.showAlert(self.error, message: "Failed to share qr code.")
                }
            }
            presentViewController(socialVC, animated: true, completion: nil)
        } else {
            println("no qr code")
        }
    }
    
    func storeInfoQrCodeTableViewCell(storeInfoQrCodeTableViewCell: StoreInfoQrCodeTableViewCell, didTapGenerateQRButton button: UIButton) {
        self.generateQRCode()
    }
    
    func shareTWAction(postImage: UIImageView, title: String) {
        if postImage.image != nil {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            var socialVC :SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            socialVC.setInitialText("")
            let image = postImage.image
            socialVC.addImage(image)
            socialVC.completionHandler = {
                (result:SLComposeViewControllerResult) in
                if result == SLComposeViewControllerResult.Done{
                    Toast.displayToastBottomWithMessage(StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_TWITTER_LOCALIZE_KEY"), duration: 1.5, view: self.tabBarController!.view)
                } else {
                    Toast.displayToastBottomWithMessage("Cancelled", duration: 1.5, view: self.tabBarController!.view)
                }
            }
            presentViewController(socialVC, animated: true, completion: nil)
        } else {
            println("no qr code")
        }
    }
    
    //MARK: Google Plus Sign In
    func googlePlusSignIn(){
        var signIn = GPPSignIn.sharedInstance();
        signIn.shouldFetchGooglePlusUser = true;
        signIn.clientID = kClientId;
        signIn.scopes = [kGTLAuthScopePlusLogin];
        signIn.trySilentAuthentication();
        signIn.delegate = self;
        signIn.authenticate();
    }
    
    //MARK: Loader methods
    func hideLoader() {
        if !self.refresh {
            self.hud?.hide(true)
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func showLoader() {
        if !refresh {
            self.showHUD()
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
    }

    //MARK: Dismiss keyboard
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK: Dismiss dim view
    func dismissView() {
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0
            }, completion: { finished in
                self.dimView.hidden = true
        })
    }
    
    //MARK: Set image/s for StoreInfoTableViewCell imageviews
    func setImageProfileCoverPhoto(image: UIImage){
        let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell: StoreInfoTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! StoreInfoTableViewCell
        if IMAGETYPE.imageType == "profile" {
            cell.profilePictureImageView.image = nil
            cell.profilePictureImageView.image = image
            self.image = image
        } else {
            cell.coverPhotoImageView.image = nil
            cell.coverPhotoImageView.image = image
            self.imageCover = image
        }
    }
    
    //MARK: Alert view
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: self.ok, style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    //Show success/failed/deleted/cancelled dialog box
    func successSharingDialogBox(timer: NSTimer) {
        var array: NSArray = timer.userInfo as! NSArray
        let sendMailErrorAlert = UIAlertView(title: array[0] as? String, message: array[1] as? String, delegate: self, cancelButtonTitle: StringHelper.localizedStringWithKey("OKBUTTON_LOCALIZE_KEY"))
        sendMailErrorAlert.show()
        self.timer?.invalidate()
    }
    
    //MARK: Show MBProgressHUD bar
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    //MARK: Show dim view
    func showView(){
        dimView.hidden = false
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0.5
            }, completion: { finished in
        })
    }

    func shareToGooglePlus() {
        // TODO: Toggle buttons here.
        if (GPPSignIn.sharedInstance().userID != nil){
            // Signed in?
            var user = GPPSignIn.sharedInstance().googlePlusUser
            println(user.name.JSONString())
            if (user.emails != nil){
                var shareDialog = GPPShare.sharedInstance().nativeShareDialog();
                
                // This line will fill out the title, description, and thumbnail from
                // the URL that you are sharing and includes a link to that URL.
                //shareDialog.setURLToShare(NSURL(fileURLWithPath: kShareURL));
                shareDialog.attachImage(self.imageToPost)
                shareDialog.setTitle(title, description: "Sharing your store qr code on Google Plus", thumbnailURL: nil)
                shareDialog.open();
                println(user.emails.first?.JSONString() ?? "no email")
            } else {
                println("no email")
            }
        } else {
            
        }
    }
    
    //MARK: MFMailComposeViewController Delegate methods
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.addAttachmentData(UIImageJPEGRepresentation(imageToPost, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "qrcode.jpeg")
        
        mailComposerVC.setSubject(title)
        
        mailComposerVC.setMessageBody(title, isHTML: true)
        mailComposerVC.setSubject(title)
        mailComposerVC.setMessageBody(title, isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.value {
            case MFMailComposeResultCancelled.value:
                Toast.displayToastBottomWithMessage(StringHelper.localizedStringWithKey("STORE_INFO_CANCEL_EMAIL_LOCALIZE_KEY"), duration: 1.5, view: self.tabBarController!.view)
                //var array = [self.info, StringHelper.localizedStringWithKey("STORE_INFO_CANCEL_EMAIL_LOCALIZE_KEY")]
                //self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "successSharingDialogBox:", userInfo: array, repeats: false)
            
            case MFMailComposeResultSaved.value:
                Toast.displayToastBottomWithMessage(StringHelper.localizedStringWithKey("STORE_INFO_SAVE_EMAIL_LOCALIZE_KEY"), duration: 1.5, view: self.tabBarController!.view)
                //var array = [self.info, StringHelper.localizedStringWithKey("STORE_INFO_SAVE_EMAIL_LOCALIZE_KEY")]
                //self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "successSharingDialogBox:", userInfo: array, repeats: false)
            
            case MFMailComposeResultSent.value:
                 Toast.displayToastBottomWithMessage(StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_EMAIL_LOCALIZE_KEY"), duration: 1.5, view: self.tabBarController!.view)
                //var array = [self.successTitle, StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_EMAIL_LOCALIZE_KEY")]
                //self.timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "successSharingDialogBox:", userInfo: array, repeats: false)
           
            case MFMailComposeResultFailed.value:
                Toast.displayToastBottomWithMessage(StringHelper.localizedStringWithKey("STORE_INFO_FAIL_EMAIL_LOCALIZE_KEY"), duration: 1.5, view: self.tabBarController!.view)
                //var array = [self.info, StringHelper.localizedStringWithKey("STORE_INFO_FAIL_EMAIL_LOCALIZE_KEY")]
                //self.timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "successSharingDialogBox:", userInfo: array, repeats: false)
           
            default:
                break
        }
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: Textview delegate method
    func textViewNextResponder(textView: UITextView) {
        textView.becomeFirstResponder()
    }
    
    //MARK: UzyPicker Delegate Mehtods
    //MARK: Configure UzyPicker appearance
    func uzyConfig() -> UzysAppearanceConfig {
        let config: UzysAppearanceConfig = UzysAppearanceConfig()
        config.finishSelectionButtonColor = Constants.Colors.appTheme
        return config
    }
    
    //MARK: UzzyPickerDelegate
    func uzysAssetsPickerController(picker: UzysAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        let assetsLibrary = ALAssetsLibrary()
        let alaSset: ALAsset = assets[0] as! ALAsset
        
        for allaSset in assets as! [ALAsset] {
            let image: UIImage = UIImage(CGImage: allaSset.defaultRepresentation().fullScreenImage().takeUnretainedValue(), scale: 1.0, orientation: UIImageOrientation.Up)!
            
            self.setImageProfileCoverPhoto(image)
        }
    }
    
    func uzysAssetsPickerControllerDidCancel(picker: UzysAssetsPickerController!) {
        
    }
    
    func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker: UzysAssetsPickerController!) {
        
    }
    
    //MARK: Tableview delegate methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell: StoreInfoTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(storeInfoHeaderTableViewCellIndentifier, forIndexPath: indexPath) as! StoreInfoTableViewCell
            index = indexPath
            cell.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.mobilePhoneLabel.text = self.mobilePhone
            cell.storeDescriptionLabel.text = self.storeDesc
            cell.storeInfoLabel.text = self.storeInfo
            cell.storeNameLabel.text = self.storeName
            cell.storeLinkTitleLabel.text = self.storeLink
            cell.storeLinkTitleLabel.required()
            
            cell.verifyButton.setTitle(self.changeTitle, forState: UIControlState.Normal)
            
            if self.storeInfoModel != nil {
                let url: NSString = NSString(string: (self.storeInfoModel?.avatar)!.absoluteString!)
                
                cell.storeLinkLabel.text = "http://www.online.api.easydeal.ph/\(self.storeInfoModel!.storeSlug)"
               
                if(self.storeInfoModel?.store_name != nil) {
                    if self.image != nil && self.imageCover != nil {
                        cell.coverEditImageView.image = self.imageCover
                        cell.profilePictureImageView.image = self.image
                    } else if self.image != nil && self.imageCover == nil {
                        cell.profilePictureImageView.image = self.image
                        cell.coverPhotoImageView.sd_setImageWithURL(self.storeInfoModel!.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                    } else if self.image == nil && self.imageCover != nil {
                        cell.profilePictureImageView.sd_setImageWithURL(self.storeInfoModel!.avatar, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                        cell.coverEditImageView.image = self.imageCover
                    } else {
                        let url: NSString = NSString(string: (self.storeInfoModel?.avatar)!.absoluteString!)
                        let url2: NSString = NSString(string: (self.storeInfoModel?.coverPhoto)!.absoluteString!)
                        if url != "" && url2 != "" {
                            //Download the image from url if 'url' and 'url2' is not empty
                            cell.profilePictureImageView.sd_setImageWithURL(self.storeInfoModel!.avatar, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                            cell.coverPhotoImageView.sd_setImageWithURL(self.storeInfoModel!.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                        } else if url == "" && url2 != "" {
                            //Download the image from url if 'url2' is not empty and set profilePictureImageView with default placeholder if 'url' is empty
                            cell.profilePictureImageView.image = UIImage(named: "dummy-placeholder.jpg")
                            cell.coverPhotoImageView.sd_setImageWithURL(self.storeInfoModel!.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                        } else if url != "" && url2 == "" {
                            //Download the image from url if 'url' is not empty and set coverPhotoImageView with default placeholder if 'url2' is empty
                            cell.profilePictureImageView.sd_setImageWithURL(self.storeInfoModel!.avatar, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                            cell.coverPhotoImageView.image = UIImage(named: "dummy-placeholder.jpg")
                        } else {
                            //Set profilePictureImageView and coverPhotoImageView with default placeholder if 'url' and 'url2' is empty
                            cell.profilePictureImageView.image = UIImage(named: "dummy-placeholder.jpg")
                            cell.coverPhotoImageView.image = UIImage(named: "dummy-placeholder.jpg")
                        }
                    }
                    
                    cell.storeNameTextField.enabled = false
                    cell.mobilePhoneTextField.text = self.storeInfoModel?.contact_number
                    cell.storeDescriptionTextView.text = self.storeInfoModel?.store_description
                    cell.storeNameTextField.text = self.storeInfoModel?.store_name
                    cell.tinTextField.text = self.storeInfoModel?.tin
                    
                    cell.profileEditImageView.image = UIImage(named: "edit.png")
                    cell.coverEditImageView.image = UIImage(named: "edit.png")
                    
                    if (!url.isEqual("")) {
                        cell.profileEditLabel.text = editPhoto
                        cell.coverEditLabel.text = editCover
                    } else {
                        cell.profileEditLabel.text = addPhoto
                        cell.coverEditLabel.text = addCover
                    }
                    
                    cell.verifyButton.setTitle(self.changeTitle, forState: UIControlState.Normal)
                    cell.tinLabel.text = self.tinTitle
                    cell.tinLabel.required()
                    cell.tinTextField.placeholder = self.tinTitle
                    cell.verifyButton.tag = 2
                } else {
                    cell.profileEditImageView.image = UIImage(named: "dummy-placeholder.jpg")
                    cell.coverEditImageView.image = UIImage(named: "dummy-placeholder.jpg")
                    cell.profileEditLabel.text = addPhoto
                    cell.coverEditLabel.text = addCover
                }
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier( storeInfoPreferredCategoriesTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoPreferredCategoriesTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if self.storeInfoModel != nil {
                cell.titleLabel.text = self.tableData[indexPath.row].title
                cell.setChecked(self.tableData[indexPath.row].isChecked)
            }
            
            return cell
        } else if indexPath.section == 2 {
            if self.hasQRCode {
                let cell: StoreInfoQrCodeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(storeInfoQRCodeTableViewCellIndentifier, forIndexPath: indexPath) as! StoreInfoQrCodeTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.shareButtonContainerView.hidden = false
                cell.generateQrButton.hidden = true
                cell.shareButtonContainerView.userInteractionEnabled = true
                cell.cannotGenerateLabel.hidden = true
                cell.cannotGenerateLabel.text = self.cannotGenerate
                
                if let url = NSURL(string: "\(self.qrUrl)") {
                    if let data = NSData(contentsOfURL: url){
                        cell.qrCodeImageView.image = UIImage(data: data)
                    } else {
                        cell.qrCodeImageView.image = nil
                        cell.qrCodeImageView.backgroundColor = UIColor.lightGrayColor()
                        cell.cannotGenerateLabel.hidden = false
                        cell.generateQrButton.hidden = false
                        cell.generateQrButton.setTitle(self.retryGenerate, forState: UIControlState.Normal)
                    }
                }
                
                cell.delegate = self
                
                return cell
            } else {
                let cell: StoreInfoSectionTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(storeInfoSectionTableViewCellIndentifier, forIndexPath: indexPath) as! StoreInfoSectionTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.qrCodeLabel.text = self.qrCode
                cell.generateLabel.text = self.generate
                
                if self.isFail {
                    cell.generateQRCodeButton.setTitle(self.retryGenerate, forState: UIControlState.Normal)
                } else {
                    cell.generateQRCodeButton.setTitle(self.generateQRCodeTitle, forState: UIControlState.Normal)
                }
                
                cell.delegate = self
                
                return cell
            }
        } else if indexPath.section == 3 {
            // TODO: Add delegate methods
            /*if self.storeInfoModel != nil {
                cell.referralCodeTextField.text = self.storeInfoModel?.referralCode
                cell.referralPersonNameTextField.text = self.storeInfoModel?.referralPerson
            }*/
            
            return self.referralCodeWithIndexPath(indexPath)
        } else if indexPath.section == 4 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier( storeInfoAddressTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoAddressTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            
            //Display current address
            cell.storeAddressTitleLabel.text = self.storeAddressTitle
            
            if self.storeInfoModel?.store_address != "" || self.storeInfoModel?.title != "" {
                cell.addressTitle.text = self.storeInfoModel?.title
                cell.addressLabel.text = self.storeInfoModel?.store_address
                cell.newAddressLabel.text = self.changeAddress
            } else {
                cell.addressLabel.text = self.addressNotSet
                cell.addressTitle.text = ""
                cell.newAddressLabel.text = self.newAddress
            }
            
            return cell
        } else if indexPath.section == 5 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier( storeInfoBankAccountTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoBankAccountTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            
            //Display current bank account
            cell.bankAccountTitleLabel.text = self.bankAccountTitle
            cell.newAccountLabel.text = self.newAccount
            cell.newAccountLabel.hidden = true
            cell.arrowButton.hidden = true
            
            if self.storeInfoModel?.accountTitle != "" || self.storeInfoModel?.bankAccount != "" {
                cell.bankAccountDetailLabel.text = self.storeInfoModel?.bankAccount
                cell.bankAccountInfoLabel.text = self.storeInfoModel?.accountTitle
            } else {
                cell.bankAccountDetailLabel.text = self.bankNotSet
                cell.bankAccountInfoLabel.text = ""
            }
            
            if self.storeInfoModel != nil {
                cell.accountTitle = self.storeInfoModel!.accountTitle
            }
            
            return cell
        } else {
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier( storeInfoAccountInformationTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoAccountInformationTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            
            cell.accountInfoLabel.text = self.accountInfo
            cell.passwordLabel.text = self.password
            cell.changePasswordButton.setTitle(changeTitle, forState: UIControlState.Normal)
            cell.saveLabel.text = save
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            //NOTE: Product category is only visible if the user is an affiliate
            //Check if isReseller is true, return self.storeInfoModel!.productCategoryName.count
            //Else, return 0
            if SessionManager.isReseller() {
                if self.storeInfoModel != nil {
                    return self.storeInfoModel!.productCategoryName.count
                } else {
                    return 0
                }
            } else {
                return 0
            }
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 623
        } else if indexPath.section == 1 {
            if SessionManager.isReseller() {
                return 44
            } else {
                return 0
            }
        } else if indexPath.section == 2 {
            if self.hasQRCode {
                return 341
            } else {
                return 208
            }
        } else if indexPath.section == 3 {
            if SessionManager.isSeller() {
                return 125
            } else {
                return 190
            }
        } else if indexPath.section == 4 {
            return 163
        } else if indexPath.section == 5 {
            return 163
        } else {
            return 221
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            if SessionManager.isReseller() {
                let headerView: StoreInfoPreferredCategoriesSectionView = XibHelper.puffViewWithNibName("AddProductHeaderView", index: 2) as! StoreInfoPreferredCategoriesSectionView
                return headerView
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            if SessionManager.isReseller() {
                return 50
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            if contains(self.selectedCategories, self.storeInfoModel!.productId[indexPath.row].toInt()!) {
                self.tableData[indexPath.row].isChecked = false
                if let index = find(self.selectedCategories, self.storeInfoModel!.productId[indexPath.row].toInt()!) {
                    self.selectedCategories.removeAtIndex(index)
                }
            } else {
                self.tableData[indexPath.row].isChecked = true
                self.selectedCategories.insert(self.storeInfoModel!.productId[indexPath.row].toInt()!, atIndex: self.selectedCategories.count)
            }
        }
        
        self.tableView.reloadData()
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        
        if indexPath.section == 1 {
            let originalStatus: Bool = self.tableData[indexPath.row].isChecked
            self.tableData[indexPath.row].isChecked = false
        }
        
        self.tableView.reloadData()
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }

    //MARK: -
    //MARK: - REST API request
    //MARK: POST METHOD - Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    *Function to refresh token to get another access token
    *
    */
    func fireRefreshToken(storeInfoType: StoreInfoType) {
        
        self.showLoader()
        
        let manager = APIManager.sharedInstance
        
        //Set parameter of POST method
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            //Parsed 'responseObject' json object
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            
            if storeInfoType == StoreInfoType.GetStroreInfo {
                self.fireStoreInfo()
            } else if storeInfoType == StoreInfoType.SaveStoreInfo{
                self.saveAccountInfo()
            } else if storeInfoType == StoreInfoType.SetMobile{
                self.setMobileNumber(self.newContactNumber, oldNumber: self.mobileNumber)
            } else if storeInfoType == StoreInfoType.VerifyNumber {
                self.verifyViewController()
            } else {
                self.generateQr()
            }
            
            self.hideLoader()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                //Catch unsuccessful return from the API
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    //Parsed error message from API return
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(self.error, message: errorModel.message)
                } else {
                    self.showAlert(Constants.Localized.error, message: self.somethingWentWrong)
                }
                
                self.hideLoader()
        })
        
    }
    
    //MARK: - POST METHOD - Fire Store Info
    /* Function to request store info.
    *
    * (Parameter) - access_token
    *
    *
    * If the API request is successful, it will parse the 'responseObject', storing it on storeInfoModel
    *
    * If the API request is unsuccessful, it will add empty view, update the counter and call
    * 'showAlert' function (funcion for handling of error based on the error type)
    */
    func fireStoreInfo(){
        
        self.showLoader()
        
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()]
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.sellerStoreInfo, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                //Parsed returned response from the API
                self.storeInfoModel = StoreInfoModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
                println(responseObject)
                //if response is successful generate for-loop in storeInfoModel and append each category in tableData
                for i in 0..<self.storeInfoModel!.productCategoryName.count {
                    self.tableData.append(StoreInfoPreferredCategoriesModel(title: self.storeInfoModel!.productCategoryName[i], isChecked: self.storeInfoModel!.isSelected[i], productId: self.storeInfoModel!.productId[i]))
                    
                    //if self.storeInfoModel!.isSelected[i] is true, then inser productId in selectedCategories array
                    if self.storeInfoModel!.isSelected[i] {
                        self.selectedCategories.insert(self.storeInfoModel!.productId[i].toInt()!, atIndex: self.selectedCategories.count)
                    }
                }
                
                //Reloading the tableview
                self.tableView.reloadData()
                self.hideLoader()
                
                self.refresh = true
            } else {
                self.hideLoader()
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(self.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                     self.fireRefreshToken(StoreInfoType.GetStroreInfo)
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
                }
            }
         })
    }
    
    //MARK: POST METHOD - Generate QR code
    /*
    *
    *
    *Function to generate QR code
    *
    */
    func generateQr() {
        
        self.showHUD()
        
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()]
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.sellerGenerateQrCode, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                //If isSuccessful is true, get data from 'data'
                //Check if value if 'qrcodeUrl' inside the 'data' object has content
                //Else, set qrUrl to empty
                let value: AnyObject = responseObject["data"]!!
                if let qrCode = value["qrcodeUrl"] as? String {
                    self.qrUrl = qrCode
                    self.hasQRCode = true
                } else {
                    self.qrUrl = ""
                }
                
                self.tableView.reloadData()
                self.dismissView()
                
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                self.dismissView()
                let indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 2)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(self.error, message: errorModel.message)
                    self.isFail = true
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(StoreInfoType.GenerateQR)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                    self.isFail = true
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    self.isFail = true
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    self.isFail = true
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                    self.isFail = true
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
            }
        })
    }
    
    //MARK: POST METHOD - Update changes in store info
    /*
    *
    * (Parameters) - if affiliate
    *                   - storeName, storeDescription, categoryIds, profilePhoto, coverPhoto
    *                else
    *                   - storeName, storeDescription, profilePhoto, coverPhoto
    *
    *Function to update changes made in store info
    *
    */
    func saveStoreInfo() {
    
        self.showHUD()
        
        var datas: [NSData] = []
        var imagesKeyProfile: [String] = []
        var imagesKeyCover: [String] = []
        
        //let url: String = "\(APIAtlas.sellerUpdateSellerInfo)?access_token=\(SessionManager.accessToken())"
        let parameters: NSDictionary?
        
        imagesKeyProfile.append("0")
        imagesKeyCover.append("0")
        
        if self.image != nil && self.imageCover != nil {
            let data: NSData = UIImageJPEGRepresentation(self.image, 0)
            let dataCoverPhoto: NSData = UIImageJPEGRepresentation(self.imageCover, 1)
            datas.append(data)
            datas.append(dataCoverPhoto)
        } else if self.image != nil && self.imageCover == nil{
            let data: NSData = UIImageJPEGRepresentation(self.image, 0)
            datas.append(data)
        } else if self.image == nil && self.imageCover != nil {
            let dataCoverPhoto: NSData = UIImageJPEGRepresentation(self.imageCover, 1)
            datas.append(dataCoverPhoto)
        }
        
        let data = NSJSONSerialization.dataWithJSONObject(self.selectedCategories, options: nil, error: nil)
        var formattedCategories: String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        
        //Set the parameter of the POST method
        if self.storeInfoModel!.isReseller {
            parameters = ["storeName" : self.storeInfoModel!.store_name, "storeDescription" : self.storeInfoModel!.store_description, "categoryIds" : formattedCategories, "profilePhoto" : imagesKeyProfile, "coverPhoto" : imagesKeyCover, "referralCode": self.referrerCode];
        } else {
            parameters = ["storeName" : self.storeInfoModel!.store_name, "storeDescription" : self.storeInfoModel!.store_description, "profilePhoto" : imagesKeyProfile, "coverPhoto" : imagesKeyCover, "referralCode": self.referrerCode];
        }
        
        if !self.storeInfoModel!.store_name.isEmpty && !self.storeInfoModel!.store_description.isEmpty {
            WebServiceManager.fireSaveStoreInfoRequestWithUrl(APIAtlas.sellerUpdateSellerInfo+"?access_token=\(SessionManager.accessToken())", parameters: parameters!, datas: datas, imageProfile: self.image, imageCover: self.imageCover, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                if successful {
                    //If isSuccessful is true, call method 'fireStoreInfo' to get store details
                    self.fireStoreInfo()
                    self.showAlert(self.successTitle, message: self.success)
                    
                    self.hud?.hide(true)
                } else {
                    self.hud?.hide(true)
                    if requestErrorType == .ResponseError {
                        //Error in api requirements
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        self.showAlert(self.error, message: errorModel.message)
                    } else if requestErrorType == .AccessTokenExpired {
                        self.fireRefreshToken(StoreInfoType.SaveStoreInfo)
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
                    }
                }
            })
        } else {
            var message: String = self.empty
            
            if self.storeInfoModel!.store_name.isEmpty && !self.storeInfoModel!.store_description.isEmpty {
                message = self.emptyStoreName
            } else if !self.storeInfoModel!.store_name.isEmpty && self.storeInfoModel!.store_description.isEmpty {
                message = self.emptyStoreDesc
            }
            
            self.showAlert(self.error, message: message)
            self.hud?.hide(true)
            self.dismissView()
        }
    }
    
    //MARK: ChangeMobileNumberViewControllerDelegate protocol method
    //MARK: POST METHOD - Update Mobile Number
    /*
    *
    * (Parameters) - access_token, oldContactNumber, newContactNumber
    *
    *Function to mobile number
    *
    */
    func setMobileNumber(newNumber: String, oldNumber: String) {
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        
        //Set parameter of the POST method
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "oldContactNumber" : oldNumber, "newContactNumber" : newNumber]
        
        self.mobileNumber = oldNumber
        self.newContactNumber = newNumber
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.sellerChangeMobileNumber, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                //If isSuccessful is true, get data from 'data'
                //Check if value if 'qrcodeUrl' inside the 'data' object has content
                //Else, set qrUrl to empty
                //If isSuccessful is true, call 'storeInfoVerify' method to call VerifyNumberViewController
                //Set verifyOrChange to 1
                self.verifyOrChange = 1
                self.storeInfoVerify(newNumber)
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                self.dismissView()
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(self.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(StoreInfoType.SetMobile)
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
                }
            }
        })
    }
    
    //MARK: - Resend verification code
    /*
    *
    *Function to resend verification code
    *
    */
    func verifyViewController() {
        
        self.showHUD()
        
        self.showView()
        //Set parameter of the POST method
        let parameters: NSDictionary = [:]
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.sellerResendVerification+"\(SessionManager.accessToken())&mobileNumber=\(self.mobileNumber)", parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                //If 'isSuccessful' is true, call VerifyNumberViewController
                var verifyNumberViewController = VerifyNumberViewController(nibName: "VerifyNumberViewController", bundle: nil)
                verifyNumberViewController.delegate = self
                verifyNumberViewController.mobileNumber = self.newContactNumber
                verifyNumberViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                verifyNumberViewController.providesPresentationContextTransitionStyle = true
                verifyNumberViewController.definesPresentationContext = true
                verifyNumberViewController.view.frame.origin.y = verifyNumberViewController.view.frame.size.height
                self.navigationController?.presentViewController(verifyNumberViewController, animated: true, completion:
                    nil)
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                self.dismissView()
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(self.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(StoreInfoType.VerifyNumber)
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
                }
            }
        })
    }
    
    //MARK: - 
    //MARK: - Referral Code
    func referralCodeWithIndexPath(indexPath: NSIndexPath) -> ReferralCodeTableViewCell {
        let cell: ReferralCodeTableViewCell = tableView.dequeueReusableCellWithIdentifier(ReferralCodeTableViewCell.nibNameAndIdentifier(), forIndexPath: indexPath) as! ReferralCodeTableViewCell
        
        cell.delegate = self
        cell.clipsToBounds = true
        
        if self.storeInfoModel != nil {
            if self.storeInfoModel!.referralCode != "" {
                cell.setYourReferralCodeWithCode(self.storeInfoModel!.referralCode)
            }
            
            if self.storeInfoModel!.referrerCode != "" {
                cell.setReferrerCodeWithCode("\(self.storeInfoModel!.referrerCode) - \(self.storeInfoModel!.referrerName)")
            }
            
            return cell
        }
        
        return cell
    }
    
    //MARK: - 
    //MARK: - Referral Code With Index Path
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
