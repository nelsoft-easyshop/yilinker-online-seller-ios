//
//  StoreInfoViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit
import MessageUI

class StoreInfoViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, StoreInfoTableViewCellDelegate, StoreInfoSectionTableViewCellDelegate, StoreInfoBankAccountTableViewCellDelegate , StoreInfoAccountInformationTableViewCellDelegate, ChangeBankAccountViewControllerDelegate, ChangeAddressViewControllerDelegate, ChangeMobileNumberViewControllerDelegate, StoreInfoAddressTableViewCellDelagate, ChangeEmailViewControllerDelegate, VerifyViewControllerDelegate, CongratulationsViewControllerDelegate, UzysAssetsPickerControllerDelegate, StoreInfoQrCodeTableViewCellDelegate, MFMailComposeViewControllerDelegate, GPPSignInDelegate {
    
    var storeInfoModel: StoreInfoModel?
    var storeAddressModel: StoreAddressModel?
    
    let storeInfoHeaderTableViewCellIndentifier: String = "StoreInfoTableViewCell"
    let storeInfoSectionTableViewCellIndentifier: String = "StoreInfoSectionTableViewCell"
    let storeInfoQRCodeTableViewCellIndentifier: String = "StoreInfoQrCodeTableViewCell"
    let storeInfoAddressTableViewCellIdentifier: String = "StoreInfoAddressTableViewCell"
    let storeInfoBankAccountTableViewCellIdentifier: String = "StoreInfoBankAccountTableViewCell"
    let storeInfoAccountInformationTableViewCellIdentifier: String = "StoreInfoAccountInformationTableViewCell"
    let storeInfoPreferredCategoriesTableViewCellIdentifier: String = "StoreInfoPreferredCategoriesTableViewCell"
    var hud: MBProgressHUD?
    
    var dimView: UIView = UIView()
    
    var index: NSIndexPath?
    
    var uploadImages: [UIImage] = []
    
    var image: UIImage?
    var imageCover: UIImage?
    var imageToPost: UIImage?
    
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
    let empty: String = StringHelper.localizedStringWithKey("STORE_INFO_EMPTY_LOCALIZE_KEY")
    let successTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_TITLE_LOCALIZE_KEY")
    let tinTitle: String = StringHelper.localizedStringWithKey("STORE_INFO_TIN_LOCALIZE_KEY")
    let bankNotSet: String = StringHelper.localizedStringWithKey("STORE_INFO_NO_BANK_LOCALIZE_KEY")
    let addressNotSet: String = StringHelper.localizedStringWithKey("STORE_INFO_NO_ADDRESS_LOCALIZE_KEY")
    
    var qrUrl: String = ""
    var qr: String = ""
    
    var tableData: [StoreInfoPreferredCategoriesModel] = []
    var selectedCategories: [Int] = []
    
    //Google Plus Sign In
    var kClientId = "120452328739-36rpdqne3pvgj21p7ptru7daqp0tgiik.apps.googleusercontent.com"; // Get this from https://console.developers.google.com
    var kShareURL = "https://yilinker.com/";
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = storeInfoTitle
        self.edgesForExtendedLayout = .None
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        self.hasQRCode = false
        
        self.initializeViews()
        self.registerNibs()
        self.fireStoreInfo()
        self.backButton()
        
