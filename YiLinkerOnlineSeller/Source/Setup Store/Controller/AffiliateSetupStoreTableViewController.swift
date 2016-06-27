//
//  AffiliateSetupStoreTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit
import MessageUI

class AffiliateSetupStoreTableViewController: UITableViewController, StoreInfoQrCodeTableViewCellDelegate, SetupStoreFormTableViewCellDelegate, FooterButtonTableViewCellDelegate , AffiliateStoreHeaderTableViewCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate , MFMailComposeViewControllerDelegate {
    
    var affiliateStoreHeaderView: AffiliateStoreHeaderTableViewCell?
    var footerButtonTableViewCell: FooterButtonTableViewCell = FooterButtonTableViewCell()
    
    private let kTableHeaderHeight: CGFloat = 200.0
    
    private var isQRVisible: Bool = false
    
    var uploadImageType: UploadImageType = .ProfilePhoto
    
    private var affiliateStoreInfoModel: AffiliateStoreInfoModel = AffiliateStoreInfoModel()
    
    var storeInfoModel: StoreInfoModel = StoreInfoModel()
    
    var numberOfRows: Int = 2
    
    //MARK: -
    //MARK: - Nib Name
    class func nibName() -> String {
        return "AffiliateSetupStoreTableViewController"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    //MARK: -
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton()
        
        self.registerCellWithNibNameAndIdentifier(SetupStoreFormTableViewCell.nibNameAndIdentifier())
        self.registerCellWithNibNameAndIdentifier(StoreInfoQrCodeTableViewCell.nibNameAndIdentifier())
        self.registerCellWithNibNameAndIdentifier(AffiliateStoreHeaderTableViewCell.nibNameAndIdentifier())
        self.registerCellWithNibNameAndIdentifier(FooterButtonTableViewCell.nibNameAndIdentifer())
        
        self.addHeaderView()
        self.addFooterView()
        
        self.setViewTitleToTitle(StringHelper.localizedStringWithKey("SETUP_STORE_TITLE_LOCALIZE_KEY"))
        println(self.storeInfoModel.store_name)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 
    //MARK: - Set View Title To Title
    func setViewTitleToTitle(title: String) {
        self.title = title
    }
    
    //MARK: - 
    //MARK: - Register Cell With Nib Name And Identifier
    func registerCellWithNibNameAndIdentifier(nibNameAndIdentifer: String) {
        let nib: UINib = UINib(nibName: nibNameAndIdentifer, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: nibNameAndIdentifer)
    }
    
    //MARK: -
    //MARK: - Table View Data Source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.numberOfRows
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: SetupStoreFormTableViewCell = tableView.dequeueReusableCellWithIdentifier(SetupStoreFormTableViewCell.nibNameAndIdentifier(), forIndexPath: indexPath) as! SetupStoreFormTableViewCell
            cell.selectionStyle = .None
            cell.delegate = self
            
            if self.storeInfoModel.store_name != "" {
                cell.storeNameTextField.enabled = false
                cell.storeNameTextField.text = self.storeInfoModel.store_name
                self.affiliateStoreInfoModel.name = self.storeInfoModel.store_name
            } else {
                cell.storeNameTextField.enabled = true
            }
            
            if self.storeInfoModel.storeSlug != "" {
                cell.storeLinkTextField.enabled = false
                cell.storeLinkTextField.text = self.storeInfoModel.storeSlug
                self.affiliateStoreInfoModel.storeLink = self.storeInfoModel.storeSlug
            } else {
                cell.storeLinkTextField.enabled = true
            }
            
            cell.storeDescriptionTextView.text = self.storeInfoModel.store_description
            self.affiliateStoreInfoModel.storeDescription = self.storeInfoModel.store_description
            
