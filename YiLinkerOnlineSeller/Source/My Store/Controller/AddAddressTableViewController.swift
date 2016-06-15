//
//  AddAddressViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

//MARK: Delegate
//AddAddressTableViewController Delegate Method
protocol AddAddressTableViewControllerDelegate {
    func addAddressTableViewController(didAddAddressSucceed addAddressTableViewController: AddAddressTableViewController)
}

class AddAddressTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, NewAddressTableViewCellDelegate {
    
    //Strings
    let editAddressTitle: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_TITLE_EDIT_LOCALIZE_KEY")
    let addAddressTitle: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_TITLE_ADD_LOCALIZE_KEY")
    let addressTitle: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_ADDRESS_TITLE_LOCALIZE_KEY")
    let unitNo: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_UNIT_NO_LOCALIZE_KEY")
    let bldgName: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_BLDG_NAME_LOCALIZE_KEY")
    let streetNo: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_STREET_NO_LOCALIZE_KEY")
    let streetName: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_STREET_NAME_LOCALIZE_KEY")
    let subdivision: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_SUBDIVISION_LOCALIZE_KEY")
    let province: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_PROVINCE_LOCALIZE_KEY")
    let city: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_CITY_LOCALIZE_KEY")
    let barangay: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_BARANGAY_LOCALIZE_KEY")
    let zipCode: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_ZIP_CODE_LOCALIZE_KEY")
    let additionalInfo: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_ADDITIONAL_INFO_LOCALIZE_KEY")
    let ok: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_OK_LOCALIZE_KEY")
    let somethingWentWrong: String = StringHelper.localizedStringWithKey("ERROR_SOMETHING_WENT_WRONG_LOCALIZE_KEY")
    let error: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_ERROR_LOCALIZE_KEY")
    let streetNameRequired: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_STREET_NAME_REQUIRED_LOCALIZE_KEY")
    let streetNoRequired: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_STREET_NO_REQUIRED_LOCALIZE_KEY")
    let zipCodeRequired: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_ZIP_CODE_REQUIRED_LOCALIZE_KEY")
    let addressTitleRequired: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_ADDRESS_TITLE_REQUIRED_LOCALIZE_KEY")
    let provinceRequired: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_PROVINCE_REQUIRED_LOCALIZE_KEY")
    let cityRequired: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_CITY_REQUIRED_LOCALIZE_KEY")
    let barangayRequired: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_BARANGAY_REQUIRED_LOCALIZE_KEY")
    
    //Models
    var addressModel: AddressModelV2 = AddressModelV2()
    var barangayModel: BarangayModel = BarangayModel()
    var cityModel: CityModel = CityModel()
    var provinceModel: ProvinceModel = ProvinceModel()

    var hud: MBProgressHUD?
    
    var pickerView: UIPickerView = UIPickerView()
    
    var addressCellReference = [NewAddressTableViewCell?]()
    
    //Global variable declarations
    var titles: [String] = []
    
    var activeTextField: Int = 0
    var barangayRow: Int = 0
    var cityRow: Int = 0
    var provinceRow: Int = 0
    var isEdit: Bool = true
    var isEdit2: Bool = true
    var isEdit3: Bool = false
    var selectedProvince: String = ""
    var selectedCity: String = ""
    
    var delegate: AddAddressTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titles = [self.addressTitle, self.unitNo, self.bldgName, self.streetNo, self.streetName, self.subdivision, self.province, self.city, self.barangay, self.zipCode]
        
        self.registerNib()
        self.backButton()
        self.requestGetProvince()
        
