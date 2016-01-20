//
//  CustomizedCategoryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct CategoryStrings {
    static let titleCategory = StringHelper.localizedStringWithKey("CATEGORY_TITLE_LOCALIZE_KEY")
    static let details = StringHelper.localizedStringWithKey("CATEGORY_DETAILS_LOCALIZE_KEY")
    static let categoryName = StringHelper.localizedStringWithKey("CATEGORY_NAME_LOCALIZE_KEY")
    static let categoryParent = StringHelper.localizedStringWithKey("CATEGORY_PARENT_LOCALIZE_KEY")
    static let none = StringHelper.localizedStringWithKey("CATEGORY_NONE_LOCALIZE_KEY")
    static let categorySubCategories = StringHelper.localizedStringWithKey("CATEGORY_SUB_CATEGORIES_LOCALIZE_KEY")
    static let categoryAddSub = StringHelper.localizedStringWithKey("CATEGORY_ADD_SUB_LOCALIZE_KEY")
    static let categoryItems = StringHelper.localizedStringWithKey("CATEGORY_ITEMS_UNDER_LOCALIZE_KEY")
    static let categoryNewItems = StringHelper.localizedStringWithKey("CATEGORY_NEW_ITEM_LOCALIZE_KEY")
    static let categoryEdit = StringHelper.localizedStringWithKey("CATEGORY_EDIT_LOCALIZE_KEY")
    static let categorySeeAll = StringHelper.localizedStringWithKey("CATEGORY_SEE_ALL_LOCALIZE_KEY")
    static let categoryItems2 = StringHelper.localizedStringWithKey("CATEGORY_ITEMS_LOCALIZE_KEY")
    static let categoryNameEmpty = StringHelper.localizedStringWithKey("CATEGORY_NAME_EMPTY_LOCALIZE_KEY")
    
    static let titleAddCustomized = StringHelper.localizedStringWithKey("CATEGORY_ADD_CUSTOMIZED_LOCALIZE_KEY")
    static let search = StringHelper.localizedStringWithKey("CATEGORY_SEARCH_LOCALIZE_KEY")
    
    static let titleEditCustomized = StringHelper.localizedStringWithKey("CATEGORY_EDIT_SUB_TITLE_LOCALIZE_KEY")
    static let subRemoveCategories = StringHelper.localizedStringWithKey("CATEGORY_REMOVE_CATEGORIES_LOCALIZE_KEY")
    static let subAddCategories = StringHelper.localizedStringWithKey("CATEGORY_ADD_CATEGORIES_LOCALIZE_KEY")
    static let subClearAll = StringHelper.localizedStringWithKey("CATEGORY_CLEAR_ALL_LOCALIZE_KEY")
    static let subRemovedSelected = StringHelper.localizedStringWithKey("CATEGORY_REMOVED_SELECTED_LOCALIZE_KEY")
    static let subCancel = StringHelper.localizedStringWithKey("CATEGORY_CANCEL_LOCALIZE_KEY")
    static let titleAddCategories = StringHelper.localizedStringWithKey("CATEGORY_ADD_CATEGORY_TITLE_LOCALIZE_KEY")
    static let subEditCategory = StringHelper.localizedStringWithKey("CATEGORY_EDIT_CATEGORY_TITLE_LOCALIZE_KEY")
    
    static let titleAddItems = StringHelper.localizedStringWithKey("CATEGORY_ADD_ITEMS_TITLE_LOCALIZE_KEY")
    static let titleEditItems = StringHelper.localizedStringWithKey("CATEGORY_EDIT_ITEMS_TITLE_LOCALIZE_KEY")
    static let itemRemoveItems = StringHelper.localizedStringWithKey("CATEGORY_REMOVE_ITEMS_LOCALIZE_KEY")
}

class CustomizedCategoryViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var parentCategory: [String] = []
    var subCategories: [NSArray] = []
    var categoryItems: [NSArray] = []
    
    var hud: MBProgressHUD?
    
    var customizedCategoriesModel: CustomizedCategoriesModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "CustomizedCategoryTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "CustomizedCategory")
        
        customizedNavigationBar()
        requestGetCustomizedCategories()
        self.emptyLabel.text = StringHelper.localizedStringWithKey("EMPTY_LABEL_NO_CATEGORY_FOUND_LOCALIZE_KEY")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if customizedCategoriesModel != nil {
            requestGetCustomizedCategories()
        }
    }
    
    // MARK: - Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = CategoryStrings.titleCategory
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "addCategory"), style: .Plain, target: self, action: "addCategoryAction"), navigationSpacer]
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
    
    // MARK: - Actions
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addCategoryAction() {
        let addCustomizedCategory = AddCustomizedCategoryViewController(nibName: "AddCustomizedCategoryViewController", bundle: nil)
        addCustomizedCategory.title = CategoryStrings.titleAddCustomized
        addCustomizedCategory.isNew = true
        addCustomizedCategory.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addCustomizedCategory, animated: true)
    }
    
    // MARK: - Requests
    
    func requestGetCustomizedCategories() {
        if Reachability.isConnectedToNetwork() {
            if self.customizedCategoriesModel == nil {
                self.showHUD()
            }
            
            WebServiceManager.fireGetCustomizedCategoriesRequestWithUrl(APIAtlas.getCustomizedCategories, actionHandler: {
                (successful, responseObject, requestErrorType) -> Void in
                if successful {
                    self.customizedCategoriesModel = CustomizedCategoriesModel.parseDataWithDictionary(responseObject as! NSDictionary)
                    
                    if self.customizedCategoriesModel.customizedCategories.count != 0 {
                        self.tableView.reloadData()
                    } else {
                        self.emptyLabel.hidden = false
                    }
                    self.hud?.hide(true)
                } else {
                    self.hud?.hide(true)
                    if requestErrorType == .ResponseError {
                        //Error in api requirements
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                    } else if requestErrorType == .AccessTokenExpired {
                        self.requestRefreshToken()
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
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.failed)
        }
        
    }
    
    func requestDeleteCustomizedCategories(categoryId: Int) {
        self.showHUD()
        
        WebServiceManager.fireDeleteCustomizedCategoryRequestWithUrl(APIAtlas.deleteCustomizedCategory, categoryId: categoryId, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.hud?.hide(true)
                self.tableView.reloadData()
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken()
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
    
    func requestRefreshToken() {
        
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.loginUrl, actionHandler: { (successful, responseObject, RequestErrorType) -> Void in
            if successful {
                self.hud?.hide(true)
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.requestGetCustomizedCategories()
            } else {
                //Forcing user to logout.
                self.hud?.hide(true)
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logout()
                    GPPSignIn.sharedInstance().signOut()
                    self.navigationController?.popToRootViewControllerAnimated(false)
                })
            }
        })
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if customizedCategoriesModel == nil {
            return 0
        }
        
        return customizedCategoriesModel.customizedCategories.count//parentCategory.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CustomizedCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CustomizedCategory") as! CustomizedCategoryTableViewCell
        cell.selectionStyle = .None
        
        cell.parentCategoryLabel.text = customizedCategoriesModel.customizedCategories[indexPath.row].name
//        cell.subCategoriesLabel.text = String(customizedCategoriesModel.customizedCategories[indexPath.row].categoryId)
        
        
//        let subCategoriesArray: NSArray = self.subCategories[indexPath.row]
//        var sub: String = ""
//        for i in 0..<subCategoriesArray.count {
//            sub += subCategoriesArray[i] as! String
//            if i != subCategoriesArray.count - 1 {
//                sub += ", "
//            }
//        }
//        cell.subCategoriesLabel.text = sub
        
//        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        cell.selectionStyle = .None
//        cell.textLabel?.text = "Sub Category " + String(indexPath.row)
//        cell.textLabel?.font = UIFont(name: "Panton-Bold", size: 12.0)
//        cell.textLabel?.textColor = Constants.Colors.hex666666
//        cell.detailTextLabel.text = "Sub Categories"
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if Reachability.isConnectedToNetwork() {
            let addCustomizedCategory = AddCustomizedCategoryViewController(nibName: "AddCustomizedCategoryViewController", bundle: nil)
            addCustomizedCategory.title = CategoryStrings.titleEditCustomized
            addCustomizedCategory.requestGetCategoryDetails(self.customizedCategoriesModel.customizedCategories[indexPath.row].categoryId)
            addCustomizedCategory.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(addCustomizedCategory, animated: true)
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.failed)
        }
        // to delete categories
//        requestDeleteCustomizedCategories(self.customizedCategoriesModel.customizedCategories[indexPath.row].categoryId)
    }
    
    func passNewCategory(category: String) {
        
    }
    
}
