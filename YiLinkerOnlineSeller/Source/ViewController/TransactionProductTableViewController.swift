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
    
    var productModel: TransactionOrderProductModel!
    
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
        var purchaseNib = UINib(nibName: purchaseCellIdentifier, bundle: nil)
        tableView.registerNib(purchaseNib, forCellReuseIdentifier: purchaseCellIdentifier)
        
        var productNib = UINib(nibName: productCellIdentifier, bundle: nil)
        tableView.registerNib(productNib, forCellReuseIdentifier: productCellIdentifier)
        
        var descriptionNib = UINib(nibName: descriptionCellIdentifier, bundle: nil)
        tableView.registerNib(descriptionNib, forCellReuseIdentifier: descriptionCellIdentifier)
    }
    
    func initializeTableView() {
        if tableHeaderView == nil {
            tableHeaderView = XibHelper.puffViewWithNibName("TransactionProductDetailsHeaderView", index: 0) as! TransactionProductDetailsHeaderView
            tableHeaderView.frame.size.width = self.view.frame.size.width
            tableHeaderView.productNameLabel.text = productModel.productName
            tableHeaderView.productDescriptionLabel.text = ""
        }
        
        self.tableView.tableHeaderView = tableHeaderView
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func initializeNavigationBar() {
        self.title = "Product Details"
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
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
        var headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 45))
        headerView.backgroundColor = Constants.Colors.selectedCellColor
        
        
        var headerSubView: UIView = UIView(frame: CGRectMake(0, 10, self.view.bounds.width, 35))
        headerSubView.backgroundColor = UIColor.whiteColor()
        
        var headerTextLabel: UILabel = UILabel(frame: CGRectMake(16, 8, (self.view.bounds.width - 32), 20))
        headerTextLabel.textColor = Constants.Colors.grayText
        headerTextLabel.font = UIFont(name: "Panton-Bold", size: CGFloat(14))
        headerTextLabel.text = sectionHeader[section]
        headerSubView.addSubview(headerTextLabel)
        
        headerView.addSubview(headerSubView)
        
        var line: UIView = UIView(frame: CGRectMake(0, 44, self.view.bounds.width, 1))
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
            cell.quantityLabel.text = "\(productModel.quantity)"
            cell.priceLabel.text = productModel.unitPrice
            cell.totalCostLabel.text = productModel.totalPrice
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
    

    
}
