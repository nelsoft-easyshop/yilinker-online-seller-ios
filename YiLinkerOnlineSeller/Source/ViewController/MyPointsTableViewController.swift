//
//  MyPointsTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-Seller. All rights reserved.
//

import UIKit

class MyPointsTableViewController: UITableViewController, PointsBreakdownTableViewCellDelegate {
    let cellPointsEarned: String = "PointsEarnedTableViewCell"
    let cellPointsDetails: String = "PointsDetailsTableViewCell"
    let cellPointsBreakDownHeader: String = "PointsBreakdownTableViewCell"
    let cellPoints: String = "PointsTableViewCell"
    
    var hud: MBProgressHUD?
    
    var totalPointsModel: TotalPointsModel = TotalPointsModel(isSuccessful: false, message: "", data: "0")
    var myPointsHistory: MyPointsHistoryModel = MyPointsHistoryModel(isSuccessful: false, message: "", data: [])
    
    var isMyPointsEnd: Bool = false
    var myPointsPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
        titleView()
        backButton()
        registerNibs()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        myPointsPage = 0
        fireGetTotalPoints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeViews() {
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
    
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150.0

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        var headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 1))
        headerView.backgroundColor = UIColor(red: 70/255, green: 35/255, blue: 103/255, alpha: 1)
        
        self.tableView.tableHeaderView = headerView
    }
    
    func titleView() {
        self.title = "My Points"
    }
    
    func backButton() {
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
        var nibEarned = UINib(nibName: cellPointsEarned, bundle: nil)
        self.tableView.registerNib(nibEarned, forCellReuseIdentifier: cellPointsEarned)
        
        var nibDetails = UINib(nibName: cellPointsDetails, bundle: nil)
        self.tableView.registerNib(nibDetails, forCellReuseIdentifier: cellPointsDetails)
        
        var nibHeader = UINib(nibName: cellPointsBreakDownHeader, bundle: nil)
        self.tableView.registerNib(nibHeader, forCellReuseIdentifier: cellPointsBreakDownHeader)
        
        var nibPoints = UINib(nibName: cellPoints, bundle: nil)
        self.tableView.registerNib(nibPoints, forCellReuseIdentifier: cellPoints)
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
        if myPointsHistory.data.count != 0 {
            
            return myPointsHistory.data.count + 3
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellPointsEarned, forIndexPath: indexPath) as! PointsEarnedTableViewCell
            cell.pointsLabel.text = totalPointsModel.data
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellPointsDetails, forIndexPath: indexPath) as! PointsDetailsTableViewCell
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellPointsBreakDownHeader, forIndexPath: indexPath) as! PointsBreakdownTableViewCell
            cell.delegate = self
            
            if myPointsHistory.data.count == 0 {
                cell.breakDownView.hidden = true
            } else {
                cell.breakDownView.hidden = false
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellPoints, forIndexPath: indexPath) as! PointsTableViewCell
            
            println("Index \(indexPath.row)")
            println("Count \(myPointsHistory.data.count)")
            
            let tempModel: MyPointsModel = myPointsHistory.data[indexPath.row - 3]
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.s6"
            let date: NSDate = dateFormatter.dateFromString(tempModel.date)!
            
            let dateFormatter1 = NSDateFormatter()
            dateFormatter1.dateFormat = "MMM dd, yyyy"
            let dateAdded = dateFormatter1.stringFromDate(date)
            
            
            cell.dateLabel.text = dateAdded
            cell.detailsLabel.text = tempModel.userPointTypeName
        
            var points: String = tempModel.points
            
            if Array(tempModel.points)[0] != "-" {
                points = "+\(tempModel.points)"
            }
            
            if points.rangeOfString("+") != nil {
                cell.pointsLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1.0)
                cell.pointsTitleLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1.0)
            } else {
                cell.pointsLabel.textColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1.0)
                cell.pointsTitleLabel.textColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 0.75)
            }
            
            cell.pointsLabel.text = points
            
            return cell
        }
    }
    
    override func scrollViewDidEndDragging(aScrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset: CGPoint = aScrollView.contentOffset
        var bounds: CGRect = aScrollView.bounds
        var size: CGSize = aScrollView.contentSize
        var inset: UIEdgeInsets = aScrollView.contentInset
        var y: CGFloat = offset.y + bounds.size.height - inset.bottom
        var h: CGFloat = size.height
        var reload_distance: CGFloat = 50
        var temp: CGFloat = h + reload_distance
        if y > temp {
            fireGetPointsHistory()
        }
    }
    
    /*
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 65
        } else if indexPath.row == 1 {
            return 175
        } else if indexPath.row == 2 {
            return 40
        }else {
            return 65
        }
    }*/

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
    
    // MARK: - PointsBreakdownTableViewCellDelegate
    // Callback when how to earned points button is clicked
    func howToEarnActionForIndex(sender: AnyObject) {
        
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

    
    func fireGetTotalPoints() {
        showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.GET(APIAtlas.getPointsTotal, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.totalPointsModel = TotalPointsModel.parseDataWithDictionary(responseObject as! NSDictionary)
            
            if self.totalPointsModel.isSuccessful {
                self.fireGetPointsHistory()
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.totalPointsModel.message, title: "Error")
            }
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
    
    func fireGetPointsHistory() {
        if !isMyPointsEnd {
            
            showHUD()
            let manager = APIManager.sharedInstance

            myPointsPage++
            
            let url: String = "\(APIAtlas.getPointsHistory)?access_token=\(SessionManager.accessToken())&perPage=15&page=\(myPointsPage)"
            
            manager.GET(url, parameters: nil, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
    
                //self.myPointsHistory = MyPointsHistoryModel.parseDataWithDictionary(responseObject as! NSDictionary)
                
                let pointHistory: MyPointsHistoryModel = MyPointsHistoryModel.parseDataWithDictionary(responseObject as! NSDictionary)
                println("Count 1 \(self.myPointsHistory.data.count)")
                
                if pointHistory.data.count < 15 {
                    self.isMyPointsEnd = true
                }
                
                if self.totalPointsModel.isSuccessful {
                    self.myPointsHistory.data += pointHistory.data
                    self.tableView.reloadData()
                } else {
                    self.isMyPointsEnd = true
                }
                self.hud?.hide(true)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                    self.hud?.hide(true)
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken("pointsHistory")
                    } else {
                        if Reachability.isConnectedToNetwork() {
                            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong!", title: "Error")
                        } else {
                            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Check your internet connection!", title: "Error")
                        }
                        println(error)
                    }
            })
        } else {
            self.hud?.hide(true)
        }

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
            
            if type == "totalPoints" {
                self.fireGetTotalPoints()
            } else if type == "pointsHistory" {
                self.fireGetPointsHistory()
            }
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }
    
}
