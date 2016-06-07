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
    
    override func viewDidLoad() {
        self.initializeViews()
        self.initializedNavigationBarItems()
    }
    
    //MARK: UITableView DataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "WarehouseCell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
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
    
}
