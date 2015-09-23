//
//  SettingsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/25/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SettingsItemTableViewCellDelegate, SettingDeactivateTableViewCellDelegate, UIActionSheetDelegate, DeactivateModalViewControllerDelegate {
    
    let settingsHeaderIdentifier: String = "SettingsHeaderTableViewCell"
    let settingsItemIdentifier: String = "SettingsItemTableViewCell"
    let settingsDeactivateIdentifier: String = "SettingDeactivateTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var isEmailOn: Bool = false
    var isSMSOn: Bool = false
    
    var hud: MBProgressHUD?
    
    var dimView: UIView?
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    var connectionLocalizeString: String = ""
    var connectionMessageLocalizeString: String = ""
    var deactivateLocalizeString: String = ""
    var deactivateAccountLocalizeString: String = ""
    var cancelLocalizeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
        initializeLocalizedString()
        registerNibs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
        connectionLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONUNREACHABLE_LOCALIZE_KEY")
        connectionMessageLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONERRORMESSAGE_LOCALIZE_KEY")
        deactivateLocalizeString = StringHelper.localizedStringWithKey("DEACTIVATE_LOCALIZED_KEY")
        deactivateAccountLocalizeString = StringHelper.localizedStringWithKey("DEACTIVATE_ACCOUNT_LOCALIZED_KEY")
        cancelLocalizeString = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
    }
    
    func initializeViews() {
        self.title = StringHelper.localizedStringWithKey("SETTINGS_TITLE_LOCALIZED_KEY")
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.delegate = self
        tableView.dataSource = self
        
        dimView = UIView(frame: self.view.bounds)
        dimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController?.view.addSubview(dimView!)
        //self.view.addSubview(dimView!)
        dimView?.hidden = true
        dimView?.alpha = 0
    }
    
    func registerNibs() {
        var nibHeader = UINib(nibName: settingsHeaderIdentifier, bundle: nil)
        tableView.registerNib(nibHeader, forCellReuseIdentifier: settingsHeaderIdentifier)
        
        var nibItem = UINib(nibName: settingsItemIdentifier, bundle: nil)
        tableView.registerNib(nibItem, forCellReuseIdentifier: settingsItemIdentifier)
        
        var nibDeactivate = UINib(nibName: settingsDeactivateIdentifier, bundle: nil)
        tableView.registerNib(nibDeactivate, forCellReuseIdentifier: settingsDeactivateIdentifier)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(settingsItemIdentifier, forIndexPath: indexPath) as! SettingsItemTableViewCell
            cell.delegate = self
            
            if indexPath.row == 0 {
                cell.setTitleText(StringHelper.localizedStringWithKey("SETTINGS_EMAIL_LOCALIZED_KEY"))
                cell.setSettingSwitchStatus(isEmailOn)
            } else if indexPath.row == 1 {
                cell.setTitleText(StringHelper.localizedStringWithKey("SETTINGS_SMS_LOCALIZED_KEY"))
                cell.setSettingSwitchStatus(isSMSOn)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(settingsDeactivateIdentifier, forIndexPath: indexPath) as! SettingDeactivateTableViewCell
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 45
        } else {
            return 35
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(settingsHeaderIdentifier) as! SettingsHeaderTableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    // MARK: - SettingsItemTableViewCellDelegate : Switch Value CHanged
    
    func settingSwitchChanged(sender: AnyObject, isOn: Bool) {
        var pathOfTheCell: NSIndexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        
        if rowOfTheCell == 0 {
            isEmailOn = isOn
            firePostSettings("email", isOn: isOn)
        } else {
            isSMSOn = isOn
            firePostSettings("sms", isOn: isOn)
        }
        
        println(isOn)
    }
    
    // MARK: - SettingDeactivateTableViewCellDelegate : Deactivate My Account is Tapped
    func deactivateTapped(sender: AnyObject) {
        if(controllerAvailable()){
            handleIOS8()
        } else {
            var actionSheet: UIActionSheet
            actionSheet = UIActionSheet(title: deactivateAccountLocalizeString, delegate: self, cancelButtonTitle: self.cancelLocalizeString, destructiveButtonTitle: deactivateLocalizeString)
            
            actionSheet.delegate = self
            actionSheet.showInView(self.view)
        }
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
    
    
    
    func firePostSettings(type: String, isOn: Bool) {
        showHUD()
        let manager = APIManager.sharedInstance
        var parameters: NSDictionary
        var url: String = ""
        
        if type == "email" {
            url = APIAtlas.postEmailNotif
        } else if type == "sms" {
            url = APIAtlas.postSMSNotif
        }
        url = "\(url)?access_token=\(SessionManager.accessToken())&isSubscribe=\(isOn)"
        
        manager.POST(url, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
                println("RESPONSE \(responseObject)")
                self.hud?.hide(true)
            
            if let tempDict = responseObject as? NSDictionary {
                let tempVar = tempDict["isSuccessful"] as! Bool
                if !(tempVar){
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: tempDict["message"] as! String, title: self.errorLocalizeString)
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: tempDict["message"] as! String, title: StringHelper.localizedStringWithKey("NOTIFICATIONS_LOCALIZED_KEY"))
                }
            }
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken(type, isON: isOn)
                } else {
                    if Reachability.isConnectedToNetwork() {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.somethingWrongLocalizeString, title: self.errorLocalizeString)
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.connectionMessageLocalizeString, title: self.connectionLocalizeString)
                    }
                    println(error)
                }
        })
    }
    
    func fireRefreshToken(type: String, isON: Bool) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.firePostSettings(type, isOn: isON)
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }
    
    //Method for
    func handleIOS8(){
        let alert = UIAlertController(title: deactivateAccountLocalizeString, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: deactivateLocalizeString, style: UIAlertActionStyle.Destructive) { (alert) -> Void in
            self.showDeactivateModal()
        }
        
        let cancelButton = UIAlertAction(title: self.cancelLocalizeString, style: UIAlertActionStyle.Cancel) { (alert) -> Void in
            println("Cancel Pressed")
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func controllerAvailable() -> Bool {
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            return true;
        }
        else {
            return false;
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        println("Title : \(actionSheet.buttonTitleAtIndex(buttonIndex))")
        println("Button Index : \(buttonIndex)")
        
        if buttonIndex == 0 {
            self.showDeactivateModal()
        } else if buttonIndex == 1 {
        } else {
            
        }
    }
    
    func showDeactivateModal(){
        var deactivateModal = DeactivateModalViewController(nibName: "DeactivateModalViewController", bundle: nil)
        deactivateModal.delegate = self
        deactivateModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        deactivateModal.providesPresentationContextTransitionStyle = true
        deactivateModal.definesPresentationContext = true
        deactivateModal.view.backgroundColor = UIColor.clearColor()
        deactivateModal.view.frame.origin.y = 0
        self.tabBarController?.presentViewController(deactivateModal, animated: true, completion: nil)
        
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    func hideDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 0
            }, completion: { finished in
                self.dimView!.hidden = true
        })
    }
    
    // MARK : DeactivateModalViewControllerDelegate
    func closeDeactivateModal(){
        hideDimView()
    }
    
    func submitDeactivateModal(password: String){
        hideDimView()
    }
    
}
