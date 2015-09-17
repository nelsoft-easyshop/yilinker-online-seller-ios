//
//  TransactionProductTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionProductTableViewController: UITableViewController {
    var purchaseCellIdentifier: String = "TransactionProductPurchaseTableViewCell"
    var productCellIdentifier: String = "TransactionProductDetailsTableViewCell"
    var descriptionCellIdentifier: String = "TransactionProductDescriptionTableViewCell"
    
    var sectionHeader: [String] = ["Purchase Details", "Product Details", "Description"]
    var productAttributeData: [String] = ["SKU", "Brand", "Weight (kg)", "Height (mm)", "Type of Jack"]
    var productAttributeValueData: [String] = ["ABCD-123-5678-90122", "Beats Studio Version", "0.26", "203mm", "3.5mm"]
    
    var tableHeaderView: TransactionProductDetailsHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeNavigationBar()
        initializeTableView()
        registerNibs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNibs() {
        let purchaseNib = UINib(nibName: purchaseCellIdentifier, bundle: nil)
        tableView.registerNib(purchaseNib, forCellReuseIdentifier: purchaseCellIdentifier)
        
        let productNib = UINib(nibName: productCellIdentifier, bundle: nil)
        tableView.registerNib(productNib, forCellReuseIdentifier: productCellIdentifier)
        
        let descriptionNib = UINib(nibName: descriptionCellIdentifier, bundle: nil)
        tableView.registerNib(descriptionNib, forCellReuseIdentifier: descriptionCellIdentifier)
    }
    
    func initializeTableView() {
        if tableHeaderView == nil {
            tableHeaderView = XibHelper.puffViewWithNibName("TransactionProductDetailsHeaderView", index: 0) as! TransactionProductDetailsHeaderView
            tableHeaderView.frame.size.width = self.view.frame.size.width
        }
        
        self.tableView.tableHeaderView = tableHeaderView
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func initializeNavigationBar() {
        self.title = "Product Details"
        
        let backButton:UIButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        let customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeader.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return productAttributeData.count
        } else {
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 45))
        headerView.backgroundColor = Constants.Colors.selectedCellColor
        
        
        let headerSubView: UIView = UIView(frame: CGRectMake(0, 10, self.view.bounds.width, 35))
        headerSubView.backgroundColor = UIColor.whiteColor()
        
        let headerTextLabel: UILabel = UILabel(frame: CGRectMake(16, 8, (self.view.bounds.width - 32), 20))
        headerTextLabel.textColor = Constants.Colors.grayText
        headerTextLabel.font = UIFont(name: "Panton-Bold", size: CGFloat(14))
        headerTextLabel.text = sectionHeader[section]
        headerSubView.addSubview(headerTextLabel)
        
        headerView.addSubview(headerSubView)
        
        let line: UIView = UIView(frame: CGRectMake(0, 44, self.view.bounds.width, 1))
        line.backgroundColor = Constants.Colors.selectedCellColor
        
        headerView.addSubview(line)
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {           //Details
            return 100
        } else if indexPath.section == 1 {    //Product Lis
            return 35
        } else if indexPath.section == 2 {    //Consignee
            return 100
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell: TransactionProductPurchaseTableViewCell = tableView.dequeueReusableCellWithIdentifier(purchaseCellIdentifier, forIndexPath: indexPath) as! TransactionProductPurchaseTableViewCell
            return cell
        } else if indexPath.section == 1 {
            let cell: TransactionProductDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier(productCellIdentifier, forIndexPath: indexPath) as! TransactionProductDetailsTableViewCell
            
            cell.productAttributeLabel.text = productAttributeData[indexPath.row]
            cell.productDeatilsLabel.text = productAttributeValueData[indexPath.row]
            
            return cell
        } else {
            let cell: TransactionProductDescriptionTableViewCell = tableView.dequeueReusableCellWithIdentifier(descriptionCellIdentifier, forIndexPath: indexPath) as! TransactionProductDescriptionTableViewCell
            return cell
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}
