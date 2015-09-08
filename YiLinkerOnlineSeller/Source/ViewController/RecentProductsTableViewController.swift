//
//  RecentProductsTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class RecentProductsTableViewController: UITableViewController {
    
    let recentOrderCellIdentifier: String = "RecentProductsTableViewCell"
    
    var hud: MBProgressHUD?
    
    var isProductsEnd: Bool = false
    var productPage: Int = 1
    
    var tableData: [TransactionModel] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        registerNibs()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        productPage = 0
        isProductsEnd = false
        tableData = []
        fireGetRecentOrders()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func registerNibs() {
        var nib = UINib(nibName: recentOrderCellIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: recentOrderCellIdentifier)
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
        return tableData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(recentOrderCellIdentifier, forIndexPath: indexPath) as! RecentProductsTableViewCell

        var temp: TransactionModel = tableData[indexPath.row]
        cell.setProductImage("")
        cell.setProductName(temp.order_id)
        cell.setModeOfPayment(temp.payment_type)
        cell.setPrice(temp.total_price)
        cell.setStatus(temp.order_status)

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
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
            fireGetRecentOrders()
        }
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
    
    func fireGetRecentOrders() {
        if !isProductsEnd {
            
            self.showHUD()
            let manager = APIManager.sharedInstance
            productPage++
            
            let url: String = "\(APIAtlas.transactionList)?access_token=\(SessionManager.accessToken())&perPage=15&page=\(productPage)"
            
            manager.GET(url, parameters: nil, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                let transactionModel: TransactionsModel = TransactionsModel.parseDataWithDictionary(responseObject)
                
                println(responseObject)
                
                if transactionModel.transactions.count < 15 {
                    self.isProductsEnd = true
                }
                
                if transactionModel.isSuccessful {
                    self.tableData += transactionModel.transactions
                    self.tableView.reloadData()
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                }
                
                
                self.hud?.hide(true)
                
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                    self.hud?.hide(true)
                    
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken()
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    }
                    
                    println(error)
            })
        } else {
            self.hud?.hide(true)
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
            
            self.fireGetRecentOrders()
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }
}
