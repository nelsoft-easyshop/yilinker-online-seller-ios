//
//  TransactionTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/4/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionTableViewController: UITableViewController {
    
    var filterTableViewCellIdentifier: String = "TransactionFilterTableViewCell"
    
    var tableData: [TransactionsFilterModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerNibs()
        populateData()
        initializeNavigationBar()
        initializesViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNibs() {
        let nib = UINib(nibName: filterTableViewCellIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: filterTableViewCellIdentifier)
    }
    
    func populateData() {
        
        tableData.removeAll(keepCapacity: false)
        
        tableData.append(TransactionsFilterModel(headerText: "DATES", items:
            [TransactionsFilterItemModel(title: "Today", isChecked: true),
            TransactionsFilterItemModel(title: "This Week", isChecked: false),
            TransactionsFilterItemModel(title: "This Month", isChecked: false),
            TransactionsFilterItemModel(title: "Total", isChecked: false)]))
        
        tableData.append(TransactionsFilterModel(headerText: "STATUS", items:
            [TransactionsFilterItemModel(title: "New Update", isChecked: false),
                TransactionsFilterItemModel(title: "New Order", isChecked: false),
                TransactionsFilterItemModel(title: "On-Going", isChecked: false),
                TransactionsFilterItemModel(title: "Completed", isChecked: false),
                TransactionsFilterItemModel(title: "Cancelled", isChecked: false),]))
        
        tableData.append(TransactionsFilterModel(headerText: "PAYMENT METHOD", items:
            [TransactionsFilterItemModel(title: "Cash on Delivery", isChecked: false),
                TransactionsFilterItemModel(title: "Credit/ Debit Card", isChecked: false),
                TransactionsFilterItemModel(title: "DragonPay", isChecked: false),
                TransactionsFilterItemModel(title: "PesoPay", isChecked: false),
                TransactionsFilterItemModel(title: "Wallet", isChecked: false),]))
        
        self.tableView.reloadData()
    }
    
    func initializesViews() {
        
        let footerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 60))
        footerView.backgroundColor = Constants.Colors.selectedCellColor
        
        let clearFilterView: UIView = UIView(frame: CGRectMake(0, 20, self.view.bounds.width, 35))
        clearFilterView.backgroundColor = UIColor.whiteColor()
        
        let clearTextLabel: UILabel = UILabel(frame: CGRectMake(16, 8, (self.view.bounds.width - 32), 20))
        clearTextLabel.textColor = Constants.Colors.productPrice
        clearTextLabel.font = UIFont(name: "Panton-Regular", size: CGFloat(14))
        clearTextLabel.text = "Clear Filter"
        clearFilterView.addSubview(clearTextLabel)
        footerView.addSubview(clearFilterView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "populateData")
        footerView.addGestureRecognizer(tapGesture)
        
        tableView.tableFooterView = footerView
    }
    
    func initializeNavigationBar() {
        self.title = "Filter"
        
        let closeButton:UIButton = UIButton(type: UIButtonType.Custom)
        closeButton.frame = CGRectMake(0, 0, 25, 20)
        closeButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        closeButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.setImage(UIImage(named: "check-1"), forState: UIControlState.Normal)
        let customBackButton:UIBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = 0
        self.navigationItem.rightBarButtonItems = [navigationSpacer, customBackButton]
        
        let checkButton = UIButton(type: UIButtonType.Custom)
        checkButton.frame = CGRectMake(0, 0, 25, 20)
        checkButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        checkButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "close-1"), forState: UIControlState.Normal)
        let customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = 0
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    func check() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].items.count
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 40))
        headerView.backgroundColor = Constants.Colors.selectedCellColor
        let headerTextLabel: UILabel = UILabel(frame: CGRectMake(16, 15, (self.view.bounds.width - 32), 20))
        headerTextLabel.textColor = Constants.Colors.grayText
        headerTextLabel.font = UIFont(name: "Panton-Regular", size: CGFloat(12))
        headerTextLabel.text = tableData[section].headerText
        headerView.addSubview(headerTextLabel)
        
        return headerView
    }
    
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(filterTableViewCellIdentifier, forIndexPath: indexPath) as! TransactionFilterTableViewCell
        
        let tempModel = tableData[indexPath.section]
        if indexPath.section == 0 {
            cell.setType(0)
        } else {
            cell.setType(1)
        }
        
        cell.setTitleLabelText(tempModel.items[indexPath.row].title)
        cell.setChecked(tempModel.items[indexPath.row].isChecked)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            for var i: Int = 0; i < tableData[0].items.count; i++ {
                tableData[0].items[i].isChecked = false
                print(tableData[0].items[i].isChecked)
            }
            tableData[indexPath.section].items[indexPath.row].isChecked = true
            self.tableView.reloadData()
        } else {
            tableData[indexPath.section].items[indexPath.row].isChecked = !tableData[indexPath.section].items[indexPath.row].isChecked
        }
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
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
