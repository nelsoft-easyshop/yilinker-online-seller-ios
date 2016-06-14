//
//  WarehouseFilterViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Elbert Philip O. Yagaya on 4/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol WarehouseFilterViewControllerDelegate{
    func warehouseFilter(status: [String], category: [String], productGroup: [String])
}

class WarehouseFilterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var hud: MBProgressHUD?
    var warehouseFilter: WareFilterModel?
    
    var status: [String] = []
    var category: [String] = []
    var productGroup: [String] = []
    
    var selectedStatus: [String] = []
    var selectedCategory: [String] = []
    var selectedProductGroup: [String] = []
    
    var statusValue: [Bool] = []
    var categoryValue: [Bool] = []
    var productGroupValue: [Bool] = []
    
    var delegate: WarehouseFilterViewControllerDelegate?
    
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
        self.selectedStatus = []
        self.selectedCategory = []
        self.selectedProductGroup = []
        
        for (index, stat) in enumerate(self.statusValue){
            if stat {
                self.selectedStatus.append(self.status[index])
            }
        }
        
        for (index, cat) in enumerate(self.categoryValue){
            if cat {
                self.selectedCategory.append(self.category[index])
            }
        }
        
        for (index, group) in enumerate(self.productGroupValue){
            if group {
                self.selectedProductGroup.append(self.productGroup[index])
            }
        }
        
        self.delegate?.warehouseFilter(self.selectedStatus, category: self.selectedCategory, productGroup: self.selectedProductGroup)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //let view = UIView(frame: CGRect.zeroRect)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        view.backgroundColor = Constants.Colors.backgroundGray
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 20))
        label.font = UIFont(name: "Panton Bold", size: 14.0)
        
        if self.warehouseFilter != nil {
            let sectionTitles: [String] = ["Product Status","Product Category", "Product Group"]
            label.text = sectionTitles[section]
        }
        
        label.backgroundColor = UIColor.clearColor()
        label.textColor = Constants.Colors.grayLine
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
        cell.textLabel!.font = UIFont(name: "Panton", size: 14.0)
        if self.warehouseFilter != nil {
            cell.textLabel!.text = self.warehouseFilter!.filterModel[indexPath.section].name[indexPath.row]
        }
        
        /*
        if indexPath.section == 0 {
            if contains(self.status, self.warehouseFilter!.filterModel[indexPath.section].name[indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        } else if indexPath.section == 1 {
            /*
            if self.category == self.warehouseFilter!.filterModel[indexPath.section].name[indexPath.row] {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }*/
            if contains(self.category, self.warehouseFilter!.filterModel[indexPath.section].name[indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        } else {
            /*
            if self.productGroup == self.warehouseFilter!.filterModel[indexPath.section].name[indexPath.row] {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }*/
            if contains(self.productGroup, self.warehouseFilter!.filterModel[indexPath.section].name[indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }*/
        if indexPath.section == 0 {
            if self.statusValue[indexPath.row] == true {
                cell.selected = true
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        } else if indexPath.section == 1 {
            if self.categoryValue[indexPath.row] == true {
                cell.selected = true
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        } else {
            if self.productGroupValue[indexPath.row] == true {
                cell.selected = true
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
        if cell!.selected {
            cell!.selected = false
            if cell!.accessoryType == UITableViewCellAccessoryType.None {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                if indexPath.section == 0 {
                    self.statusValue[indexPath.row] = true
                } else if indexPath.section == 1 {
                    self.categoryValue[indexPath.row] = true
                } else {
                    self.productGroupValue[indexPath.row] = true
                }
            } else {
                cell!.accessoryType = UITableViewCellAccessoryType.None
                if indexPath.section == 0 {
                    self.statusValue[indexPath.row] = false
                } else if indexPath.section == 1 {
                    self.categoryValue[indexPath.row] = false
                } else {
                    self.productGroupValue[indexPath.row] = false
                }
            }
        }
        /*if indexPath.section == 0 {
            if contains(self.status, cell!.textLabel!.text!) {
                self.statusValue[indexPath.row] = false
            } else {
               self.statusValue[indexPath.row] = true
            }
        } else if indexPath.section == 1 {
            /*if self.category == cell!.textLabel!.text! {
                self.category = ""
            } else {
                self.category = cell!.textLabel!.text!
            }*/
            if contains(self.category, cell!.textLabel!.text!) {
                self.categoryValue[indexPath.row] = false
            } else {
                self.categoryValue[indexPath.row] = true
            }
        } else {
            /*
            if self.productGroup == cell!.textLabel!.text! {
                self.productGroup = ""
            } else {
                self.productGroup = cell!.textLabel!.text!
            }*/
            if contains(self.productGroup, cell!.textLabel!.text!) {
                self.productGroupValue[indexPath.row] = false
            } else {
                self.productGroupValue[indexPath.row] = true
            }
        }*/
        
        //self.tableView.reloadData()
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
                        for (i, status) in enumerate(self.warehouseFilter!.filter) {
                            for (j, value) in enumerate(self.warehouseFilter!.filterModel[i].name) {
                                if i == 0 {
                                    if contains(self.selectedStatus, self.warehouseFilter!.filterModel[i].name[j]) {
                                        self.statusValue.append(true)
                                    } else {
                                        self.statusValue.append(false)
                                    }
                                    self.status.append(self.warehouseFilter!.filterModel[i].name[j])
                                } else if i == 1 {
                                    if contains(self.selectedCategory, self.warehouseFilter!.filterModel[i].name[j]) {
                                        self.categoryValue.append(true)
                                    } else {
                                        self.categoryValue.append(false)
                                    }
                                    self.category.append(self.warehouseFilter!.filterModel[i].name[j])
                                } else {
                                    if contains(self.selectedProductGroup, self.warehouseFilter!.filterModel[i].name[j]) {
                                        self.productGroupValue.append(true)
                                    } else {
                                        self.productGroupValue.append(false)
                                    }
                                    self.productGroup.append(self.warehouseFilter!.filterModel[i].name[j])
                                }
                            }
                        }
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
