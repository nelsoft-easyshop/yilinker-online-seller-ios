//
//  StoreInfoViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol StoreInfoViewControllerDelegate {
    
}

class StoreInfoViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, StoreInfoTableViewCellDelegate, StoreInfoSectionTableViewCellDelegate, StoreInfoBankAccountTableViewCellDelegate , StoreInfoAccountInformationTableViewCellDelegate, ChangeBankAccountViewControllerDelegate, ChangeAddressViewControllerDelegate, ChangeMobileNumberViewControllerDelegate, StoreInfoAddressTableViewCellDelagate, ChangeEmailViewControllerDelegate, VerifyViewControllerDelegate , UzysAssetsPickerControllerDelegate{
    
    var storeInfoModel: StoreInfoModel?
    var storeAddressModel: StoreAddressModel?
    
    let storeInfoHeaderTableViewCellIndentifier: String = "StoreInfoTableViewCell"
    let storeInfoSectionTableViewCellIndentifier: String = "StoreInfoSectionTableViewCell"
    let storeInfoAddressTableViewCellIdentifier: String = "StoreInfoAddressTableViewCell"
    let storeInfoBankAccountTableViewCellIdentifier: String = "StoreInfoBankAccountTableViewCell"
    let storeInfoAccountInformationTableViewCellIdentifier: String = "StoreInfoAccountInformationTableViewCell"
    
    //var storeInfoHeader: StoreInfoTableViewCell = XibHelper.puffViewWithNibName("StoreInfoTableViewCell", index: 0) as! StoreInfoTableViewCell
    
    var newContactNumber: String = ""
    
    var dimView: UIView = UIView()
    
    var verifyOrChange: Int = 0
    
    var hud: MBProgressHUD?
    
    var index: NSIndexPath?
    
    var uploadImages: [UIImage] = []
    var image: UIImage?
    var imageCover: UIImage?
    var imageType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //storeInfoHeader.delegate = self
        self.edgesForExtendedLayout = .None
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        //self.storeInfoTableView.tableHeaderView = storeInfoHeader
        self.initializeViews()
        self.registerNibs()
        self.fireStoreInfo()
        
        var tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
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

    func registerNibs() {
        
        let storeInfoHeader = UINib(nibName: storeInfoHeaderTableViewCellIndentifier, bundle: nil)
        self.tableView.registerNib(storeInfoHeader, forCellReuseIdentifier: storeInfoHeaderTableViewCellIndentifier)
        
        var storeInfo = UINib(nibName: storeInfoSectionTableViewCellIndentifier, bundle: nil)
        self.tableView.registerNib(storeInfo, forCellReuseIdentifier: storeInfoSectionTableViewCellIndentifier)
        
        var storeInfoBankAccount = UINib(nibName: storeInfoBankAccountTableViewCellIdentifier, bundle: nil)
        self.tableView.registerNib(storeInfoBankAccount, forCellReuseIdentifier: storeInfoBankAccountTableViewCellIdentifier)
        
        var storeInfoAddress = UINib(nibName: storeInfoAddressTableViewCellIdentifier, bundle: nil)
        self.tableView.registerNib(storeInfoAddress, forCellReuseIdentifier: storeInfoAddressTableViewCellIdentifier)
        
        var storeInfoAccountInformation = UINib(nibName: storeInfoAccountInformationTableViewCellIdentifier, bundle: nil)
        self.tableView.registerNib(storeInfoAccountInformation, forCellReuseIdentifier: storeInfoAccountInformationTableViewCellIdentifier)
    }
    
