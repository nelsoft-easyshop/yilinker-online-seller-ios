//
//  AddWarehouseViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Elbert Philip O. Yagaya on 4/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class AddWarehouseViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!

    // Labels
    @IBOutlet weak var warehouseNameLabel: UILabel!
    @IBOutlet weak var fullAddressLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var cityMunLabel: UILabel!
    @IBOutlet weak var barangayDistrictLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var warehouseNameTextField: UITextField!
    @IBOutlet weak var fullAddressTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var cityMunTextField: UITextField!
    @IBOutlet weak var barangayDistrictTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    // Variables
    var selectedIndex: Int = 0
    var selectedTextField: UITextField?
    var textField: UITextField?
    
    // Models 
    var countryModel: WarehouseCountryModel?
    var provinceModel: WarehouseProvinceModel?
    var cityModel: WarehouseCityModel?
    var barangayModel: WarehouseBarangayModel?
    
    var countryId: String = ""
    var provinceId: String = ""
    var cityId: String = ""
    var barangayId: String = ""
    
    override func viewDidLoad() {
        self.initializedNavigationBarItems()
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
        self.warehouseNameLabel.required()
        self.fullAddressLabel.required()
        self.countryLabel.required()
        self.provinceLabel.required()
        self.cityMunLabel.required()
        self.barangayDistrictLabel.required()
        
        //self.warehouseNameTextField.delegate = self
        //self.fullAddressTextField.delegate = self
        self.countryTextField.delegate = self
        self.provinceTextField.delegate = self
        self.cityMunTextField.delegate = self
        self.barangayDistrictTextField.delegate = self
        
        self.warehouseNameTextField.placeholder = "Warehouse Name"
        self.fullAddressTextField.placeholder = "Full Address"
        self.countryTextField.placeholder = "Select Country"
        self.provinceTextField.placeholder = "Select Province"
        self.cityMunTextField.placeholder = "Select City/Municipality"
        self.barangayDistrictTextField.placeholder = "Select Barangay/District"
        self.zipCodeTextField.placeholder = "Zip Code"
        
        self.fireAddressByType(self.countryTextField)
        self.selectedTextField = self.countryTextField
        self.provinceTextField.userInteractionEnabled = false
        self.cityMunTextField.userInteractionEnabled = false
        self.barangayDistrictTextField.userInteractionEnabled = false
    }
    
    //MARK: Textfield delegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        self.selectedTextField = textField
       
        if self.countryModel != nil {
           self.addPicker(self.selectedIndex, textField: textField)
        } else if self.provinceModel != nil && self.countryId != "" {
            self.addPicker(self.selectedIndex, textField: textField)
        } else if self.cityModel != nil && self.provinceId != "" {
            self.addPicker(self.selectedIndex, textField: textField)
        } else if self.barangayModel != nil && self.cityId != "" {
            self.addPicker(self.selectedIndex, textField: textField)
        }
    }
    
    //MARK: Private Methods
    func addPicker(selectedIndex: Int, textField: UITextField) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(0, inComponent: 0, animated: false)
        textField.inputView = pickerView
        textField.addToolBarWithDoneTarget(self, done: "done")
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
        addButton.addTarget(self, action: "addWarehouse", forControlEvents: UIControlEvents.TouchUpInside)
        var customAddButton: UIBarButtonItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = customAddButton
        
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addWarehouse() {
        println("AddWarehouse, API CALL")
        if self.warehouseNameTextField.text == "" || self.fullAddressTextField.text == "" || self.countryTextField.text == "" || self.provinceTextField.text == "" || self.cityMunTextField.text == "" || self.barangayDistrictTextField.text == "" {
            self.showAlert("Fill-up the following textfields.", message: "")
        } else {
            self.fireAddWarehouse()
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
    
    //MARK: Pickerview delegate methods
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.selectedTextField == self.countryTextField && self.countryModel != nil {
            return self.countryModel!.location.count
        } else if selectedTextField == self.provinceTextField &&  self.provinceModel != nil {
            return self.provinceModel!.location.count
        } else if selectedTextField == self.cityMunTextField && self.cityModel != nil {
            return self.cityModel!.location.count
        } else if selectedTextField == self.barangayDistrictTextField && self.barangayModel != nil{
            return self.barangayModel!.location.count
        }
        
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if self.selectedTextField == self.countryTextField && self.countryModel != nil {
            return self.countryModel!.location[row]
        } else if selectedTextField == self.provinceTextField &&  self.provinceModel != nil {
            return self.provinceModel!.location[row]
        } else if selectedTextField == self.cityMunTextField && self.cityModel != nil {
            return self.cityModel!.location[row]
        } else if selectedTextField == self.barangayDistrictTextField && self.barangayModel != nil{
            return self.barangayModel!.location[row]
        }
        
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndex = row
        if self.selectedTextField == self.countryTextField && self.countryModel != nil{
            self.countryId = "\(self.countryModel!.countryId[row])"
            self.textField = self.provinceTextField
            
            if self.countryTextField.text != self.countryModel!.location[row] {
                self.provinceTextField.text = ""
                self.cityMunTextField.text = ""
                self.barangayDistrictTextField.text = ""
                self.zipCodeTextField.text = ""
                self.provinceId = ""
                self.cityId = ""
                self.barangayId = ""
            }
            
            self.countryTextField.text = self.countryModel!.location[row]
        } else if self.selectedTextField == self.provinceTextField && self.provinceModel != nil {
            self.provinceId = "\(self.provinceModel!.provinceId[row])"
            self.textField = self.cityMunTextField
            
            if self.provinceTextField.text != self.provinceModel!.location[row] {
                self.cityMunTextField.text = ""
                self.barangayDistrictTextField.text = ""
                self.zipCodeTextField.text = ""
                self.cityId = ""
                self.barangayId = ""
                self.cityModel = nil
                self.barangayModel = nil
            }
            
            self.provinceTextField.text = self.provinceModel!.location[row]
        } else if self.selectedTextField == self.cityMunTextField && self.cityModel != nil {
            self.cityId = "\(self.cityModel!.cityId[row])"
            self.textField = self.barangayDistrictTextField
            
            if self.cityMunTextField.text != self.cityModel!.location[row] {
                self.barangayDistrictTextField.text = ""
                self.zipCodeTextField.text = ""
                self.barangayId = ""
                self.barangayModel = nil
            }
            
            self.cityMunTextField.text = self.cityModel!.location[row]
        } else if self.selectedTextField == self.barangayDistrictTextField && self.barangayModel != nil {
            self.barangayId = "\(self.barangayModel!.barangayId[row])"
            self.textField = self.barangayDistrictTextField
            self.barangayDistrictTextField.text = self.barangayModel!.location[row]
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func done() {
        
        if self.countryTextField.text == "" && self.countryModel != nil {
            self.countryTextField.text = self.countryModel!.location[0]
            self.countryId = "\(self.countryModel!.countryId[0])"
            self.textField = self.provinceTextField
        }
        
        if self.provinceTextField.text == "" && self.provinceModel != nil {
            self.provinceTextField.text = self.provinceModel!.location[0]
            self.provinceId = "\(self.provinceModel!.provinceId[0])"
            self.textField = self.cityMunTextField
        }
        
        if self.cityMunTextField.text == "" && self.cityModel != nil {
            self.cityMunTextField.text = self.cityModel!.location[0]
            self.cityId = "\(self.cityModel!.cityId[0])"
            self.textField = self.barangayDistrictTextField
        }
        
        if self.barangayDistrictTextField.text == "" && self.barangayModel != nil {
            self.barangayDistrictTextField.text = self.barangayModel!.location[0]
            self.barangayId = "\(self.barangayModel!.barangayId[0])"
            self.textField = self.barangayDistrictTextField
        }
        
        self.selectedTextField = self.textField
        self.fireAddressByType(self.selectedTextField!)
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
    
    func fireRefreshToken(token: Int) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                if token == 1001 {
                    self.fireAddressByType(self.selectedTextField!)
                } else {
                    self.fireAddWarehouse()
                }
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                })
            }
        })
    }
    
    // MARK: -
    // MARK: - POST METHOD: Fire Upload Main Images
    /*
    *
    * (Parameters) - type, access_token
    *
    * Function to upload images
    *
    */
    
    func fireAddressByType(textField: UITextField) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var url: String = ""
        var parameters: NSMutableDictionary = NSMutableDictionary()
        
        if textField == self.countryTextField {
            url = APIAtlas.allCountries + SessionManager.accessToken()
            parameters = ["" : ""]
        } else if textField == self.provinceTextField {
            url = APIAtlas.childProvinces + SessionManager.accessToken()
            parameters = ["regionId" : self.countryId]
        } else if textField == self.cityMunTextField {
            url = APIAtlas.childCities + SessionManager.accessToken()
            parameters = ["provinceId" : self.provinceId]
        } else if textField == self.barangayDistrictTextField {
            url = APIAtlas.barangaysByCity + SessionManager.accessToken()
            parameters = ["cityId" : self.cityId]
        }
        
        WebServiceManager.fireAddWarehouseAddressRequestWithUrl(url, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if let success = responseObject["isSuccessful"] as? Bool {
                    if success {
                        if textField == self.countryTextField {
                            self.countryModel = WarehouseCountryModel.parseDataWithDictionary(responseObject as! NSDictionary)
                            self.provinceTextField.userInteractionEnabled = false
                            self.cityMunTextField.userInteractionEnabled = false
                            self.barangayDistrictTextField.userInteractionEnabled = false
                        } else if textField == self.provinceTextField {
                            self.provinceModel = WarehouseProvinceModel.parseDataWithDictionary(responseObject as! NSDictionary)
                            self.provinceTextField.userInteractionEnabled = true
                            self.cityMunTextField.userInteractionEnabled = false
                            self.barangayDistrictTextField.userInteractionEnabled = false
                        } else if textField == self.cityMunTextField {
                            self.cityModel = WarehouseCityModel.parseDataWithDictionary(responseObject as! NSDictionary)
                            self.provinceTextField.userInteractionEnabled = true
                            self.cityMunTextField.userInteractionEnabled = true
                            self.barangayDistrictTextField.userInteractionEnabled = false
                        } else if textField == self.barangayDistrictTextField {
                            self.barangayModel = WarehouseBarangayModel.parseDataWithDictionary(responseObject as! NSDictionary)
                            self.provinceTextField.userInteractionEnabled = true
                            self.cityMunTextField.userInteractionEnabled = true
                            self.barangayDistrictTextField.userInteractionEnabled = true
                        }
                        
                        self.countryTextField!.endEditing(true)
                        self.provinceTextField!.endEditing(true)
                        self.cityMunTextField!.endEditing(true)
                        self.barangayDistrictTextField.endEditing(true)
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
                    self.fireRefreshToken(1001)
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
    
    func fireAddWarehouse() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var parameters: NSMutableDictionary  = ["warehouseId" : "", "name" : self.warehouseNameTextField.text, "address" : self.fullAddressTextField.text, "location" : self.barangayId, "zipCode" : self.zipCodeTextField.text]

        WebServiceManager.fireAddWarehouseAddressRequestWithUrl(APIAtlas.addWarehouse + SessionManager.accessToken(), parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if let success = responseObject["isSuccessful"] as? Bool {
                    if success {
                        Toast.displayToastWithMessage(responseObject["message"] as! String, duration: 1.5, view: self.tabBarController!.view)
                        self.warehouseNameTextField.text = ""
                        self.fullAddressTextField.text = ""
                        self.countryTextField.text = ""
                        self.provinceTextField.text = ""
                        self.cityMunTextField.text = ""
                        self.barangayDistrictTextField.text = ""
                        self.zipCodeTextField.text = ""
                        self.back()
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
                    self.fireRefreshToken(1002)
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
