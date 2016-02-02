//
//  PayoutEarningsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutEarningsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Tableview
    @IBOutlet weak var tableView: UITableView!
    
    // Strings
    var cellNibName: String = "PayoutEarningsTableViewCell"
    var cellIdentifier: String = "PayoutEarningsTableViewCell"
    
    // Models
    var earningsModel: PayoutEarningsModel?
    
    // Global variables
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = "Earnings"
        self.backButton()
        self.registerCell()
        self.fireEarningGroupList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation bar
    // MARK: - Add Back Button in navigation bar
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
    
    //MARK: - Navigation bar back button action
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    // MARK: - Regiter nib files
    func registerCell() {
        let nib: UINib = UINib(nibName: self.cellNibName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    // MARK: Alert view
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    // Show loader
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.earningsModel != nil {
            return 6
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! PayoutEarningsTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if self.earningsModel != nil {
            switch indexPath.row {
            case 0:
                cell.earningTypeImageView.image = UIImage(named: "earning-transation")
                cell.earningTypeLabel.text = "Transaction"
                cell.earningTypeAmountLabel.text = self.earningsModel!.earningAmount[0].formatToPeso()
                break
            case 1:
                cell.earningTypeImageView.image = UIImage(named: "earning-comment")
                cell.earningTypeLabel.text = "Comments"
                cell.earningTypeAmountLabel.text = self.earningsModel!.earningAmount[3].formatToPeso()
                break
            case 2:
                cell.earningTypeImageView.image = UIImage(named: "earning-follower")
                cell.earningTypeLabel.text = "Followers"
                cell.earningTypeAmountLabel.text = self.earningsModel!.earningAmount[2].formatToPeso()
                break
            case 3:
                cell.earningTypeImageView.image = UIImage(named: "earning-buyer")
                cell.earningTypeLabel.text = "Buyer Network"
                var totalAmount: String = "\(self.earningsModel!.earningAmount[1].floatValue + self.earningsModel!.earningAmount[4].floatValue + self.earningsModel!.earningAmount[5].floatValue)"
                cell.earningTypeAmountLabel.text = totalAmount.formatToPeso()
                break
            case 4:
                cell.earningTypeImageView.image = UIImage(named: "earning-affiliate")
                cell.earningTypeLabel.text = "Affiliate Network"
                var totalAmount: String = "\(self.earningsModel!.earningAmount[6].floatValue + self.earningsModel!.earningAmount[7].floatValue)"
                cell.earningTypeAmountLabel.text = totalAmount.formatToPeso()
                break
            case 5:
                cell.earningTypeImageView.image = UIImage(named: "earning-withdrawal")
                cell.earningTypeLabel.text = "Withdrawal"
                cell.earningTypeAmountLabel.text = self.earningsModel!.earningAmount[8].formatToPeso()
                break
            default:
                
                break
            }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var payoutEarningsTypeViewController = PayoutEarningsTypeViewController(nibName: "PayoutEarningsTypeViewController", bundle: nil)
        payoutEarningsTypeViewController.earningTypeId = self.earningsModel!.earningTypeId[indexPath.row]
        //self.presentViewController(payoutEarningsTypeViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(payoutEarningsTypeViewController, animated:true)
    }
    
    func fireEarningGroupList() {
        self.showHUD()
        var parameters: NSDictionary = [:]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
