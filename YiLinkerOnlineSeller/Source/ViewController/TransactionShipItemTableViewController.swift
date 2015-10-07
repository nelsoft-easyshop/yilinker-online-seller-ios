//
//  TransactionShipItemTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol TransactionShipItemTableViewControllerDelegate {
    func cancelTransactionShipItem()
    func readyForPickupItemTransaction()
}

class TransactionShipItemTableViewController: UITableViewController, TransactionShipItemTableViewCellDelegate {
    
    var delegate: TransactionShipItemTableViewControllerDelegate?
    
    var cellIdentifier: String = "TransactionShipItemTableViewCell"
    
    var hud: MBProgressHUD?
    var invoiceNumber: String = ""
    var selectedDate: String = ""
    var remarks: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
        
        initializeNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initializeNavigationBar() {
        self.title = StringHelper.localizedStringWithKey("TRANSACTION_SHIP_ITEM_LOCALIZE_KEY")
        
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TransactionShipItemTableViewCell
        cell.delegate = self

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 621.0
    }

    // MARK: TransactionShipItemTableViewCellDelegate
    func cancelTransactionShipItem() {
        delegate?.cancelTransactionShipItem()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func readyForPickupItem(date: String, remarks: String){
        selectedDate = date
        self.remarks = remarks
        firePostCancellation()
    }
    
    
    func firePostCancellation(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(),
            "transactionId": invoiceNumber,
            "pickupSchedule": selectedDate,
            "pickupRemark": remarks];
        
        manager.POST(APIAtlas.shipItem, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject)
            var response: NSDictionary = responseObject as! NSDictionary
            if response["isSuccessful"] as! Bool {
                self.navigationController?.popViewControllerAnimated(true)
                self.delegate?.readyForPickupItemTransaction()
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: response["message"] as! String, title: StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY"))
            }
            
            
            self.hud?.hide(true)
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                if Reachability.isConnectedToNetwork() {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken()
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                        
                    }
                } else {
                    UIAlertController.displayNoInternetConnectionError(self)
                }
                
                
                println(error)
        })
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
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.firePostCancellation()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
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

}
