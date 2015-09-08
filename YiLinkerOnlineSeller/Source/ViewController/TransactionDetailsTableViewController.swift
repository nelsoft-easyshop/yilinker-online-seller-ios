//
//  TransactionDetailsTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/4/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionDetailsTableViewController: UITableViewController, TransactionDetailsFooterViewDelegate, TransactionConsigneeTableViewCellDelegate, TransactionCancelOrderViewControllerDelegate, TransactionCancelOrderSuccessViewControllerDelegate {
    
    var detailsCellIdentifier: String = "TransactionDetailsTableViewCell"
    var productsCellIdentifier: String = "TransactionProductTableViewCell"
    var consigneeCellIdentifier: String = "TransactionConsigneeTableViewCell"
    var deliveryCellIdentifier: String = "TransactionDeliveryTableViewCell"
    
    var sectionHeader: [String] = ["DETAILS", "PRODUCT LIST", "CONSIGNEE", "DELIVERY STATUS"]
    var productList: [String] = ["North Face Super Uber Travel Bag", "Beats Studio Type 20 Headphones", "Sony Super Bass"]
    
    var tableHeaderView: UIView!
    var tidLabel: UILabel!
    var counterLabel: UILabel!
    
    var tableFooterView: TransactionDetailsFooterView!
    
    var dimView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeNavigationBar()
        initializeTableView()
        initializeViews()
        registerNibs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNibs() {
        var detailsNib = UINib(nibName: detailsCellIdentifier, bundle: nil)
        tableView.registerNib(detailsNib, forCellReuseIdentifier: detailsCellIdentifier)
        
        var productsNib = UINib(nibName: productsCellIdentifier, bundle: nil)
        tableView.registerNib(productsNib, forCellReuseIdentifier: productsCellIdentifier)
        
        var consigneeNib = UINib(nibName: consigneeCellIdentifier, bundle: nil)
        tableView.registerNib(consigneeNib, forCellReuseIdentifier: consigneeCellIdentifier)
        
        var deliveryNib = UINib(nibName: deliveryCellIdentifier, bundle: nil)
        tableView.registerNib(deliveryNib, forCellReuseIdentifier: deliveryCellIdentifier)
    }
    
    func initializeTableView() {
        tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 80))
        tableHeaderView.backgroundColor = UIColor.whiteColor()
        
        tidLabel = UILabel(frame: CGRectMake(16, 20, (self.view.bounds.width - 32), 20))
        tidLabel.textColor = Constants.Colors.grayText
        tidLabel.font = UIFont(name: "Panton-Bold", size: CGFloat(14))
        tidLabel.text = "TID-203-553-918"
        tableHeaderView.addSubview(tidLabel)
        
        counterLabel = UILabel(frame: CGRectMake(16, 40, (self.view.bounds.width - 32), 20))
        counterLabel.textColor = Constants.Colors.grayText
        counterLabel.font = UIFont(name: "Panton-Regular", size: CGFloat(14))
        counterLabel.text = "5 Products"
        tableHeaderView.addSubview(counterLabel)
        
        if tableFooterView == nil {
            tableFooterView = XibHelper.puffViewWithNibName("TransactionDetailsFooterView", index: 0) as! TransactionDetailsFooterView
            tableFooterView.delegate = self
            tableFooterView.frame.size.width = self.view.frame.size.width
        }
        
        
        self.tableView.tableHeaderView = tableHeaderView
        self.tableView.tableFooterView = tableFooterView
    }
    
    func initializeNavigationBar() {
        self.title = "Transaction Details"
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func initializeViews(){
        dimView = UIView(frame: self.view.bounds)
        dimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController?.view.addSubview(dimView!)
        //self.view.addSubview(dimView!)
        dimView?.hidden = true
        dimView?.alpha = 0
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return sectionHeader.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {           //Details
            return 1
        } else if section == 1 {    //Product Lis
            return productList.count
        } else if section == 2 {    //Consignee
            return 1
        }  else if section == 3 {    //Delivery Status
            return 1
        } else {
            return 0
        }        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: TransactionDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier(detailsCellIdentifier, forIndexPath: indexPath) as! TransactionDetailsTableViewCell
            cell.selectionStyle = .None;
            
            return cell
        } else if indexPath.section == 1 {
            let cell: TransactionProductTableViewCell = tableView.dequeueReusableCellWithIdentifier(productsCellIdentifier, forIndexPath: indexPath) as! TransactionProductTableViewCell
            cell.productNameLabel.text = productList[indexPath.row]
            
            return cell
        }  else if indexPath.section == 2 {
            let cell: TransactionConsigneeTableViewCell = tableView.dequeueReusableCellWithIdentifier(consigneeCellIdentifier, forIndexPath: indexPath) as! TransactionConsigneeTableViewCell
            cell.selectionStyle = .None;
            cell.delegate = self
            return cell
        }  else if indexPath.section == 3 {
            let cell: TransactionDeliveryTableViewCell = tableView.dequeueReusableCellWithIdentifier(deliveryCellIdentifier, forIndexPath: indexPath) as! TransactionDeliveryTableViewCell
            cell.selectionStyle = .None;
            return cell
        } else {
            let cell: TransactionDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier(detailsCellIdentifier, forIndexPath: indexPath) as! TransactionDetailsTableViewCell
            cell.selectionStyle = .None;
            // Configure the cell...
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 40))
        headerView.backgroundColor = Constants.Colors.selectedCellColor
        var headerTextLabel: UILabel = UILabel(frame: CGRectMake(16, 15, (self.view.bounds.width - 32), 20))
        headerTextLabel.textColor = Constants.Colors.grayText
        headerTextLabel.font = UIFont(name: "Panton-Regular", size: CGFloat(12))
        headerTextLabel.text = sectionHeader[section]
        headerView.addSubview(headerTextLabel)
        
        return headerView
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {           //Details
            return 231
        } else if indexPath.section == 1 {    //Product Lis
            return 35
        } else if indexPath.section == 2 {    //Consignee
            return 190
        }  else if indexPath.section == 3 {    //Delivery Status
            return 155
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            var productDetailsController = TransactionProductTableViewController(nibName: "TransactionProductTableViewController", bundle: nil)
            self.navigationController?.pushViewController(productDetailsController, animated:true)
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
    
    func showDimView() {
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
    
    // MARK: - TransactionDetailsFooterViewDelegate
    func shipItemAction() {
        var shipItemController = TransactionShipItemTableViewController(nibName: "TransactionShipItemTableViewController", bundle: nil)
        self.navigationController?.pushViewController(shipItemController, animated:true)
    }
    
    func cancelOrderAction() {
        showDimView()
        
        var cancelOrderController = TransactionCancelOrderViewController(nibName: "TransactionCancelOrderViewController", bundle: nil)
        cancelOrderController.delegate = self
        cancelOrderController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        cancelOrderController.providesPresentationContextTransitionStyle = true
        cancelOrderController.definesPresentationContext = true
        cancelOrderController.view.backgroundColor = UIColor.clearColor()
        self.tabBarController?.presentViewController(cancelOrderController, animated: true, completion: nil)
    }
    
    // MARK: - TransactionCancelOrderViewControllerDelegate
    func closeCancelOrderViewController() {
        hideDimView()
    }
    
    func yesCancelOrderAction() {
        var successController = TransactionCancelOrderSuccessViewController(nibName: "TransactionCancelOrderSuccessViewController", bundle: nil)
        successController.delegate = self
        successController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        successController.providesPresentationContextTransitionStyle = true
        successController.definesPresentationContext = true
        successController.view.backgroundColor = UIColor.clearColor()
        self.tabBarController?.presentViewController(successController, animated: true, completion: nil)
    }
    
    func noCancelOrderAction() {
        hideDimView()
    }
    
    
    // MARK: - TransactionCancelOrderSuccessViewControllerDelegate
    func closeCancelOrderSuccessViewController() {
        hideDimView()
    }
    
    func returnToDashboardAction() {
        hideDimView()
    }
    

    
    // MARK: - TransactionConsigneeTableViewCellDelegate
    func messageConsigneeAction() {
        
    }

    func smsConsigneeAction() {
        
    }
    
    func callConsigneeAction() {
        
    }
}
