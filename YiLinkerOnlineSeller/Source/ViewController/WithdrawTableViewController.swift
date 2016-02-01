//
//  WithdrawTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WithdrawTableViewController: UITableViewController {
    
    var headerView: UIView!
    var availableBalanceView: WithdrawAvailableBalanceView!
    var amountView: WithdrawAmountView!
    var methodView: WithdrawMethodView!
    var depositToView: WithdrawDepositToView!
    var mobileNoView: WithdrawMobileNoView!
    var confimationCodeView: WithdrawConfirmationCodeView!
    var proceedView: WithdrawProceedView!
    
    var newFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        addViews()
    }
    
    // MARK: - Initialize Views
    
    func getHeaderView() -> UIView {
        if self.headerView == nil {
            self.headerView = UIView(frame: CGRectZero)
            self.headerView.autoresizesSubviews = false
        }
        return self.headerView
    }
    
    func getAvailableBalanceView() -> WithdrawAvailableBalanceView {
        if self.availableBalanceView == nil {
            self.availableBalanceView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 0) as! WithdrawAvailableBalanceView
        }
        return self.availableBalanceView
    }
    
    func getAmountView() -> WithdrawAmountView {
        if self.amountView == nil {
            self.amountView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 1) as! WithdrawAmountView
        }
        return self.amountView
    }
    
    func getMethodView() -> WithdrawMethodView {
        if self.methodView == nil {
            self.methodView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 2) as! WithdrawMethodView
        }
        return self.methodView
    }
    
    func getDepositToView() -> WithdrawDepositToView {
        if self.depositToView == nil {
            self.depositToView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 3) as! WithdrawDepositToView
        }
        return self.depositToView
    }
    
    func getMobileNoView() -> WithdrawMobileNoView {
        if self.mobileNoView == nil {
            self.mobileNoView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 4) as! WithdrawMobileNoView
        }
        return self.mobileNoView
    }
    
    func getConfimationCodeView() -> WithdrawConfirmationCodeView {
        if self.confimationCodeView == nil {
            self.confimationCodeView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 5) as! WithdrawConfirmationCodeView
        }
        return self.confimationCodeView
    }
    
    func getProceedView() -> WithdrawProceedView {
        if self.proceedView == nil {
            self.proceedView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 6) as! WithdrawProceedView
        }
        return self.proceedView
    }
    
    // MARK: - Functions
    
    func addViews() {
        self.getHeaderView().addSubview(self.getAvailableBalanceView())
        self.getHeaderView().addSubview(self.getAmountView())
        self.getHeaderView().addSubview(self.getMethodView())
        self.getHeaderView().addSubview(self.getDepositToView())
        self.getHeaderView().addSubview(self.getMobileNoView())
        self.getHeaderView().addSubview(self.getConfimationCodeView())
        self.getHeaderView().addSubview(self.getProceedView())
        
        positionViews()
    }
    
    func positionViews() {
        self.setPosition(self.amountView, from: self.availableBalanceView)
        self.setPosition(self.methodView, from: self.amountView)
        self.setPosition(self.depositToView, from: self.methodView)
        self.setPosition(self.mobileNoView, from: self.depositToView)
        self.setPosition(self.confimationCodeView, from: self.mobileNoView)
        self.setPosition(self.proceedView, from: self.confimationCodeView)
        
        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.proceedView.frame)
        self.headerView.frame = newFrame
        
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame) + 20
        view.frame = newFrame
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
