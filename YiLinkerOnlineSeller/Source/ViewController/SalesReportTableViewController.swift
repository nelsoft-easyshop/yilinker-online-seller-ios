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
    
    var tempEndDate: NSDate = NSDate()
    var tempStartDate: NSDate = NSDate()
    
    
    var hud: MBProgressHUD?
    
    var salesReportModel: SalesReportModel = SalesReportModel(isSuccessful: false, message: "", productCount: 0, totalTransactionCount: 0, totalSales: "", confirmedTransactionPerDay: [], cancelledTransactionPerDay: [])
    
    var isFromDatePicker: Bool = false
    
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
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        datePickerController = DatePickerViewController(nibName: "DatePickerViewController", bundle: nil)
        datePickerController!.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func registerNibs() {
        var nibHeader = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.registerNib(nibHeader, forCellReuseIdentifier: cellIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SalesReportTableViewCell
        cell.delegate = self
        cell.dateLabel.text = formatDate(tempStartDate) + "-" + formatDate(tempEndDate)
        cell.passModel(salesReportModel, startDate: tempStartDate, endDate: tempEndDate)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 500.0
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
        self.view.addSubview(self.hud!)
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
                    tempEndDate = tempStartDate
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
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.salesReportModel.message, title: "Error")
            }
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken("totalPoints")
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