        self.isEdit3 = true
        if self.isEdit {
            self.title =  self.editAddressTitle
        } else {
            self.title = self.addressTitle
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    //MARK: Private Methods
    func done() {
        if activeTextField == 6 {
            self.requestGetCities(self.addressModel.provinceId)
            self.isEdit3 = false
            self.setTextAtIndex(7, text: "")
            self.setTextAtIndex(8, text: "")
        } else if activeTextField == 7 {
            self.requestGetBarangay(self.addressModel.cityId)
            self.setTextAtIndex(8, text: "")
        } else {
            let row = NSIndexPath(forItem: activeTextField, inSection: 0)
            let cell: NewAddressTableViewCell = tableView.cellForRowAtIndexPath(row) as! NewAddressTableViewCell
            cell.rowTextField.endEditing(true)
        }
    }
    
    //Get text in cells
    func getTextAtIndex(index: Int) -> String {
        // Fix for Issue #303
        //let row = NSIndexPath(forItem: index, inSection: 0)
        let cell: NewAddressTableViewCell = //tableView.cellForRowAtIndexPath(row) as! NewAddressTableViewCell
        addressCellReference[index]!
        return cell.rowTextField.text
    }
    
    //Register nib file
    func registerNib() {
        let nib: UINib = UINib(nibName: Constants.Checkout.newAddressTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: Constants.Checkout.newAddressTableViewCellNibNameAndIdentifier)
    }
    
    //Add text in cell
    func setTextAtIndex(index: Int, text: String) {
        let row = NSIndexPath(forItem: index, inSection: 0)
        let cell: NewAddressTableViewCell = tableView.cellForRowAtIndexPath(row) as! NewAddressTableViewCell
        cell.rowTextField.text = text
    }
    
    //Show alert view
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: self.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController!.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    //MARK: Navigation bar
    //Add buttons in navigation bar
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
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    //Navigation bar button methods
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func check() {
        var index: Int = -1
        var index2: Int = 1001
        for i in 0..<10 {
            if getTextAtIndex(i) == "" && i != 1 && i != 2 && i != 3 && i != 5 {
                index = i
                break
            }
        }
        
        /*if index == 0 {
            //self.activeTextField = index - 1
            //self.next()
            //showAlert(title: self.error, message: self.addressTitleRequired)
            //index2 =  1002
        } else*/ if index == 4 {
            self.activeTextField = index - 1
            self.next()
            showAlert(title: self.error, message: self.streetNameRequired)
            index2 =  1002
        } else if index == 6 {
            self.activeTextField = index - 1
            self.next()
            showAlert(title: self.error, message: self.provinceRequired)
            index2 =  1002
        } else if index == 7 {
            self.activeTextField = index - 1
            self.next()
            showAlert(title: self.error, message: self.cityRequired)
            index2 =  1002
        } else if index == 8 {
            self.activeTextField = index - 1
            self.next()
            showAlert(title: self.error, message: self.barangayRequired)
            index2 =  1002
        } /*else if index == 9 {
            self.activeTextField = index - 1
            self.next()
            showAlert(title: self.error, message: self.zipCodeRequired)
            index2 =  1002
        }*/
        
        //If index is zero all required fields are filled up
        if index2 == 1001 {
            if self.isEdit2 {
                self.fireEditAddress()
            } else {
                requestAddAddress()
            }
        }
    }
    
    // MARK: - Keyboard Toolbar Actions
    func next() {
        if activeTextField + 1 != self.titles.count {
            let indexPath = NSIndexPath(forItem: activeTextField + 1, inSection: 0)
            let cell: NewAddressTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! NewAddressTableViewCell
            cell.rowTextField.becomeFirstResponder()
        } else {
            self.tableView.endEditing(true)
        }
    }
    
    func previous() {
        if activeTextField != 0 {
            let indexPath = NSIndexPath(forItem: activeTextField - 1, inSection: 0)
            let cell: NewAddressTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! NewAddressTableViewCell
            cell.rowTextField.becomeFirstResponder()
        } else {
            self.tableView.endEditing(true)
        }
    }
    
    //MARK: Tableview Delegate methods
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: NewAddressTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.newAddressTableViewCellNibNameAndIdentifier) as! NewAddressTableViewCell
        cell.rowTitleLabel.text = titles[indexPath.row]
        cell.tag = indexPath.row
        cell.delegate = self
        cell.rowTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if self.isEdit {
            if indexPath.row == 0 {
                cell.rowTextField.text = self.addressModel.title
            } else if indexPath.row == 1 {
                cell.rowTextField.text = self.addressModel.unitNumber
            } else if indexPath.row == 2 {
                cell.rowTextField.text = self.addressModel.buildingName
            } else if indexPath.row == 3 {
                cell.rowTextField.text = self.addressModel.streetNumber
            } else if indexPath.row == 4 {
                cell.rowTextField.text = self.addressModel.streetName
            } else if indexPath.row == 5 {
                cell.rowTextField.text = self.addressModel.subdivision
            } else if indexPath.row == 6 {
                cell.rowTextField.text = self.addressModel.province
            } else if indexPath.row == 7 {
                cell.rowTextField.text = self.addressModel.city
            } else if indexPath.row == 8 {
                cell.rowTextField.text = self.addressModel.barangay
            } else {
                cell.rowTextField.text = self.addressModel.zipCode
                cell.rowTextField.keyboardType = UIKeyboardType.NumberPad
            }
        }
        
