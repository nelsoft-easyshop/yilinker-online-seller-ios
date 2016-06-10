//
//  ParentCategoryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ParentCategoryViewControllerDelegate {
    func updateParentCategory(parentCategory: String, parentId: Int)
}

class ParentCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: ParentCategoryViewControllerDelegate?
    var customizedCategoriesModel: CustomizedCategoriesModel!
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var selectedParentId: Int = 0
    
    var hud: MBProgressHUD?
    var requestTask: NSURLSessionDataTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if Reachability.isConnectedToNetwork() {
            requestGetCustomizedCategories("")
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.failed)
        }
        customizedNavigationBar()
        customizedViews()
        
    }
    
    // MARK: - Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = CategoryStrings.categoryParent
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeAction")
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "nav-check"), style: .Plain, target: self, action: "checkAction"), navigationSpacer]
    }
    
    func customizedViews() {
        self.searchBarTextField.layer.cornerRadius = searchBarTextField.frame.size.height / 2
        self.searchBarTextField.placeholder = CategoryStrings.search
        	
        var searchImage = UIImageView(image: UIImage(named: "search2"))
        searchImage.frame = CGRectMake(0.0, 0.0,40.0, 40.0)
        searchImage.contentMode = UIViewContentMode.Center
        searchBarTextField.leftView = searchImage
        searchBarTextField.leftViewMode = UITextFieldViewMode.Always
        searchBarTextField.addTarget(self, action: "searchBarTextDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.emptyLabel.text = StringHelper.localizedStringWithKey("EMPTY_LABEL_NO_CATEGORY_FOUND_LOCALIZE_KEY")
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
    
    // MARK: - Requests
    
    func requestGetCustomizedCategories(key: String) {
        if Reachability.isConnectedToNetwork() {
            self.showHUD()
            
            WebServiceManager.fireGetParentCategoryRequestWithUrl(APIAtlas.getCustomizedCategories, key: key, actionHandler: {
                (successful, responseObject, requestErrorType) -> Void in
                if successful {
                    self.customizedCategoriesModel = CustomizedCategoriesModel.parseDataWithDictionary(responseObject as! NSDictionary)
                    
                    if self.customizedCategoriesModel.customizedCategories.count != 0 {
                        self.tableView.reloadData()
                        self.tableView.hidden = false
                        self.emptyLabel.hidden = true
                    } else {
                        self.emptyLabel.hidden = false
                        self.tableView.hidden = true
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
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.error)
        }
    }
    
    func requestRefreshToken() {
        
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.loginUrl, actionHandler: { (successful, responseObject, RequestErrorType) -> Void in
            if successful {
                self.hud?.hide(true)
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.requestGetCustomizedCategories(self.searchBarTextField.text)
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
    
    // MARK: - Actions
    
    func closeAction() {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func checkAction() {
        if self.selectedParentId != 0 {
            for i in 0..<customizedCategoriesModel.customizedCategories.count {
                if self.selectedParentId == customizedCategoriesModel.customizedCategories[i].categoryId {
                    delegate?.updateParentCategory(customizedCategoriesModel.customizedCategories[i].name,
                                         parentId: customizedCategoriesModel.customizedCategories[i].categoryId)
                    break
                }
            }
        } else {
            delegate?.updateParentCategory("NONE", parentId: 0)
        }
        
        closeAction()
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.customizedCategoriesModel != nil {
            return self.customizedCategoriesModel.customizedCategories.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
        
        cell.selectionStyle = .None
        cell.textLabel?.text = customizedCategoriesModel.customizedCategories[indexPath.row].name
        cell.textLabel?.font = UIFont(name: "Panton", size: 12.0)
        
        if selectedParentId == customizedCategoriesModel.customizedCategories[indexPath.row].categoryId {
            var check = UIImageView(frame: CGRectMake(0, 0, 10, 10))
            check.image = UIImage(named: "checkCategory")
            cell.accessoryView = check
        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.selectedParentId == customizedCategoriesModel.customizedCategories[indexPath.row].categoryId {
            self.selectedParentId = 0
        } else {
            self.selectedParentId = customizedCategoriesModel.customizedCategories[indexPath.row].categoryId
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Text Field Delegates
    
    func searchBarTextDidChanged(textField: UITextField) {
        if count(self.searchBarTextField.text) > 2 || self.searchBarTextField.text == "" {
            requestGetCustomizedCategories(self.searchBarTextField.text)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.searchBarTextField.resignFirstResponder()
        
        return true
    }
    
}
