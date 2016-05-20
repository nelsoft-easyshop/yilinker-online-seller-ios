//
//  ProductUploadCategoryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Constant variable declarations
struct ProductUploadCategoryViewControllerConstant {
    static let productUploadCategoryTableViewCellNibNameAndIdentifier = "ProductUploadCategoryTableViewCell"
}

class ProductUploadCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Tableview
    @IBOutlet weak var tableView: UITableView!
    
    // Models
    var categories: [CategoryModel] = []
    var shippingCategories: [ConditionModel] = []
    var productGroups: [ConditionModel] = []
    var selectedProductGroups: [ConditionModel] = []
    var productGroupId: [Int] = []
    var productGroup: [Bool] = []
    
    // Global variables
    var hud: MBProgressHUD?
    var userType: UserType?
    var productCategory: UploadProduct = UploadProduct.ProductCategory
    var parentID: Int = 1
    var pageTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.backButton()
        self.footerView()
        self.registerCell()
        
        for i in 0..<self.selectedProductGroups.count {
            if !contains(self.productGroupId, self.selectedProductGroups[i].uid) {
                self.productGroupId.append(self.selectedProductGroups[i].uid)
            }
        }
        
        if self.productCategory == UploadProduct.ProductCategory {
            // Set navigation bar title
            self.title = self.pageTitle
            self.fireCategoryWithParentID(self.parentID)
        } else if self.productCategory == UploadProduct.ShippingCategory {
            self.fireShippingCategories()
            // Set navigation bar title
            self.title = "Select Shipping Category"
        } else {
            self.fireProductGroup()
            // Set navigation bar title
            self.title = "Select Product Group"
        }
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
        
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check-white"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        checkButton.hidden = true
        
        if self.productCategory == UploadProduct.ProductGroups {
            checkButton.hidden = false
        }
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
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

    // MARK: -
    // MARK: - Navigation bar button actions
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func check() {
        let uploadViewController: ProductUploadTC = self.navigationController!.viewControllers[0] as! ProductUploadTC
        self.selectedProductGroups.removeAll(keepCapacity: false)
        for i in 0..<self.productGroup.count {
            if self.productGroup[i] == true {
                self.selectedProductGroups.append(self.productGroups[i])
            }
        }
        uploadViewController.selectedProductGroup(self.selectedProductGroups)
        
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    func search() {
        let modalStyle = UIModalTransitionStyle.CrossDissolve
        let searchViewController: ProductUploadSearchViewController = ProductUploadSearchViewController(nibName: "ProductUploadSearchViewController", bundle: nil)
        let navigationController: UINavigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
        searchViewController.modalTransitionStyle = modalStyle
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: - Private methods
    // MARK: - Remove table view footer
    
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
        let cell: ProductUploadCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier) as! ProductUploadCategoryTableViewCell
        
        if self.productCategory == UploadProduct.ProductCategory {
            let categoryModel: CategoryModel = self.categories[indexPath.row]
            
            cell.categoryTitleLabel.text = categoryModel.name
            
            if categoryModel.hasChildren == "1" {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
        } else if self.productCategory == UploadProduct.ShippingCategory {
            let shippingCategoryModel: ConditionModel = self.shippingCategories[indexPath.row]
            
            cell.categoryTitleLabel.text = shippingCategoryModel.name
            cell.accessoryType = UITableViewCellAccessoryType.None
        } else {
            let productGroup: ConditionModel = self.productGroups[indexPath.row]
            cell.categoryTitleLabel.text = productGroup.name
            if self.productGroup[indexPath.row] == true {
                //cell.categoryTitleLabel.text = productGroup.name + "*"
                cell.selected = true
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                /*if cell.selected {
                cell.selected = false
                if cell.accessoryType == UITableViewCellAccessoryType.None {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
                }
                }*/
                //cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.categoryTitleLabel.text = productGroup.name
                //cell.selected = false
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            
            
            /*
            if cell.selected {
                cell.selected = false
                if cell.accessoryType == UITableViewCellAccessoryType.None {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            }*/
        }

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.productCategory == UploadProduct.ProductCategory {
            return self.categories.count
        } else if self.productCategory == UploadProduct.ShippingCategory{
            return self.shippingCategories.count
        } else {
            return self.productGroups.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        var categoryModel: CategoryModel = CategoryModel()
        var shippingCategoriesModel: ConditionModel = ConditionModel(uid: 0, name: "")
        var productGroupsModel: ConditionModel = ConditionModel(uid: 0, name: "")
        
        if self.productCategory == UploadProduct.ProductCategory {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            categoryModel = self.categories[indexPath.row]
        } else if self.productCategory == UploadProduct.ShippingCategory {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            shippingCategoriesModel = self.shippingCategories[indexPath.row]
        } else {
            productGroupsModel = self.productGroups[indexPath.row]
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            println(self.productGroup)
            if cell!.selected {
                cell!.selected = false
                if cell!.accessoryType == UITableViewCellAccessoryType.None {
                    cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                    self.productGroup.removeAtIndex(indexPath.row)
                    self.productGroup.insert(true, atIndex: indexPath.row)
                } else {
                    cell!.accessoryType = UITableViewCellAccessoryType.None
                    println("row: \(indexPath.row)")
                    self.productGroup.removeAtIndex(indexPath.row)
                    self.productGroup.insert(false, atIndex: indexPath.row)
                    //self.selectedProductGroups.removeAtIndex(indexPath.row)
                    println(self.productGroup.count)
                }
            }
        }
        
        if self.userType == UserType.Seller {
            if categoryModel.hasChildren == "1" {
                let productUploadCategoryViewController: ProductUploadCategoryViewController = ProductUploadCategoryViewController(nibName: "ProductUploadCategoryViewController", bundle: nil)
                productUploadCategoryViewController.pageTitle = categoryModel.name
                productUploadCategoryViewController.parentID = categoryModel.uid
                productUploadCategoryViewController.userType = self.userType
                self.navigationController!.pushViewController(productUploadCategoryViewController, animated: true)
            } else {
                let uploadViewController: ProductUploadTC = self.navigationController!.viewControllers[0] as! ProductUploadTC
                if self.productCategory == UploadProduct.ProductCategory {
                    uploadViewController.selectedCategory(categoryModel)
                    self.navigationController!.popToRootViewControllerAnimated(true)
                } else if self.productCategory == UploadProduct.ShippingCategory {
                    uploadViewController.selectedShippingCategory(shippingCategoriesModel)
                    self.navigationController!.popToRootViewControllerAnimated(true)
                }
            }
        } else {
            let resellerViewController: ResellerItemViewController = ResellerItemViewController(nibName: "ResellerItemViewController", bundle: nil)
            resellerViewController.categoryModel = categoryModel
            self.navigationController?.pushViewController(resellerViewController, animated: true)
        }
    }
    
    //MARK: -
    //MARK: - REST API request
    //MARK: - GET METHOD: Fire Category With Parent ID
    /*
    *
    * (Parameters) - access_token, parentId
    *
    *Function to get list of category
    *
    */
    
    func fireCategoryWithParentID(parentID: Int) {
        self.showHUD()
        
        let parentIDKey = "parentId"
        let accessTokenKey = "access_token"
        let parameters: NSDictionary = [accessTokenKey: SessionManager.accessToken(), parentIDKey: parentID]
        
        WebServiceManager.fireGetProductUploadRequestWithUrl(APIAtlas.categoryUrl, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                
                let dictionary: NSDictionary = responseObject as! NSDictionary
                let data: NSArray = dictionary["data"] as! NSArray
                
                for categoryDictionary in data as! [NSDictionary] {
                    let categoryModel: CategoryModel = CategoryModel(uid: categoryDictionary["productCategoryId"] as! Int, name: categoryDictionary["name"] as! String, hasChildren: categoryDictionary["hasChildren"] as! String)
                    self.categories.append(categoryModel)
                }
                
                self.tableView.reloadData()
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(parentID, uploadProduct: UploadProduct.ProductCategory)
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        })
        /*
        let manager = APIManager.sharedInstance
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
        })*/
    }
    
    // MARK: -
    // MARK: - POST METHOD: Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    *Function to refresh token to get another access token
    *
    */
    
    func fireRefreshToken(parentID: Int, uploadProduct: UploadProduct) {
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
            
            if uploadProduct == UploadProduct.ProductCategory {
                self.fireCategoryWithParentID(parentID)
            } else {
                self.fireShippingCategories()
            }
            
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
    
    // MARK: -
    // MARK: - GET METHOD: Shipping Categories
    /*
    *
    * (Parameters) - access_token
    *
    * Function to get shipping categories
    *
    */
    
    func fireShippingCategories() {
        self.showHUD()
        
        WebServiceManager.fireGetProductUploadV3RequestWithUrl(APIAtlas.shippingCategoriesUrl+"?access_token=\(SessionManager.accessToken())", actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                let conditionParseModel: ConditionParserModel = ConditionParserModel.parseDataFromDictionary(responseObject as! NSDictionary)
                
                let uidKey = "shippingCategoryId"
                let nameKey = "name"
                
                for dictionary in conditionParseModel.data as [NSDictionary] {
                    let condition: ConditionModel = ConditionModel(uid: dictionary[uidKey] as! Int, name: dictionary[nameKey] as! String)
                    self.shippingCategories.append(condition)
                }
                
                self.tableView.reloadData()
                
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(0, uploadProduct: UploadProduct.ShippingCategory)
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        })
    }
    
    // MARK: -
    // MARK: - GET METHOD: Product Group
    /*
    *
    * (Parameters) - access_token
    *
    * Function to get Product Groups
    *
    */
    
    func fireProductGroup() {
        self.showHUD()
        
        WebServiceManager.fireGetProductUploadV3RequestWithUrl(APIAtlas.productGroupsUrl+"?access_token=\(SessionManager.accessToken())", actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                let conditionParseModel: ConditionParserModel = ConditionParserModel.parseDataFromDictionary(responseObject as! NSDictionary)
                
                let uidKey = "id"
                let nameKey = "name"
                
                for dictionary in conditionParseModel.data as [NSDictionary] {
                    let condition: ConditionModel = ConditionModel(uid: dictionary[uidKey] as! Int, name: dictionary[nameKey] as! String)
                    self.productGroups.append(condition)
                    if contains(self.productGroupId, condition.uid) {
                        self.productGroup.append(true)
                    } else {
                       self.productGroup.append(false)
                    }
                }
                /*
                if self.productGroup.count != 0 {
                    for i in 0..<self.productGroup.count {
                        if self.selectedProductGroups.count != 0 {
                            if !contains(self.productGroupId, self.selectedProductGroups[i].uid) {
                                self.productGroupId.append(self.selectedProductGroups[i].uid)
                                
                            } else {
                                self.productGroup.removeAtIndex(i)
                                self.productGroup.insert(false, atIndex: i)
                            }
                        }
                    }
                }*/
                
                self.tableView.reloadData()
                
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(0, uploadProduct: UploadProduct.ProductGroups)
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        })
    }

    // Dealloc
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
}
