//
//  ViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by @EasyShop.ph on 8/24/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct DashboardViewConstants {
    //Strings
    static let myStoreString = StringHelper.localizedStringWithKey("MY_STORE_LOCALIZE_KEY")
    static let editProfileString = StringHelper.localizedStringWithKey("EDIT_PROFILE_LOCALIZE_KEY")
    static let setupStoreString = StringHelper.localizedStringWithKey("SETUP_STORE_LOCALIZE_KEY")
    static let salesReportString = StringHelper.localizedStringWithKey("SALES_REPORT_LOCALIZE_KEY")
    static let transactionsString = StringHelper.localizedStringWithKey("TRANSACTIONS_LOCALIZE_KEY")
    static let productManagementString = StringHelper.localizedStringWithKey("PRODUCT_MANAGEMENT_LOCALIZE_KEY")
    static let customizedCategoryString = StringHelper.localizedStringWithKey("CUSTOMIZED_CATEGORY_LOCALIZE_KEY")
    static let uploadItemString = StringHelper.localizedStringWithKey("UPLOAD_ITEMS_LOCALIZE_KEY")
    static let selectProduct = StringHelper.localizedStringWithKey("SELECT_PRODUCT_LOCALIZE_KEY")
    static let payout: String = StringHelper.localizedStringWithKey("PAYOUT_LOCALIZE_KEY")
    static let followersString = StringHelper.localizedStringWithKey("FOLLOWERS_LOCALIZE_KEY")
    static let activityLogsString = StringHelper.localizedStringWithKey("ACTIVITY_LOGS_LOCALIZE_KEY")
    static let myPointsString = StringHelper.localizedStringWithKey("MY_POINTS_LOCALIZE_KEY")
    static let resolutionCenterString = StringHelper.localizedStringWithKey("RESOLUTION_CENTER_LOCALIZE_KEY")
    static let helpString = StringHelper.localizedStringWithKey("HELP_LOCALIZE_KEY")
    static let logoutString = StringHelper.localizedStringWithKey("LOGOUT_LOCALIZE_KEY")
    
    static let warehouseString = StringHelper.localizedStringWithKey("WAREHOUSE_LOCALIZE_KEY")
    
    static func getButtonTitles(isSeller: Bool) -> [String] {
        var titles: [String] = []
        
        if isSeller {
            titles = [myStoreString, warehouseString, salesReportString, transactionsString, productManagementString, customizedCategoryString, uploadItemString, payout, followersString, activityLogsString, resolutionCenterString, helpString, logoutString]
        } else {
            titles = [editProfileString, setupStoreString, salesReportString, transactionsString, productManagementString, customizedCategoryString, selectProduct, payout, followersString, activityLogsString, helpString, logoutString]
        }
        
        return titles
    }
    
    static func getButtonIcons(isSeller: Bool) -> [String] {
        var icons: [String] = []
        
        if isSeller {
            icons = ["mystore", "warehouse_icon", "report", "transaction", "product", "category", "uploadItem", "withdraw2", "followers", "activityLog", "resolution", "help", "logout"]
        } else {
            icons = ["edit-profile", "mystore", "report", "transaction", "product", "category", "uploadItem", "withdraw2", "followers", "activityLog", "help", "logout"]
        }
        
        return icons
    }
    
}

class DashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let dashBoardHeaderIdentifier: String = "DashBoardHeaderCollectionViewCell"
    let dashBoardItemIdentifier: String = "DashBoardItemCollectionViewCell"

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loginBlockerView: UIView!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var coverPhotoHeightConstraint: NSLayoutConstraint!
    
    let coverPhotoHeight = 125;
    
    var tableData: [String] = []
    
    var tableImages: [String] = []
    
    var storeInfo: StoreInfoModel!
    
    var hud: MBProgressHUD?
    
    var ctr: Int = 0
    var openCtr: Int = 0
    
    var oldPushNotifData: String = ""
    
    // Variable for storing messaging and search controller if user logged in as affiliate
    var messagingController: UIViewController = UIViewController()
    var searchViewController: UIViewController = UIViewController()
    
    var refreshTokenCtr: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController!.tabBar.tintColor = Constants.Colors.appTheme
        
        self.registerNibs()
        self.initializeViews()
        self.intializeCollectionViewData()
        
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
        self.refreshTokenCtr = 0
        if SessionManager.isLoggedIn() {
            self.loginBlockerView.hidden = true
            self.fireStoreInfo(true)
            self.setupGCM()
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
        
        if !SessionManager.isLoggedIn() {
            SessionManager.setAccessToken("")
            let signInViewController = LoginAndRegisterTableViewController(nibName: "LoginAndRegisterTableViewController", bundle: nil)
            self.presentViewController(signInViewController, animated: false, completion: nil)
        }
        
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
        }
    }
    
    //MARK: -
    //MARK: - Initializations
    func intializeCollectionViewData() {
        self.tableData = DashboardViewConstants.getButtonTitles(SessionManager.isSeller())
        self.tableImages = DashboardViewConstants.getButtonIcons(SessionManager.isSeller())
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
        collectionView?.backgroundColor = UIColor.clearColor()
        //collectionView?.bounces = false
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
    
    
    //MARK: -
    //MARK: - Delegates and Data Source
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: DashBoardItemCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(dashBoardItemIdentifier, forIndexPath: indexPath) as! DashBoardItemCollectionViewCell
        
        cell.setText(self.tableData[indexPath.row])
        cell.setIconImage(UIImage(named: self.tableImages[indexPath.row])!)
        if self.tableImages[indexPath.row] == "uploadItem" {
            cell.iconView.backgroundColor = Constants.Colors.uploadViewColor
        } else {
            cell.iconView.backgroundColor = Constants.Colors.productPrice
        }
        
        if self.checkIfNewUser() {
            if self.tableData[indexPath.row] == DashboardViewConstants.editProfileString ||
                self.tableData[indexPath.row] == DashboardViewConstants.helpString ||
                self.tableData[indexPath.row] == DashboardViewConstants.logoutString {
                    cell.iconView.alpha = 1.0
            } else {
                cell.iconView.alpha = 0.5
            }
        } else {
            cell.iconView.alpha = 1.0
        }
        
        if self.checkIfNewStore() {
            if self.tableData[indexPath.row] == DashboardViewConstants.editProfileString ||
                self.tableData[indexPath.row] == DashboardViewConstants.helpString ||
                self.tableData[indexPath.row] == DashboardViewConstants.logoutString ||
                self.tableData[indexPath.row] == DashboardViewConstants.setupStoreString {
                    cell.iconView.alpha = 1.0
            } else {
                cell.iconView.alpha = 0.5
            }
        } else {
            cell.iconView.alpha = 1.0
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
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
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if self.tableData[indexPath.row] == DashboardViewConstants.myStoreString {
            var storeInfoViewController = StoreInfoViewController(nibName: "StoreInfoViewController", bundle: nil)
            self.navigationController?.pushViewController(storeInfoViewController, animated:true)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.editProfileString {
            var editProfileViewController = EditProfileTableViewController(nibName: "EditProfileTableViewController", bundle: nil)
            editProfileViewController.storeInfo = self.storeInfo
            editProfileViewController.isNewUser = self.checkIfNewUser()
            editProfileViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(editProfileViewController, animated:true)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.setupStoreString && !self.checkIfNewUser() {
            let affiliateSelectProductViewController: AffiliateSetupStoreTableViewController = AffiliateSetupStoreTableViewController(nibName: AffiliateSetupStoreTableViewController.nibName(), bundle: nil) as AffiliateSetupStoreTableViewController
            affiliateSelectProductViewController.storeInfoModel = self.storeInfo
            affiliateSelectProductViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(affiliateSelectProductViewController, animated:true)
        } else if self.tableData[indexPath.row] == DashboardViewConstants.salesReportString && !self.checkIfNewUser() && !self.checkIfNewStore() {
            var salesViewController = SalesReportViewController(nibName: "SalesReportViewController", bundle: nil)
            self.navigationController?.pushViewController(salesViewController, animated:true)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.transactionsString && !self.checkIfNewUser() && !self.checkIfNewStore() {
            let transaction = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
            transaction.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(transaction, animated: true)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.productManagementString && !self.checkIfNewUser() && !self.checkIfNewStore() {
            let productManagement = ProductManagementViewController(nibName: "ProductManagementViewController", bundle: nil)
            productManagement.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(productManagement, animated: true)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.customizedCategoryString  && !self.checkIfNewUser() && !self.checkIfNewStore() {
            var customizedCategory = CustomizedCategoryViewController(nibName: "CustomizedCategoryViewController", bundle: nil)
            self.navigationController?.pushViewController(customizedCategory, animated:true)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.uploadItemString && !self.checkIfNewUser() && !self.checkIfNewStore() {
            
            let productUploadTableViewController: ProductUploadTC = ProductUploadTC(nibName: "ProductUploadTC", bundle: nil)
            let navigationController: UINavigationController = UINavigationController(rootViewController: productUploadTableViewController)
            ProductUploadCombination.draft = true
            ProductUploadEdit.uploadType = UploadType.NewProduct
            /*
            let productUploadTableViewController: ProductUploadTableViewController = ProductUploadTableViewController(nibName: "ProductUploadTableViewController", bundle: nil)
            let navigationController: UINavigationController = UINavigationController(rootViewController: productUploadTableViewController)
            ProductUploadCombination.draft = true
            ProductUploadEdit.uploadType = UploadType.NewProduct*/
            navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
            self.tabBarController!.presentViewController(navigationController, animated: true, completion: nil)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.selectProduct && !self.checkIfNewUser() && !self.checkIfNewStore() {
            //Setup Store
//            let resellerViewController: ResellerViewController = ResellerViewController(nibName: "ResellerViewController", bundle: nil)
//            let navigationController: UINavigationController = UINavigationController(rootViewController: resellerViewController)
//            navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
//            self.tabBarController!.presentViewController(navigationController, animated: true, completion: nil)

            let vc: AffiliateSelectProductViewController = AffiliateSelectProductViewController(nibName: AffiliateSelectProductViewController.nibName(), bundle: nil) as AffiliateSelectProductViewController
             vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if self.tableData[indexPath.row] == DashboardViewConstants.payout && !self.checkIfNewUser() && !self.checkIfNewStore() {
            let payoutVC = PayoutViewController(nibName: "PayoutViewController", bundle: nil)
            payoutVC.hidesBottomBarWhenPushed = true
            payoutVC.storeInfo = self.storeInfo
            self.navigationController?.pushViewController(payoutVC, animated: true)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.followersString && !self.checkIfNewUser() && !self.checkIfNewStore() {
            var followerController = FollowersViewController(nibName: "FollowersViewController", bundle: nil)
            self.navigationController?.pushViewController(followerController, animated:true)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.activityLogsString && !self.checkIfNewUser() && !self.checkIfNewStore() {
            var activityViewController = ActivityLogTableViewController(nibName: "ActivityLogTableViewController", bundle: nil)
            self.navigationController?.pushViewController(activityViewController, animated:true)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.myPointsString && !self.checkIfNewUser() && !self.checkIfNewStore() {
            var myPointsViewController = MyPointsTableViewController(nibName: "MyPointsTableViewController", bundle: nil)
            self.navigationController?.pushViewController(myPointsViewController, animated:true)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.resolutionCenterString && !self.checkIfNewUser() && !self.checkIfNewStore() {
            let resolutionCenter = self.storyboard?.instantiateViewControllerWithIdentifier("ResolutionCenterViewControllerV2")
                as! ResolutionCenterViewControllerV2
            resolutionCenter.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(resolutionCenter, animated:true)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.helpString {
            let help = HelpViewController(nibName: "HelpViewController", bundle: nil)
            help.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(help, animated: true)
            
        } else if self.tableData[indexPath.row] == DashboardViewConstants.logoutString {
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
        } else if self.tableData[indexPath.row] == DashboardViewConstants.warehouseString {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let warehouseVC: WarehouseListViewController = storyboard.instantiateViewControllerWithIdentifier("WarehouseListViewController") as! WarehouseListViewController
            self.navigationController?.pushViewController(warehouseVC, animated: true)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset: CGPoint = scrollView.contentOffset
        self.coverPhotoHeightConstraint.constant = CGFloat(self.coverPhotoHeight) + (offset.y * -1)
        self.view.layoutIfNeeded()
    }

    //MARK: -
    //MARK: - API Requests
    func fireCreateRegistration(registrationID : String) {
        self.showHUD()
        WebServiceManager.fireCreateGCMRegistrationIDWithUrl(APIAtlas.ACTION_GCM_CREATE, registrationId: "\(registrationID)", deviceType: "1", accessToken: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
            self.hideHud()
            println(responseObject)
        
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
//                    self.fireRefreshToken(true)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
                
            }

        }
        
        //Old Request
//        self.showHUD()
//        
//        let manager = APIManager.sharedInstance
//        //seller@easyshop.ph
//        //password
//        let parameters: NSDictionary = [
//            "registrationId": "\(registrationID)",
//            "access_token"  : SessionManager.accessToken(),
//            "deviceType"    : "1"
//            ]   as Dictionary<String, String>
//        
//        let url = APIAtlas.baseUrl + APIAtlas.ACTION_GCM_CREATE
//        
//        manager.POST(url, parameters: parameters, success: {
//            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
//            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
//            //SVProgressHUD.dismiss()
//            self.hideHud()
//            //self.showSuccessMessage()
//            }, failure: {
//                (task: NSURLSessionDataTask!, error: NSError!) in
//                
//                println(task.response?.description)
//                
//                println(error.description)
//                if (Reachability.isConnectedToNetwork()) {
//                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
//                    
//                    if task.statusCode == 401 {
//                        self.fireRefreshToken(true)
//                    } else {
//                        UIAlertController.displaySomethingWentWrongError(self)
//                    }
//                }
//                self.hideHud()
//        })
    }
    
    func fireDeleteRegistration(registrationID : String) {
        self.showHUD()
        let url = "\(APIAtlas.ACTION_GCM_DELETE)?access_token=\(SessionManager.accessToken())"
        WebServiceManager.fireDeleteGCMRegistrationIDWithUrl(url, registrationId: "\(registrationID)", deviceType: "1", accessToken: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
            self.hideHud()
            println(responseObject)
            if !successful {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
//                    self.fireRefreshToken(true)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
                
            }
            self.logoutUser()
        }
        
        //Old Request
        
//        if Reachability.isConnectedToNetwork() {
//            self.logoutUser()
//            if(SessionManager.isLoggedIn()){
//                let manager = APIManager.sharedInstance
//                let parameters: NSDictionary = [
//                    
//                    "registrationId": "\(registrationID)",
//                    "deviceType"    : "1"
//                    ]   as Dictionary<String, String>
//                
//                let url = "\(APIAtlas.ACTION_GCM_DELETE)?access_token=\(SessionManager.accessToken())"
//                self.showHUD()
//                manager.POST(url, parameters: parameters, success: {
//                    (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
//                    println(responseObject)
//                    println("Registration successful!")
//                    self.logoutUser()
//                    self.hud?.hide(true)
//                    }, failure: {
//                        (task: NSURLSessionDataTask!, error: NSError!) in
//                        let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
//                        println("Registration unsuccessful!")
//                        self.hud?.hide(true)
//                        if task.statusCode == 401 {
//                        } else {
//                            if Reachability.isConnectedToNetwork() {
//                                var info = error.userInfo!
//                                self.logoutUser()
//                                
//                            } else {
//                                UIAlertController.displayNoInternetConnectionError(self)
//                            }
//                        }
//                        
//                })
//            }
//        } else {
//            UIAlertController.displayNoInternetConnectionError(self)
//        }
//        
    }
    
    func fireStoreInfo(showHUD: Bool){
        if showHUD {
            self.showHUD()
        }
        
        WebServiceManager.fireGetStoreInfoWithUrl(APIAtlas.sellerStoreInfo, accessToken: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
//            println(responseObject)
            self.hideHud()
            if successful {
                self.storeInfo = StoreInfoModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
                
                SessionManager.setFullAddress(self.storeInfo.store_address)
                SessionManager.setUserFullName(self.storeInfo.name)
                
                NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.store_name, forKey: "storeName")
                NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.store_address, forKey: "storeAddress")
                NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.totalSales, forKey: "totalSales")
                NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.productCount, forKey: "productCount")
                NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.transactionCount, forKey: "transactionCount")
                NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.userId, forKey: "userId")
                
                NSUserDefaults.standardUserDefaults().synchronize()
                
                self.coverPhotoImageView.sd_setImageWithURL(self.storeInfo.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder"))
                
                self.intializeCollectionViewData()
                self.collectionView.reloadData()
                
                self.hideHud()
                
                if self.checkIfNewUser() && self.openCtr == 0 {
                    var editProfileViewController = EditProfileTableViewController(nibName: "EditProfileTableViewController", bundle: nil)
                    editProfileViewController.storeInfo = self.storeInfo
                    editProfileViewController.isNewUser = self.checkIfNewUser()
                    editProfileViewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(editProfileViewController, animated:true)
                    self.openCtr++
                }

            } else {
                self.storeInfo = StoreInfoModel(name: "", firstName: "", lastName: "", email: "", gender: "", nickname: "", contact_number: "", specialty: "", birthdate: "", store_name: "", store_description: "", storeSlug: "", avatar: NSURL(string: "")!, cover_photo: NSURL(string: "")!, is_allowed: false, title: "", unit_number: "", bldg_name: "", street_number: "", street_name: "", subdivision: "", zip_code: "", full_address: "", account_title: "", account_number: "", bank_account: "", bank_id: 0, productCount: 0, transactionCount: 0, totalSales: "", isReseller: false, isEmailVerified: false, isEmailSubscribed: false, isSmsSubscribed: false, productId: [], productCategoryName: [], isSelected: [], tin: "", messageCount: 0, referralCode: "", referrerCode: "", referrerName: "", accountName: "", bankName: "", validId: "", isBankEditable: false, isBusinessEditable: false, isLegalDocsEditable: false, validIdMessage: "", userId: "")
                
                
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
                
                
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(showHUD)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
                
            }
        }
        
        //Old Request
//        
//        let manager = APIManager.sharedInstance
//        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
//        
//        manager.POST(APIAtlas.sellerStoreInfo, parameters: parameters, success: {
//            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
//            self.storeInfo = StoreInfoModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
//            
//            SessionManager.setFullAddress(self.storeInfo.store_address)
//            SessionManager.setUserFullName(self.storeInfo.name)
//            
//            NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.store_name, forKey: "storeName")
//            NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.store_address, forKey: "storeAddress")
//            NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.totalSales, forKey: "totalSales")
//            NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.productCount, forKey: "productCount")
//            NSUserDefaults.standardUserDefaults().setObject(self.storeInfo?.transactionCount, forKey: "transactionCount")
//            
//            NSUserDefaults.standardUserDefaults().synchronize()
//            
//            self.intializeCollectionViewData()
//            self.collectionView.reloadData()
//            
//            self.hideHud()
//            
//            if self.checkIfNewUser() && self.openCtr == 0 {
//                var editProfileViewController = EditProfileTableViewController(nibName: "EditProfileTableViewController", bundle: nil)
//                editProfileViewController.storeInfo = self.storeInfo
//                editProfileViewController.isNewUser = self.checkIfNewUser()
//                editProfileViewController.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(editProfileViewController, animated:true)
//                self.openCtr++
//            }
//            
//            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
//                self.hideHud()
//                
//                if let taskReponse = task.response as? NSHTTPURLResponse {
//                    if taskReponse.statusCode == 401 {
//                        self.fireRefreshToken(showHUD)
//                    } else {
//                        UIAlertController.displaySomethingWentWrongError(self)
//                        self.storeInfo = StoreInfoModel(name: "", firstName: "", lastName: "", email: "", gender: "", nickname: "", contact_number: "", specialty: "", birthdate: "", store_name: "", store_description: "", storeSlug: "", avatar: NSURL(string: "")!, cover_photo: NSURL(string: "")!, is_allowed: false, title: "", unit_number: "", bldg_name: "", street_number: "", street_name: "", subdivision: "", zip_code: "", full_address: "", account_title: "", account_number: "", bank_account: "", bank_id: 0, productCount: 0, transactionCount: 0, totalSales: "", isReseller: false, isEmailVerified: false, isEmailSubscribed: false, isSmsSubscribed: false, productId: [], productCategoryName: [], isSelected: [], tin: "", messageCount: 0, referralCode: "", referrerCode: "", referrerName: "", accountName: "", bankName: "", validId: "", isBankEditable: false, isBusinessEditable: false, isLegalDocsEditable: false, validIdMessage: "")
//                        
//                        
//                        var store_name1 = NSUserDefaults.standardUserDefaults().stringForKey("storeName")
//                        println("Store name \(store_name1)")
//                        if NSUserDefaults.standardUserDefaults().stringForKey("storeName") != nil {
//                            self.storeInfo.store_name = NSUserDefaults.standardUserDefaults().stringForKey("storeName")!
//                        }
//                        
//                        if NSUserDefaults.standardUserDefaults().stringForKey("storeAddress") != nil {
//                            self.storeInfo.store_address = NSUserDefaults.standardUserDefaults().stringForKey("storeAddress")!
//                        }
//                        
//                        if NSUserDefaults.standardUserDefaults().stringForKey("totalSales") != nil {
//                            self.storeInfo.totalSales = NSUserDefaults.standardUserDefaults().stringForKey("totalSales")!
//                        }
//                        
//                        self.storeInfo.productCount = NSUserDefaults.standardUserDefaults().integerForKey("productCount")
//                        self.storeInfo.transactionCount = NSUserDefaults.standardUserDefaults().integerForKey("transactionCount")
//                        
//                        self.collectionView.reloadData()
//                    }
//                } else {
//                    if !Reachability.isConnectedToNetwork() {
//                        UIAlertController.displayNoInternetConnectionError(self)
//                    } else {
//                        UIAlertController.displaySomethingWentWrongError(self)
//                    }
//                }
//                
//                
//                println(error)
//        })
    }
    
    func fireRefreshToken(showHud: Bool) {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            self.refreshTokenCtr++;
            if successful {
                if self.refreshTokenCtr > 1 {
                    self.fireDeleteRegistration(SessionManager.gcmToken())
                } else {
                    SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                    self.fireStoreInfo(showHud)
                }
                
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                })
            }
        })
    }
    
    //MARK: -
    //MARK: - Other Functions
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
        if self.storeInfo != nil {
            if self.storeInfo.firstName.trim().isEmpty && self.storeInfo.lastName.trim().isEmpty && self.storeInfo.email.trim().isEmpty {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func checkIfNewStore() -> Bool {
        if self.storeInfo != nil {
            if self.storeInfo.store_name.trim().isEmpty {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func logoutUser() {
        self.ctr = 0
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "rememberMe")
        SessionManager.setAccessToken("")
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.changeRootToDashboard()
    }
    
    
    
}

