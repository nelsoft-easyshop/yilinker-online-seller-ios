//
//  PayoutRequestListViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

struct PayoutRequestList {
    static let kNumberOfSections: Int = 1
    static let kRowHeight: CGFloat = 65
}

class PayoutRequestListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Tableview
    @IBOutlet weak var tableView: UITableView!
    
    // Local Strings
    
    // Models
    var requestListModel: [PayoutRequestListModel] = []
    
    // Global Variables
    var hud: MBProgressHUD?
    
    //Boolean - used ad indicator for pagination
    var isPageEnd: Bool = false
    //Integer - used to store number of page 1 to ...
    var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Withdrawal Request List"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.backButton()
        self.footerView()
        self.registerCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.requestListModel.removeAll(keepCapacity: false)
        self.page = 0
        self.isPageEnd = false
        self.fireRequestList()
        //return true
    }
    
    // MARK: -
    // MARK: Navigation bar - Add Back Button in navigation bar
    
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
    
    // MARK: -
    // MARK: - Navigation bar back button action
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    // MARK: -
    // MARK: - Private methods
    // Remove tableview footer
    func footerView() {
        let footerView: UIView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = footerView
    }
    
    // MARK: -
    // MARK: - Register Cell
    
    func registerCell() {
        let nib: UINib = UINib(nibName: PayoutRequestListTableViewCell.listNibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: PayoutRequestListTableViewCell.listNibNameAndIdentifier())
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
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return PayoutRequestList.kNumberOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.requestListModel.count != 0 {
            return self.requestListModel.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(PayoutRequestListTableViewCell.listNibNameAndIdentifier(), forIndexPath: indexPath) as! PayoutRequestListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if self.requestListModel.count != 0 {
            cell.dateLabel.text = self.requestListModel[indexPath.row].date
            if self.requestListModel[indexPath.row].withdrawalMethod == "bank" {
                cell.requestDetailLabel.text =   "\(PayoutRequestListStrings.kBank) | \(self.requestListModel[indexPath.row].totalAmount.formatToTwoDecimal().formatToPeso())"
            } else {
                cell.requestDetailLabel.text =   "\(PayoutRequestListStrings.kCheque) | \(self.requestListModel[indexPath.row].totalAmount.formatToTwoDecimal().formatToPeso())"
            }
            
            if self.requestListModel[indexPath.row].charge != "0.0000" {
                cell.bankChargeLabel.text = "\(PayoutRequestListStrings.kBankCharge): \(self.requestListModel[indexPath.row].charge.formatToTwoDecimal().formatToPeso())"
            } else {
                cell.bankChargeLabel.hidden = true
            }
            
            if self.requestListModel[indexPath.row].status == "completed" {
                cell.statusView.backgroundColor = Constants.Colors.completedColor
                cell.statusLabel.text = PayoutRequestListStrings.kCompleted
            } else if self.requestListModel[indexPath.row].status == "Pending" {
                cell.statusView.backgroundColor = Constants.Colors.tentativeColor
                cell.statusLabel.text = PayoutRequestListStrings.kTentative
            } else {
                cell.statusView.backgroundColor = Constants.Colors.inProgressColor
                cell.statusLabel.text = PayoutRequestListStrings.kInProgress
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PayoutRequestList.kRowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var payoutRequestListDetailViewController: PayoutRequestListDetailViewController = PayoutRequestListDetailViewController(nibName: "PayoutRequestListDetailViewController", bundle: nil)
        payoutRequestListDetailViewController.payoutRequestModel = self.requestListModel[indexPath.row]
        self.navigationController?.pushViewController(payoutRequestListDetailViewController, animated: true)
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
            self.fireRequestList()
        }
    }
    
    // MARK: -
    // MARK: -  Rest API Request
    // MARK: GET METHOD - Fire Request List
    /*
    *
    * (Parameters) - access_token, page, perPage
    *
    * Function to get the list of withdrawals
    *
    */
    
    func fireRequestList() {
        if !self.isPageEnd {
            self.page++
            
            self.showHUD()
            var parameters: NSDictionary = [:]
            WebServiceManager.fireGetPayoutRequestEarningsRequestWithUrl(APIAtlas.payoutRequestList+"\(SessionManager.accessToken())&page=\(self.page)&perPage=15", parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                if successful {
                    var earnings: [PayoutRequestListModel] = []
                    earnings = PayoutRequestListModel.parseDataWithDictionary(responseObject)
                    
                    if earnings.count != 0 {
                        if earnings.count < 15 {
                            self.isPageEnd = true
                        }
                        
                        for i in 0..<earnings.count {
                            self.requestListModel.append(PayoutRequestListModel(date: earnings[i].date, withdrawalMethod: earnings[i].withdrawalMethod, totalAmount: earnings[i].totalAmount, charge: earnings[i].charge, netAmount: earnings[i].netAmount, currencyCode: earnings[i].currencyCode, status: earnings[i].status, payTo: earnings[i].payTo, bankName: earnings[i].bankName, accountNumber: earnings[i].accountNumber, accountName: earnings[i].accountName))
                        }
                        
                        self.tableView.hidden = false
                    }
                    
                    self.tableView.reloadData()
                    self.hud?.hide(true)
                } else {
                    if requestErrorType == .ResponseError {
                        //Error in api requirements
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message)
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
            
            self.fireRequestList()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message)
                } else {
                    UIAlertController.displaySomethingWentWrongError(self)
                }
                self.hud?.hide(true)
        })
    }
}
