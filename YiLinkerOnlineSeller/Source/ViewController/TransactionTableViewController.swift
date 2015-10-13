//
//  TransactionTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/4/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol TransactionTableViewControllerDelegate {
    func doneWithFilter(dates: String, statuses: [String], paymentMethods: [String], selectedDate: Int, selectedStatus: Int, selectedPayment: Int)
}

class TransactionTableViewController: UITableViewController {
    
    var delegate: TransactionTableViewControllerDelegate?
    
    var filterTableViewCellIdentifier: String = "TransactionFilterTableViewCell"
    
    var tableData: [TransactionsFilterModel] = []
    
    var selectedDate: Int = 4
    var selectedStatus: Int = 0
    var selectedPayment: Int = 0
    
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
        var nib = UINib(nibName: filterTableViewCellIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: filterTableViewCellIdentifier)
    }
    
    func populateData() {
        
        tableData.removeAll(keepCapacity: false)
        
        let datesString = StringHelper.localizedStringWithKey("TRANSACTIONS_DATES_LOCALIZE_KEY")
        let todayString = StringHelper.localizedStringWithKey("TRANSACTIONS_TODAY_LOCALIZE_KEY")
        let thisWeekString = StringHelper.localizedStringWithKey("TRANSACTIONS_THIS_WEEK_LOCALIZE_KEY")
        let thisMonthString = StringHelper.localizedStringWithKey("TRANSACTIONS_THIS_MONTH_LOCALIZE_KEY")
        let totalString = StringHelper.localizedStringWithKey("TRANSACTIONS_TOTAL_LOCALIZE_KEY")
        
        tableData.append(TransactionsFilterModel(headerText: datesString, items:
            [TransactionsFilterItemModel(title: todayString, isChecked: false),
            TransactionsFilterItemModel(title: thisWeekString, isChecked: false),
            TransactionsFilterItemModel(title: thisMonthString, isChecked: false),
            TransactionsFilterItemModel(title: totalString, isChecked: false)]))
        
        let statusString = StringHelper.localizedStringWithKey("TRANSACTIONS_STATUS_LOCALIZE_KEY")
        let newOrderString = StringHelper.localizedStringWithKey("TRANSACTIONS_NEW_ORDER_LOCALIZE_KEY")
        let newUpdateString = StringHelper.localizedStringWithKey("TRANSACTIONS_NEW_UPDATE_LOCALIZE_KEY")
        let ongoingString = StringHelper.localizedStringWithKey("TRANSACTIONS_ONGOING_LOCALIZE_KEY")
        let completedString = StringHelper.localizedStringWithKey("TRANSACTIONS_COMPLETED_LOCALIZE_KEY")
        let cancelledString = StringHelper.localizedStringWithKey("TRANSACTIONS_CANCELLED_LOCALIZE_KEY")
        
        tableData.append(TransactionsFilterModel(headerText: statusString, items:
            [TransactionsFilterItemModel(title: newOrderString, isChecked: false),
                TransactionsFilterItemModel(title: newUpdateString, isChecked: false),
                TransactionsFilterItemModel(title: ongoingString, isChecked: false),
                TransactionsFilterItemModel(title: completedString, isChecked: false),
                TransactionsFilterItemModel(title: cancelledString, isChecked: false),]))
        
        let paymentMethodString = StringHelper.localizedStringWithKey("TRANSACTIONS_PAYMENT_METHOD_LOCALIZE_KEY")
        let codString = StringHelper.localizedStringWithKey("TRANSACTIONS_COD_LOCALIZE_KEY")
        let creditDebitString = StringHelper.localizedStringWithKey("TRANSACTIONS_CREDIT_DEBIT_CARD_LOCALIZE_KEY")
        let dragonPayString = StringHelper.localizedStringWithKey("TRANSACTIONS_DRAGONPAY_LOCALIZE_KEY")
        let pesoPayString = StringHelper.localizedStringWithKey("TRANSACTIONS_PESOPAY_LOCALIZE_KEY")
        let walletString = StringHelper.localizedStringWithKey("TRANSACTIONS_WALLET_LOCALIZE_KEY")
        
        tableData.append(TransactionsFilterModel(headerText: paymentMethodString, items:
            [TransactionsFilterItemModel(title: codString, isChecked: false),
                TransactionsFilterItemModel(title: creditDebitString, isChecked: false),
                TransactionsFilterItemModel(title: dragonPayString, isChecked: false),
                TransactionsFilterItemModel(title: pesoPayString, isChecked: false),
                TransactionsFilterItemModel(title: walletString, isChecked: false),]))
        
        
        if selectedDate != 0 {
            tableData[0].items[selectedDate - 1].isChecked = true
        }
        
        if selectedStatus != 0 {
            if selectedStatus != 0 {
                tableData[1].items[selectedStatus].isChecked = true
            }
        }
        
        if selectedPayment != 0 {
            tableData[2].items[selectedPayment - 1].isChecked = true
        }
        
        self.tableView.reloadData()
    }
    
    func clearFilter() {
        selectedDate = 4
        selectedStatus = 0
        selectedPayment = 0
        
        populateData()
    }
    
    func initializesViews() {
        
        var footerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 60))
        footerView.backgroundColor = Constants.Colors.selectedCellColor
        
        var clearFilterView: UIView = UIView(frame: CGRectMake(0, 20, self.view.bounds.width, 35))
        clearFilterView.backgroundColor = UIColor.whiteColor()
        
        var clearTextLabel: UILabel = UILabel(frame: CGRectMake(16, 8, (self.view.bounds.width - 32), 20))
        clearTextLabel.textColor = Constants.Colors.productPrice
        clearTextLabel.font = UIFont(name: "Panton-Regular", size: CGFloat(14))
        clearTextLabel.text = StringHelper.localizedStringWithKey("TRANSACTIONS_CLEAR_FILTER_LOCALIZE_KEY")
        clearFilterView.addSubview(clearTextLabel)
        footerView.addSubview(clearFilterView)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "clearFilter")
        footerView.addGestureRecognizer(tapGesture)
        
        tableView.tableFooterView = footerView
    }
    
    func initializeNavigationBar() {
        self.title = StringHelper.localizedStringWithKey("TRANSACTIONS_FILTER_TITLE_LOCALIZE_KEY")
        
        var closeButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        closeButton.frame = CGRectMake(0, 0, 25, 20)
        closeButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        closeButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.setImage(UIImage(named: "check-1"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = 0
        self.navigationItem.rightBarButtonItems = [navigationSpacer, customBackButton]
        
        var checkButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 20)
        checkButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        checkButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "close-1"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = 0
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    func check() {
        var dates: String = ""
        for subValue in tableData[0].items {
            if subValue.isChecked {
                dates = subValue.title
            }
        }
        
        var statuses: [String] = []
        for subValue in tableData[1].items {
            if subValue.isChecked {
                statuses.append(subValue.title)
            }
        }
        
        var paymentMethods: [String] = []
        for subValue in tableData[2].items {
            if subValue.isChecked {
                paymentMethods.append(subValue.title)
            }
        }
        
        delegate?.doneWithFilter(dates, statuses: statuses, paymentMethods: paymentMethods, selectedDate: selectedDate, selectedStatus: selectedStatus, selectedPayment: selectedPayment)
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
        var headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 40))
        headerView.backgroundColor = Constants.Colors.selectedCellColor
        var headerTextLabel: UILabel = UILabel(frame: CGRectMake(16, 15, (self.view.bounds.width - 32), 20))
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
        
        var tempModel = tableData[indexPath.section]
        if indexPath.section == 0 {
            cell.setType(0)
        } else {
            cell.setType(0)
        }
        
        cell.setTitleLabelText(tempModel.items[indexPath.row].title)
        cell.setChecked(tempModel.items[indexPath.row].isChecked)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
//        if indexPath.section == 0 {
//            for var i: Int = 0; i < tableData[0].items.count; i++ {
//                tableData[0].items[i].isChecked = false
//                println(tableData[0].items[i].isChecked)
//            }
//            tableData[indexPath.section].items[indexPath.row].isChecked = true
//            self.tableView.reloadData()
//        } else {
//            tableData[indexPath.section].items[indexPath.row].isChecked = !tableData[indexPath.section].items[indexPath.row].isChecked
//        }
        
        let originalStatus: Bool = tableData[indexPath.section].items[indexPath.row].isChecked
        
        if indexPath.section == 0 {
            selectedDate = indexPath.row + 1
        } else if indexPath.section == 1 {
            if !originalStatus {
                selectedStatus = indexPath.row
            } else {
                selectedStatus = 0
            }
        }  else if indexPath.section == 2 {
            if !originalStatus {
                selectedPayment = indexPath.row + 1
            }  else {
                selectedPayment = 0
            }
        }
        
        for var i: Int = 0; i < tableData[indexPath.section].items.count; i++ {
            tableData[indexPath.section].items[i].isChecked = false
        }
        if indexPath.section == 0 {
            tableData[indexPath.section].items[indexPath.row].isChecked = true
        } else {
            tableData[indexPath.section].items[indexPath.row].isChecked = !originalStatus
        }
        self.tableView.reloadData()

        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
}
