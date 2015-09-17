//
//  ViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by @EasyShop.ph on 8/24/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SignInViewControllerDelegate {
    
    let dashBoardHeaderIdentifier: String = "DashBoardHeaderCollectionViewCell"
    let dashBoardItemIdentifier: String = "DashBoardItemCollectionViewCell"

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loginBlockerView: UIView!
    
    var tableData: [String] = ["My\nStore", "Sales\nReport", "Transactions", "Product\nManagement", "Customized\nCategory", "Upload\nItem", "Followers", "Activity\nLog", "My\nPoints", "Resolution\nCenter", "Help", "Logout"]
    
    var tableImages: [String] = ["mystore", "report", "transaction", "product", "category", "uploadItem", "followers", "activityLog", "points", "resolution", "help", "logout"]
    
    var storeInfo: StoreInfoModel!
    
    var hud: MBProgressHUD?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController!.tabBar.tintColor = Constants.Colors.appTheme
        if !NSUserDefaults.standardUserDefaults().boolForKey("rememberMe") {
            SessionManager.setAccessToken("")
            let signInViewController = SignInViewController(nibName: "SignInViewController", bundle: nil)
            signInViewController.delegate = self
            self.presentViewController(signInViewController, animated: false, completion: nil)
        }
        
//        println(SessionManager.accessToken())
        registerNibs()
        initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true

        if SessionManager.isLoggedIn() {
            self.loginBlockerView.hidden = true
        } else {
            self.loginBlockerView.hidden = false
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("rememberMe") {
            if storeInfo == nil {
                fireStoreInfo()
            }
        }

        self.tabBarController?.tabBar.hidden = false
    }
    
    
    // Show hud
    
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
    
    func initializeViews() {
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.Bottom
        }
        
        self.tabBarController!.tabBar.tintColor = Constants.Colors.appTheme
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 340.0)
        
        if screenHeight <= 480 {
            layout.itemSize = CGSize(width: ((screenWidth - 32)/4), height: (screenHeight * 0.22))
        } else {
            layout.itemSize = CGSize(width: ((screenWidth - 32)/4), height: (screenHeight * 0.19))
        }
        
        layout.sectionInset = UIEdgeInsetsMake(0, 16.0, 0, 16.0)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.bounces = false
        collectionView?.alwaysBounceVertical = true
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRectMake(0, 0, view.frame.width, 20)
        gradient.colors = [UIColor.grayColor().CGColor, UIColor.clearColor().CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 1)
    }
    
    func registerNibs() {
        let cellHeaderNib = UINib(nibName: dashBoardHeaderIdentifier, bundle: nil)
        self.collectionView?.registerNib(cellHeaderNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: dashBoardHeaderIdentifier)
        
        let cellNib = UINib(nibName: dashBoardItemIdentifier, bundle: nil)
        self.collectionView?.registerNib(cellNib, forCellWithReuseIdentifier: dashBoardItemIdentifier)
    }
    
    
    // MARK: SignInViewControllerDelegate
    func passStoreInfoModel(storeInfoModel: StoreInfoModel) {
        storeInfo = storeInfoModel
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return tableData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: DashBoardItemCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(dashBoardItemIdentifier, forIndexPath: indexPath) as! DashBoardItemCollectionViewCell
        
        cell.setText(tableData[indexPath.row])
        cell.setIconImage(UIImage(named: tableImages[indexPath.row])!)
        
        if tableImages[indexPath.row] == "uploadItem" {
            cell.iconView.backgroundColor = Constants.Colors.uploadViewColor
        } else {
            cell.iconView.backgroundColor = Constants.Colors.productPrice
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: dashBoardHeaderIdentifier, forIndexPath: indexPath) as! DashBoardHeaderCollectionViewCell
            
            if storeInfo != nil{
                let totalSales: String = "P\(storeInfo.totalSales)"
                let totalProducts: String = "\(storeInfo.productCount)"
                let totalTransactions: String = "\(storeInfo.transactionCount)"
                
                headerView.setStoreName(storeInfo.store_name)
                headerView.setAddress(storeInfo.store_address)
                headerView.setCoverPhotoUrl(storeInfo.coverPhoto)
                headerView.setProfilePhotoUrl(storeInfo.avatar)
                headerView.setTotalProducts(totalProducts)
                headerView.setTotalSales(totalSales)
                headerView.setTotalTransactions(totalTransactions)
                
                print("totalTransactions \(totalTransactions)")
            }
            
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        println("Clicked item \(tableData[indexPath.row])")
        if indexPath.row == 0 {
            let storeInfoViewController = StoreInfoViewController(nibName: "StoreInfoViewController", bundle: nil)
            self.navigationController?.pushViewController(storeInfoViewController, animated:true)
        } else if indexPath.row == 0 {
           
        } else if indexPath.row == 1 {
            let salesViewController = SalesReportViewController(nibName: "SalesReportViewController", bundle: nil)
            self.navigationController?.pushViewController(salesViewController, animated:true)
        } else if indexPath.row == 2 {
            let transaction = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
            transaction.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(transaction, animated: true)
        } else if indexPath.row == 3 {
            let productManagement = ProductManagementViewController(nibName: "ProductManagementViewController", bundle: nil)
            productManagement.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(productManagement, animated: true)
        } else if indexPath.row == 4 {
            let customizedCategory = CustomizedCategoryViewController(nibName: "CustomizedCategoryViewController", bundle: nil)
            self.navigationController?.pushViewController(customizedCategory, animated:true)
        } else if indexPath.row == 5 {
            let productUploadTableViewController: ProductUploadTableViewController = ProductUploadTableViewController(nibName: "ProductUploadTableViewController", bundle: nil)
            let navigationController: UINavigationController = UINavigationController(rootViewController: productUploadTableViewController)
            navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
            self.tabBarController!.presentViewController(navigationController, animated: true, completion: nil)
        } else if indexPath.row == 6 {
            let followerController = FollowersViewController(nibName: "FollowersViewController", bundle: nil)
            self.navigationController?.pushViewController(followerController, animated:true)
        } else if indexPath.row == 7 {
            let activityViewController = ActivityLogTableViewController(nibName: "ActivityLogTableViewController", bundle: nil)
            self.navigationController?.pushViewController(activityViewController, animated:true)
        } else if indexPath.row == 8 {
            let myPointsViewController = MyPointsTableViewController(nibName: "MyPointsTableViewController", bundle: nil)
            self.navigationController?.pushViewController(myPointsViewController, animated:true)
            
        } else if indexPath.row == 9 {
            let resolutionCenter = self.storyboard?.instantiateViewControllerWithIdentifier("ResolutionCenterViewController")
                as! ResolutionCenterViewController
            resolutionCenter.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(resolutionCenter, animated:true)
        } else if indexPath.row == 10 {
            
        } else if indexPath.row == 11 {
            let alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: "Logout", style: .Destructive, handler: { action in
                switch action.style{
                case .Default:
                    print("default")
                    
                case .Cancel:
                    print("cancel")
                    
                case .Destructive:
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "rememberMe")
                    let signInViewController = SignInViewController(nibName: "SignInViewController", bundle: nil)
                    self.presentViewController(signInViewController, animated: true, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func fireStoreInfo(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.POST(APIAtlas.sellerStoreInfo, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.storeInfo = StoreInfoModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
            
            SessionManager.setFullAddress(self.storeInfo.store_address)
            SessionManager.setUserFullName(self.storeInfo.name)
            
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.store_name, forKey: "storeName")
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.store_address, forKey: "storeAddress")
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.totalSales, forKey: "totalSales")
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.productCount, forKey: "productCount")
            NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.transactionCount, forKey: "transactionCount")
            
            NSUserDefaults.standardUserDefaults().synchronize()
            
            self.collectionView.reloadData()
            self.hud?.hide(true)
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    self.storeInfo = StoreInfoModel(name: "", email: "", gender: "", nickname: "", contact_number: "", specialty: "", birthdate: "", store_name: "", store_description: "", avatar: NSURL(string: "")!, cover_photo: NSURL(string: "")!, is_allowed: false, title: "", unit_number: "", bldg_name: "", street_number: "", street_name: "", subdivision: "", zip_code: "", full_address: "", account_title: "", account_number: "", bank_account: "", bank_id: 0, productCount: 0, transactionCount: 0, totalSales: "")
                    
                    
                    let store_name1 = NSUserDefaults.standardUserDefaults().stringForKey("storeName")
                    print("Store name \(store_name1)")
                    self.storeInfo.store_name = NSUserDefaults.standardUserDefaults().stringForKey("storeName")!
                    self.storeInfo.store_address = NSUserDefaults.standardUserDefaults().stringForKey("storeAddress")!
                    self.storeInfo.totalSales = NSUserDefaults.standardUserDefaults().stringForKey("totalSales")!
                    self.storeInfo.productCount = NSUserDefaults.standardUserDefaults().integerForKey("productCount")
                    self.storeInfo.transactionCount = NSUserDefaults.standardUserDefaults().integerForKey("transactionCount")
                    
                    self.collectionView.reloadData()
                }
                
                print(error)
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
            self.fireStoreInfo()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }
    
}