        if indexPath.row == 8 {
            cell.rowTitleLabel.required()
        } else if indexPath.row == 0 {
            //cell.rowTitleLabel.required()
        } else if indexPath.row == 4 {
            cell.rowTitleLabel.required()
        } else if indexPath.row == 6 {
            cell.rowTitleLabel.required()
        } else if indexPath.row == 7 {
            cell.rowTitleLabel.required()
        } else if indexPath.row == 9 {
            //cell.rowTitleLabel.required()
            cell.rowTextField.keyboardType = UIKeyboardType.NumberPad
        }
        
        if indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 {
            var selected: Int = 0
            var titles: [String] = []
            if indexPath.row == 6 {
                if self.provinceModel.location.count != 0 {
                    for (index, uid) in enumerate(self.provinceModel.provinceId) {
                        if uid == self.addressModel.provinceId {
                            selected = index
                            titles = self.provinceModel.location
                            cell.rowTextField.text = self.provinceModel.location[index]
                        }
                    }
                }
            } else if indexPath.row == 7 {
                if self.cityModel.location.count != 0 {
                    for (index, uid) in enumerate(self.cityModel.cityId) {
                        if uid == self.addressModel.cityId {
                            selected = index
                            titles = self.cityModel.location
                            cell.rowTextField.text = self.cityModel.location[index]
                        }
                    }
                }
            } else if indexPath.row == 8 {
                if self.cityModel.location.count != 0 {
                    for (index, uid) in enumerate(self.barangayModel.barangayId) {
                        if uid == self.addressModel.barangayId {
                            selected = index
                            titles = self.barangayModel.location
                            cell.rowTextField.text = self.barangayModel.location[index]
                        }
                    }
                }
            }
            
            cell.titles = titles
            cell.addPicker(selected)
            
            if indexPath.row == 6 {
                cell.titles = self.provinceModel.location
            } else if indexPath.row == 7 {
                cell.titles = self.cityModel.location
            } else {
                cell.titles = self.barangayModel.location
            }
        }
        
        if indexPath.row == self.activeTextField {
            cell.rowTextField.becomeFirstResponder()
        }
        
        addressCellReference.append(cell)
        assert(addressCellReference[indexPath.row] == cell)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //MARK: NewAddressTableViewCell Delegate methods
    func newAddressTableViewCell(didClickNext newAddressTableViewCell: NewAddressTableViewCell) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(newAddressTableViewCell)!
        