            return cell
        } else {
            let cell: StoreInfoQrCodeTableViewCell = tableView.dequeueReusableCellWithIdentifier(StoreInfoQrCodeTableViewCell.nibNameAndIdentifier(), forIndexPath: indexPath) as! StoreInfoQrCodeTableViewCell
            cell.selectionStyle = .None
            // Configure the cell...
            cell.delegate = self
            cell.cannotGenerateLabel.hidden = true
            if self.isQRVisible {
                println("qr is visible")
                cell.shareButtonContainerView.hidden = false
                cell.shareButtonContainerView.transform = CGAffineTransformMakeTranslation(0, -60.0)
                cell.generateQrButton.hidden = true
//                cell.shareContainerVerticalSpaceConstraint.constant = 0
                cell.shareButtonContainerView.hidden = false
                cell.shareButtonContainerView.userInteractionEnabled = true

                cell.qrCodeImageView.sd_setImageWithURL(NSURL(string: self.affiliateStoreInfoModel.qrCodeImageUrl), placeholderImage: UIImage(named: "dummy-placeholder")!, completed: { (image, error, cacheType, url) -> Void in
                    if image != nil {
                        self.affiliateStoreInfoModel.qrCodeImage = image
                    }
                })
            } else {
                println("qr is not visible")
            }
            
            return cell
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return SetupStoreFormTableViewCell.height()
        } else {
            if self.isQRVisible {
                return StoreInfoQrCodeTableViewCell.heightIfQRCodeIsNotHidden()
            } else {
                return StoreInfoQrCodeTableViewCell.heightIfQRCodeIsHidden()
            }
        }
    }
    
    //MARK: - 
    //MARK: - Add Header View
    func addHeaderView() {
        self.affiliateStoreHeaderView = self.tableView.dequeueReusableCellWithIdentifier(AffiliateStoreHeaderTableViewCell.nibNameAndIdentifier()) as? AffiliateStoreHeaderTableViewCell
        self.affiliateStoreHeaderView!.delegate = self
        
        if "\(self.storeInfoModel.avatar)" != "" {
            self.affiliateStoreHeaderView?.profilePhotoCustomView.imageView.sd_setImageWithURL(self.storeInfoModel.avatar, placeholderImage: UIImage(named: "dummy-placeholder")!)
            self.affiliateStoreHeaderView?.profilePhotoCustomView.placeHolderView.hidden = true
        }
        
        if "\(self.storeInfoModel.coverPhoto)" != "" {
            self.affiliateStoreHeaderView?.coverPhotoCustomUploadView.imageView.sd_setImageWithURL(self.storeInfoModel.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder")!)
            self.affiliateStoreHeaderView?.coverPhotoCustomUploadView.placeHolderView.hidden = true
        }
        
        self.tableView.tableHeaderView = self.affiliateStoreHeaderView
    }
    
    //MARK: - 
    //MARK: - Add Footer View
    func addFooterView() {
        footerButtonTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(FooterButtonTableViewCell.nibNameAndIdentifer()) as! FooterButtonTableViewCell
        
        if self.storeInfoModel.name != "" && self.storeInfoModel.storeSlug != "" {
            footerButtonTableViewCell.button.setTitle(StringHelper.localizedStringWithKey("STORE_INFO_SAVE_LOCALIZE_KEY"), forState: UIControlState.Normal)
        } else {
            self.numberOfRows = 1
        }
        
        self.tableView.tableFooterView = footerButtonTableViewCell
        footerButtonTableViewCell.delegate = self
    }
    
    //MARK: -
    //MARK: Customize navigation bar - adding back button
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
    
    //MARK: -
    //MARK: Back
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //MARK: - 
    //MARK: - Store Info QR Code Table View Cell
    func shareFBAction(postImage: UIImageView, title: String) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText(self.affiliateStoreInfoModel.qrCodeImageUrl)
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: StringHelper.localizedStringWithKey("SETUP_STORE_FB_ERROR_LOCALIZE_KEY"), title: StringHelper.localizedStringWithKey("SETUP_STORE_UNABLE_ERROR_LOCALIZE_KEY"))
        }
    }
    
    func shareTWAction(postImage: UIImageView, title: String) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            var tweetShare: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetShare.setInitialText(self.affiliateStoreInfoModel.qrCodeImageUrl)
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: StringHelper.localizedStringWithKey("SETUP_STORE_TWITTER_ERROR_LOCALIZE_KEY"), title: StringHelper.localizedStringWithKey("SETUP_STORE_UNABLE_ERROR_LOCALIZE_KEY"))
        }
    }
    
    func shareEMAction(postImage: UIImageView, title: String) {
        if MFMailComposeViewController.canSendMail() {
            let myController = MFMailComposeViewController()
            myController.mailComposeDelegate = self
            myController.setSubject("QR Code")
            myController.setMessageBody("", isHTML: false)
            myController.setToRecipients([])
            
            let imageData = UIImagePNGRepresentation(postImage.image)
            myController.addAttachmentData(imageData!, mimeType: "image/png", fileName: "image")
            
            self.presentViewController(myController, animated: true, completion: nil)
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: StringHelper.localizedStringWithKey("SETUP_STORE_EMAIL_ERROR_LOCALIZE_KEY"), title: StringHelper.localizedStringWithKey("SETUP_STORE_UNABLE_ERROR_LOCALIZE_KEY"))
        }
        
    }
    
    func shareGPAction(postImage: UIImageView, title: String) {
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(false, completion: {
            
        })
    }
    
    func storeInfoQrCodeTableViewCell(storeInfoQrCodeTableViewCell: StoreInfoQrCodeTableViewCell, didTapGenerateQRButton button: UIButton) {
        /*self.isQRVisible = true
        
        var indexPath: NSIndexPath = self.tableView.indexPathForCell(storeInfoQrCodeTableViewCell)!
        self.tableView.reloadData()
        
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)*/
        
        //TODO:
        self.fireQrCodeWithQRCodeGenerateCell(storeInfoQrCodeTableViewCell)
    }
    
    //MARK: -
    //MARK: - Setup Store Form Table View Cell Delegate
    func setupStoreFormTableViewCell(setupStoreFormTableViewCell: SetupStoreFormTableViewCell, didTapReturnInTextField textField: UITextField) {
        if textField == setupStoreFormTableViewCell.storeNameTextField {
            setupStoreFormTableViewCell.storeDescriptionTextView.becomeFirstResponder()
        } else {
            self.tableView.endEditing(true)
        }
    }
    
    func setupStoreFormTableViewCell(setupStoreFormTableViewCell: SetupStoreFormTableViewCell, didStartEditingAtTextField textField: UITextField) {
      
    }
    
    func setupStoreFormTableViewCell(setupStoreFormTableViewCell: SetupStoreFormTableViewCell, didTapReturnInTextViewtextField: UITextView) {
        if setupStoreFormTableViewCell.storeLinkTextField.enabled == false {
            self.tableView.endEditing(true)
        } else {
            setupStoreFormTableViewCell.storeLinkTextField.becomeFirstResponder()
        }
        
    }

    func setupStoreFormTableViewCell(setupStoreFormTableViewCell: SetupStoreFormTableViewCell, didTextFieldChange textField: UITextField) {
        if textField == setupStoreFormTableViewCell.storeNameTextField {
            self.affiliateStoreInfoModel.name = textField.text
        } else if textField == setupStoreFormTableViewCell.storeLinkTextField {
            self.affiliateStoreInfoModel.storeLink = textField.text
        }
    }
    
    func setupStoreFormTableViewCell(setupStoreFormTableViewCell: SetupStoreFormTableViewCell, didTextViewChange textView: UITextView) {
        self.affiliateStoreInfoModel.storeDescription = textView.text
    }
    
    //MARK: - 
    //MARK: - Footer View Delegate
    func footerButtonTableViewCell(footerButtonTableViewCell: FooterButtonTableViewCell, didTapButton button: UIButton) {
        self.tableView.endEditing(true)
        self.tableView.userInteractionEnabled = false
        
        if affiliateStoreInfoModel.name != "" && affiliateStoreInfoModel.storeDescription != "" && affiliateStoreInfoModel.storeLink != "" {
            if self.affiliateStoreInfoModel.storeLink.isNoSpecialCharacters() {
                self.fireSetupStoreInfoWithUrl(footerButtonTableViewCell)
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: StringHelper.localizedStringWithKey("SETUP_STORE_LINK_ERROR_LOCALIZE_KEY"), title: StringHelper.localizedStringWithKey("SETUP_STORE_UNABLE_ERROR_LOCALIZE_KEY"))
            }
            
        } else {
            Toast.displayToastBottomWithMessage(StringHelper.localizedStringWithKey("SETUP_STORE_INCOMPLETE_ERROR_LOCALIZE_KEY"), duration: 2.0, view: self.navigationController!.view)
            self.tableView.userInteractionEnabled = true
            footerButtonTableViewCell.stopActivityIndicatorViewFromAnimating()
        }
    }
    
    //MARK: - 
    //MARK: - Affiliate Store Header Table View Cell Delegate
    func affiliateStoreHeaderTableViewCell(affiliateStoreHeaderTableViewCell: AffiliateStoreHeaderTableViewCell, didTapView customView: UIView) {
        self.uploadImageType = .CoverPhoto
        
        if customView == affiliateStoreHeaderTableViewCell.coverPhotoCustomUploadView {
            if self.affiliateStoreHeaderView?.coverPhotoCustomUploadView.uploadImageStatus == .NoPhoto {
                self.selectPhoto()
            } else if self.affiliateStoreHeaderView?.coverPhotoCustomUploadView.uploadImageStatus == .UploadError {
                self.affiliateStoreHeaderView?.coverPhotoCustomUploadView.startLoading()
            } else {
                self.selectPhoto()
            }
            
        } else {
            self.uploadImageType = .ProfilePhoto
            
            if self.affiliateStoreHeaderView?.profilePhotoCustomView.uploadImageStatus == .NoPhoto {
                self.selectPhoto()
            } else if self.affiliateStoreHeaderView?.profilePhotoCustomView.uploadImageStatus == .UploadError {
                self.affiliateStoreHeaderView?.profilePhotoCustomView.startLoading()
            } else {
                self.selectPhoto()
            }
        }
    }
    
    func selectPhoto() {
        var imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: - 
    //MARK: - Image Picker Controller Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
         dismissViewControllerAnimated(true, completion: nil)
        
        if self.uploadImageType == .ProfilePhoto {
            self.affiliateStoreHeaderView?.profilePhotoCustomView.imageView.image = image
            self.affiliateStoreHeaderView?.profilePhotoCustomView.startLoading()
            self.fireUploadPhotoWithUploadIMageType("profile", image: image)
            
        } else {
            self.affiliateStoreHeaderView?.coverPhotoCustomUploadView.imageView.image = image
            
            self.affiliateStoreHeaderView?.coverPhotoCustomUploadView.imageView.image = image
            self.affiliateStoreHeaderView?.coverPhotoCustomUploadView.startLoading()
           
            self.fireUploadPhotoWithUploadIMageType("cover", image: image)
           
        }
    }
    
    //MARK: - 
    //MARK: - Fire QR Code With QR Code Generate Cell
    func fireQrCodeWithQRCodeGenerateCell(storeInfoQrCodeTableViewCell: StoreInfoQrCodeTableViewCell) {
        storeInfoQrCodeTableViewCell.startLoading()
        
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()]
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.sellerGenerateQrCode, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            storeInfoQrCodeTableViewCell.stopLoading()
            
            if successful {
                let affiliateGenerateQrCodeModel: AffiliateGenerateQrCodeModel = AffiliateGenerateQrCodeModel.parseDataFromDictionary(responseObject as! NSDictionary)
                
                if affiliateGenerateQrCodeModel.isSuccessful {
                    self.isQRVisible = true
                    self.affiliateStoreInfoModel.qrCodeImageUrl = affiliateGenerateQrCodeModel.qrcodeUrl
                    var indexPath: NSIndexPath = self.tableView.indexPathForCell(storeInfoQrCodeTableViewCell)!
                    self.tableView.reloadData()
                    self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                }
                
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                } else if requestErrorType == .AccessTokenExpired {
                    
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
    //MARK: - Fire Upload Photo With Upload Image Type
    func fireUploadPhotoWithUploadIMageType(uploadImageType: String, image: UIImage) {
        WebServiceManager.fireUploadImageWithUrl(APIAtlas.uploadImageUrl, accessToken: SessionManager.accessToken(), image: image, type: uploadImageType,
            actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                if successful {
                    if uploadImageType == "profile" {
                        self.affiliateStoreHeaderView?.profilePhotoCustomView.uploadSuccess()
                        let uploadImageModel: UploadImageModel = UploadImageModel.parseDataFromDictionary(responseObject as! NSDictionary)
                        self.affiliateStoreInfoModel.profilePhotoFileName = uploadImageModel.fileName
                        println(uploadImageModel.fileName)
                    } else {
                        self.affiliateStoreHeaderView?.coverPhotoCustomUploadView.uploadSuccess()
                        let uploadImageModel: UploadImageModel = UploadImageModel.parseDataFromDictionary(responseObject as! NSDictionary)
                        self.affiliateStoreInfoModel.coverPhotoFileName = uploadImageModel.fileName
                        println(uploadImageModel.fileName)
                    }
                } else {
                    if requestErrorType == .ResponseError {
                        println("error: \(responseObject as! NSDictionary)")
                        
                        if uploadImageType == "profile" {
                            self.affiliateStoreHeaderView?.profilePhotoCustomView.showErrorLoading()
                        } else {
                            self.affiliateStoreHeaderView?.coverPhotoCustomUploadView.showErrorLoading()
                        }
                        
                    } else if requestErrorType == .AccessTokenExpired {
                        
                        if uploadImageType == "profile" {
                            self.fireRefreshTokenWithRefreshType(.Profile, params: [image, uploadImageType])
                        } else {
                            self.fireRefreshTokenWithRefreshType(.Cover, params: [image, uploadImageType])
                        }
                        
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
        })
    }
    
    //MARK: -
    //MARK: - Fire Refresh Token With Refresh Type
    func fireRefreshTokenWithRefreshType(setupStoreRefreshType: SetupStoreRefreshType, params: [AnyObject]) {
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireUploadPhotoWithUploadIMageType(params[1] as! String, image: params[0] as! UIImage)
            } else {
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        })
    }
    
    //MARK: -
    //MARK: - Fire Setup Store Info With Url
    func fireSetupStoreInfoWithUrl(footerButtonTableViewCell: FooterButtonTableViewCell) {
        WebServiceManager.fireAffiliateStoreSetupWithUrl(APIAtlas.affiliateStoreSetupUrl, storeLink: self.affiliateStoreInfoModel.storeLink, storeName: self.affiliateStoreInfoModel.name, storeDescription: self.affiliateStoreInfoModel.storeDescription, profilePhoto: self.affiliateStoreInfoModel.profilePhotoFileName, coverPhoto: self.affiliateStoreInfoModel.coverPhotoFileName)
            { (successful, responseObject, requestErrorType) -> Void in
               
                if successful {
                    footerButtonTableViewCell.stopActivityIndicatorViewFromAnimating()
                    self.tableView.userInteractionEnabled = true
                    
                    if footerButtonTableViewCell.button.titleLabel!.text == StringHelper.localizedStringWithKey("STORE_INFO_SAVE_LOCALIZE_KEY") {
                        self.navigationController!.popToRootViewControllerAnimated(true)
                    } else {
                        let vc: AffiliateSelectProductViewController = AffiliateSelectProductViewController(nibName: AffiliateSelectProductViewController.nibName(), bundle: nil) as AffiliateSelectProductViewController
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    if requestErrorType == .ResponseError {
                        //Error in api requirements
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.navigationController!.view)
                        footerButtonTableViewCell.stopActivityIndicatorViewFromAnimating()
                        self.tableView.userInteractionEnabled = true
                    } else if requestErrorType == .AccessTokenExpired {
                        self.fireRefreshTokenWithRefreshType(.Profile, params: [self.affiliateStoreInfoModel.storeLink, self.affiliateStoreInfoModel.name, self.affiliateStoreInfoModel.storeDescription])
                    } else if requestErrorType == .PageNotFound {
                        footerButtonTableViewCell.stopActivityIndicatorViewFromAnimating()
                        self.tableView.userInteractionEnabled = true
                        Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                    } else if requestErrorType == .NoInternetConnection {
                        footerButtonTableViewCell.stopActivityIndicatorViewFromAnimating()
                        self.tableView.userInteractionEnabled = true
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    } else if requestErrorType == .RequestTimeOut {
                        footerButtonTableViewCell.stopActivityIndicatorViewFromAnimating()
                        self.tableView.userInteractionEnabled = true
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    } else if requestErrorType == .UnRecognizeError {
                        footerButtonTableViewCell.stopActivityIndicatorViewFromAnimating()
                        self.tableView.userInteractionEnabled = true
                        Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                    }
                }

        }
    }
}