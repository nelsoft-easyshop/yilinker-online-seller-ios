//
//  LanguageTranslationPickerTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/26/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class LanguageTranslationPickerTableViewController: UITableViewController {
    
    var tableData: [ProductLanguageModel] = []
    
    var productId: String = ""
    
    var hud: MBProgressHUD?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializesViews()
        self.registerNibs()
        self.addBackButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fireGetLanguages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initializations
    func initializesViews() {
        self.title = StringHelper.localizedStringWithKey("TRANSLATION_TITLE")
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func registerNibs() {
        var nib = UINib(nibName: ProductManagementMenuTableViewCell.reuseIdentidifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: ProductManagementMenuTableViewCell.reuseIdentidifier)
    }
    
    func addBackButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //MARK: - Util Function
    //Loader function
    func showLoader() {
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
    
    //Hide loader
    func dismissLoader() {
        self.hud?.hide(true)
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.tableData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tempModel: ProductLanguageModel = self.tableData[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(ProductManagementMenuTableViewCell.reuseIdentidifier, forIndexPath: indexPath) as! ProductManagementMenuTableViewCell
        cell.selectionStyle = .None
        cell.setCellText("\(tempModel.languageName) - \(tempModel.countryName) (\(tempModel.languageCode) - \(tempModel.countryCode))")
        
        if tempModel.isSelected {
            cell.setCellTypeTextLabel(StringHelper.localizedStringWithKey("TRANSLATION_TRANSLATED"))
        } else {
            cell.setCellTypeTextLabel("")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let languageTranslation = LanguageTranslationTableViewController(nibName: "LanguageTranslationTableViewController", bundle: nil)
        languageTranslation.productLanguage = self.tableData[indexPath.row]
        languageTranslation.productId = self.productId
        self.navigationController?.pushViewController(languageTranslation, animated: true)
    }
    
    //MARK: -
    //MARK: - Fire Get Languages
    func fireGetLanguages() {
        self.showLoader()
        
        WebServiceManager.fireGetProductLanguageRequestWithUrl(APIAtlas.productLanguages, productId: self.productId, access_token: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
            self.dismissLoader()
            
            if successful {
                self.tableData = ProductLanguageModel.parseArrayDataWithDictionary(responseObject)
                self.tableView.reloadData()
            } else {
                
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(true)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.navigationController!.view)
                }

            }
        }
    }
    
    func fireRefreshToken(showHud: Bool) {
        self.showLoader()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireGetLanguages()
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                })
            }
        })
    }
    
}
