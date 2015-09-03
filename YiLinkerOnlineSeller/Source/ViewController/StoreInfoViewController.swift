//
//  StoreInfoViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class StoreInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StoreInfoTableViewCellDelegate, StoreInfoSectionTableViewCellDelegate, StoreInfoBankAccountTableViewCellDelegate , StoreInfoAccountInformationTableViewCellDelegate, ChangeBankAccountViewControllerDelegate, ChangeAddressViewControllerDelegate, ChangeMobileNumberViewControllerDelegate, StoreInfoAddressTableViewCellDelagate, ChangeEmailViewControllerDelegate {
    
    @IBOutlet weak var storeInfoTableView: UITableView!
    
    var storeInfoModel: StoreInfoModel?
    var storeAddressModel: StoreAddressModel?
    
    let storeInfoSectionTableViewCellIndentifier: String = "StoreInfoSectionTableViewCell"
    let storeInfoAddressTableViewCellIdentifier: String = "StoreInfoAddressTableViewCell"
    let storeInfoBankAccountTableViewCellIdentifier: String = "StoreInfoBankAccountTableViewCell"
    let storeInfoAccountInformationTableViewCellIdentifier: String = "StoreInfoAccountInformationTableViewCell"
    
    var storeInfoHeader: StoreInfoTableViewCell = XibHelper.puffViewWithNibName("StoreInfoTableViewCell", index: 0) as! StoreInfoTableViewCell
    
    var newContactNumber: String = ""
    
    var dimView: UIView = UIView()
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        storeInfoHeader.delegate = self
        
        dimView = UIView(frame: self.view.bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        self.storeInfoTableView.tableHeaderView = storeInfoHeader
        self.initializeViews()
        self.registerNibs()
        self.fireStoreInfo()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.storeInfoTableView.tableFooterView = UIView(frame: CGRectZero)
        self.storeInfoTableView.delegate = self
        self.storeInfoTableView.dataSource = self
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

    func registerNibs() {
        var storeInfo = UINib(nibName: storeInfoSectionTableViewCellIndentifier, bundle: nil)
        self.storeInfoTableView.registerNib(storeInfo, forCellReuseIdentifier: storeInfoSectionTableViewCellIndentifier)
        
        var storeInfoBankAccount = UINib(nibName: storeInfoBankAccountTableViewCellIdentifier, bundle: nil)
        storeInfoTableView.registerNib(storeInfoBankAccount, forCellReuseIdentifier: storeInfoBankAccountTableViewCellIdentifier)
        
        var storeInfoAddress = UINib(nibName: storeInfoAddressTableViewCellIdentifier, bundle: nil)
        storeInfoTableView.registerNib(storeInfoAddress, forCellReuseIdentifier: storeInfoAddressTableViewCellIdentifier)
        
        var storeInfoAccountInformation = UINib(nibName: storeInfoAccountInformationTableViewCellIdentifier, bundle: nil)
        storeInfoTableView.registerNib(storeInfoAccountInformation, forCellReuseIdentifier: storeInfoAccountInformationTableViewCellIdentifier)
    }
    
    func fireStoreInfo(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.POST(APIAtlas.sellerStoreInfo, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.storeInfoModel = StoreInfoModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
            //self.populateData()
           
            self.storeInfoHeader.coverPhotoImageView.sd_setImageWithURL(self.storeInfoModel!.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
            self.storeInfoHeader.profilePictureImageView.sd_setImageWithURL(self.storeInfoModel!.avatar, placeholderImage: UIImage(named: "dummy-placeholder.jpg"))
            self.storeInfoHeader.storeNameTextField.text = self.storeInfoModel?.store_name
            self.storeInfoHeader.mobilePhoneTextField.text = self.storeInfoModel?.contact_number
            self.storeInfoHeader.verifyButton.setTitle("Change", forState: UIControlState.Normal)
            self.storeInfoHeader.verifyButton.tag = 2
           /*
            if self.storeInfoModel?.contact_number == nil {
            
            } else {
            
            } */
            self.storeInfoTableView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error)
            })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("sections \(indexPath.section) row \(indexPath.row)")
        println("\(self.storeInfoModel?.store_address)")
        if indexPath.section == 0 {
            let cell: StoreInfoSectionTableViewCell = self.storeInfoTableView.dequeueReusableCellWithIdentifier(storeInfoSectionTableViewCellIndentifier, forIndexPath: indexPath) as! StoreInfoSectionTableViewCell
            cell.delegate = self
            return cell
       } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier( storeInfoAddressTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoAddressTableViewCell
            cell.delegate = self
            //Display current bank account
            cell.addressLabel.text = self.storeInfoModel?.store_address
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier( storeInfoBankAccountTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoBankAccountTableViewCell
            cell.delegate = self
            //Display current bank account
            cell.bankAccountTitleLabel.text = self.storeInfoModel?.accountTitle
            cell.bankAccountDetailLabel.text = self.storeInfoModel?.bankAccount
            println(cell)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier( storeInfoAccountInformationTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoAccountInformationTableViewCell
            cell.delegate = self
            cell.emailAddressTextField.text = self.storeInfoModel?.email
            //
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 198
        } else if indexPath.section == 1 {
            return 163
        } else  if indexPath.section == 2 {
            return 163
        } else {
            return 299
        }
    }
    
    //Store Details Function
    func storeInfoVerify() {
        println("verify")
        self.showView()
        
        if storeInfoHeader.verifyButton.tag == 1 {
            var verifyNumberViewController = VerifyNumberViewController(nibName: "VerifyNumberViewController", bundle: nil)
            verifyNumberViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            verifyNumberViewController.providesPresentationContextTransitionStyle = true
            verifyNumberViewController.definesPresentationContext = true
            let black = UIColor.blackColor()
            let transparent = black.colorWithAlphaComponent(0.5)
            verifyNumberViewController.view.backgroundColor = transparent
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
    
    func changeEmailAddress(){
        println("Email Address")
        var changeEmailViewController = ChangeEmailViewController(nibName: "ChangeEmailViewController", bundle: nil)
        changeEmailViewController.delegate = self
        changeEmailViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        changeEmailViewController.providesPresentationContextTransitionStyle = true
        changeEmailViewController.definesPresentationContext = true
        changeEmailViewController.view.frame.origin.y = changeEmailViewController.view.frame.size.height
        changeEmailViewController.type = "email"
        self.navigationController?.presentViewController(changeEmailViewController, animated:true, completion: nil)
        
        self.showView()
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
        changeEmailViewController.newEmailAddressTextField.secureTextEntry = true
        changeEmailViewController.confirmEmailAddressTextField.secureTextEntry = true
        changeEmailViewController.type = "password"
        self.navigationController?.presentViewController(changeEmailViewController, animated:true, completion: nil)
        self.showView()
    }
    
    func submit(type: String) {
        
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
        println("Save Account Info")
    }
    
    func generateQRCode() {
        println("QR Code")
    }
    
    func updateBankDetail(accountTitle: String, accountName: String, accountNumber: Int, bankName: String) {
        self.storeInfoModel?.accountTitle = accountTitle
        self.storeInfoModel?.bankAccount = accountName + "\n\(accountNumber)\n" + bankName
        self.storeInfoTableView.reloadData()
    }
    
    func updateStoreAddressDetail(user_address_id: Int, location_id: Int, title: String, unit_number: String, building_name: String, street_number: String, street_name: String, subdivision: String, zip_code: String, street_address: String, country: String, island: String, region: String, province: String, city: String, municipality: String, barangay: String, longitude: Double, latitude: Double, landline: String, is_default: Bool) {
    
        self.storeInfoModel?.title = title
        self.storeInfoModel?.store_address = unit_number + " " + building_name + ", " + street_number + " " + street_name + " " + subdivision + ", " + zip_code
        
        self.storeInfoTableView.reloadData()

    }
    
    func setMobileNumber(newNumber: String) {
        self.storeInfoHeader.mobilePhoneTextField.text = newNumber
        self.storeInfoHeader.verifyButton.setTitle("Verify", forState: UIControlState.Normal)
        self.storeInfoHeader.verifyButton.tag = 1
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0
            }, completion: { finished in
                self.dimView.hidden = true
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