        /*
        self.tableData.append(StoreInfoPreferredCategoriesModel(title: "Clothing", isChecked: false))
        self.tableData.append(StoreInfoPreferredCategoriesModel(title: "Gadgets", isChecked: false))
        self.tableData.append(StoreInfoPreferredCategoriesModel(title: "Shoes", isChecked: false))
        self.tableData.append(StoreInfoPreferredCategoriesModel(title: "Home Improvements", isChecked: false))
        self.tableData.append(StoreInfoPreferredCategoriesModel(title: "Toys, Kids and Babies", isChecked: false))
        self.tableData.append(StoreInfoPreferredCategoriesModel(title: "Health and Beauty", isChecked: false))
        */
        
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
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        updateUI();
    }
    
    
    func updateUI() {
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
        
        var storeInfoPreferredCategories = UINib(nibName: storeInfoPreferredCategoriesTableViewCellIdentifier, bundle: nil)
        self.tableView.registerNib(storeInfoPreferredCategories, forCellReuseIdentifier: storeInfoPreferredCategoriesTableViewCellIdentifier)
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
                for var i: Int = 0; i < self.storeInfoModel?.productCategoryName.count; i++ {
                    self.tableData.append(StoreInfoPreferredCategoriesModel(title: self.storeInfoModel!.productCategoryName[i], isChecked: self.storeInfoModel!.isSelected[i], productId: self.storeInfoModel!.productId[i]))
                    if self.storeInfoModel!.isSelected[i] {
                        self.selectedCategories.insert(self.storeInfoModel!.productId[i].toInt()!, atIndex: self.selectedCategories.count)
                    }
                    println(self.selectedCategories)
                }
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
       return 6
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
        if indexPath.section == 0 {
            
            let cell: StoreInfoTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(storeInfoHeaderTableViewCellIndentifier, forIndexPath: indexPath) as! StoreInfoTableViewCell
            index = indexPath
            cell.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.storeInfoLabel.text = self.storeInfo
            cell.storeNameLabel.text = self.storeName
            cell.storeDescriptionLabel.text = self.storeDesc
            cell.mobilePhoneLabel.text = self.mobilePhone
            cell.verifyButton.setTitle(self.changeTitle, forState: UIControlState.Normal)
            
            if(self.storeInfoModel?.store_name != nil){
                
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
                        cell.profilePictureImageView.sd_setImageWithURL(self.storeInfoModel!.avatar, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                        cell.coverPhotoImageView.sd_setImageWithURL(self.storeInfoModel!.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                    } else if url == "" && url2 != "" {
                        cell.profilePictureImageView.image = UIImage(named: "dummy-placeholder.jpg")
                        cell.coverPhotoImageView.sd_setImageWithURL(self.storeInfoModel!.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                    } else {
                        cell.profilePictureImageView.sd_setImageWithURL(self.storeInfoModel!.avatar, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                        cell.coverPhotoImageView.image = UIImage(named: "dummy-placeholder.jpg")
                    }
                    
                }
                
                cell.storeNameTextField.text = self.storeInfoModel?.store_name
                cell.storeNameTextField.enabled = false
                cell.mobilePhoneTextField.text = self.storeInfoModel?.contact_number
                cell.storeDescriptionTextView.text = self.storeInfoModel?.store_description
                cell.profileEditImageView.image = UIImage(named: "edit.png")
                cell.coverEditImageView.image = UIImage(named: "edit.png")
                cell.tinTextField.text = self.self.storeInfoModel?.tin
                let url: NSString = NSString(string: (self.storeInfoModel?.avatar)!.absoluteString!)
                if (!url.isEqual("")) {
                    cell.profileEditLabel.text = editPhoto
                    cell.coverEditLabel.text = editCover
                    
                } else {
                    cell.profileEditLabel.text = addPhoto
                    cell.coverEditLabel.text = addCover
                }
                
                //self.image = cell.profilePictureImageView.image
                //self.imageCover = cell.coverPhotoImageView.image
                //if(self.verifyOrChange == 1) {
                //    cell.verifyButton.setTitle("Verify", forState: UIControlState.Normal)
                //} else {
                cell.verifyButton.setTitle(self.changeTitle, forState: UIControlState.Normal)
                cell.tinLabel.text = self.tinTitle
                cell.tinTextField.placeholder = self.tinTitle
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
                if let url = NSURL(string: "\(self.qrUrl)") {
                    if let data = NSData(contentsOfURL: url){
                        //imageURL.contentMode = UIViewContentMode.ScaleAspectFit
                        cell.qrCodeImageView.image = UIImage(data: data)
                    }
                }
                cell.delegate = self
                return cell
            } else {
                let cell: StoreInfoSectionTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(storeInfoSectionTableViewCellIndentifier, forIndexPath: indexPath) as! StoreInfoSectionTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.qrCodeLabel.text = self.qrCode
                cell.generateLabel.text = self.generate
                cell.generateQRCodeButton.setTitle(self.generateQRCodeTitle, forState: UIControlState.Normal)
                cell.delegate = self
                return cell
            }
       } else if indexPath.section == 3 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier( storeInfoAddressTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoAddressTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            //Display current bank account
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
        } else if indexPath.section == 4 {
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
                //cell.newAccountLabel.hidden = false
                //cell.arrowButton.hidden = false
                cell.bankAccountDetailLabel.text = self.bankNotSet
                cell.bankAccountInfoLabel.text = ""
            }
            cell.accountTitle = self.storeInfoModel!.accountTitle
            println("account title \(cell.accountTitle)")
            return cell
        } else {
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier( storeInfoAccountInformationTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoAccountInformationTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            cell.accountInfoLabel.text = self.accountInfo
            cell.passwordLabel.text = self.password
            cell.changePasswordButton.setTitle(changeTitle, forState: UIControlState.Normal)
            cell.saveLabel.text = save
            //cell.saveButton.setTitle(save, forState: UIControlState.Normal)
            //cell.emailAddressTextField.text = self.storeInfoModel?.email
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
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
            return 556
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
            return 163
        } else if indexPath.section == 4 {
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
                println("yes")
                self.tableData[indexPath.row].isChecked = false
                if let index = find(self.selectedCategories, self.storeInfoModel!.productId[indexPath.row].toInt()!) {
                    self.selectedCategories.removeAtIndex(index)
                }
                println(self.selectedCategories)
            } else {
                self.tableData[indexPath.row].isChecked = true
                self.selectedCategories.insert(self.storeInfoModel!.productId[indexPath.row].toInt()!, atIndex: self.selectedCategories.count)
                println(self.selectedCategories)
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
    
    func storeNameAndDescription(storeName: String, storeDescription: String) {
        self.storeInfoModel!.store_name = storeName
        self.storeInfoModel!.store_description = storeDescription
    }
    //MARK: Store Details Function
    func storeInfoVerify(mobile: String) {
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
            changeMobileNumber.mobile = mobile
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
            let dataCoverPhoto: NSData = UIImageJPEGRepresentation(self.imageCover, 1)
            datas.append(dataCoverPhoto)
        }
       
        let data = NSJSONSerialization.dataWithJSONObject(self.selectedCategories, options: nil, error: nil)
        var formattedCategories: String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        let parameters: NSDictionary?
        
        if self.storeInfoModel!.isReseller {
             parameters = ["storeName" : cell.storeNameTextField.text, "storeDescription" : cell.storeDescriptionTextView.text, "categoryIds" : formattedCategories, "profilePhoto" : imagesKeyProfile, "coverPhoto" : imagesKeyCover];
            if self.selectedCategories.count != 0 {
                let url: String = "\(APIAtlas.sellerUpdateSellerInfo)?access_token=\(SessionManager.accessToken())"
                self.storeNameAndDescription(cell.storeNameTextField.text, storeDescription: cell.storeDescriptionTextView.text)
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
                            self.fireStoreInfo()
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
            } else {
                self.showAlert("Ooops!!", message: "Please select category.")
            }
        } else {
            print(cell.storeNameTextField.text)
            parameters = ["storeName" : cell.storeNameTextField.text, "storeDescription" : cell.storeDescriptionTextView.text, "profilePhoto" : imagesKeyProfile, "coverPhoto" : imagesKeyCover];
            let url: String = "\(APIAtlas.sellerUpdateSellerInfo)?access_token=\(SessionManager.accessToken())"
            self.storeNameAndDescription(cell.storeNameTextField.text, storeDescription: cell.storeDescriptionTextView.text)
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
                        self.fireStoreInfo()
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
        
    }
    
    func generateQRCode() {
        println("QR Code")
        self.showView()
        self.generateQr()
    }
    
    func generateQr(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.sellerGenerateQrCode+"\(SessionManager.accessToken())", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject)
            if responseObject["isSuccessful"] as! Bool {
                let value: AnyObject = responseObject["data"]!!
                if let qrCode = value["qrcodeUrl"] as? String {
                    self.qrUrl = qrCode
                    self.hasQRCode = true
                } else {
                    self.qrUrl = ""
                }
            } else {
                self.showAlert(self.error, message: self.invalid)
            }
            self.tableView.reloadData()
            self.dismissView()
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
                    self.fireRefreshToken(StoreInfoType.GenerateQR)
                } else {
                    self.showAlert(self.error, message: self.somethingWentWrong)
                }
                self.dismissView()
        }) 

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
                self.storeInfoVerify(oldNumber)
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
            } else if storeInfoType == StoreInfoType.VerifyNumber {
                self.verifyViewController()
            } else {
                self.generateQr()
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
    
    func shareFBAction(postImage: UIImageView, title: String) {
    
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc.setInitialText("")
        let image = postImage.image
        vc.addImage(image)
        
        var socialVC :SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        
        socialVC.completionHandler = {
            (result:SLComposeViewControllerResult) in
            self.showAlert(self.successTitle, message: StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_FB_LOCALIZE_KEY"))
        }

        presentViewController(vc, animated: true, completion: nil)
        
        /*
        var sharingItems = [AnyObject]()
        let image = postImage.image
        
        if (postImage.image != nil) {
            sharingItems = [title, postImage.image!]
        } else {
            sharingItems = [title]
        }
        
        let activityController = UIActivityViewController(activityItems:
            sharingItems, applicationActivities: nil)
        
        activityController.excludedActivityTypes =  [
            UIActivityTypePostToWeibo,
            UIActivityTypePrint,
            UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]
        
        activityController.completionWithItemsHandler = { (s: String?, ok: Bool, items: [AnyObject]?, err:NSError?) -> Void in
            print("completed \(s) \(ok) \(items) \(err)")
            if s != nil {
                if s == "com.apple.UIKit.activity.Mail" {
                    self.showAlert(self.successTitle, message: StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_EMAIL_LOCALIZE_KEY"))
                } else if s == "com.apple.UIKit.activity.PostToFacebook" {
                    self.showAlert(self.successTitle, message: StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_FB_LOCALIZE_KEY"))
                } else if s == "com.apple.UIKit.activity.PostToTwitter" {
                    self.showAlert(self.successTitle, message: StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_TWITTER_LOCALIZE_KEY"))
                } else {
                    self.showAlert(self.successTitle, message: StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_GPLUS_LOCALIZE_KEY"))
                }
            } else {
                
            }
        }
        
        self.presentViewController(activityController, animated: true,
            completion: nil)
        */
        
        
        
       // sharingItems.append(NSURL(string: "https://sociobiology.files.wordpress.com/2013/07/strassmann-queller-qr-code.jpg")!)
        
        //let shareViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        //self.presentViewController(shareViewController, animated: true, completion: nil)
    }
    
    func shareTWAction(postImage: UIImageView, title: String) {
        
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc.setInitialText("")
        let image = postImage.image
        vc.addImage(image)
        
        var socialVC :SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        socialVC.completionHandler = {
            (result:SLComposeViewControllerResult) in
            // Your code
            self.showAlert(self.successTitle, message: StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_TWITTER_LOCALIZE_KEY"))
        }
        presentViewController(vc, animated: true, completion: nil)
       
        
    }
    
    func shareEMAction(postImage: UIImageView, title: String) {
        imageToPost = postImage.image
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        /*
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.addAttachmentData(UIImageJPEGRepresentation(postImage.image, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "qrcode.jpeg")
            
            mailComposeVC.setSubject(title)
            
            mailComposeVC.setMessageBody(title, isHTML: true)
            
            self.presentViewController(mailComposeVC, animated: true, completion: nil)
        } else {
            // show failure alert
        }*/
    }
    
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
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.value {
        case MFMailComposeResultCancelled.value:
            self.showAlert(self.successTitle, message: StringHelper.localizedStringWithKey("STORE_INFO_CANCEL_EMAIL_LOCALIZE_KEY"))
            NSLog("Mail cancelled")
        case MFMailComposeResultSaved.value:
            self.showAlert(self.successTitle, message: StringHelper.localizedStringWithKey("STORE_INFO_SAVE_EMAIL_LOCALIZE_KEY"))
            NSLog("Mail saved")
        case MFMailComposeResultSent.value:
            self.showAlert(self.successTitle, message: StringHelper.localizedStringWithKey("STORE_INFO_SUCCESS_EMAIL_LOCALIZE_KEY"))
            NSLog("Mail sent")
        case MFMailComposeResultFailed.value:
            self.showAlert(self.successTitle, message: StringHelper.localizedStringWithKey("STORE_INFO_FAIL_EMAIL_LOCALIZE_KEY"))
            NSLog("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func shareGPAction(postImage: UIImageView, title: String) {
        self.imageToPost = postImage.image
        self.googlePlusSignIn()
        self.updateUI()
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
            //let image: UIImage = UIImage(CGImage: allaSset.defaultRepresentation().fullResolutionImage(), scale: allaSset.defaultRepresentation().scale(), orientation: allaSset.defaultRepresentation().orientation())!
            let image: UIImage = UIImage(CGImage: allaSset.defaultRepresentation().fullScreenImage().takeUnretainedValue(), scale: 1.0, orientation: UIImageOrientation.Up)!
            
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
        if IMAGETYPE.imageType == "profile" {
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
