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
    static let kRowHeight: CGFloat = 76
}

struct PayoutEarningsTypesStrings {
    static let kNoTransaction: String = StringHelper.localizedStringWithKey("PAYOUT_EARNINGS_NO_TRANSACTION_LOCALIZE_KEY")
    static let kNoComments: String = StringHelper.localizedStringWithKey("PAYOUT_EARNINGS_NO_COMMENTS_LOCALIZE_KEY")
    static let kNoFollowers: String = StringHelper.localizedStringWithKey("PAYOUT_EARNINGS_NO_FOLLOWERS_LOCALIZE_KEY")
    static let kNoBuyer: String = StringHelper.localizedStringWithKey("PAYOUT_EARNINGS_NO_BUYER_LOCALIZE_KEY")
    static let kNoAffiliate: String = StringHelper.localizedStringWithKey("PAYOUT_EARNINGS_NO_AFFILIATE_LOCALIZE_KEY")
    static let kNoWithdrawal: String = StringHelper.localizedStringWithKey("PAYOUT_EARNINGS_NO_WITHDRAWAL_LOCALIZE_KEY")
}

class PayoutEarningsTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EmptyViewDelegate {

    // Label
    @IBOutlet weak var noResultLabel: UILabel!
    
    // Tableview
    @IBOutlet weak var tableView: UITableView!
    
    // View Controller
    var emptyView: EmptyView?
    
    // Models
    var earningsTypeModel: [PayoutEarningsTypeModel] = []
    
    // Global variables
    var hud: MBProgressHUD?
    
    //Boolean - used ad indicator for pagination
    var isPageEnd: Bool = false
    //Integer - used to store number of page 1 to ...
    var page: Int = 0
    var earningTypeId: Int = 0
    var earningType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.earningType
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.noResultLabel.hidden = true
        
        switch self.earningTypeId {
        case 1:
            self.noResultLabel.text = PayoutEarningsTypesStrings.kNoTransaction
            break
        case 2:
            self.noResultLabel.text = PayoutEarningsTypesStrings.kNoComments
            break
        case 3:
            self.noResultLabel.text = PayoutEarningsTypesStrings.kNoFollowers
            break
        case 4:
            self.noResultLabel.text = PayoutEarningsTypesStrings.kNoBuyer
            break
        case 5:
            self.noResultLabel.text = PayoutEarningsTypesStrings.kNoAffiliate
            break
        case 6:
            self.noResultLabel.text = PayoutEarningsTypesStrings.kNoWithdrawal
            break
        default:
            break
        }
       
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
        let nibNameAndIdentifierEarningsType: UINib = UINib(nibName: PayoutEarningsTypeTableViewCell.earningsTypeNibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(nibNameAndIdentifierEarningsType, forCellReuseIdentifier: PayoutEarningsTypeTableViewCell.earningsTypeNibNameAndIdentifier())
        
        let nibNameAndIdentifierEarningsTransactionType: UINib = UINib(nibName: PayoutEarningsTransactionTypeTableViewCell.transactionsNibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(nibNameAndIdentifierEarningsTransactionType, forCellReuseIdentifier: PayoutEarningsTransactionTypeTableViewCell.transactionsNibNameAndIdentifier())
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
    // MARK: - Add Empty empty view
    
    func addEmptyView() {
        self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
        self.emptyView?.frame = self.view.frame
        self.emptyView!.delegate = self
        self.view.addSubview(self.emptyView!)
    }
    
    // MARK: -
    // MARK: - Empty View Delegate Method
    
    func didTapReload() {
        if Reachability.isConnectedToNetwork() {
            self.showHUD()
            self.emptyView?.hidden = true
            self.fireEarningsList()
        }
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
                
                cell.statusLabel.text = self.earningsTypeModel[indexPath.row].status.uppercaseString
                
                if self.earningsTypeModel[indexPath.row].statusId == 1 {
                    cell.statusView.backgroundColor = Constants.Colors.completedColor
                } else {
                    cell.statusView.backgroundColor = Constants.Colors.tentativeColor
                }
                
                cell.dateLabel.text = self.earningsTypeModel[indexPath.row].date
                
                var transactionNo = (self.earningsTypeModel[indexPath.row].descriptions as NSString).substringWithRange(NSRange(location: 0, length: 21))
                cell.transactionNoLabel.text = transactionNo
                cell.productNameLabel.text = self.earningsTypeModel[indexPath.row].descriptions.stringByReplacingOccurrencesOfString(transactionNo+"\\n", withString: "").stringByReplacingOccurrencesOfString("\\n", withString: "\r\n")
                cell.amountLabel.text = self.earningsTypeModel[indexPath.row].currencyCode + " " + self.earningsTypeModel[indexPath.row].amount
            }
            
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(PayoutEarningsTypeTableViewCell.earningsTypeNibNameAndIdentifier(), forIndexPath: indexPath) as! PayoutEarningsTypeTableViewCell
            if self.earningsTypeModel.count != 0 {
                
                cell.statusLabel.text = self.earningsTypeModel[indexPath.row].status.uppercaseString
                
                if self.earningTypeId == 2 || self.earningTypeId == 3 || self.earningTypeId == 6 {
                    cell.statusView.backgroundColor = Constants.Colors.completedColor
                } else {
                    if self.earningsTypeModel[indexPath.row].statusId == 1 {
                        cell.statusView.backgroundColor = Constants.Colors.completedColor
                    } else {
                        cell.statusView.backgroundColor = Constants.Colors.tentativeColor
                    }
                }
                cell.dateLabel.text = self.earningsTypeModel[indexPath.row].date
                cell.itemLabel.text = self.earningsTypeModel[indexPath.row].descriptions
                cell.amountLabel.text = self.earningsTypeModel[indexPath.row].currencyCode + " " + self.earningsTypeModel[indexPath.row].amount
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
            
            if Reachability.isConnectedToNetwork() {
                self.page++
            }
            
            self.showHUD()
            var parameters: NSDictionary = [:]
            WebServiceManager.fireGetPayoutRequestEarningsRequestWithUrl(APIAtlas.payoutEarningsList+"\(SessionManager.accessToken())&page=\(self.page)&perPage=15&earningGroupId=\(self.earningTypeId)", parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                if successful {
                    var earnings = PayoutEarningsTypeModel.parseDataWithDictionary(responseObject)
                    if earnings.count != 0 {
                        
                        if earnings.count < 15 {
                            self.isPageEnd = true
                        }
                        
                        for i in 0..<earnings.count {
                            self.earningsTypeModel.append(PayoutEarningsTypeModel(date: earnings[i].date, earningTypeId: earnings[i].earningTypeId, amount: earnings[i].amount, currencyCode: earnings[i].currencyCode, status: earnings[i].status, statusId: earnings[i].statusId, descriptions: earnings[i].descriptions))
                        }
                        
                        self.tableView.hidden = false
                    } else {
                        if self.earningsTypeModel.count == 0 {
                            self.noResultLabel.hidden = false
                            self.tableView.hidden = true
                        } else {
                            self.noResultLabel.hidden = true
                            self.isPageEnd = true
                            self.tableView.hidden = false
                        }
                    }
                    self.tableView.reloadData()
                    self.hud?.hide(true)
                } else {
                    
                    if self.earningsTypeModel.count == 0 {
                        self.addEmptyView()
                    }
                    
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
                    //self.tableView.hidden = true
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message)
                } else {
                    UIAlertController.displaySomethingWentWrongError(self)
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
