//
//  WarehouseListViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Elbert Philip O. Yagaya on 4/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WarehouseListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var warehouseList: [WarehouseModel] = []
    var hud: MBProgressHUD?
   
    
    override func viewDidLoad() {
        self.initializeViews()
        self.initializedNavigationBarItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.warehouseList = []
        self.fireGetWarehouseList()

    }
    
    //MARK: UITableView DataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.warehouseList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "WarehouseCell"
        let cell: MGSwipeTableCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MGSwipeTableCell
        
        cell.delegate = self
        //configure right buttons
        cell.rightButtons = [MGSwipeButton(title:"",icon: UIImage(named:"warehouse_delete"), backgroundColor: UIColor.lightGrayColor())
            ,MGSwipeButton(title: "",icon: UIImage(named:"warehouse_edit"), backgroundColor: UIColor.lightGrayColor())]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Border
        
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
            warehouseDetailVC.warehouse = self.warehouseList[indexPath.row]
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
    
    func fireDeleteWarehouse(warehouseId: Int) {
        
        self.showHUD()
        
        WebServiceManager.fireDeleteWarehouse(APIAtlas.deleteWarehouse + SessionManager.accessToken(), warehouseId: warehouseId) { (successful, responseObject, requestErrorType) -> Void in
            
            //self.hud?.hide(true)
            
            if successful {
                println("\(responseObject)")
                self.warehouseList = []
                Toast.displayToastWithMessage(responseObject["message"] as! String, duration: 2.0, view: self.view)
                self.fireGetWarehouseList()
                println("\(self.warehouseList.count)")
                self.tableView.reloadData()
                
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
            
        }
    }
    
    
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
    
    @IBAction func fireDeleteButton(sender: UIButton) {
        println("delete")
    }
    
    @IBAction func fireEditButton(sender: UIButton) {
        println("edit")
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addWarehouseVC: AddWarehouseViewController = storyboard.instantiateViewControllerWithIdentifier("AddWarehouseViewController") as! AddWarehouseViewController
        let navController = UINavigationController(rootViewController: addWarehouseVC)
        addWarehouseVC.navigationController!.navigationBar.barTintColor = self.navigationController!.navigationBar.barTintColor
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool
    {
        let indexPath = tableView.indexPathForCell(cell)
        if index == 0 {
            println("delete")
            if self.warehouseList.count != 0 {
                let selectedWarehouse: WarehouseModel = self.warehouseList[indexPath!.row]
                self.fireDeleteWarehouse(selectedWarehouse.id)
            }
        } else {
            println("edit")
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let addWarehouseVC: AddWarehouseViewController = storyboard.instantiateViewControllerWithIdentifier("AddWarehouseViewController") as! AddWarehouseViewController
            addWarehouseVC.warehouseModel = self.warehouseList[indexPath!.row]
            let navController = UINavigationController(rootViewController: addWarehouseVC)
            addWarehouseVC.navigationController!.navigationBar.barTintColor = self.navigationController!.navigationBar.barTintColor
            self.presentViewController(navController, animated: true, completion: nil)
        }
        
        return true
    }
}
