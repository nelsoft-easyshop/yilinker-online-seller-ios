//
//  ActivityLogTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ActivityLogTableViewController: UITableViewController {
    
    var tableData:[ActivityLogModel] = []
    
    var activities: ActivityLogItemsModel = ActivityLogItemsModel(isSuccessful: false, message: "", activities: [])
    
    var hud: MBProgressHUD?
    var isPageEnd: Bool = false
    var page: Int = 1
    var perPage: Int = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViews()
        self.initializeNavigationBar()
        self.registerNibs()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.page = 0
        self.fireGetActivityLogs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initializeViews() {
        //Add Nav Bar
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 75.0
    }
    
    func initializeNavigationBar() {
        self.title = StringHelper.localizedStringWithKey("ACTIVITY_LOGS_TITLE_LOCALIZE_KEY")
        
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

    
    func registerNibs() {
        var nib = UINib(nibName: "ActivityLogTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ActivityLogTableViewCell")
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData[section].activities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityLogTableViewCell", forIndexPath: indexPath) as! ActivityLogTableViewCell

        cell.setDetailsText(tableData[indexPath.section].activities[indexPath.row].details)
        cell.setTimeText(tableData[indexPath.section].activities[indexPath.row].time)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.setSectionHeader(tableData[section].date)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func scrollViewDidEndDragging(aScrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset: CGPoint = aScrollView.contentOffset
        var bounds: CGRect = aScrollView.bounds
        var size: CGSize = aScrollView.contentSize
        var inset: UIEdgeInsets = aScrollView.contentInset
        var y: CGFloat = offset.y + bounds.size.height - inset.bottom
        var h: CGFloat = size.height
        var reload_distance: CGFloat = 10
        var temp: CGFloat = h + reload_distance
        if y > temp {
            self.fireGetActivityLogs()
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
    
    //Function to sort activity logs items
    func initializeActivityLogsItem() {
        self.tableData.removeAll(keepCapacity: false)
        var tempDates: [String] = []
    
        for subValue in self.activities.activities {
            if !contains(tempDates, self.formatDateToCompleteString(formatStringToDate(subValue.date))) {
                tempDates.append(self.formatDateToCompleteString(formatStringToDate(subValue.date)))
                self.tableData.append(ActivityLogModel(date: self.formatDateToCompleteString(self.formatStringToDate(subValue.date)), activities: []))
            }
        }
        
        for var i = 0; i < self.tableData.count; i++ {
            for subValue in self.activities.activities {
                if self.formatDateToCompleteString(self.formatStringToDate(subValue.date)) == self.tableData[i].date {
                    self.tableData[i].activities.append(ActivityModel(time: self.formatDateToTimeString(self.formatStringToDate(subValue.date)), details: subValue.text))
                }
            }
        }

        self.tableView.reloadData()
    }
    
    //MARK: - API Requests
    //MARK: - Get Activity logs items
    func fireGetActivityLogs() {
        if !self.isPageEnd {
            self.showHUD()
            self.page++
            
            let url = APIAtlas.getActivityLogs
            
            WebServiceManager.fireGetActivityLogsRequestWithUrl(url, access_token: SessionManager.accessToken(), page: "\(self.page)", perPage: "\(self.perPage)",  actionHandler:  { (successful, responseObject, requestErrorType) -> Void in
                
                self.hud?.hide(true)
                if successful {
                    let activityLogs: ActivityLogItemsModel = ActivityLogItemsModel.parseDataWithDictionary(responseObject as! NSDictionary)
                    
                    if activityLogs.activities.count < 15 {
                        self.isPageEnd = true
                    }
                    
                    if activityLogs.isSuccessful {
                        self.activities.activities += activityLogs.activities
                        self.initializeActivityLogsItem()
                    } else {
                        self.isPageEnd = true
                    }
                } else {
                    if requestErrorType == .ResponseError {
                        //Error in api requirements
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                    } else if requestErrorType == .AccessTokenExpired {
                        self.fireRefreshToken()
                    } else if requestErrorType == .PageNotFound {
                        //Page not found
                        Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                    } else if requestErrorType == .NoInternetConnection {
                        //No internet connection
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    } else if requestErrorType == .RequestTimeOut {
                        //Request timeout
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    } else if requestErrorType == .UnRecognizeError {
                        //Unhandled error
                        Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                    }

                }
            })
            
        } else {
            self.hud?.hide(true)
            let titleString = StringHelper.localizedStringWithKey("ACTIVITY_LOGS_TITLE_LOCALIZE_KEY")
            let noMoreDataString = StringHelper.localizedStringWithKey("NO_MORE_DATA_LOCALIZE_KEY")
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: noMoreDataString, title: titleString)
        }
    }
    
    //MARK: - Fire Refresh Token
    /* Function called when access_token is already expired.
    * (Parameter) params: TemporaryParameters -- collection of all params
    * needed by all API request in the Wishlist.
    *
    * This function is for requesting of access token and parse it to save in SessionManager.
    * If request is successful, it will check the requestType and redirect/call the API request
    * function based on the requestType.
    * If the request us unsuccessful, it will forcely logout the user
    */
    func fireRefreshToken() {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireGetActivityLogs()
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                })
            }
        })
    }
    
    
    
    //MARK: - Date Helper Functions
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
