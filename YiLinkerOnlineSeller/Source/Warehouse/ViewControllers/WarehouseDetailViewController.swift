//
//  WarehouseDetailViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Elbert Philip O. Yagaya on 4/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WarehouseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WarehouseFilterViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var hud: MBProgressHUD?
    
    //Warehouse Inventory
    //Get Warehouse Inventory Params
    var warehouseId: String = "964"
    var page: Int = 1
    var category: String = ""
    var status: String = ""
    var query: String = ""
    var group: String = ""
    
    var totalpage: Int = 2
    
    var warehouseInventory: [WarehouseInventoryProduct] = []
    
    override func viewDidLoad() {
        self.initializeViews()
        self.initializedNavigationBarItems()
        //self.configureCell()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.fireGetWarehouseInventory()
    }

    //MARK: UITableView DataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowNumbers = [1, 5, self.warehouseInventory.count]
        
        if section < rowNumbers.count {
            return rowNumbers[section]
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cellIdentifier: String = "WarehouseDetailCell1"
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
            return cell;
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cellIdentifier: String = "WarehouseDetailCell2"
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
                return cell;
            } else {
                let cellIdentifier: String = "WarehouseDetailCell3"
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
                return cell;

            }
        } else if indexPath.section == 2 {
            let cellIdentifier: String = "WarehouseProductListCell"
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
            
            let tempInventory = self.warehouseInventory[indexPath.row]
            
            if let nameLabel = cell.viewWithTag(1) as? UILabel {
                nameLabel.text = tempInventory.name
            }
            
            if let quantityLabel = cell.viewWithTag(2) as? UILabel {
                quantityLabel.text = "System Inventory: \(tempInventory.quantity)"
            }
            
            return cell;
        }
    
        let cellIdentifier: String = "WarehouseDetailCell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        return cell;
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let headerTitles = ["","Details", "Product List"]

        if section < headerTitles.count {
            return headerTitles[section]
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 70.0
        } else if indexPath.section == 1 {
            return 50.0
        } else {
            return 70.0
        }
    }
    
    //MARK: UITableView Delegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            println("Epoy")
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let wareHouseProductDetailVC: WarehouseProductDetailViewController = storyboard.instantiateViewControllerWithIdentifier("WarehouseProductDetailViewController") as! WarehouseProductDetailViewController
            let navController = UINavigationController(rootViewController: wareHouseProductDetailVC)
            wareHouseProductDetailVC.navigationController!.navigationBar.barTintColor = self.navigationController!.navigationBar.barTintColor
            self.presentViewController(navController, animated: true, completion: nil)
        }
    }
    
    func scrollViewDidEndDragging(aScrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset: CGPoint = aScrollView.contentOffset
        var bounds: CGRect = aScrollView.bounds
        var size: CGSize = aScrollView.contentSize
        var inset: UIEdgeInsets = aScrollView.contentInset
        var y: CGFloat = offset.y + bounds.size.height - inset.bottom
        var h: CGFloat = size.height
        var reload_distance: CGFloat = 10
        var temp: CGFloat = h + reload_distance
        if y > temp {
            self.fireGetWarehouseInventory()
        }
    }
    
    //MARK: Local Methods
    
    func initializeViews() {
        self.tableView.tableFooterView = UIView()
    }
    
    func initializedNavigationBarItems() {
        self.title = StringHelper.localizedStringWithKey("Warehouse Detail")
        
        var backButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        var addButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        addButton.frame = CGRectMake(0, 0, 20, 20)
        addButton.setImage(UIImage(named: "filter"), forState: UIControlState.Normal)
        addButton.addTarget(self, action: "addFilter", forControlEvents: UIControlEvents.TouchUpInside)
        var customAddButton: UIBarButtonItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = customAddButton
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func addFilter() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let warehouseFilterVC: WarehouseFilterViewController = storyboard.instantiateViewControllerWithIdentifier("WarehouseFilterViewController") as! WarehouseFilterViewController
        warehouseFilterVC.delegate = self
        warehouseFilterVC.status = self.status
        warehouseFilterVC.category = self.category
        warehouseFilterVC.productGroup = self.group
        self.navigationController?.pushViewController(warehouseFilterVC, animated: true)
    }

    func configureCell() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
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
    
    
    //MARK: API Methods
    func fireGetWarehouseInventory() {
        
        if self.page <= self.totalpage {
            self.showHUD()
            WebServiceManager.fireGetWarehouseInventory(APIAtlas.warehouseInventory, warehouseId: self.warehouseId, page: "\(self.page)", category: self.category, status: self.status, query: self.query, group: self.group, accessToken: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
                self.hud?.hide(true)
                if successful {
                    self.page++
                    self.totalpage = WarehouseInventoryProduct.getTotalPage(responseObject)
                    self.warehouseInventory += WarehouseInventoryProduct.parseArrayWithDictionary(responseObject)
                    self.tableView.reloadData()
                } else {
                    if requestErrorType == .ResponseError {
                        //Error in api requirements
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                    } else if requestErrorType == .AccessTokenExpired {
                        self.fireRefreshToken("getWarehousInventory")
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
            }
        } else {
            let noMoreDataString = StringHelper.localizedStringWithKey("NO_MORE_DATA_LOCALIZE_KEY")
            
            Toast.displayToastWithMessage(noMoreDataString, duration: 1.5, view: self.view)
        }
        
    }
    
    func fireRefreshToken(type: String) {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                
                if type == "getWarehousInventory" {
                    self.fireGetWarehouseInventory()
                }
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                })
            }
        })
    }
    
    // MARK: -
    // MARK: - WarehouseFilterViewController Delegate Method 
    func warehouseFilter(status: String, category: String, productGroup: String) {
        self.status = status
        self.category = category
        self.group = productGroup
    }
}
