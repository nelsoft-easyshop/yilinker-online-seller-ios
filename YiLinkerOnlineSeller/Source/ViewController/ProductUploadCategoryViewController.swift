//
//  ProductUploadCategoryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Delegate
// ProductUploadCategoryViewController delegate method
protocol ProductUploadCategoryViewControllerDelegate {
    func productUploadCategoryViewController(didSelectCategory category: String)
}

// MARK: Constant variable declarations
struct ProductUploadCategoryViewControllerConstant {
    static let productUploadCategoryTableViewCellNibNameAndIdentifier = "ProductUploadCategoryTableViewCell"
}

class ProductUploadCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Tableview
    @IBOutlet weak var tableView: UITableView!
    
    // Models
    var categories: [CategoryModel] = []
    
    // Global variables
    var hud: MBProgressHUD?
    var userType: UserType?
    
    var parentID: Int = 1
    var pageTitle: String = ""
    
    // Initialize ProductUploadCategoryViewControllerDelegate
    var delegate: ProductUploadCategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set navigation bar title
        self.title = self.pageTitle
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.backButton()
        self.footerView()
        self.registerCell()
        
        self.fireCategoryWithParentID(self.parentID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation bar
    // Add back button in navigation bar
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
    
    // Add search button in navigation bar
    func searchButton() {
        var searchButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        searchButton.frame = CGRectMake(0, 0, 40, 40)
        searchButton.addTarget(self, action: "search", forControlEvents: UIControlEvents.TouchUpInside)
        let image: UIImage = UIImage(named: "search")!
        let tintedImage = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        searchButton.setImage(tintedImage, forState: UIControlState.Normal)
        searchButton.tintColor = UIColor.whiteColor()
        
        var customSearchButton:UIBarButtonItem = UIBarButtonItem(customView: searchButton)
        customSearchButton.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer, customSearchButton]
    }

    // Navigation bar button actions
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func search() {
        let modalStyle = UIModalTransitionStyle.CrossDissolve
        let searchViewController: ProductUploadSearchViewController = ProductUploadSearchViewController(nibName: "ProductUploadSearchViewController", bundle: nil)
        let navigationController: UINavigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
        searchViewController.modalTransitionStyle = modalStyle
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    // MARK: Private methods
    // MARK: Remove table view footer
    func footerView() {
        let footerView: UIView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = footerView
    }
    
    // MARK: Register tableview cell
    func registerCell() {
        let nib: UINib = UINib(nibName: ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier)
    }
    
    //MARK: Alert view
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    //MARK: Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    // MARK: Table view delegate and data source methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let categoryModel: CategoryModel = self.categories[indexPath.row]
        let cell: ProductUploadCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier) as! ProductUploadCategoryTableViewCell
        cell.categoryTitleLabel.text = categoryModel.name
        
        if categoryModel.hasChildren == "1" {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        var categoryModel: CategoryModel = self.categories[indexPath.row]
        
        if self.userType == UserType.Seller {
            if categoryModel.hasChildren == "1" {
                let productUploadCategoryViewController: ProductUploadCategoryViewController = ProductUploadCategoryViewController(nibName: "ProductUploadCategoryViewController", bundle: nil)
                productUploadCategoryViewController.pageTitle = categoryModel.name
                productUploadCategoryViewController.parentID = categoryModel.uid
                productUploadCategoryViewController.userType = self.userType
                self.navigationController!.pushViewController(productUploadCategoryViewController, animated: true)
            } else {
                let uploadViewController: ProductUploadTableViewController = self.navigationController!.viewControllers[0] as! ProductUploadTableViewController
                uploadViewController.didSelecteCategory(categoryModel)
                self.navigationController!.popToRootViewControllerAnimated(true)
                
            }
        } else {
            let resellerViewController: ResellerItemViewController = ResellerItemViewController(nibName: "ResellerItemViewController", bundle: nil)
            resellerViewController.categoryModel = categoryModel
            self.navigationController?.pushViewController(resellerViewController, animated: true)
        }
    }
    
    //MARK: -
    //MARK: - REST API request
    //MARK: GET METHOD - Fire Category With Parent ID
    /*
    *
    * (Parameters) - access_token, parentId
    *
    *Function to get list of category
    *
    */
    func fireCategoryWithParentID(parentID: Int) {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        
        let parentIDKey = "parentId"
        let accessTokenKey = "access_token"
        let parameters: NSDictionary = [accessTokenKey: SessionManager.accessToken(), parentIDKey: parentID]
        
        manager.GET(APIAtlas.categoryUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            let dictionary: NSDictionary = responseObject as! NSDictionary
            let isSuccessful = dictionary["isSuccessful"] as! Bool
            
            if isSuccessful {
                let data: NSArray = dictionary["data"] as! NSArray
                
                for categoryDictionary in data as! [NSDictionary] {
                    let categoryModel: CategoryModel = CategoryModel(uid: categoryDictionary["productCategoryId"] as! Int, name: categoryDictionary["name"] as! String, hasChildren: categoryDictionary["hasChildren"] as! String)
                    self.categories.append(categoryModel)
                }
            }
            self.tableView.reloadData()
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken(parentID)
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
    
    //MARK: POST METHOD - Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    *Function to refresh token to get another access token
    *
    */
    func fireRefreshToken(parentID: Int) {
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
            self.fireCategoryWithParentID(parentID)
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

    // Dealloc
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
}
