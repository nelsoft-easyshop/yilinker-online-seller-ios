//
//  TransactionDeliveryLogTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionDeliveryLogTableViewController: UITableViewController {
    
    var deliveryLogCellIdentifier: String = "TransactionDeliveryLogTableViewCell"
    var signatureCellIdentifier: String = "TransactionDeliveryLogSignatureTableViewCell"
    
    var orderProductId: String = ""
    
    var hud: MBProgressHUD?
    var tableHeaderView: UIView!
    var tidLabel: UILabel!
    
    var deliveryLogs: DeliveryLogsModel!
    var tableData: [DeliveryLogsSectionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deliveryLogs = DeliveryLogsModel(isSuccessful: false, message: "", orderProductId: "", productName: "", deliveryLogs: [])
        
        initializeNavigationBar()
        registerNibs()
        initializeTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNibs() {
        var deliveryNib = UINib(nibName: deliveryLogCellIdentifier, bundle: nil)
        self.tableView.registerNib(deliveryNib, forCellReuseIdentifier: deliveryLogCellIdentifier)
        
        var signatureNib = UINib(nibName: signatureCellIdentifier, bundle: nil)
        self.tableView.registerNib(signatureNib, forCellReuseIdentifier: signatureCellIdentifier)
    }
    
    
    func initializeTableView() {
        tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 35))
        tableHeaderView.backgroundColor = UIColor.whiteColor()
        
        tidLabel = UILabel(frame: CGRectMake(16, 20, (self.view.bounds.width - 32), 20))
        tidLabel.textColor = Constants.Colors.grayText
        tidLabel.font = UIFont(name: "Panton-Bold", size: CGFloat(14))
        tidLabel.text = ""
        tableHeaderView.addSubview(tidLabel)
        
        self.tableView.tableHeaderView = tableHeaderView
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func initializeNavigationBar() {
        self.title = "Delivery Log"
        
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
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].deliveryLogs.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model: DeliveryLogsItemModel = tableData[indexPath.section].deliveryLogs[indexPath.row]
        
        if model.clientSignature.isEmpty{
            let cell: TransactionDeliveryLogSignatureTableViewCell = tableView.dequeueReusableCellWithIdentifier(signatureCellIdentifier, forIndexPath: indexPath) as! TransactionDeliveryLogSignatureTableViewCell
            return cell
        } else {
            let cell: TransactionDeliveryLogTableViewCell = tableView.dequeueReusableCellWithIdentifier(deliveryLogCellIdentifier, forIndexPath: indexPath) as! TransactionDeliveryLogTableViewCell
            return cell
        }
    }
    
    // MARK: - Methods
    
    func setSectionHeader(date: String) -> UIView {
        var sectionHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.tableView.sectionHeaderHeight))
        sectionHeaderView.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
        var middleLine: UIView = UIView(frame: CGRectMake(0, 0, sectionHeaderView.frame.size.width, 0.5))
        middleLine.backgroundColor = .grayColor()
        middleLine.center.y = sectionHeaderView.center.y + (15 / 2)
        sectionHeaderView.addSubview(middleLine)
        
        var dateLabel: UILabel = UILabel(frame: CGRectMake(0, 0, sectionHeaderView.frame.size.width, 20))
        dateLabel.textAlignment = .Center
        dateLabel.font = UIFont.systemFontOfSize(12.0)
        dateLabel.textColor = .grayColor()
        dateLabel.text = "  " + date + "  "
        dateLabel.sizeToFit()
        dateLabel.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
        dateLabel.frame.size.width = dateLabel.frame.size.width + 10
        dateLabel.center.x = sectionHeaderView.center.x
        dateLabel.center.y = sectionHeaderView.center.y + (15 / 2)
        
        sectionHeaderView.addSubview(dateLabel)
        
        return sectionHeaderView
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func initializeActivityLogsItem() {
        tableData.removeAll(keepCapacity: false)
        var tempDates: [String] = []
        
        for subValue in deliveryLogs.deliveryLogs {
            if !contains(tempDates, formatDateToCompleteString(formatStringToDate(subValue.date))) {
                tempDates.append(formatDateToCompleteString(formatStringToDate(subValue.date)))
                tableData.append(DeliveryLogsSectionModel(date: formatDateToCompleteString(formatStringToDate(subValue.date)), deliveryLogs: []))
            }
        }
        
        println(tempDates)
        
        for var i = 0; i < tableData.count; i++ {
            for subValue in deliveryLogs.deliveryLogs {
                if formatDateToCompleteString(formatStringToDate(subValue.date)) == tableData[i].date {
                    tableData[i].deliveryLogs.append(DeliveryLogsItemModel(actionType: subValue.actionType, date: formatDateToCompleteString(formatStringToDate(subValue.date)), location: subValue.location, riderName: subValue.riderName, clientSignature: subValue.clientSignature))
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    func fireGetDeliveryLogs() {
        
        showHUD()
        let manager = APIManager.sharedInstance
        
        var parameters: NSDictionary = NSDictionary(dictionary: ["access_token": SessionManager.accessToken(), "orderProductId": orderProductId])
        
        manager.GET(APIAtlas.getActivityLogs, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            let model: DeliveryLogsModel = DeliveryLogsModel.parseDataWithDictionary(responseObject as! NSDictionary)
            
            if model.isSuccessful {
                
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: model.message, title: "Error")
            }
            
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                } else {
                    if Reachability.isConnectedToNetwork() {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong!", title: "Error")
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Check your internet connection!", title: "Error")
                    }
                    println(error)
                }
        })
        
        
    }
    
    func fireRefreshToken() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.fireGetDeliveryLogs()
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }
    
    
    func formatStringToDate(date: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        
        return dateFormatter.dateFromString(date)!
    }
    
    func formatDateToString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        return dateFormatter.stringFromDate(date)
    }
    
    func formatDateToTimeString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "KK:mm aa"
        return dateFormatter.stringFromDate(date)
    }
    
    func formatDateToCompleteString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.stringFromDate(date)
    }
}
