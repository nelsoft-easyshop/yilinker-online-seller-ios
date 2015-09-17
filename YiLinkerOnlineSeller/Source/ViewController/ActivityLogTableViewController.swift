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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        initializeNavigationBar()
        registerNibs()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        page = 0
        fireGetActivityLogs()
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
        self.title = "Activity Log"
        
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

    
    func registerNibs() {
        let nib = UINib(nibName: "ActivityLogTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ActivityLogTableViewCell")
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData[section].activities.count
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityLogTableViewCell", forIndexPath: indexPath) as! ActivityLogTableViewCell

        cell.setDetailsText(tableData[indexPath.section].activities[indexPath.row].details)
        cell.setTimeText(tableData[indexPath.section].activities[indexPath.row].time)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setSectionHeader(tableData[section].date)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func scrollViewDidEndDragging(aScrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset: CGPoint = aScrollView.contentOffset
        let bounds: CGRect = aScrollView.bounds
        let size: CGSize = aScrollView.contentSize
        let inset: UIEdgeInsets = aScrollView.contentInset
        let y: CGFloat = offset.y + bounds.size.height - inset.bottom
        let h: CGFloat = size.height
        let reload_distance: CGFloat = 10
        let temp: CGFloat = h + reload_distance
        if y > temp {
            fireGetActivityLogs()
        }
    }
    
    // MARK: - Methods
    
    func setSectionHeader(date: String) -> UIView {
        let sectionHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.tableView.sectionHeaderHeight))
        sectionHeaderView.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
        let middleLine: UIView = UIView(frame: CGRectMake(0, 0, sectionHeaderView.frame.size.width, 0.5))
        middleLine.backgroundColor = .grayColor()
        middleLine.center.y = sectionHeaderView.center.y + (15 / 2)
        sectionHeaderView.addSubview(middleLine)
        
        let dateLabel: UILabel = UILabel(frame: CGRectMake(0, 0, sectionHeaderView.frame.size.width, 20))
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
    
        for subValue in activities.activities {
            if !tempDates.contains(formatDateToCompleteString(formatStringToDate(subValue.date))) {
                tempDates.append(formatDateToCompleteString(formatStringToDate(subValue.date)))
                tableData.append(ActivityLogModel(date: formatDateToCompleteString(formatStringToDate(subValue.date)), activities: []))
            }
        }
        
        print(tempDates)
        
        for var i = 0; i < tableData.count; i++ {
            for subValue in activities.activities {
                if formatDateToCompleteString(formatStringToDate(subValue.date)) == tableData[i].date {
                    tableData[i].activities.append(ActivityModel(time: formatDateToTimeString(formatStringToDate(subValue.date)), details: subValue.text))
                }
            }
        }

        self.tableView.reloadData()
    }
    
    func fireGetActivityLogs() {
        if !isPageEnd {
            
            showHUD()
            let manager = APIManager.sharedInstance
            
            page++
            
            let url: String = "\(APIAtlas.getActivityLogs)?access_token=\(SessionManager.accessToken())&perPage=15&page=\(page)"
            
            manager.GET(url, parameters: nil, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                
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
                        print(error)
                    }
            })
        } else {
            self.hud?.hide(true)
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "No more data!", title: "Activity Logs")
        }
        
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
            
            self.fireGetActivityLogs()
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
        })
        
    }
    
    
    func formatStringToDate(date: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        
        return dateFormatter.dateFromString(date)!
    }
    
    func formatDateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        return dateFormatter.stringFromDate(date)
    }
    
    func formatDateToTimeString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "KK:mm aa"
        return dateFormatter.stringFromDate(date)
    }
    
    func formatDateToCompleteString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.stringFromDate(date)
    }
    
}
