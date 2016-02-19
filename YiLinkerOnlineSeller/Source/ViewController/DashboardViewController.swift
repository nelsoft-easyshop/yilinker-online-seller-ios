//
//  ViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by @EasyShop.ph on 8/24/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let dashBoardHeaderIdentifier: String = "DashBoardHeaderCollectionViewCell"
    let dashBoardItemIdentifier: String = "DashBoardItemCollectionViewCell"

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loginBlockerView: UIView!
    
    var tableData: [String] = []
    
    var tableImages: [String] = []
    
    var storeInfo: StoreInfoModel!
    
    var hud: MBProgressHUD?
    
    var ctr: Int = 0
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    var connectionLocalizeString: String = ""
    var connectionMessageLocalizeString: String = ""
    var oldPushNotifData: String = ""
    
    // Variable for storing messaging and search controller if user logged in as affiliate
    var messagingController: UIViewController = UIViewController()
    var searchViewController: UIViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController!.tabBar.tintColor = Constants.Colors.appTheme
        
        registerNibs()
        initializeViews()
        initializeLocalizedString()
        
        // Payout Withdrawal Timer
        if NSUserDefaults.standardUserDefaults().valueForKey("cooldownKey") == nil {
            NSUserDefaults.standardUserDefaults().setObject(60, forKey: "cooldownKey")
        } else if NSUserDefaults.standardUserDefaults().valueForKey("cooldownKey") as! Int == 0 {
            NSUserDefaults.standardUserDefaults().setObject(60, forKey: "cooldownKey")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        if SessionManager.isLoggedIn() {
            self.loginBlockerView.hidden = true
            fireStoreInfo(true)
            setupGCM()
        } else {
            self.loginBlockerView.hidden = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        if !NSUserDefaults.standardUserDefaults().boolForKey("rememberMe") {
            if !SessionManager.isLoggedIn() {
                SessionManager.setAccessToken("")
                let signInViewController = LoginAndRegisterTableViewController(nibName: "LoginAndRegisterTableViewController", bundle: nil)
                self.presentViewController(signInViewController, animated: false, completion: nil)
            }
//        }
        self.navigationController?.navigationBarHidden = true
        
        self.tabBarController?.tabBar.hidden = false
        
        
        var viewControllers: [UIViewController] =  self.tabBarController!.viewControllers as! [UIViewController]
        if viewControllers.count == 4 {
            //remove search tab index
            viewControllers.removeAtIndex(1)
            self.tabBarController?.setViewControllers(viewControllers, animated: true)
        }
        
        //Remove messaging item
        if SessionManager.isReseller() {
            self.removeMessagingAndSearchInTabBar()
        } else {
            self.addMessagingController(self.messagingController)
            //self.addMessagingController(self.searchViewController)
        }
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHING_WENT_WRONG_LOCALIZE_KEY")
        connectionLocalizeString = StringHelper.localizedStringWithKey("CONNECTION_UNREACHABLE_LOCALIZE_KEY")
        connectionMessageLocalizeString = StringHelper.localizedStringWithKey("CONNECTION_ERROR_MESSAGE_LOCALIZE_KEY")
        
        let myStoreString = StringHelper.localizedStringWithKey("MY_STORE_LOCALIZE_KEY")
        let salesReportString = StringHelper.localizedStringWithKey("SALES_REPORT_LOCALIZE_KEY")
        let transactionsString = StringHelper.localizedStringWithKey("TRANSACTIONS_LOCALIZE_KEY")
        let productManagementString = StringHelper.localizedStringWithKey("PRODUCT_MANAGEMENT_LOCALIZE_KEY")
        let customizedCategoryString = StringHelper.localizedStringWithKey("CUSTOMIZED_CATEGORY_LOCALIZE_KEY")
        var uploadItemString: String = ""
        if SessionManager.isReseller() {
            uploadItemString = StringHelper.localizedStringWithKey("SELECT_PRODUCT_LOCALIZE_KEY")
        } else {
            uploadItemString = StringHelper.localizedStringWithKey("UPLOAD_ITEMS_LOCALIZE_KEY")
        }
        let payout: String = StringHelper.localizedStringWithKey("PAYOUT_LOCALIZE_KEY")
        let followersString = StringHelper.localizedStringWithKey("FOLLOWERS_LOCALIZE_KEY")
        let activityLogsString = StringHelper.localizedStringWithKey("ACTIVITY_LOGS_LOCALIZE_KEY")
        let myPointsString = StringHelper.localizedStringWithKey("MY_POINTS_LOCALIZE_KEY")
        let resolutionCenterString = StringHelper.localizedStringWithKey("RESOLUTION_CENTER_LOCALIZE_KEY")
        let helpString = StringHelper.localizedStringWithKey("HELP_LOCALIZE_KEY")
        let logoutString = StringHelper.localizedStringWithKey("LOGOUT_LOCALIZE_KEY")
        
        tableData.removeAll(keepCapacity: false)
        tableData.append(myStoreString)
        tableData.append(salesReportString)
        tableData.append(transactionsString)
        tableData.append(productManagementString)
        tableData.append(customizedCategoryString)
        tableData.append(uploadItemString)
        // Payout module
        tableData.append(payout)
        
        tableData.append(followersString)
        tableData.append(activityLogsString)
        tableData.append(myPointsString)
        if !SessionManager.isReseller(){
            tableData.append(resolutionCenterString)
        }
        tableData.append(helpString)
        tableData.append(logoutString)
        
        tableImages.removeAll(keepCapacity: false)
        tableImages.append("mystore")
        tableImages.append("report")
        tableImages.append("transaction")
        tableImages.append("product")
        tableImages.append("category")
        tableImages.append("uploadItem")
        tableImages.append("withdraw2")
        tableImages.append("followers")
        tableImages.append("activityLog")
        tableImages.append("points")
        if !SessionManager.isReseller(){
            tableImages.append("resolution")
        } else {
            for var i = 0; i < tableImages.count; i++ {
                if tableImages[i] == "resolution" {
                    tableImages.removeAtIndex(i)
                }
            }
        }
        tableImages.append("help")
        tableImages.append("logout")
    }
    
    func removeMessagingAndSearchInTabBar() {
        var viewControllers: [UIViewController] =  self.tabBarController!.viewControllers as! [UIViewController]
        if viewControllers.count == 3 {
            //self.searchViewController = viewControllers[1]
            self.messagingController = viewControllers[1]
            
            viewControllers.removeAtIndex(1)
            //viewControllers.removeAtIndex(1)
            
            self.tabBarController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
    //MARK: - Add Messaging Controller
    func addMessagingController(viewController: UIViewController) {
        var viewControllers: [UIViewController] =  self.tabBarController!.viewControllers as! [UIViewController]
        if viewControllers.count == 2 {
            viewControllers.insert(viewController, atIndex: 1)
            self.tabBarController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
    func setupGCM(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRegistration:",
            name: appDelegate.registrationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNewMessage:",
            name: appDelegate.messageKey, object: nil)
        
    }
    
    func onRegistration(notification: NSNotification){
        if let info = notification.userInfo as? Dictionary<String,String> {
            if let error = info["error"] {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: error, title: "Error registering with GCM")
            } else if let registrationToken = info["registrationToken"] {
                let message = "Check the xcode debug console for the registration token for the server to send notifications to your device"
                self.fireCreateRegistration(registrationToken)
                println("Registration Successful! \(message)")
            }
        }
    }

    
    func onNewMessage(notification : NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        if self.oldPushNotifData != data {
                            var count = SessionManager.getUnReadMessagesCount() + 1
                            SessionManager.setUnReadMessagesCount(count)
                            self.setMessageBadgeCount()
                        }
                    }
                }
                self.oldPushNotifData = data
            }
        }
        
    }
    
    func setMessageBadgeCount() {
        if self.tabBarController!.tabBar.items?.count == 3 && SessionManager.isSeller() {
            if SessionManager.getUnReadMessagesCount() != 0 {
                (self.tabBarController!.tabBar.items![1] as! UITabBarItem).badgeValue = String(SessionManager.getUnReadMessagesCount())
            } else {
                (self.tabBarController!.tabBar.items![1] as! UITabBarItem).badgeValue = nil
            }
        }
    }
    
    func fireCreateRegistration(registrationID : String) {
        self.showHUD()
        
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = [
            "registrationId": "\(registrationID)",
            "access_token"  : SessionManager.accessToken(),
            "deviceType"    : "1"
            ]   as Dictionary<String, String>
        
        let url = APIAtlas.baseUrl + APIAtlas.ACTION_GCM_CREATE
        
        manager.POST(url, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            //SVProgressHUD.dismiss()
            self.hideHud()
            //self.showSuccessMessage()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                println(task.response?.description)
                
                println(error.description)
                if (Reachability.isConnectedToNetwork()) {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken(true)
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                    }
                }
                self.hideHud()
        })
    }
    
    // Show hud
    
    func showHUD() {
        
        if SessionManager.isLoggedIn() {
            if ctr == 0 || self.checkIfNewUser() {
                displayHUD()
                ctr++
            } else if ctr != 0 {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
        }
//        if NSUserDefaults.standardUserDefaults().boolForKey("rememberMe") {
//            if ctr == 0{
//                displayHUD()
//            } else {
//                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//            }
//        } else {
//            if ctr == 1 {
//                displayHUD()
//            } else if ctr != 0 {
//                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//            }
//        }
        
    }

    func displayHUD() {
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
    
    func hideHud() {
        self.hud?.hide(true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func checkIfNewUser() -> Bool {
        if self.storeInfo.firstName.isEmpty && self.storeInfo.lastName.isEmpty && self.storeInfo.email.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func initializeViews() {
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.Bottom
        }
        
        self.tabBarController!.tabBar.tintColor = Constants.Colors.appTheme
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
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
        
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRectMake(0, 0, view.frame.width, 20)
        gradient.colors = [UIColor.grayColor().CGColor, UIColor.clearColor().CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 1)
    }
    
    func registerNibs() {
        var cellHeaderNib = UINib(nibName: dashBoardHeaderIdentifier, bundle: nil)
        self.collectionView?.registerNib(cellHeaderNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: dashBoardHeaderIdentifier)
        
        var cellNib = UINib(nibName: dashBoardItemIdentifier, bundle: nil)
        self.collectionView?.registerNib(cellNib, forCellWithReuseIdentifier: dashBoardItemIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: dashBoardHeaderIdentifier, forIndexPath: indexPath) as! DashBoardHeaderCollectionViewCell
            
            if storeInfo != nil{
                let totalSales: String = "\(storeInfo.totalSales)"
                let totalProducts: String = "\(storeInfo.productCount)"
                let totalTransactions: String = "\(storeInfo.transactionCount)"
                
                headerView.setStoreName(storeInfo.store_name)
                headerView.setAddress(storeInfo.store_address)
                headerView.setCoverPhotoUrl(storeInfo.coverPhoto)
                headerView.setProfilePhotoUrl(storeInfo.avatar)
                headerView.setTotalProducts(totalProducts)
                headerView.setTotalSales(totalSales.formatToTwoDecimal().formatToPeso())
                headerView.setTotalTransactions(totalTransactions)
            }
            
            return headerView
//        default:
//            assert(false, "Unexpected element kind")
//        }
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var temp: Int = 0
        if SessionManager.isReseller() {
            temp = 1
        } else {
            temp = 0
        }
        
        if indexPath.row == 0 {
            if SessionManager.isSeller() {
                var storeInfoViewController = StoreInfoViewController(nibName: "StoreInfoViewController", bundle: nil)
                self.navigationController?.pushViewController(storeInfoViewController, animated:true)
            } else {
                var editProfileViewController = EditProfileTableViewController(nibName: "EditProfileTableViewController", bundle: nil)
                editProfileViewController.storeInfo = self.storeInfo
                editProfileViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(editProfileViewController, animated:true)
            }
        } else if indexPath.row == 0 {
           
        } else if indexPath.row == 1 {
            var salesViewController = SalesReportViewController(nibName: "SalesReportViewController", bundle: nil)
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
            var customizedCategory = CustomizedCategoryViewController(nibName: "CustomizedCategoryViewController", bundle: nil)
            self.navigationController?.pushViewController(customizedCategory, animated:true)
        } else if indexPath.row == 5 {
            if SessionManager.isSeller() {
                let productUploadTableViewController: ProductUploadTableViewController = ProductUploadTableViewController(nibName: "ProductUploadTableViewController", bundle: nil)
                let navigationController: UINavigationController = UINavigationController(rootViewController: productUploadTableViewController)
                ProductUploadCombination.draft = true
                ProductUploadEdit.uploadType = UploadType.NewProduct
                navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
                self.tabBarController!.presentViewController(navigationController, animated: true, completion: nil)
            } else {
                let resellerViewController: ResellerViewController = ResellerViewController(nibName: "ResellerViewController", bundle: nil)
                let navigationController: UINavigationController = UINavigationController(rootViewController: resellerViewController)
                navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
                self.tabBarController!.presentViewController(navigationController, animated: true, completion: nil)
            }
        } else if indexPath.row == 6 {
            let payoutVC = PayoutViewController(nibName: "PayoutViewController", bundle: nil)
            payoutVC.hidesBottomBarWhenPushed = true
            payoutVC.storeInfo = self.storeInfo
            self.navigationController?.pushViewController(payoutVC, animated: true)
        } else if indexPath.row == 7 {
            var followerController = FollowersViewController(nibName: "FollowersViewController", bundle: nil)
            self.navigationController?.pushViewController(followerController, animated:true)
        } else if indexPath.row == 8 {
            var activityViewController = ActivityLogTableViewController(nibName: "ActivityLogTableViewController", bundle: nil)
            self.navigationController?.pushViewController(activityViewController, animated:true)
        } else if indexPath.row == 9 {
            var myPointsViewController = MyPointsTableViewController(nibName: "MyPointsTableViewController", bundle: nil)
            self.navigationController?.pushViewController(myPointsViewController, animated:true)
            
        } else if indexPath.row == (11 - temp) {
            let help = HelpViewController(nibName: "HelpViewController", bundle: nil)
            help.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(help, animated: true)

        } else if indexPath.row == 10 {
            let resolutionCenter = self.storyboard?.instantiateViewControllerWithIdentifier("ResolutionCenterViewControllerV2")
                as! ResolutionCenterViewControllerV2
            resolutionCenter.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(resolutionCenter, animated:true)
        } else if indexPath.row == (12 - temp) {
            let areYouSUreString = StringHelper.localizedStringWithKey("ARE_YOU_SURE_LOGOUT_LOCALIZE_KEY")
            let logoutString = StringHelper.localizedStringWithKey("LOGOUT_LOCALIZE_KEY")
            let cancelString = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
            
            var alert = UIAlertController(title: nil, message: areYouSUreString, preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: logoutString, style: .Destructive, handler: { action in
                switch action.style{
                case .Default:
                    println("default")
                    
                case .Cancel:
                    println("cancel")
                    
                case .Destructive:
                    self.fireDeleteRegistration(SessionManager.gcmToken())
                    
                }
            }))
            alert.addAction(UIAlertAction(title: cancelString, style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func fireDeleteRegistration(registrationID : String) {
        if Reachability.isConnectedToNetwork() {
            if(SessionManager.isLoggedIn()){
                let manager: APIManager = APIManager.sharedInstance
                let parameters: NSDictionary = [
                    
                    "registrationId": "\(registrationID)",
                    "deviceType"    : "1"
                    ]   as Dictionary<String, String>
                
                let url = "\(APIAtlas.ACTION_GCM_DELETE)?access_token=\(SessionManager.accessToken())"
                self.showHUD()
                manager.POST(url, parameters: parameters, success: {
                    (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                    println(responseObject)
                    println("Registration successful!")
                    self.logoutUser()
                    self.hud?.hide(true)
                    }, failure: {
                        (task: NSURLSessionDataTask!, error: NSError!) in
                        let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                        println("Registration unsuccessful!")
                        self.hud?.hide(true)
                        if task.statusCode == 401 {
                        } else {
                            if Reachability.isConnectedToNetwork() {
                                var info = error.userInfo!
                                
//                                if info["data"] != nil {
                                    self.logoutUser()
//                                } else {
//                                    UIAlertController.displaySomethingWentWrongError(self)
//                                }
                                
                            } else {
                                UIAlertController.displayNoInternetConnectionError(self)
                            }
                        }
                        
                })
            }
        } else {
            UIAlertController.displayNoInternetConnectionError(self)
        }
        
    }
    
    func logoutUser() {
        self.ctr = 0
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "rememberMe")
        SessionManager.setAccessToken("")
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.changeRootToDashboard()
    }
    
    func fireStoreInfo(showHUD: Bool){
        if showHUD {
            self.showHUD()
        }
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
            
            self.initializeLocalizedString()
            self.collectionView.reloadData()
            
            self.hideHud()
            
            if self.checkIfNewUser() {
                var editProfileViewController = EditProfileTableViewController(nibName: "EditProfileTableViewController", bundle: nil)
                editProfileViewController.storeInfo = self.storeInfo
                editProfileViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(editProfileViewController, animated:true)
            }
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hideHud()
                
                if let taskReponse = task.response as? NSHTTPURLResponse {
                    if taskReponse.statusCode == 401 {
                        self.fireRefreshToken(showHUD)
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                        self.storeInfo = StoreInfoModel(name: "", firstName: "", lastName: "", email: "", gender: "", nickname: "", contact_number: "", specialty: "", birthdate: "", store_name: "", store_description: "", avatar: NSURL(string: "")!, cover_photo: NSURL(string: "")!, is_allowed: false, title: "", unit_number: "", bldg_name: "", street_number: "", street_name: "", subdivision: "", zip_code: "", full_address: "", account_title: "", account_number: "", bank_account: "", bank_id: 0, productCount: 0, transactionCount: 0, totalSales: "", isReseller: false, isEmailSubscribed: false, isSmsSubscribed: false, productId: [""], productCategoryName: [""], isSelected: [false], tin: "", messageCount: 0, referralCode: "", referrerCode: "", accountName: "", bankName: "")
                        
                        
                        var store_name1 = NSUserDefaults.standardUserDefaults().stringForKey("storeName")
                        println("Store name \(store_name1)")
                        if NSUserDefaults.standardUserDefaults().stringForKey("storeName") != nil {
                            self.storeInfo.store_name = NSUserDefaults.standardUserDefaults().stringForKey("storeName")!
                        }
                        
                        if NSUserDefaults.standardUserDefaults().stringForKey("storeAddress") != nil {
                            self.storeInfo.store_address = NSUserDefaults.standardUserDefaults().stringForKey("storeAddress")!
                        }
                        
                        if NSUserDefaults.standardUserDefaults().stringForKey("totalSales") != nil {
                            self.storeInfo.totalSales = NSUserDefaults.standardUserDefaults().stringForKey("totalSales")!
                        }
                        
                        self.storeInfo.productCount = NSUserDefaults.standardUserDefaults().integerForKey("productCount")
                        self.storeInfo.transactionCount = NSUserDefaults.standardUserDefaults().integerForKey("transactionCount")
                        
                        self.collectionView.reloadData()
                    }
                } else {
                    if !Reachability.isConnectedToNetwork() {
                        UIAlertController.displayNoInternetConnectionError(self)
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                    }
                }
            
                
                println(error)
        })
    }
    
    func fireRefreshToken(showHud: Bool) {
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
            self.fireStoreInfo(showHud)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hideHud()
        })
        
    }
    
}