    func fireStoreInfo(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.POST(APIAtlas.sellerStoreInfo, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.storeInfoModel = StoreInfoModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
            //self.populateData()
            /*
            if self.storeInfoModel?.contact_number == nil {
            
            } else {
            
            } */
            self.tableView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error)
            })
    }
    
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
            if(self.storeInfoModel?.store_name != nil){
                cell.coverPhotoImageView.sd_setImageWithURL(self.storeInfoModel!.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                cell.profilePictureImageView.sd_setImageWithURL(self.storeInfoModel!.avatar, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
                cell.storeNameTextField.text = self.storeInfoModel?.store_name
                cell.mobilePhoneTextField.text = self.storeInfoModel?.contact_number
                cell.storeDescriptionTextView.text = self.storeInfoModel?.store_description
                cell.profileEditImageView.image = UIImage(named: "edit.png")
                cell.coverEditImageView.image = UIImage(named: "edit.png")
                cell.profileEditLabel.text = "Edit Profile Photo"
                cell.coverEditLabel.text = "Edit Cover Photo"
                if(self.verifyOrChange == 1) {
                    cell.verifyButton.setTitle("Verify", forState: UIControlState.Normal)
                } else {
                    cell.verifyButton.setTitle("Change", forState: UIControlState.Normal)
                }
                cell.verifyButton.tag = 2
            } else {
                cell.profileEditImageView.image = UIImage(named: "dummy-placeholder.jpg")
                cell.coverEditImageView.image = UIImage(named: "dummy-placeholder.jpg")
            }
           
            return cell
        } else if indexPath.section == 1 {
            let cell: StoreInfoSectionTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(storeInfoSectionTableViewCellIndentifier, forIndexPath: indexPath) as! StoreInfoSectionTableViewCell
            cell.delegate = self
            return cell
       } else if indexPath.section == 2 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier( storeInfoAddressTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoAddressTableViewCell
            cell.delegate = self
            //Display current bank account
            cell.addressLabel.text = self.storeInfoModel?.store_address
            cell.addressTitle.text = self.storeInfoModel?.title
            return cell
        } else if indexPath.section == 3 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier( storeInfoBankAccountTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoBankAccountTableViewCell
            cell.delegate = self
            //Display current bank account
            cell.bankAccountTitleLabel.text = self.storeInfoModel?.accountTitle
            cell.bankAccountDetailLabel.text = self.storeInfoModel?.bankAccount
            println(cell)
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier( storeInfoAccountInformationTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoAccountInformationTableViewCell
            cell.delegate = self
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
            return 198
        } else if indexPath.section == 2 {
            return 163
        } else  if indexPath.section == 3 {
            return 163
        } else {
            return 221
        }
    }
    
    //Store Details Function
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
            self.navigationController?.presentViewController(verifyNumberViewController, animated: true, completion:
                nil)
        } else {
            var changeMobileNumber = ChangeMobileNumberViewController(nibName: "ChangeMobileNumberViewController", bundle: nil)
            changeMobileNumber.delegate = self
            changeMobileNumber.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            changeMobileNumber.providesPresentationContextTransitionStyle = true
            changeMobileNumber.definesPresentationContext = true
            changeMobileNumber.view.frame.origin.y = changeMobileNumber.view.frame.size.height
            self.navigationController?.presentViewController(changeMobileNumber, animated: true, completion:
                nil)
            self.verifyOrChange = 2

        }

    }
    
    func changeAddress() {
        var changeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        self.navigationController?.pushViewController(changeAddressViewController, animated:true)
    }
    
    func newAddress() {
        var changeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        self.navigationController?.pushViewController(changeAddressViewController, animated:true)
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
        changeEmailViewController.titleLabel.text = "Change Password"
        changeEmailViewController.oldEmailLabel.text = "Old Password"
        changeEmailViewController.newEmailLabel.text = "New Password"
        changeEmailViewController.confirmEmailLabel.text = "Confirm Password"
        changeEmailViewController.oldEmailAddressTextField.placeholder = "Enter old password"
        changeEmailViewController.newEmailAddressTextField.placeholder = "Enter new password"
        changeEmailViewController.confirmEmailAddressTextField.placeholder = "Confirm new password"
        changeEmailViewController.oldEmailAddressTextField.secureTextEntry = true
        changeEmailViewController.newEmailAddressTextField.secureTextEntry = true
        changeEmailViewController.confirmEmailAddressTextField.secureTextEntry = true
        changeEmailViewController.type = "password"
        self.navigationController?.presentViewController(changeEmailViewController, animated:true, completion: nil)
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
        self.navigationController?.presentViewController(changeMobileNumberViewController, animated: true, completion:
            nil)
    }
    
    func saveAccountInfo() {
        self.showHUD()

        //self.tableView.reloadData()
        let cell: StoreInfoTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(storeInfoHeaderTableViewCellIndentifier, forIndexPath: index!) as! StoreInfoTableViewCell
        cell.delegate = self

        println("sample \(cell.storeNameTextField.text)")
        
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
                
            }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                println(error.userInfo)
                
                self.hud?.hide(true)
        }

    }
    
    func generateQRCode() {
        println("QR Code")
    }
    
    func updateBankDetail(accountTitle: String, accountName: String, accountNumber: String, bankName: String) {
        self.storeInfoModel?.accountTitle = accountTitle
        self.storeInfoModel?.bankAccount = accountName + "\n"+accountNumber+"\n" + bankName
        self.tableView.reloadData()
    }
    
    func updateStoreAddressDetail(title: String, storeAddress: String) {
    
        self.storeInfoModel?.title = title
        self.storeInfoModel?.store_address = storeAddress
        self.tableView.reloadData()

    }
    
    func setMobileNumber(newNumber: String, oldNumber: String) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "oldContactNumber" : oldNumber, "newContactNumber" : newNumber];
        manager.POST(APIAtlas.sellerChangeMobileNumber, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.storeInfoModel?.contact_number = newNumber
            self.verifyOrChange = 1
            self.storeInfoVerify()
            println(self.verifyOrChange)
            self.tableView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error.description)
        })
    }
    
    func dismissView() {
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0
            }, completion: { finished in
                self.dimView.hidden = true
        })
    }
    
    func showView(){
        dimView.hidden = false
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0.5
            }, completion: { finished in
        })
    }

    
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
    
    func uzyConfig() -> UzysAppearanceConfig {
        let config: UzysAppearanceConfig = UzysAppearanceConfig()
        config.finishSelectionButtonColor = Constants.Colors.appTheme
        return config
    }
    
    //UzzyPickerDelegate
    
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
    func uzysAssetsPickerControllerDidCancel(picker: UzysAssetsPickerController!) {
        
    }
    
    func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker: UzysAssetsPickerController!) {
        
    }

    func dismissKeyboard(){
        self.view.endEditing(true)
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
