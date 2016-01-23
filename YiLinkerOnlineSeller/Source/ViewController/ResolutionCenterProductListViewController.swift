//
//  ResolutionCenterProductListViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: - Delegate
// ResolutionCenterProductListViewController Delegate methods
protocol ResolutionCenterProductListViewControllereDelegate {
    func resolutionCenterProductListViewController(resolutionCenterProductListViewController: ResolutionCenterProductListViewController, didSelecteProducts products: [TransactionOrderProductModel])
}

class ResolutionCenterProductListViewController: UIViewController {
    
    // Tableview
    @IBOutlet weak var tableView: UITableView!
    
    // Constant Strings
    let cellHeight: CGFloat = 86.0
    let cellIdentifier: String = "ResellerItemTableViewCell"
    let cellNibName: String = "ResellerItemTableViewCell"
    
    // Models
    var transactionDetails: TransactionDetailsModel = TransactionDetailsModel()
    var transactionDetailsFiltered: [TransactionOrderProductModel] = []
    var transactionItemModel: [TransactionItemModel] = []
    
    // Global variables
    var transactionId: String = ""
    
    var hud: MBProgressHUD?
    
    // Initialized ResolutionCenterProductListViewControllereDelegate
    var delegate: ResolutionCenterProductListViewControllereDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Item"
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.registerCell()
        self.backButton()
        self.checkButton()
        self.footerView()
        self.fireGetTransactionItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    // Remove tableview footer
    func footerView() {
        let footerView: UIView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = footerView
    }
    
    // MARK: - Regiter nib files
    func registerCell() {
        let nib: UINib = UINib(nibName: self.cellNibName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    // MARK: - Show alert view
    func showAlert(title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController!.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    // MARK: - Navigation bar
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
    
    func checkButton() {
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 45, 45)
        checkButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer, customCheckButton]
    }

    // Navigation bar button action
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func check() {
        var products: [TransactionOrderProductModel] = []
        
        for i in 0..<self.transactionDetails.transactionItems[0].products.count {
            if self.transactionDetails.transactionItems[0].products[i].transactionOrderItemStatus == TransactionOrderItemStatus.Selected {
                products.append(self.transactionDetails.transactionItems[0].products[i])
            }
        }
        
        self.delegate!.resolutionCenterProductListViewController(self, didSelecteProducts: products)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Tableview delegate and data source mehtods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.transactionDetailsFiltered.count != 0 {
            return self.transactionDetailsFiltered.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let transactionProductModel: TransactionOrderProductModel =  self.transactionDetails.transactionItems[0].products[indexPath.row]
        let cell: ResellerItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as! ResellerItemTableViewCell
       
        cell.cellTitleLabel.text = self.transactionDetailsFiltered[indexPath.row].productName
        cell.cellSellerLabel.text = self.transactionItemModel[indexPath.row].sellerStore
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.cellImageView.sd_setImageWithURL(NSURL(string: self.transactionDetailsFiltered[indexPath.row].productImage), placeholderImage: UIImage(named: "dummy-placeholder"))
        
        if self.transactionDetailsFiltered[indexPath.row].transactionOrderItemStatus == TransactionOrderItemStatus.Selected {
            cell.checkImage()
        } else {
            cell.addImage()
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if self.transactionDetailsFiltered[indexPath.row].transactionOrderItemStatus == TransactionOrderItemStatus.Selected {
            self.transactionDetailsFiltered[indexPath.row].transactionOrderItemStatus = TransactionOrderItemStatus.UnSelected
        } else {
            self.transactionDetailsFiltered[indexPath.row].transactionOrderItemStatus = TransactionOrderItemStatus.Selected
        }
        self.tableView.reloadData()
    }
    
    // MARK: -
    // MARK: - REST API request
    // MARK: POST METHOD - Get transaction items
    /*
    *
    * (Parameters) - access_token, transactionId
    *
    * Function to get resolution center transaction items
    *
    */
    func fireGetTransactionItems() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        
        var productIds: [Int] = []
        
        let parameters: NSDictionary = [
            "access_token": SessionManager.accessToken(),
            "transactionId": self.transactionId]
        
        manager.GET(APIAtlas.resolutionCenterGetTransactionItems, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            
            self.transactionDetails = TransactionDetailsModel.parseDataWithDictionary(responseObject as! NSDictionary)
            
            for i in 0..<self.transactionDetails.transactionItems[0].products.count {
                if self.transactionDetails.transactionItems[0].products[i].orderProductStatusId == 4 {
                    self.transactionDetailsFiltered.append(self.transactionDetails.transactionItems[0].products[i])
                    self.transactionItemModel.append(self.transactionDetails.transactionItems[0])
                }
                
            }
            
            self.tableView.reloadData()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                } else {
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        self.showAlert(Constants.Localized.error, message: errorModel.message)
                    } else {
                        self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                    }
                }
                
                self.hud?.hide(true)
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
            
            self.fireGetTransactionItems()
            
            self.hud?.hide(true)
            
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
