//
//  StoreInfoViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class StoreInfoViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, StoreInfoTableViewCellDelegate, StoreInfoSectionTableViewCellDelegate, StoreInfoBankAccountTableViewCellDelegate , StoreInfoAccountInformationTableViewCellDelegate, ChangeBankAccountViewControllerDelegate, ChangeAddressViewControllerDelegate, ChangeMobileNumberViewControllerDelegate, StoreInfoAddressTableViewCellDelagate, ChangeEmailViewControllerDelegate, VerifyViewControllerDelegate, CongratulationsViewControllerDelegate, UzysAssetsPickerControllerDelegate, StoreInfoQrCodeTableViewCellDelegate{
    
    var storeInfoModel: StoreInfoModel?
    var storeAddressModel: StoreAddressModel?
    
    let storeInfoHeaderTableViewCellIndentifier: String = "StoreInfoTableViewCell"
    let storeInfoSectionTableViewCellIndentifier: String = "StoreInfoSectionTableViewCell"
    let storeInfoQRCodeTableViewCellIndentifier: String = "StoreInfoQrCodeTableViewCell"
    let storeInfoAddressTableViewCellIdentifier: String = "StoreInfoAddressTableViewCell"
    let storeInfoBankAccountTableViewCellIdentifier: String = "StoreInfoBankAccountTableViewCell"
    let storeInfoAccountInformationTableViewCellIdentifier: String = "StoreInfoAccountInformationTableViewCell"

    var hud: MBProgressHUD?
    
    var dimView: UIView = UIView()
    
    var index: NSIndexPath?
    
    var uploadImages: [UIImage] = []
    
    var image: UIImage?
    var imageCover: UIImage?
    
    var verifyOrChange: Int = 0
    var imageType: String = ""
    var mobileNumber: String = ""
    var newContactNumber: String = ""
    var hasQRCode: Bool = false
    
    let storeInfoTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_TITLE_LOCALIZE_KEY")
    let addPhoto: String = StringHelper.localizedStringWithKey("STORE_INFO_ADD_PHOTO_LOCALIZE_KEY")
    let editPhoto: String = StringHelper.localizedStringWithKey("STORE_INFO_EDIT_PHOTO_LOCALIZE_KEY")
    let addCover: String = StringHelper.localizedStringWithKey("STORE_INFO_ADD_COVER_LOCALIZE_KEY")
    let editCover: String = StringHelper.localizedStringWithKey("STORE_INFO_EDIT_COVER_LOCALIZE_KEY")
    let storeInfo: String = StringHelper.localizedStringWithKey("STORE_INFO_STORE_INFO_LOCALIZE_KEY")
    let storeName: String = StringHelper.localizedStringWithKey("STORE_INFO_STORE_NAME_LOCALIZE_KEY")
    let storeDesc: String = StringHelper.localizedStringWithKey("STORE_INFO_STORE_DESC_LOCALIZE_KEY")
    let mobilePhone: String = StringHelper.localizedStringWithKey("STORE_INFO_MOBILE_LOCALIZE_KEY")
    let changeTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_CHANGE_LOCALIZE_KEY")
    let qrCode: String = StringHelper.localizedStringWithKey("STORE_INFO_QR_LOCALIZE_KEY")
    let generate: String = StringHelper.localizedStringWithKey("STORE_INFO_GENERATE_LOCALIZE_KEY")
    let generateQRCodeTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_GENERATE_QR_LOCALIZE_KEY")
    let storeAddressTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_STORE_ADDRESS_LOCALIZE_KEY")
    let newAddress: String = StringHelper.localizedStringWithKey("STORE_INFO_NEW_ADDRESS_LOCALIZE_KEY")
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
    let empty: String = StringHelper.localizedStringWithKey("STORE_INFO_EMPTY_LOCALIZE_KEY")
    let successTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_TITLE_LOCALIZE_KEY")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = storeInfoTitle
        self.edgesForExtendedLayout = .None
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        self.hasQRCode = true
        
        self.initializeViews()
        self.registerNibs()
        self.fireStoreInfo()
        self.backButton()
        
        var tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
       
    }
    
    //MARK: Initialize views
    func initializeViews() {
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
    }
    
    //MARK: Get store info
    func fireStoreInfo(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.POST(APIAtlas.sellerStoreInfo, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.storeInfoModel = StoreInfoModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
            
            println("store info \(responseObject)")
            if responseObject["isSuccessful"] as! Bool {
                self.tableView.reloadData()
            } else {
                self.showAlert(Constants.Localized.error, message: responseObject["message"] as! String)
            }
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(self.error, message: errorModel.message)
                    //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                } else if task.statusCode == 401 {
                    self.fireRefreshToken(StoreInfoType.GetStroreInfo)
                } else {
                    self.showAlert(self.error, message: self.somethingWentWrong)
                }
        })
    }
    
    //MARK: Navigation bar
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
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //MARK: Tableview delegate methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("sections \(indexPath.section) row \(indexPath.row)")
        println("\(self.storeInfoModel?.store_address)")
  
        if indexPath.section == 0 {
            
            let cell: StoreInfoTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(storeInfoHeaderTableViewCellIndentifier, forIndexPath: indexPath) as! StoreInfoTableViewCell
            index = indexPath
            cell.delegate = self
            
            cell.storeInfoLabel.text = self.storeInfo
            cell.storeNameLabel.text = self.storeName
            cell.storeDescriptionLabel.text = self.storeDesc
            cell.mobilePhoneLabel.text = self.mobilePhone
            cell.verifyButton.setTitle(self.changeTitle, forState: UIControlState.Normal)
            
            if(self.storeInfoModel?.store_name != nil){
               
                if self.image != nil || self.imageCover != nil {
                    cell.coverEditImageView.image = self.imageCover
                    cell.profilePictureImageView.image = self.image
                } else {
                    cell.coverPhotoImageView.sd_setImageWithURL(self.storeInfoModel!.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                    cell.profilePictureImageView.sd_setImageWithURL(self.storeInfoModel!.avatar, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                }
                
                cell.storeNameTextField.text = self.storeInfoModel?.store_name
                cell.mobilePhoneTextField.text = self.storeInfoModel?.contact_number
                cell.storeDescriptionTextView.text = self.storeInfoModel?.store_description
                cell.profileEditImageView.image = UIImage(named: "edit.png")
                cell.coverEditImageView.image = UIImage(named: "edit.png")
                let url: NSString = NSString(string: (self.storeInfoModel?.avatar)!.absoluteString!)
                if (!url.isEqual("")) {
                    cell.profileEditLabel.text = editPhoto
                    cell.coverEditLabel.text = editCover
                } else {
                    cell.profileEditLabel.text = addPhoto
                    cell.coverEditLabel.text = addCover
                }
                
                //if(self.verifyOrChange == 1) {
                //    cell.verifyButton.setTitle("Verify", forState: UIControlState.Normal)
                //} else {
                cell.verifyButton.setTitle(self.changeTitle, forState: UIControlState.Normal)
                //}
                cell.verifyButton.tag = 2
            } else {
                cell.profileEditImageView.image = UIImage(named: "dummy-placeholder.jpg")
                cell.coverEditImageView.image = UIImage(named: "dummy-placeholder.jpg")
                cell.profileEditLabel.text = addPhoto
                cell.coverEditLabel.text = addCover
            }
           
            return cell
        } else if indexPath.section == 1 {
            if self.hasQRCode {
                let cell: StoreInfoQrCodeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(storeInfoQRCodeTableViewCellIndentifier, forIndexPath: indexPath) as! StoreInfoQrCodeTableViewCell
                cell.delegate = self
                return cell
            } else {
                let cell: StoreInfoSectionTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(storeInfoSectionTableViewCellIndentifier, forIndexPath: indexPath) as! StoreInfoSectionTableViewCell
                cell.qrCodeLabel.text = self.qrCode
                cell.generateLabel.text = self.generate
                cell.generateQRCodeButton.setTitle(self.generateQRCodeTitle, forState: UIControlState.Normal)
                cell.delegate = self
                return cell
            }
       } else if indexPath.section == 2 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier( storeInfoAddressTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoAddressTableViewCell
            cell.delegate = self
            //Display current bank account
            cell.addressLabel.text = self.storeInfoModel?.store_address
            cell.addressTitle.text = self.storeInfoModel?.title
            cell.storeAddressTitleLabel.text = self.storeAddressTitle
            cell.newAddressLabel.text = self.newAddress
            return cell
        } else if indexPath.section == 3 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier( storeInfoBankAccountTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoBankAccountTableViewCell
            cell.delegate = self
            //Display current bank account
            cell.bankAccountTitleLabel.text = self.bankAccountTitle
            cell.bankAccountDetailLabel.text = self.storeInfoModel?.bankAccount
            cell.bankAccountInfoLabel.text = self.storeInfoModel?.accountTitle
            cell.newAccountLabel.text = self.newAccount
            println(cell)
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier( storeInfoAccountInformationTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoAccountInformationTableViewCell
            cell.delegate = self
            cell.accountInfoLabel.text = self.accountInfo
            cell.passwordLabel.text = self.password
            cell.changePasswordButton.setTitle(changeTitle, forState: UIControlState.Normal)
            cell.saveButton.setTitle(save, forState: UIControlState.Normal)
            //cell.emailAddressTextField.text = self.storeInfoModel?.email
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 502
        } else if indexPath.section == 1 {
            if self.hasQRCode {
                return 322
            } else {
                return 198
            }            
        } else if indexPath.section == 2 {
            return 163
        } else  if indexPath.section == 3 {
            return 163
        } else {
            return 221
        }
    }
    
    func storeNameAndDescription(storeName: String, storeDescription: String) {
        self.storeInfoModel?.store_name = storeName
        self.storeInfoModel?.store_description = storeDescription
    }
    //MARK: Store Details Function
    func storeInfoVerify() {
        println("verify " + "\(self.verifyOrChange)")
        self.showView()
        
        if self.verifyOrChange == 1 {
            var verifyNumberViewController = VerifyNumberViewController(nibName: "VerifyNumberViewController", bundle: nil)
            verifyNumberViewController.delegate = self
            verifyNumberViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            verifyNumberViewController.providesPresentationContextTransitionStyle = true
            verifyNumberViewController.definesPresentationContext = true
            verifyNumberViewController.view.frame.origin.y = verifyNumberViewController.view.frame.size.height
            self.tabBarController?.presentViewController(verifyNumberViewController, animated: true, completion:
                nil)
            self.verifyOrChange = 2
            verifyNumberViewController.mobileNumber = self.mobileNumber
            println(verifyNumberViewController.mobileNumber)
        } else {
            var changeMobileNumber = ChangeMobileNumberViewController(nibName: "ChangeMobileNumberViewController", bundle: nil)
            changeMobileNumber.delegate = self
            changeMobileNumber.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            changeMobileNumber.providesPresentationContextTransitionStyle = true
            changeMobileNumber.definesPresentationContext = true
            changeMobileNumber.view.frame.origin.y = changeMobileNumber.view.frame.size.height
            self.tabBarController?.presentViewController(changeMobileNumber, animated: true, completion:
                nil)
            self.verifyOrChange = 2
        }

    }

    func newBankAccount() {
        var changeBankAccountViewController = ChangeBankAccountViewController(nibName: "ChangeBankAccountViewController", bundle: nil)
        changeBankAccountViewController.delegate = self
        self.navigationController?.pushViewController(changeBankAccountViewController, animated:true)
        
    }
    
    func changeToNewAddress() {
        var changeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        changeAddressViewController.delegate = self
        self.navigationController?.pushViewController(changeAddressViewController, animated:true)
    }

    func changePassword() {
        println("Email Password")
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
    
    //MARK: CongratulationsViewController protocol method
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
    
    //MARK: VerifyViewController protocol method
    func verifyViewController() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.sellerResendVerification+"\(SessionManager.accessToken())&mobileNumber=\(self.mobileNumber)", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                println(responseObject.description)
                if responseObject["isSuccessful"] as! Bool {
                    var verifyNumberViewController = VerifyNumberViewController(nibName: "VerifyNumberViewController", bundle: nil)
                    verifyNumberViewController.delegate = self
                    verifyNumberViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                    verifyNumberViewController.providesPresentationContextTransitionStyle = true
                    verifyNumberViewController.definesPresentationContext = true
                    verifyNumberViewController.view.frame.origin.y = verifyNumberViewController.view.frame.size.height
                    self.navigationController?.presentViewController(verifyNumberViewController, animated: true, completion:
                    nil)
                //self.dismissView()
                } else {
                    self.showAlert(self.error, message: self.invalid)
                }
                //self.setSelectedViewControllerWithIndex(0)
                self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(self.error, message: errorModel.message)
                    //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                } else if task.statusCode == 401 {
                    self.fireRefreshToken(StoreInfoType.VerifyNumber)
                } else {
                    self.showAlert(self.error, message: self.somethingWentWrong)
                }
                self.dismissView()
        })
        self.showView()
    }
    
    func saveAccountInfo() {
        self.showHUD()

        //self.tableView.reloadData()
        let cell: StoreInfoTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(storeInfoHeaderTableViewCellIndentifier, forIndexPath: index!) as! StoreInfoTableViewCell
        cell.delegate = self

        let manager = APIManager.sharedInstance
        
        var datas: [NSData] = []
        
        var imagesKeyProfile: [String] = []
        var imagesKeyCover: [String] = []

        for var x = 0; x < 1; x++ {
            imagesKeyProfile.append("\(x)")
        }
        
        for var x = 0; x < 1; x++ {
            imagesKeyCover.append("\(x)")
        }
    
        if self.image != nil && self.imageCover != nil {
            let data: NSData = UIImageJPEGRepresentation(self.image, 0)
            let dataCoverPhoto: NSData = UIImageJPEGRepresentation(self.imageCover, 1)
            datas.append(data)
            datas.append(dataCoverPhoto)
        } else if self.image != nil && self.imageCover == nil{
            let data: NSData = UIImageJPEGRepresentation(self.image, 0)
            datas.append(data)
        } else if self.image == nil && self.imageCover != nil {
            let dataCoverPhoto: NSData = UIImageJPEGRepresentation(self.imageCover, 0)
            datas.append(dataCoverPhoto)
        }
       
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "storeName" : cell.storeNameTextField.text, "storeDescription" : cell.storeDescriptionTextView.text, "profilePhoto" : imagesKeyProfile, "coverPhoto" : imagesKeyCover];

        let url: String = "\(APIAtlas.sellerUpdateSellerInfo)?access_token=\(SessionManager.accessToken())"
        
        if !cell.storeNameTextField.text.isEmpty && !cell.storeNameTextField.text.isEmpty {
            manager.POST(url, parameters: parameters, constructingBodyWithBlock: { (formData: AFMultipartFormData) -> Void in
                for (index, data) in enumerate(datas) {
                    println("index: \(index)")
                    if self.image != nil && self.imageCover != nil {
                        if(index == 0){
                            formData.appendPartWithFileData(data, name: "profilePhoto", fileName: "\(0)", mimeType: "image/jpeg")
                        } else {
                            formData.appendPartWithFileData(data, name: "coverPhoto", fileName: "\(1)", mimeType: "image/jpeg")
                        }
                    } else if self.image != nil && self.imageCover == nil{
                        formData.appendPartWithFileData(data, name: "profilePhoto", fileName: "\(index)", mimeType: "image/jpeg")
                    } else if self.image == nil && self.imageCover != nil {
                        formData.appendPartWithFileData(data, name: "coverPhoto", fileName: "\(index)", mimeType: "image/jpeg")
                    }
                }
                
                }, success: { (NSURLSessionDataTask, response: AnyObject) -> Void in
                    self.hud?.hide(true)
                    
                    println(response)
                    self.fireStoreInfo()
                    self.tableView.reloadData()
                    //cell.coverPhotoImageView.image = self.image
                    self.showAlert(self.successTitle, message: self.success)
                }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    println(error.userInfo)
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        self.showAlert(self.error, message: errorModel.message)
                        //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    } else if task.statusCode == 401 {
                        self.fireRefreshToken(StoreInfoType.SaveStoreInfo)
                    } else {
                        self.showAlert(self.error, message: self.somethingWentWrong)
                    }
   
                    self.hud?.hide(true)
            }
        } else {
            self.showAlert(self.error, message: self.empty)
            self.hud?.hide(true)
            self.dismissView()
        }
        
    }
    
    func generateQRCode() {
        println("QR Code")
    }
    
    //MARK: ChangeBankAccountViewControllerDelegate protoco method
    func updateBankDetail(accountTitle: String, accountName: String, accountNumber: String, bankName: String) {
        self.storeInfoModel?.accountTitle = accountTitle
        self.storeInfoModel?.bankAccount = accountName + "\n"+accountNumber+"\n" + bankName
        self.tableView.reloadData()
    }
    
    //MARK: ChangeStoreAddressViewControllerDelegate protoco method
    func updateStoreAddressDetail(title: String, storeAddress: String) {
        self.storeInfoModel?.title = title
        self.storeInfoModel?.store_address = storeAddress
        self.tableView.reloadData()
    }
    
    //MARK: ChangeMobileNumberViewControllerDelegate protocol method
    func setMobileNumber(newNumber: String, oldNumber: String) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "oldContactNumber" : oldNumber, "newContactNumber" : newNumber];
        self.mobileNumber = oldNumber
        self.newContactNumber = newNumber
        manager.POST(APIAtlas.sellerChangeMobileNumber, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            if responseObject["isSuccessful"] as! Bool {
                //self.storeInfoModel?.contact_number = newNumber
                self.verifyOrChange = 1
                println(self.verifyOrChange)
                self.mobileNumber = newNumber
                self.storeInfoVerify()
                self.hud?.hide(true)
            } else {
                self.showAlert("Error", message: responseObject["message"] as! String)
                self.dismissView()
                self.hud?.hide(true)
            }
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(self.error, message: errorModel.message)
                    //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                } else if task.statusCode == 401 {
                     self.fireRefreshToken(StoreInfoType.SetMobile)
                } else {
                    self.showAlert(self.error, message: self.somethingWentWrong)
                }
                /*
                if task.statusCode == 401{
                   
                } else if task.statusCode == 404 || task.statusCode == 400 {
                    let data = error.userInfo as! Dictionary<String, AnyObject>
                    var message = data["data"] as! Dictionary<String, AnyObject>
                    if !message.isEmpty {
                        var err = message["errors"] as! NSArray
                        self.showAlert(Constants.Localized.error, message: err[0] as! String)
                    } else {
                        self.showAlert(Constants.Localized.error, message: data["message"] as! String)
                    }
                } else {
                    self.showAlert(Constants.Localized.error, message: self.somethingWentWrong)
                }*/
                self.dismissView()
        })
    }
    
    func fireRefreshToken(storeInfoType: StoreInfoType) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            
            if storeInfoType == StoreInfoType.GetStroreInfo {
                self.fireStoreInfo()
            } else if storeInfoType == StoreInfoType.SaveStoreInfo{
                self.saveAccountInfo()
            } else if storeInfoType == StoreInfoType.SetMobile{
                self.setMobileNumber(self.newContactNumber, oldNumber: self.mobileNumber)
            } else {
                self.verifyViewController()
            }
            
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }
    
    func getStoreInfo() {
        self.fireStoreInfo()
        self.tableView.reloadData()
    }
    
    func shareAction(postImage: UIImageView, title: String) {
        var sharingItems = [AnyObject]()
        let image = postImage.image
        
        if (postImage.image != nil) {
            sharingItems = [title, postImage.image!]
        } else {
            sharingItems = [title]
        }
        
        let activityController = UIActivityViewController(activityItems:
            sharingItems, applicationActivities: nil)
        self.presentViewController(activityController, animated: true,
            completion: nil)
       // sharingItems.append(NSURL(string: "https://sociobiology.files.wordpress.com/2013/07/strassmann-queller-qr-code.jpg")!)
        
        //let shareViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        //self.presentViewController(shareViewController, animated: true, completion: nil)
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

    //MARK: Dismiss dim view
    func dismissView() {
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0
            }, completion: { finished in
                self.dimView.hidden = true
        })
    }
    
    //MARK: Show dim view
    func showView(){
        dimView.hidden = false
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0.5
            }, completion: { finished in
        })
    }

    //MARK: Open UzyPicker
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
            let image: UIImage = UIImage(CGImage: allaSset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())!
            self.uploadImages.insert(image, atIndex: 0)

            self.setImageProfileCoverPhoto(image)
        }
        
        //self.reloadUploadCellCollectionViewData()
        //self.storeInfoTableView.reloadData()
    }
    
    func uzysAssetsPickerControllerDidCancel(picker: UzysAssetsPickerController!) {
        
    }
    
    func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker: UzysAssetsPickerController!) {
        
    }
    
    func textViewNextResponder(textView: UITextView) {
        textView.becomeFirstResponder()
    }
    
    //MARK: Set image/s for StoreInfoTableViewCell imageviews
    func setImageProfileCoverPhoto(image: UIImage){
        let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell: StoreInfoTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! StoreInfoTableViewCell
        //cell.collectionView.reloadData()
        if self.imageType == "profile" {
            cell.profilePictureImageView.image = nil
            cell.profilePictureImageView.image = image
            self.image = image
        } else {
            //Cover photo
            cell.coverPhotoImageView.image = nil
            cell.coverPhotoImageView.image = image
            self.imageCover = image
        }
    }
    
    func reloadUploadCellCollectionViewData() {
     
    }

    //MARK: Dismiss keyboard
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK: Alert view
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: self.ok, style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
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
