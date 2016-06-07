//
//  WarehouseDetailViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Elbert Philip O. Yagaya on 4/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WarehouseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.initializeViews()
        self.initializedNavigationBarItems()
        //self.configureCell()
    }

    //MARK: UITableView DataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowNumbers = [1, 5, 4]
        
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
        self.navigationController?.pushViewController(warehouseFilterVC, animated: true)
    }

    func configureCell() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
    }
    
}
