//
//  WarehouseListViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Elbert Philip O. Yagaya on 4/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WarehouseListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var warehouseList: [WarehouseModel] = []
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        self.initializeViews()
        self.initializedNavigationBarItems()
        self.fireGetWarehouseList()
    }
    
    //MARK: UITableView DataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.warehouseList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "WarehouseCell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        var warehouse: WarehouseModel = self.warehouseList[indexPath.row]
        let warehouseTitle: UILabel = cell.contentView.viewWithTag(100) as! UILabel
        let warehouseAddress: UILabel = cell.contentView.viewWithTag(200) as! UILabel
        
        warehouseTitle.text = warehouse.name
        warehouseAddress.text = warehouse.fullAddress
        
        return cell;
    }
    
    //MARK: UITableView Delegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Tapped \(indexPath.row)")
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let warehouseDetailVC: WarehouseDetailViewController = storyboard.instantiateViewControllerWithIdentifier("WarehouseDetailViewController") as! WarehouseDetailViewController
        self.navigationController?.pushViewController(warehouseDetailVC, animated: true)
        
    }

    func initializeViews() {
        self.tableView.tableFooterView = UIView()
    }
    
    func initializedNavigationBarItems() {
        self.title = StringHelper.localizedStringWithKey("WAREHOUSE_LOCALIZE_KEY")
        
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
        addButton.setImage(UIImage(named: "add"), forState: UIControlState.Normal)
        addButton.addTarget(self, action: "addWarehouse", forControlEvents: UIControlEvents.TouchUpInside)
        var customAddButton: UIBarButtonItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = customAddButton
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func addWarehouse() {
        print("Add Warehouse!")
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addWarehouseVC: AddWarehouseViewController = storyboard.instantiateViewControllerWithIdentifier("AddWarehouseViewController") as! AddWarehouseViewController
        let navController = UINavigationController(rootViewController: addWarehouseVC)
        addWarehouseVC.navigationController!.navigationBar.barTintColor = self.navigationController!.navigationBar.barTintColor
        self.presentViewController(navController, animated: true, completion: nil)
    }
<<<<<<< HEAD
=======
    
    func fireGetWarehouseList () {
        self.showHUD()
        WebServiceManager.fireGetListOfWarehouses(APIAtlas.getWarehouseList + SessionManager.accessToken(), actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            println("\(responseObject)")
            
            self.hud?.hide(true)
            
            if successful {
                var responseList: NSArray = (responseObject["data"] as? NSArray)!
                
                println("\(responseList)")
                if responseList.count != 0 {
                    
                    for var i = 0; i < responseList.count; i++ {
                        let warehouseDic: NSDictionary = responseList[i] as! NSDictionary
                        let warehouse: WarehouseModel = WarehouseModel.parseDataWithDictionary(warehouseDic)
                        println("\(warehouse.barangayLocationID)")
                        println("\(warehouse.barangayLocation)")
                        println("\(warehouse.cityLocationID)")
                        println("\(warehouse.cityLocation)")
                        println("\(warehouse.provinceLocationID)")
                        println("\(warehouse.provinceLocation)")
                        println("\(warehouse.countryLocationID)")
                        println("\(warehouse.countryLocation)")
                        println("\(warehouse.flag)")
                        println("\(warehouse.id)")
                        println("\(warehouse.name)")
                        println("\(warehouse.fullAddress)")
                        println("\(warehouse.isDelete)")
                        println("\(warehouse.zipCode)")
                        self.warehouseList.append(warehouse)
                    }
                    self.tableView.reloadData()
                    println("\(self.warehouseList.count)")
                    
                } else {
                    // self.emptyLabel.hidden = false
                }
                
            } else {
                if requestErrorType == .ResponseError {
                    // Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    //                    self.fireRefreshToken()
                } else if requestErrorType == .PageNotFound {
                    // Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    // No internet connection
                    // Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    // self.addEmptyView()
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
    
    
    // Show hud
    
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

    
>>>>>>> f2f87a1a6b3d1b11a56c40253777ce262a280e03
}
