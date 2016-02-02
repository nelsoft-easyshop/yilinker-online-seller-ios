//
//  PayoutEarningsTypeViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

struct PayoutEarningsType {
    static let kNumberOfSection: Int = 1
    static let kRowHeightTransaction: CGFloat = 93
    static let kRowHeight: CGFloat = 64
    
}

class PayoutEarningsTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Tableview
    @IBOutlet weak var tableView: UITableView!
    
    // Models
    var earningsTypeModel: [PayoutEarningsTypeModel] = []
    
    // Global variables
    var hud: MBProgressHUD?
    
    //Boolean - used ad indicator for pagination
    var isPageEnd: Bool = false
    //Integer - used to store number of page 1 to ...
    var page: Int = 0
    var earningTypeId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.backButton()
        self.registerCell()
        //self.fireEarningsList()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.earningsTypeModel.removeAll(keepCapacity: false)
        self.page = 0
        self.isPageEnd = false
        self.fireEarningsList()
        //return true
    }
    
    // MARK: -
    // MARK: Navigation bar - Add Back Button in navigation bar
    
    func backButton() {
        //Add Nav Bar
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    // MARK: -
    // MARK: - Navigation bar back button action
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    // MARK: -
    // MARK: - Register Cell
    
    func registerCell() {
        let earningsTypeNib: UINib = UINib(nibName: PayoutEarningsTypeTableViewCell.earningsTypeNibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(earningsTypeNib, forCellReuseIdentifier: PayoutEarningsTypeTableViewCell.earningsTypeNibNameAndIdentifier())
        
        let earningsTransactionTypeNib: UINib = UINib(nibName: PayoutEarningsTransactionTypeTableViewCell.transactionsNibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(earningsTransactionTypeNib, forCellReuseIdentifier: PayoutEarningsTransactionTypeTableViewCell.transactionsNibNameAndIdentifier())
    }
    
    // MARK: -
    // MARK: - Show Alert view
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    // MARK: -
    // MARK: - Show loader
    
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
    
    // MARK: -
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return PayoutEarningsType.kNumberOfSection
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
    
        if self.earningsTypeModel.count != 0 {
            return self.earningsTypeModel.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.earningTypeId == 1 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(PayoutEarningsTransactionTypeTableViewCell.transactionsNibNameAndIdentifier(), forIndexPath: indexPath) as! PayoutEarningsTransactionTypeTableViewCell
            if self.earningsTypeModel.count != 0 {
                if self.earningsTypeModel[indexPath.row].status == "completed" {
                    cell.statusLabel.text = PayoutEarningsTransactionTypeStrings.kCompleted
                    cell.statusView.backgroundColor = Constants.Colors.completedColor
                } else {
                    cell.statusLabel.text = PayoutEarningsTransactionTypeStrings.kTentative
                    cell.statusView.backgroundColor = Constants.Colors.tentativeColor
                }
            }
            
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(PayoutEarningsTypeTableViewCell.earningsTypeNibNameAndIdentifier(), forIndexPath: indexPath) as! PayoutEarningsTypeTableViewCell
            if self.earningsTypeModel.count != 0 {
                if self.earningsTypeModel[indexPath.row].status == "completed" {
                    cell.statusLabel.text = PayoutEarningsTypeStrings.kCompleted
                    cell.statusView.backgroundColor = Constants.Colors.completedColor
                } else {
                    cell.statusLabel.text = PayoutEarningsTypeStrings.kTentative
                    cell.statusView.backgroundColor = Constants.Colors.tentativeColor
                }
            }
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.earningTypeId == 1 {
            return PayoutEarningsType.kRowHeightTransaction
        } else {
            return PayoutEarningsType.kRowHeight
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
    }
    
    func scrollViewDidEndDragging(aScrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset: CGPoint = aScrollView.contentOffset
        var bounds: CGRect = aScrollView.bounds
        var size: CGSize = aScrollView.contentSize
        var inset: UIEdgeInsets = aScrollView.contentInset
        var y: CGFloat = offset.y + bounds.size.height - inset.bottom
        var h: CGFloat = size.height
        var reload_distance: CGFloat = 10
        var temp: CGFloat = h + reload_distance
        if y > temp {
            self.fireEarningsList()
        }
    }
    
    // MARK: -
    // MARK: - Rest API Request
    // MARK: GET METHOD - Fire Earning List
    /*
    *
    * (Parameters) - access_token, page, perPage, earningTypeId
    *
    * Function to get earnings list based on
    *
    */
    
    func fireEarningsList() {
        if !self.isPageEnd {
            self.page++
            
            self.showHUD()
            var parameters: NSDictionary = [:]
            WebServiceManager.fireGetPayoutRequestEarningsRequestWithUrl(APIAtlas.payoutEarningsList+"\(SessionManager.accessToken())&page=\(self.page)&perPage=15&earningTypeId\(self.earningTypeId)", parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                if successful {
                    if self.earningTypeId == 1 {
                        var earnings = PayoutEarningsTypeModel.parseDataWithDictionary(responseObject)
                        if earnings.count != 0 {
                            
                            if earnings.count < 15 {
                                self.isPageEnd = true
                            }
                            
                            if successful {
                                for i in 0..<earnings.count {
                                    self.earningsTypeModel.append(PayoutEarningsTypeModel(date: earnings[i].date, earningTypeId: earnings[i].earningTypeId, amount: earnings[i].amount, currencyCode: earnings[i].currencyCode, status: earnings[i].status))
                                }
                            } else {
                                self.isPageEnd = true
                            }
                            
                            self.tableView.hidden = false
                        }
                    } else {
                        var earnings = PayoutEarningsTypeModel.parseTransactionDataWithDictionary(responseObject)
                        if earnings.count != 0 {
                            
                            if earnings.count < 15 {
                                self.isPageEnd = true
                            }
                            
                            if successful {
                                for i in 0..<earnings.count {
                                    self.earningsTypeModel.append(PayoutEarningsTypeModel(date: earnings[i].date, earningTypeId: earnings[i].earningTypeId, amount: earnings[i].amount, currencyCode: earnings[i].currencyCode, status: earnings[i].status, boughtBy: earnings[i].boughtBy, productName: earnings[i].productName, transactionNo: earnings[i].transactionNo))
                                }
                            } else {
                                self.isPageEnd = true
                            }
                            
                            self.tableView.hidden = false
                        }
                    }
                    
                    self.tableView.reloadData()
                    self.hud?.hide(true)
                } else {
                    if requestErrorType == .ResponseError {
                        //Error in api requirements
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        self.showAlert(Constants.Localized.error, message: errorModel.message)
                    } else if requestErrorType == .AccessTokenExpired {
                        self.fireRefreshToken()
                    } else if requestErrorType == .PageNotFound {
                        //Page not found
                        Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.tabBarController!.view)
                    } else if requestErrorType == .NoInternetConnection {
                        //No internet connection
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.tabBarController!.view)
                    } else if requestErrorType == .RequestTimeOut {
                        //Request timeout
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.tabBarController!.view)
                    } else if requestErrorType == .UnRecognizeError {
                        //Unhandled error
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                    }
                    self.tableView.hidden = true
                    self.hud?.hide(true)
                }
            })
        }
    }
    
    // MARK: -
    // MARK: POST METHOD - Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    * Function to refresh token to get another access token
    *
    */
    
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
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            
            self.fireEarningsList()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else {
                    self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                }
                self.hud?.hide(true)
        })
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
