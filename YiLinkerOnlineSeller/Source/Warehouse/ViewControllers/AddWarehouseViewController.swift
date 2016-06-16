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
    var selectedProvinceIndex: Int = 0
    var selectedCityIndex: Int = 0
    var selectedBrgyIndex: Int = 0
    var selectedTextField: UITextField?
    var textField: UITextField?
    
    // Models
    var countryModel: WarehouseCountryModel?
    var provinceModel: WarehouseProvinceModel?
    var cityModel: WarehouseCityModel?
    var barangayModel: WarehouseBarangayModel?
    var warehouseModel: WarehouseModel?
    
    var countryId: String = ""
    var provinceId: String = ""
    var cityId: String = ""
    var barangayId: String = ""
    var warehouseId: String = ""
    
    var navBarTitle: String = ""
    var isDone: Bool = false
    var warehouseAddressType: WarehouseAddress = WarehouseAddress.Country
    
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
    
        self.selectedTextField = self.countryTextField
        self.provinceTextField.userInteractionEnabled = false
        self.cityMunTextField.userInteractionEnabled = false
        self.barangayDistrictTextField.userInteractionEnabled = false
        
        if self.warehouseModel != nil {
            self.warehouseNameTextField.text = self.warehouseModel!.name
            self.fullAddressTextField.text = self.warehouseModel!.address
            self.countryTextField.text = self.warehouseModel!.countryLocation
            self.provinceTextField.text = self.warehouseModel!.provinceLocation
            self.cityMunTextField.text = self.warehouseModel!.cityLocation
            self.barangayDistrictTextField.text = self.warehouseModel!.barangayLocation
            self.zipCodeTextField.text = self.warehouseModel!.zipCode
            self.countryId = "\(self.warehouseModel!.countryLocationID)"
            self.provinceId = "\(self.warehouseModel!.provinceLocationID)"
            self.cityId = "\(self.warehouseModel!.cityLocationID)"
            self.barangayId = "\(self.warehouseModel!.barangayLocationID)"
            self.warehouseId = "\(self.warehouseModel!.id)"
        }
        
        self.getCountry()
    }
    
    //MARK: Textfield delegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        self.selectedTextField = textField
        self.selectedIndex = 0
        self.selectedProvinceIndex = 0
        self.selectedCityIndex = 0
        self.selectedBrgyIndex = 0
        if self.countryModel != nil && textField == self.countryTextField {
            self.warehouseAddressType = WarehouseAddress.Country
            self.countryTextField.inputView = self.addPicker(self.selectedIndex)
            self.countryTextField.addToolBarWithDoneTarget(self, done: "done")
        } else if self.provinceModel != nil && self.countryId != "" && textField == self.provinceTextField {
            self.warehouseAddressType = WarehouseAddress.Province
            self.provinceTextField.inputView = self.addPicker(self.selectedIndex)
            self.provinceTextField.addToolBarWithDoneTarget(self, done: "done")
        } else if self.cityModel != nil && self.provinceId != "" && textField == self.cityMunTextField {
            self.warehouseAddressType = WarehouseAddress.City
            self.cityMunTextField.inputView = self.addPicker(self.selectedIndex)
            self.cityMunTextField.addToolBarWithDoneTarget(self, done: "done")
        } else if self.barangayModel != nil && self.cityId != "" && textField == self.barangayDistrictTextField {
            self.warehouseAddressType = WarehouseAddress.Barangay
            self.barangayDistrictTextField.inputView = self.addPicker(self.selectedIndex)
            self.barangayDistrictTextField.addToolBarWithDoneTarget(self, done: "done")
        }
    }
    
    //MARK: Private Methods
    func addPicker(selectedIndex: Int) -> UIPickerView {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(0, inComponent: 0, animated: false)
        return pickerView
    }
    
    func addWarehouse() {
        
        if self.warehouseNameTextField.text == "" || self.fullAddressTextField.text == "" || self.countryTextField.text == "" || self.provinceTextField.text == "" || self.cityMunTextField.text == "" || self.barangayDistrictTextField.text == "" {
            self.showAlert("Fill-up the following textfields.", message: "")
        } else {
            self.fireAddWarehouse()
        }
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getCountry() {
        var url: String = APIAtlas.allCountries
        var parameters: NSMutableDictionary = [ "" : "" ]
        self.fireAddressByType(url, parameters: parameters, type: WarehouseAddress.Country)
    }
    
    func getProvince(countryId: String) {
        var url: String = APIAtlas.childProvinces
        var parameters: NSMutableDictionary = ["regionId" : countryId]
        self.fireAddressByType(url, parameters: parameters, type: WarehouseAddress.Province)
    }
    
    func getCity(provinceId: String) {
        var url: String = APIAtlas.childCities
        var parameters: NSMutableDictionary = ["provinceId" : provinceId]
        self.fireAddressByType(url, parameters: parameters, type: WarehouseAddress.City)
    }
    
    func getBarangay(cityId: String) {
        var url: String = APIAtlas.barangaysByCity
        var parameters: NSMutableDictionary = ["cityId" : cityId]
        self.fireAddressByType(url, parameters: parameters, type: WarehouseAddress.Barangay)
    }
    
    func initializedNavigationBarItems() {
        self.title = self.navBarTitle
        
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
        if self.warehouseAddressType == WarehouseAddress.Country && self.countryModel != nil {
            return self.countryModel!.location.count
        } else if self.warehouseAddressType == WarehouseAddress.Province &&  self.provinceModel != nil {
            return self.provinceModel!.location.count
        } else if self.warehouseAddressType == WarehouseAddress.City && self.cityModel != nil {
            return self.cityModel!.location.count
        } else if self.warehouseAddressType == WarehouseAddress.Barangay && self.barangayModel != nil{
            return self.barangayModel!.location.count
        }
        
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if self.warehouseAddressType == WarehouseAddress.Country && self.countryModel != nil {
            return self.countryModel!.location[row]
        } else if self.warehouseAddressType == WarehouseAddress.Province &&  self.provinceModel != nil {
            return self.provinceModel!.location[row]
        } else if self.warehouseAddressType == WarehouseAddress.City && self.cityModel != nil {
            return self.cityModel!.location[row]
        } else if self.warehouseAddressType == WarehouseAddress.Barangay && self.barangayModel != nil{
            return self.barangayModel!.location[row]
        }
        
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.warehouseAddressType == WarehouseAddress.Country && self.countryModel != nil{
            self.selectedIndex = row
        } else if self.warehouseAddressType == WarehouseAddress.Province && self.provinceModel != nil {
            self.selectedProvinceIndex = row
        } else if self.warehouseAddressType == WarehouseAddress.City && self.cityModel != nil {
            self.selectedCityIndex = row
        } else if self.warehouseAddressType == WarehouseAddress.Barangay && self.barangayModel != nil {
            self.selectedBrgyIndex = row
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func done() {
        
        if self.warehouseAddressType == WarehouseAddress.Country {
            
            if self.countryId != "\(self.countryModel!.countryId[self.selectedIndex])" {
                self.provinceTextField.text = ""
                self.cityMunTextField.text = ""
                self.barangayDistrictTextField.text = ""
                self.zipCodeTextField.text = ""
                self.provinceId = ""
                self.cityId = ""
                self.barangayId = ""
                self.selectedProvinceIndex = 0
                self.selectedCityIndex = 0
                self.selectedBrgyIndex = 0
            }
            
            self.countryTextField.text = self.countryModel!.location[self.selectedIndex]
            self.countryId = "\(self.countryModel!.countryId[self.selectedIndex])"
            self.getProvince(self.countryId)
        } else if self.warehouseAddressType == WarehouseAddress.Province {
            
            if self.provinceId != "\(self.provinceModel!.provinceId[self.selectedProvinceIndex])" {
                self.cityMunTextField.text = ""
                self.barangayDistrictTextField.text = ""
                self.zipCodeTextField.text = ""
                self.cityId = ""
                self.barangayId = ""
                self.selectedCityIndex = 0
                self.selectedBrgyIndex = 0
            }
            
            self.provinceTextField.text = self.provinceModel!.location[self.selectedProvinceIndex]
            self.provinceId = "\(self.provinceModel!.provinceId[self.selectedProvinceIndex])"
            self.getCity(self.provinceId)
            
        } else if self.warehouseAddressType == WarehouseAddress.City {
            
            if self.cityId != "\(self.cityModel!.cityId[self.selectedCityIndex])" {
                self.barangayDistrictTextField.text = ""
                self.zipCodeTextField.text = ""
                self.barangayId = ""
                self.selectedBrgyIndex = 0
            }
            
            self.cityMunTextField.text = self.cityModel!.location[self.selectedCityIndex]
            self.cityId = "\(self.cityModel!.cityId[self.selectedCityIndex])"
            self.getBarangay(self.cityId)
            
        } else if self.warehouseAddressType == WarehouseAddress.Barangay {
            
            if self.barangayId != "\(self.barangayModel!.barangayId[self.selectedBrgyIndex])" {
                self.barangayDistrictTextField.text = ""
            }
            
            self.barangayDistrictTextField.text = self.barangayModel!.location[self.selectedBrgyIndex]
            self.barangayId = "\(self.barangayModel!.barangayId[self.selectedBrgyIndex])"
            self.barangayDistrictTextField.endEditing(true)
        } else {
            if self.countryModel != nil {
                self.countryId = ""
                self.warehouseAddressType = WarehouseAddress.Country
            } else if self.provinceModel != nil {
                self.provinceId = ""
                self.warehouseAddressType = WarehouseAddress.Province
            } else if self.cityModel != nil {
                self.countryId = ""
                self.warehouseAddressType = WarehouseAddress.City
            } else if self.barangayModel != nil {
                self.countryId = ""
                self.warehouseAddressType = WarehouseAddress.Barangay
            }
            self.done()
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
            url = APIAtlas.allCountries
            parameters = ["" : ""]
        } else if textField == self.provinceTextField {
            url = APIAtlas.childProvinces
            parameters = ["regionId" : self.countryId]
        } else if textField == self.cityMunTextField {
            url = APIAtlas.childCities
            parameters = ["provinceId" : self.provinceId]
        } else if textField == self.barangayDistrictTextField {
            url = APIAtlas.barangaysByCity
            parameters = ["cityId" : self.cityId]
        }
        
        WebServiceManager.fireAddWarehouseAddressRequestWithUrl(url + SessionManager.accessToken(), parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if let success = responseObject["isSuccessful"] as? Bool {
                    if success {
                        if textField == self.countryTextField {
                            self.countryModel = WarehouseCountryModel.parseDataWithDictionary(responseObject as! NSDictionary)
                            self.provinceTextField.userInteractionEnabled = false
                            self.cityMunTextField.userInteractionEnabled = false
                            self.barangayDistrictTextField.userInteractionEnabled = false
                            
                            if self.warehouseId != "" && self.isDone == false {
                                self.fireAddressByType(self.provinceTextField)
                            }
                            
                        } else if textField == self.provinceTextField {
                            self.provinceModel = WarehouseProvinceModel.parseDataWithDictionary(responseObject as! NSDictionary)
                            self.provinceTextField.userInteractionEnabled = true
                            self.cityMunTextField.userInteractionEnabled = false
                            self.barangayDistrictTextField.userInteractionEnabled = false
                            
                            if self.warehouseId != "" && self.isDone == false {
                                self.fireAddressByType(self.cityMunTextField)
                            }
                            
                        } else if textField == self.cityMunTextField {
                            self.cityModel = WarehouseCityModel.parseDataWithDictionary(responseObject as! NSDictionary)
                            self.provinceTextField.userInteractionEnabled = true
                            self.cityMunTextField.userInteractionEnabled = true
                            self.barangayDistrictTextField.userInteractionEnabled = false
                            
                            if self.warehouseId != "" && self.isDone == false {
                                self.fireAddressByType(self.barangayDistrictTextField)
                            }
                            
                        } else if textField == self.barangayDistrictTextField {
                            self.barangayModel = WarehouseBarangayModel.parseDataWithDictionary(responseObject as! NSDictionary)
                            self.provinceTextField.userInteractionEnabled = true
                            self.cityMunTextField.userInteractionEnabled = true
                            self.barangayDistrictTextField.userInteractionEnabled = true
                            self.isDone = true
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
    
    func fireAddressByType(url: String, parameters: NSMutableDictionary, type: WarehouseAddress) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        WebServiceManager.fireAddWarehouseAddressRequestWithUrl(url + SessionManager.accessToken(), parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if let success = responseObject["isSuccessful"] as? Bool {
                    if success {
                        if type == WarehouseAddress.Country {
                            self.countryModel = WarehouseCountryModel.parseDataWithDictionary(responseObject as! NSDictionary)
                            self.provinceTextField.userInteractionEnabled = false
                            self.cityMunTextField.userInteractionEnabled = false
                            self.barangayDistrictTextField.userInteractionEnabled = false
                            if self.countryTextField.text != "" {
                                self.getProvince(self.countryId)
                            }
                        } else if type == WarehouseAddress.Province {
                            self.provinceModel = WarehouseProvinceModel.parseDataWithDictionary(responseObject as! NSDictionary)
                            self.provinceTextField.userInteractionEnabled = true
                            self.cityMunTextField.userInteractionEnabled = false
                            self.barangayDistrictTextField.userInteractionEnabled = false
                            if self.provinceTextField.text != "" {
                                self.getCity(self.provinceId)
                            }
                        } else if type == WarehouseAddress.City {
                            self.cityModel = WarehouseCityModel.parseDataWithDictionary(responseObject as! NSDictionary)
                            self.provinceTextField.userInteractionEnabled = true
                            self.cityMunTextField.userInteractionEnabled = true
                            self.barangayDistrictTextField.userInteractionEnabled = false
                            if self.cityMunTextField.text != "" {
                                self.getBarangay(self.cityId)
                            }
                        } else if type == WarehouseAddress.Barangay {
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
        
        var parameters: NSMutableDictionary  = ["warehouseId" : self.warehouseId, "name" : self.warehouseNameTextField.text, "address" : self.fullAddressTextField.text, "location" : self.barangayId, "zipCode" : self.zipCodeTextField.text]

        WebServiceManager.fireAddWarehouseAddressRequestWithUrl(APIAtlas.addWarehouse + SessionManager.accessToken(), parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if let success = responseObject["isSuccessful"] as? Bool {
                    if success {
                        Toast.displayToastWithMessage(responseObject["message"] as! String, duration: 1.5, view: self.view)
                        self.warehouseNameTextField.text = ""
                        self.fullAddressTextField.text = ""
                        self.countryTextField.text = ""
                        self.provinceTextField.text = ""
                        self.cityMunTextField.text = ""
                        self.barangayDistrictTextField.text = ""
                        self.zipCodeTextField.text = ""
                        self.countryId = ""
                        self.provinceId = ""
                        self.cityId = ""
                        self.barangayId = ""
                        self.provinceModel = nil
                        self.cityModel = nil
                        self.barangayModel = nil
                        self.provinceTextField.userInteractionEnabled = false
                        self.cityMunTextField.userInteractionEnabled = false
                        self.barangayDistrictTextField.userInteractionEnabled = false
                        Delay.delayWithDuration(1.5, completionHandler: { (success) -> Void in
                            self.back()
                        })
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
