//
//  ProductUploadBrandViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Delegate
// ProductUploadBrandViewController Delegate method
protocol ProductUploadBrandViewControllerDelegate {
    func productUploadBrandViewController(didSelectBrand brand: String, brandModel: BrandModel)
}

class ProductUploadBrandViewController: UIViewController, UITabBarControllerDelegate, UITableViewDataSource {
    
    // Tableview
    @IBOutlet weak var tableView: UITableView!
    
    // Textfield
    @IBOutlet weak var brandTextField: UITextField!
    
    // Models
    var selectedBrandModel: BrandModel = BrandModel(name: "", brandId: 0)
    
    // Global variables
    var brands: NSMutableArray = NSMutableArray()
    var hud: MBProgressHUD?
    var searchTask: NSURLSessionDataTask?
    
    // Initialize ProductUploadBrandViewControllerDelegate
    var delegate: ProductUploadBrandViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar title
        self.title = Constants.ViewControllersTitleString.addBrand
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.backButton()
        self.checkButton()
        self.registerCell()
        
        // Add texfield action
        self.brandTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        // Remove tableview footer
        let footerView: UIView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = footerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation Bar
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
    
    // Add check button in navigation bar
    func checkButton() {
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 40, 40)
        checkButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer, customCheckButton]
    }
    
    // Navigation bar button actions
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func check() {
        self.delegate!.productUploadBrandViewController(didSelectBrand: self.brandTextField.text, brandModel: self.selectedBrandModel)
        self.back()
    }
    
    // MARK: Private Methods
    func registerCell() {
        let nib: UINib = UINib(nibName: ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier)
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
    
    // MARK: - Show HUD
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
    
    func textFieldDidChange(sender: UITextField) {
        self.fireBrandWithKeyWord(sender.text)
    }
    
    // MARK: Table view data source methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brands.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let brandModel: BrandModel = self.brands.objectAtIndex(indexPath.row) as! BrandModel
        let cell: ProductUploadCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier) as! ProductUploadCategoryTableViewCell
        cell.categoryTitleLabel.text = brandModel.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let brandModel: BrandModel = self.brands.objectAtIndex(indexPath.row) as! BrandModel
        self.selectedBrandModel = brandModel
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.brandTextField.text = brandModel.name
    }

    // MARK: -
    // MARK: - REST API request
    // MARK: GET METHOD - Fire Brand
    /*
    *
    * (Parameters) - access_token, brandKeyword
    *
    * Function to get brand list
    *
    */
    func fireBrandWithKeyWord(keyWord: String) {
        
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken(), "brandKeyword": keyWord]
        
        /*if self.searchTask != nil {
            self.searchTask!.cancel()
        }*/
        
        WebServiceManager.fireGetProductUploadRequestWithUrl(APIAtlas.brandUrl, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                let data: [NSDictionary] = responseObject["data"] as! [NSDictionary]
                self.brands.removeAllObjects()
                for brandDictionary in data {
                    let brandModel: BrandModel = BrandModel(name: brandDictionary["name"] as! String, brandId: brandDictionary["brandId"] as! Int)
                    self.brands.addObject(brandModel)
                }
                self.tableView.reloadData()
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshTokenWithKeyWord(keyWord)
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
        let manager: APIManager = APIManager.sharedInstance
        
        self.searchTask = manager.GET(APIAtlas.brandUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            let dictionary: NSDictionary = responseObject as! NSDictionary
            let isSuccessful = dictionary["isSuccessful"] as! Bool
            let data: [NSDictionary] = dictionary["data"] as! [NSDictionary]
            if isSuccessful {
                self.brands.removeAllObjects()
                for brandDictionary in data {
                    let brandModel: BrandModel = BrandModel(name: brandDictionary["name"] as! String, brandId: brandDictionary["brandId"] as! Int)
                    self.brands.addObject(brandModel)
                }
                self.tableView.reloadData()
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                if error.code != NSURLErrorCancelled {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshTokenWithKeyWord(keyWord)
                    } else {
                        if error.userInfo != nil {
                            let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                            let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                            self.showAlert(Constants.Localized.error, message: errorModel.message)
                        } else {
                            self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                        }
                    }
                }
            })*/
    }
    
    // MARK: POST METHOD - Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    * Function to refresh token to get another access token
    *
    */
    func fireRefreshTokenWithKeyWord(keyWord: String) {
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
            self.fireBrandWithKeyWord(keyWord)
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
