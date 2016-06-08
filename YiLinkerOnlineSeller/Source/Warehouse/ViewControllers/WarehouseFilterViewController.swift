//
//  WarehouseFilterViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Elbert Philip O. Yagaya on 4/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WarehouseFilterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var hud: MBProgressHUD?
    var warehouseFilter: WareFilterModel?
    var status: String = ""
    var categories: String = ""
    var productGroups: String = ""
    
    override func viewDidLoad() {
        self.initializedNavigationBarItems()
        self.tableView.sectionHeaderHeight = 70
        self.fireWarehouseFilter()
    }
    
    func initializedNavigationBarItems() {
        self.title = StringHelper.localizedStringWithKey("Warehouse Filter")
        
        var backButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }

    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //let view = UIView(frame: CGRect.zeroRect)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        view.backgroundColor = UIColor.lightGrayColor()
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 20))
        
        if self.warehouseFilter != nil {
            label.text = self.warehouseFilter!.filter[section]
        }
        
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.blackColor()
        view.addSubview(label)
        //view.addSubview(view)
        
        return view
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        if self.warehouseFilter != nil {
            return self.warehouseFilter!.filter.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.warehouseFilter != nil {
            return self.warehouseFilter!.filterModel[section].name.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "FilterCell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        if self.warehouseFilter != nil {
            cell.textLabel!.text = self.warehouseFilter!.filterModel[indexPath.section].name[indexPath.row]
        }
        
        if indexPath.section == 0 {
            if self.status == self.warehouseFilter!.filterModel[indexPath.section].name[indexPath.row] {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        } else if indexPath.section == 1 {
            if self.categories == self.warehouseFilter!.filterModel[indexPath.section].name[indexPath.row] {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        } else {
            if self.productGroups == self.warehouseFilter!.filterModel[indexPath.section].name[indexPath.row] {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        if indexPath.section == 0 {
            self.status = cell!.textLabel!.text!
        } else if indexPath.section == 1 {
            self.categories = cell!.textLabel!.text!
        } else {
            self.productGroups = cell!.textLabel!.text!
        }
        /*
        // toggle old one off and the new one on
        let newCell = tableView.cellForRowAtIndexPath(indexPath)
        if newCell?.accessoryType == UITableViewCellAccessoryType.None {
            newCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        let oldCell = tableView.cellForRowAtIndexPath(self.selectedIndexPath!)
        if oldCell?.accessoryType == UITableViewCellAccessoryType.Checkmark && indexPath.section == self.selectedIndexPath!.section {
            oldCell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        self.selectedIndexPath = indexPath*/
        self.tableView.reloadData()
    }
    // MARK: -
    // MARK: - Alert view
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    // MARK: -
    // MARK: - Show HUD
    
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
    
    // MARK: -
    // MARK: - POST METHOD: Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    * Function to refresh token to get another access token
    *
    */
    
    func fireRefreshToken() {
        self.showHUD()
        
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                
                self.fireWarehouseFilter()
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                })
            }
        })
    }
    
    
    // MARK: -
    // MARK: - POST METHOD: Fire Upload Main Images
    /*
    *
    * (Parameters) - type, access_token
    *
    * Function to upload images
    *
    */
    
    func fireWarehouseFilter() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        WebServiceManager.fireWarehouseFilterRequestWithUrl(APIAtlas.warehouseFilter + SessionManager.accessToken(), actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if let success = responseObject["isSuccessful"] as? Bool {
                    if success {
                        self.warehouseFilter = WareFilterModel.parseDataFromDictionary(responseObject as! NSDictionary)
                    }
                }
                
                self.tableView.reloadData()
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            } else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
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

}