        if indexPath.row + 1 != self.titles.count {
            let nextIndexPath: NSIndexPath = NSIndexPath(forItem: indexPath.row + 1, inSection: indexPath.section)
            let cell: NewAddressTableViewCell = self.tableView.cellForRowAtIndexPath(nextIndexPath) as! NewAddressTableViewCell
            cell.rowTextField.becomeFirstResponder()
        } else {
            self.tableView.endEditing(true)
        }
    }
    
    func newAddressTableViewCell(didClickPrevious newAddressTableViewCell: NewAddressTableViewCell) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(newAddressTableViewCell)!
        
        if indexPath.row - 1 != 0 {
            let nextIndexPath: NSIndexPath = NSIndexPath(forItem: indexPath.row - 1, inSection: indexPath.section)
            let cell: NewAddressTableViewCell = self.tableView.cellForRowAtIndexPath(nextIndexPath) as! NewAddressTableViewCell
            cell.rowTextField.becomeFirstResponder()
        } else {
            self.tableView.endEditing(true)
        }
    }
    
    func newAddressTableViewCell(didBeginEditing newAddressTableViewCell: NewAddressTableViewCell, index: Int) {
        activeTextField = index
    }
    
    //MARK: NewAddressTableViewCell Delegate method
    func newAddressTableViewCell(didSelectRow row: Int, cell: NewAddressTableViewCell) {
        if activeTextField == 6 {
            //get province title and id
            self.addressModel.provinceId = self.provinceModel.provinceId[row]
            self.addressModel.province = self.provinceModel.location[row]
            self.setTextAtIndex(activeTextField, text: self.provinceModel.location[row])
            self.addressModel.city = ""
            self.addressModel.barangay = ""
            //request for new city data model and reload tableview
            //save current row and reset dependent values
            self.provinceRow = row
            self.cityRow = 0
            self.barangayRow = 0
        } else if activeTextField == 7 {
            self.addressModel.cityId = self.cityModel.cityId[row]
            self.addressModel.city = self.cityModel.location[row]
            self.setTextAtIndex(activeTextField, text: self.cityModel.location[row])
            self.addressModel.barangay = ""
            //save current row and reset dependent values
            self.cityRow = row
            self.barangayRow = 0
        } else if activeTextField == 8 {
            self.setTextAtIndex(activeTextField, text: self.barangayModel.location[row])
            self.addressModel.barangay = self.barangayModel.location[row]
            self.addressModel.barangayId = self.barangayModel.barangayId[row]
            self.barangayRow = row
        }
        
    }
    
    //MARK: -
    //MARK: - REST API request
    //MARK: POST METHOD - Edit address
    /*
    *
    * (Parameters) - access_token, title, unitNumber, buildingName, streetNumber, streetName
    *              - subdivision, province, city, barangay, zipCode, locationId, userAddressId
    *
    * Function to update address
    *
    */
    func fireEditAddress() {
        
        self.showHUD()
        
        let parameters = ["access_token": SessionManager.accessToken(),
            "title": getTextAtIndex(0),
            "unitNumber": getTextAtIndex(1),
            "buildingName": getTextAtIndex(2),
            "streetNumber": getTextAtIndex(3),
            "streetName": getTextAtIndex(4),
            "subdivision": getTextAtIndex(5),
            "province": getTextAtIndex(6),
            "city": getTextAtIndex(7),
            "barangay": getTextAtIndex(8),
            "zipCode": getTextAtIndex(9),
            "locationId": self.addressModel.barangayId,
            "userAddressId": self.addressModel.userAddressId
        ]
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.editAddress, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                //If isSuccessful is true, call the delegate method to add new address in collection view
                self.delegate!.addAddressTableViewController(didAddAddressSucceed: self)
                
                self.navigationController!.popViewControllerAnimated(true)
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(title: self.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken(AddressRefreshType.Edit)
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
    
    //MARK: POST METHOD - Add address
    /*
    *
    * (Parameters) - access_token, title, unitNumber, buildingName, streetNumber, streetName
    *              - subdivision, province, city, barangay, zipCode, locationId
    *
    * Function to add new address
    *
    */
    func requestAddAddress() {
        
        self.showHUD()
        
        //Set parameters of POST method
        let parameters = ["access_token": SessionManager.accessToken(),
            "title": getTextAtIndex(0),
            "unitNumber": getTextAtIndex(1),
            "buildingName": getTextAtIndex(2),
            "streetNumber": getTextAtIndex(3),
            "streetName": getTextAtIndex(4),
            "subdivision": getTextAtIndex(5),
            "province": getTextAtIndex(6),
            "city": getTextAtIndex(7),
            "barangay": getTextAtIndex(8),
            "zipCode": getTextAtIndex(9),
            "locationId": self.addressModel.barangayId
        ]
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.addAddressUrl, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                //If isSuccessful is true, call the delegate method to add new address in collection view
                self.delegate!.addAddressTableViewController(didAddAddressSucceed: self)
                
                self.navigationController!.popViewControllerAnimated(true)
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(title: self.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken(AddressRefreshType.Create)
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
    
    //MARK: POST METHOD - Get all barangay
    /*
    *
    * (Parameters) - access_token, cityId
    *
    * Function to get all barangay
    *
    */
    func requestGetBarangay(id: Int) {
        
        self.showHUD()
        
        //Set parameters of POST method
        let parameters = ["access_token": SessionManager.accessToken(), "cityId": String(id)]
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.barangay, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                //Parse responseObject
                self.barangayModel = BarangayModel.parseDataWithDictionary(responseObject)
                
                if self.addressModel.barangayId == 0 && self.addressModel.title != "" {
                    self.addressModel.barangay = ""
                    self.addressModel.barangayId = 0
                } else {
                    if !self.isEdit3 {
                        self.addressModel.barangay = ""
                        self.addressModel.barangayId = 0
                    } else if self.addressModel.barangayId == 0 && self.addressModel.title == "" {
                        self.addressModel.barangayId = self.barangayModel.barangayId[0]
                        self.addressModel.barangay = self.barangayModel.location[0]
                    }else {
                        self.addressModel.barangayId = self.addressModel.barangayId
                        self.addressModel.barangay = self.barangayModel.location[0]
                    }
                }
                
                self.tableView.reloadData()
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(title: self.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken(AddressRefreshType.Barangay)
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
    
    //MARK: POST METHOD - Get Cities
    /*
    *
    * (Parameters) - access_token, provinceId
    *
    * Function to get all cities
    *
    */
    func requestGetCities(id: Int) {
        self.showHUD()
        
        //Add parameter of POST method
        let parameters = ["access_token": SessionManager.accessToken(), "provinceId": String(id)]
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.citiesUrl, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                //Parse responseObject
                self.cityModel = CityModel.parseDataWithDictionary(responseObject)
                
                if self.cityModel.cityId.count != 0 && self.addressModel.title == "" {
                    self.addressModel.city = self.cityModel.location[0]
                    self.addressModel.cityId = self.cityModel.cityId[0]
                    self.requestGetBarangay(self.addressModel.cityId)
                    self.addressModel.barangay = ""
                    self.cityRow = 0
                    self.barangayRow = 0
                } else {
                    if self.addressModel.cityId != 0 {
                        self.requestGetBarangay(self.addressModel.cityId)
                    } else {
                        self.addressModel.city = self.cityModel.location[0]
                        self.addressModel.cityId = self.cityModel.cityId[0]
                        self.requestGetBarangay(self.cityModel.cityId[0])
                    }
                }
                
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(title: self.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken(AddressRefreshType.City)
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
    
    //MARK: POST METHOD - Get Provinces
    /*
    *
    * (Parameters) - access_token
    *
    * Function to get all province
    *
    */
    func requestGetProvince() {
        
        self.showHUD()
        
        //Add parameter of POST method
        let parameters = ["" : ""]
        
        WebServiceManager.fireStoreInfoRequestWithUrl(APIAtlas.provinceUrl + SessionManager.accessToken(), parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                //Parse responseObject
                self.provinceModel = ProvinceModel.parseDataWithDictionary(responseObject)
                
                if self.provinceModel.location.count != 0 && self.addressModel.title == "" {
                    self.addressModel.province = self.provinceModel.location[0]
                    self.addressModel.provinceId = self.provinceModel.provinceId[0]
                    self.requestGetCities(self.provinceModel.provinceId[0])
                    self.provinceRow = 0
                } else {
                    if self.addressModel.provinceId != 0 {
                        self.requestGetCities(self.addressModel.provinceId)
                    } else {
                        self.requestGetCities(self.provinceModel.provinceId[0])
                    }
                }
                
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(title: self.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken(AddressRefreshType.Province)
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
    
    //MARK: POST METHOD - Refresh token
    /*
    *
    * (Parameters) - access_token, oldPassword, newPassword, newPasswordConfirm
    *
    * Function to get access token
    *
    */
    func requestRefreshToken(type: AddressRefreshType) {
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        
        //Set parameters of POST method
        let parameter: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.loginUrl, parameters: parameter, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            
            if type == AddressRefreshType.Create {
                self.requestAddAddress()
            } else if type == AddressRefreshType.Edit {
                self.fireEditAddress()
            } else if type == AddressRefreshType.Province {
                self.requestGetProvince()
            } else if type == AddressRefreshType.City {
                self.requestGetCities(self.addressModel.provinceId)
                self.isEdit3 = false
                self.setTextAtIndex(7, text: "")
                self.setTextAtIndex(8, text: "")
            } else {
                if !self.isEdit3 {
                    self.addressModel.barangay = ""
                    self.addressModel.barangayId = 0
                } else if self.addressModel.barangayId == 0 && self.addressModel.title == "" {
                    self.addressModel.barangayId = self.barangayModel.barangayId[0]
                    self.addressModel.barangay = self.barangayModel.location[0]
                }else {
                    self.addressModel.barangayId = self.addressModel.barangayId
                    self.addressModel.barangay = self.barangayModel.location[0]
                }
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    //Parse error messages from API return
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(title: self.error, message: errorModel.message)
                } else {
                    self.showAlert(title: self.somethingWentWrong, message: nil)
                }
                
                self.hud?.hide(true)
        })
    }

}
