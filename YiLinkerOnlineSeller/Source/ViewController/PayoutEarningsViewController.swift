//
//  PayoutEarningsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

struct EarningsTypeStrings {
    static let kTransactions: String = StringHelper.localizedStringWithKey("PAYOUT_EARNINGS_TRANSACTION_LOCALIZE_KEY")
    static let kComments: String = StringHelper.localizedStringWithKey("PAYOUT_EARNINGS_COMMENTS_LOCALIZE_KEY")
    static let kFollowers: String = StringHelper.localizedStringWithKey("PAYOUT_EARNINGS_FOLLOWERS_LOCALIZE_KEY")
    static let kBuyerNetwork: String = StringHelper.localizedStringWithKey("PAYOUT_EARNINGS_BUYER_LOCALIZE_KEY")
    static let kAffiliateNetwork: String = StringHelper.localizedStringWithKey("PAYOUT_EARNINGS_AFFILIATE_LOCALIZE_KEY")
    static let kWithdrawal: String = StringHelper.localizedStringWithKey("PAYOUT_EARNINGS_WITHDRAWAL_LOCALIZE_KEY")
}

struct EarningsType {
    static let kNumberOfSection: Int = 1
    static let kNumberOfRowsInSection: Int = 6
    static let kRowHeight: CGFloat = 53
}

class PayoutEarningsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Tableview
    @IBOutlet weak var tableView: UITableView!
    
    // Models
    var earningsModel: [PayoutEarningsModel] = []
    
    // Global variables
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.backButton()
        self.registerCell()
        self.fireEarningGroupList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    // MARK: - Register PayoutEarningsTableViewCell
    
    func registerCell() {
        let nib: UINib = UINib(nibName: PayoutEarningsTableViewCell.nibNameAndidentifier(), bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: PayoutEarningsTableViewCell.nibNameAndidentifier())
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
        return EarningsType.kNumberOfSection
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.earningsModel.count != 0 {
            return EarningsType.kNumberOfRowsInSection
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: PayoutEarningsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PayoutEarningsTableViewCell.nibNameAndidentifier(), forIndexPath: indexPath) as! PayoutEarningsTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if self.earningsModel.count != 0 {
            switch indexPath.row {
            case 0:
                cell.earningTypeImageView.image = UIImage(named: "earning-transation")
                cell.earningTypeLabel.text = EarningsTypeStrings.kTransactions
                cell.earningTypeAmountLabel.text = self.earningsModel[0].earningAmount.formatToPeso()
                break
            case 1:
                cell.earningTypeImageView.image = UIImage(named: "earning-comment")
                cell.earningTypeLabel.text = EarningsTypeStrings.kComments
                cell.earningTypeAmountLabel.text = self.earningsModel[3].earningAmount.formatToPeso()
                break
            case 2:
                cell.earningTypeImageView.image = UIImage(named: "earning-follower")
                cell.earningTypeLabel.text = EarningsTypeStrings.kFollowers
                cell.earningTypeAmountLabel.text = self.earningsModel[2].earningAmount.formatToPeso()
                break
            case 3:
                cell.earningTypeImageView.image = UIImage(named: "earning-buyer")
                cell.earningTypeLabel.text = EarningsTypeStrings.kBuyerNetwork
                var totalAmount: String = "\(self.earningsModel[1].earningAmount.floatValue + self.earningsModel[4].earningAmount.floatValue + self.earningsModel[5].earningAmount.floatValue)"
                cell.earningTypeAmountLabel.text = totalAmount.formatToTwoDecimal().formatToPeso()
                break
            case 4:
                cell.earningTypeImageView.image = UIImage(named: "earning-affiliate")
                cell.earningTypeLabel.text = EarningsTypeStrings.kAffiliateNetwork
                var totalAmount: String = "\(self.earningsModel[6].earningAmount.floatValue + self.earningsModel[7].earningAmount.floatValue)"
                cell.earningTypeAmountLabel.text = totalAmount.formatToTwoDecimal().formatToPeso()
                break
            case 5:
                cell.earningTypeImageView.image = UIImage(named: "earning-withdrawal")
                cell.earningTypeLabel.text = EarningsTypeStrings.kWithdrawal
                cell.earningTypeAmountLabel.text = self.earningsModel[8].earningAmount.formatToPeso()
                break
            default:
                
                break
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return EarningsType.kRowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var payoutEarningsTypeViewController: PayoutEarningsTypeViewController = PayoutEarningsTypeViewController(nibName: "PayoutEarningsTypeViewController", bundle: nil)
        payoutEarningsTypeViewController.earningTypeId = self.earningsModel[indexPath.row].earningTypeId
        self.navigationController?.pushViewController(payoutEarningsTypeViewController, animated:true)
    }
    
    // MARK: -
    // MARK: -  Rest API Request
    // MARK: GET METHOD - Fire Earning Group List
    /*
    *
    * (Parameters) - access_token
    *
    * Function to get the list of earnings group eg. Transactions, Comments, Followers etc.
    *
    */
    
    func fireEarningGroupList() {
        self.showHUD()
        let parameters: NSDictionary = [:]
        WebServiceManager.fireGetPayoutRequestEarningsRequestWithUrl(APIAtlas.payoutEarningsGroup+"\(SessionManager.accessToken())", parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.earningsModel = PayoutEarningsModel.parseDataWithDictionary(responseObject)
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
                self.hud?.hide(true)
            }
        })
    }
    
    // MARK: -
    // MARK: POST METHOD - Fire Refresh token
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
            
            self.fireEarningGroupList()
            
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
}
