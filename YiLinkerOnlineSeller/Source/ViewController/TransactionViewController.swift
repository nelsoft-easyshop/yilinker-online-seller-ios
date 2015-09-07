//
//  TransactionViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var pageTitle: [String] = ["TRANSACTIONS", "NEW UPDATE", "ON-GOING", "COMPLETED", "CANCELLED"]
    var selectedImage: [String] = ["transactions2", "newUpdates2", "onGoing2", "completed2", "cancelled3"]
    var deSelectedImage: [String] = ["transaction", "newUpdates", "onGoing", "completed", "cancelled"]
    var selectedItems: [Bool] = []
    
    var selectedIndex: Int = 0
    var tableViewSectionHeight: CGFloat = 0
    var tableViewSectionTitle: String = ""
    
    var tableData: [TransactionModel] = []
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerNibs()
        customizedNavigationBar()
        customizedVies()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fireGetTransaction()
    }

    // MARK: - Methods
    
    func registerNibs() {
        let tab = UINib(nibName: "TransactionCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(tab, forCellWithReuseIdentifier: "TransactionCollectionIdentifier")
        
        let list = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        self.tableView.registerNib(list, forCellReuseIdentifier: "TransactionTableIdentifier")
    }
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Transaction"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "filter"), style: .Plain, target: self, action: "filterAction"), navigationSpacer]
    }
    
    func customizedVies() {
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: - Actions

    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func filterAction() {        
        let filterController = TransactionTableViewController(nibName: "TransactionTableViewController", bundle: nil)
        var navigation = UINavigationController(rootViewController: filterController)
        navigation.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        navigation.navigationBar.barTintColor = Constants.Colors.appTheme
        self.navigationController?.presentViewController(navigation, animated: true, completion: nil)
    }
    
    
}



extension TransactionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    

    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TransactionCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("TransactionCollectionIdentifier", forIndexPath: indexPath) as! TransactionCollectionViewCell
        
        cell.pageLabel.text = pageTitle[indexPath.row].uppercaseString
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = .whiteColor()
            cell.setTextColor(Constants.Colors.appTheme)
            cell.setImage(selectedImage[indexPath.row])
        } else {
            cell.setTextColor(UIColor.whiteColor())
            cell.backgroundColor = Constants.Colors.appTheme
            cell.setImage(deSelectedImage[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        
        self.collectionView.reloadData()
//        self.tableView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return
            CGSize(width: self.view.frame.size.width / 5, height: 50)
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TransactionTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionTableIdentifier") as! TransactionTableViewCell
        cell.selectionStyle = .None
        
        let tempModel = tableData[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: NSDate = dateFormatter.dateFromString(tempModel.date_added)!
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "MMMM dd, yyyy"
        let dateAdded = dateFormatter1.stringFromDate(date)
        
        cell.setStatus(tempModel.order_status_id.toInt()!)
        cell.setTID(tempModel.order_id)
        //cell.setPrice("P \(tempModel.total_price)"
            
        if tempModel.total_quantity.toInt() < 2 {
            cell.setProductDate("\(tempModel.total_quantity) product\t\t\(dateAdded)")
        } else {
            cell.setProductDate("\(tempModel.total_quantity) products\t\t\(dateAdded)")
        }
            
        return cell
    }
    
    // MARK: Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var transactionDetailsController = TransactionDetailsTableViewController(nibName: "TransactionDetailsTableViewController", bundle: nil)
        self.navigationController?.pushViewController(transactionDetailsController, animated:true)

    }
    
    func fireGetTransaction(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.GET(APIAtlas.transactionList, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let transactionModel: TransactionsModel = TransactionsModel.parseDataWithDictionary(responseObject)
            
            println(responseObject)
            
            if transactionModel.isSuccessful {
                self.tableData.removeAll(keepCapacity: false)
                self.tableData = transactionModel.transactions
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
            self.fireGetTransaction()
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
