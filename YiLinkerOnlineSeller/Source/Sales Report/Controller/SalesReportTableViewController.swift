//
//  SalesReportTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class SalesReportTableViewController: UITableViewController, SalesReportTableViewCellDelegate, DatePickerViewControllerDelegate {
    
    let cellIdentifier: String = "SalesReportTableViewCell"
    var datePickerController: DatePickerViewController?
    
    var tempEndDate: NSDate = NSDate().addDays(1)
    var tempStartDate: NSDate = NSDate()
    
    
    var hud: MBProgressHUD?
    
    var salesReportModel: SalesReportModel = SalesReportModel(isSuccessful: false, message: "", productCount: 0, totalTransactionCount: 0, totalSales: "", confirmedTransactionPerDay: [], cancelledTransactionPerDay: [])
    
    var isFromDatePicker: Bool = false
    
    var errorLocalizeString: String  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        registerNibs()
        fireGetSalesReport()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeViews() {
        datePickerController = DatePickerViewController(nibName: "DatePickerViewController", bundle: nil)
        datePickerController!.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
    }
    
    func registerNibs() {
        var nibHeader = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.registerNib(nibHeader, forCellReuseIdentifier: cellIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SalesReportTableViewCell
        cell.delegate = self
        cell.dateLabel.text = formatDate(tempStartDate) + "-" + formatDate(tempEndDate)
        cell.passModel(salesReportModel, startDate: tempStartDate, endDate: tempEndDate.addDays(1))
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if IphoneType.isIphone4() {
            return UIScreen.mainScreen().bounds.size.height * 0.68
        } else {
            return UIScreen.mainScreen().bounds.size.height * 0.72
        }
    }
    
    // MARK: - SalesReportTableViewCellDelegate
    
    func changeDate() {
        datePickerController?.startDate = tempStartDate
        datePickerController?.endDate = tempEndDate
        self.navigationController?.pushViewController(datePickerController!, animated:true)
    }
    
    // MARK: - DatePickerViewControllerDelegate
    func datePickerClose(startDate: NSDate, endDate: NSDate) {
        tempEndDate = endDate
        tempStartDate = startDate
        isFromDatePicker = true
        fireGetSalesReport()
    }
    
    func formatDate(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.stringFromDate(date)
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
    
    func getStartAndEndDate() {
        
        if !isFromDatePicker {
            if salesReportModel.confirmedTransactionPerDay.count != 0 {
                tempStartDate = formatStringToDate(salesReportModel.confirmedTransactionPerDay[0].date)
                tempEndDate = formatStringToDate(salesReportModel.confirmedTransactionPerDay[salesReportModel.confirmedTransactionPerDay.count - 1].date)
            }
            
            if  salesReportModel.cancelledTransactionPerDay.count != 0 {
                var tempDateStart = formatStringToDate(salesReportModel.cancelledTransactionPerDay[0].date)
                var tempDateEnd = formatStringToDate(salesReportModel.cancelledTransactionPerDay[salesReportModel.cancelledTransactionPerDay.count - 1].date)
                
                if tempStartDate.isGreaterThanDate(tempDateStart) {
                    tempStartDate = tempDateStart
                }
                
                if tempEndDate.isLessThanDate(tempDateEnd) {
                    tempEndDate = tempDateEnd
                }
            }
        }
        self.tableView.reloadData()
    }
    
    
    func formatStringToDate(date: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.dateFromString(date)!
    }
    
    func formatDateToString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.stringFromDate(date)
    }
    
    func fireGetSalesReport() {
        showHUD()
        let manager = APIManager.sharedInstance
        var parameters: NSDictionary
        if isFromDatePicker{
            parameters = ["access_token" : SessionManager.accessToken(),
                "dateFrom": formatDate(tempStartDate),
                "dateTo": formatDate(tempEndDate)];
        } else {
            parameters = ["access_token" : SessionManager.accessToken()];
        }
        
        manager.POST(APIAtlas.getSalesReport, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            println("RESPONSE \(responseObject)")
            self.salesReportModel = SalesReportModel.parseDataWithDictionary(responseObject as! NSDictionary)
            
            if self.salesReportModel.isSuccessful {
                self.getStartAndEndDate()
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.salesReportModel.message, title: self.errorLocalizeString)
            }
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken("totalPoints")
                } else {
                    if Reachability.isConnectedToNetwork() {
                        UIAlertController.displaySomethingWentWrongError(self)
                    } else {
                        UIAlertController.displayNoInternetConnectionError(self)
                    }
                    println(error)
                }
        })
    }
    
    func fireRefreshToken(type: String) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.fireGetSalesReport()
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }
}