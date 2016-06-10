//
//  WarehouseProductDetailViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Elbert Philip O. Yagaya on 4/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WarehouseProductDetailViewController: UIViewController {
    
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var systemInventoryLabel: UILabel!
    @IBOutlet weak var actualInventoryLabel: UILabel!
    @IBOutlet weak var skuTextField: UITextField!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var systemInventoryTextField: UITextField!
    @IBOutlet weak var actualInventoryTextField: UITextField!
    
    var warehouseProduct: WarehouseInventoryProduct!
    var warehouseId: String = ""
    
    override func viewDidLoad() {
        self.title = "Warehouse Product Detail"
        self.initializedNavigationBarItems()

        self.title = self.warehouseProduct.name
        self.skuTextField.text = self.warehouseProduct.sku
        self.productNameTextField.text = self.warehouseProduct.name
        self.systemInventoryTextField.text = "\(self.warehouseProduct.quantity)"
        self.actualInventoryTextField.text = "\(self.warehouseProduct.quantity)"
        
    }
    
    func initializedNavigationBarItems() {
        self.title = StringHelper.localizedStringWithKey("Add Warehouse")
        
        var backButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 20, 20)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "close-1"), forState: UIControlState.Normal)
        var customBackButton: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = 0
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        var addButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        addButton.frame = CGRectMake(0, 0, 20, 20)
        addButton.setImage(UIImage(named: "check-1"), forState: UIControlState.Normal)
        addButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        var customAddButton: UIBarButtonItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = customAddButton
        
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        println("save product edit, API CALL")
        if self.actualInventoryTextField.text == "" {
            self.showAlert("Please add actual inventory.", message: "")
        } else {
            self.fireUpdateInventory()
        }
    }
    
    // MARK: -
    // MARK: - Alert view
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    // MARK: -
    // MARK: - POST METHOD: Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    * Function to refresh token to get another access token
    *
    */
    
    func fireRefreshToken() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireUpdateInventory()
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                })
            }
        })
    }
    
    func fireUpdateInventory() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var parameters: NSMutableDictionary  = ["warehouseId" : self.warehouseId, "productUnit" : self.warehouseProduct.productUnitId, "quantity" : self.actualInventoryTextField.text]
        
        WebServiceManager.fireAddWarehouseAddressRequestWithUrl(APIAtlas.updateInventory + SessionManager.accessToken(), parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if let success = responseObject["isSuccessful"] as? Bool {
                    if success {
                        Toast.displayToastWithMessage(responseObject["message"] as! String, duration: 1.5, view: self.view)
                        Delay.delayWithDuration(1.5, completionHandler: { (success) -> Void in
                            self.back()
                        })
                    } else {
                        Toast.displayToastWithMessage(responseObject["message"] as! String, duration: 1.5, view: self.view)
                    }
                }
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            } else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
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

}

