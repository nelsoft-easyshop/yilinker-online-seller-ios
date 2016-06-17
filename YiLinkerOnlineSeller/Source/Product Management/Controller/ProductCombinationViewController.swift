//
//  ProductCombinationViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 4/21/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

typealias CombinationElement = (original: String, discount: String, final: String, commission: String, isEnabled: Bool)

struct TextFieldID {
    static let originalPrice = 1
    static let discount = 2
    static let finalPrice = 3
    static let commision = 4
}

protocol ProductCombinationViewControllerDelegate {
    func reloadDetailsFromProductCombination(controller: ProductCombinationViewController)
}

private struct Strings {
    static let title = StringHelper.localizedStringWithKey("COUNTRY_STORE_SETUP_PRODUCT_COMBINATION_TITLE_LOCALIZE_KEY")
    static let combination = StringHelper.localizedStringWithKey("PRODUCT_COMBINATION_TITLE_LOCALIZE_KEY")
    static let originalPrice = StringHelper.localizedStringWithKey("PRODUCT_COMBINATION_ORIGINAL_PRICE_LOCALIZE_KEY")
    static let discount = StringHelper.localizedStringWithKey("PRODUCT_COMBINATION_DISCOUNT_LOCALIZE_KEY")
    static let finalPrice = StringHelper.localizedStringWithKey("PRODUCT_COMBINATION_FINAL_PRICE_LOCALIZE_KEY")
    static let commission = StringHelper.localizedStringWithKey("PRODUCT_COMBINATION_COMMISION_LOCALIZE_KEY")
    static let available = StringHelper.localizedStringWithKey("PRODUCT_COMBINATION_AVAILABLE_LOCALIZE_KEY")
    static let saveProductCombination = StringHelper.localizedStringWithKey("PRODUCT_COMBINATION_SAVE_PRODUCT_COMBINATION_LOCALIZE_KEY")
    static let cannotProceed = StringHelper.localizedStringWithKey("CANNOT_PROCEED_LOCALIZE_KEY")
    static let fillUpAllFields = StringHelper.localizedStringWithKey("PRODUCT_COMBINATION_FILL_UP_LOCALIZE_KEY")
}

class ProductCombinationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var combinationElements: [CombinationElement] = []
    
    var combinationModel: [CSProductUnitModel] = []
    var countryStoreModel: CountryListModel!
    var productDetails: CSProductModel!
    
    var productUnitIds: [String] = []
    var originalPrices: [String] = []
    var discounts: [String] = []
    var finalPrices: [String] = []
    var commissions: [String] = []
    var statuses: [Int] = []
    
    var hud: MBProgressHUD?
    
    var delegate: ProductCombinationViewControllerDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupNavigationBar()
        setupTableView()
        
        for i in 0..<3 {
            let element: CombinationElement
            element.original = ""
            element.discount = ""
            element.final = ""
            element.commission = ""
            element.isEnabled = true
            combinationElements.append(element)
        }
        
        for combination in combinationModel {
            productUnitIds.append(combination.productUnitId)
            originalPrices.append(combination.appliedBaseDiscountPrice/*String(combination.price)*/)
            discounts.append(String(combination.discount))
            finalPrices.append(String(combination.discountedPrice))
            commissions.append(combination.commission)
            statuses.append(combination.status)
        }
        
        self.tableView.reloadData()
        
    }

    // MARK: - Functions
    
    func setupNavigationBar() {
        self.title = Strings.title
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-back"), style: .Plain, target: self, action: "backAction")]
//        self.navigationItem.rightBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-check"), style: .Plain, target: self, action: "checkAction")]
    }
    
    func setupTableView() {
        
        self.tableView.backgroundColor = Constants.Colors.lightBackgroundColor
        
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 10.0))
        self.tableView.tableHeaderView = headerView
        
        let footerView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 80.0))
        let saveButton: UIButton = UIButton(frame: CGRectMake(15, 0, UIScreen.mainScreen().bounds.size.width - 30, 50.0))
        saveButton.backgroundColor = Constants.Colors.pmYesGreenColor
        saveButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        saveButton.layer.cornerRadius = 3.0
        saveButton.setTitle(Strings.saveProductCombination, forState: .Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.addTarget(self, action: "saveAction", forControlEvents: .TouchUpInside)
        footerView.addSubview(saveButton)
        self.tableView.tableFooterView = footerView
        
        // registering cells
        
        self.tableView.registerNib(UINib(nibName: "ProductCombinationTableViewCell", bundle: nil), forCellReuseIdentifier: "combinationCell")
        self.tableView.registerNib(UINib(nibName: "ProductCombination2TableViewCell", bundle: nil), forCellReuseIdentifier: "combinationCell2")
        self.tableView.registerNib(UINib(nibName: "ProductCombination3TableViewCell", bundle: nil), forCellReuseIdentifier: "combinationCell3")
    }
    
    func filledAllRequirements() -> Bool {
    
        for i in 0..<statuses.count {
            
            if self.originalPrices[i] == "" || self.discounts[i] == "" {
                return false
            }
            
        }
        
        return true
    }
    
    func savingDataSuccessful(message: String) {
        
        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "", title: message)
        delegate?.reloadDetailsFromProductCombination(self)
        
    }
    
    // MARK: - Requests
    
    func fireSaveCombination() {
        
        self.showHUD()
        
        for i in 0..<self.finalPrices.count {
            let originalPrice: Double = String(self.originalPrices[i]).doubleValue
            let discount: Double = String(self.discounts[i]).doubleValue
            self.finalPrices[i] = "\(originalPrice - (originalPrice * (discount / 100)))"
        }
        
        let parameters = ["code": countryStoreModel.code,
            "productId": productDetails.id,
            "productUnitId": productUnitIds.description,
            "price": originalPrices.description,
            "discountedPrice": finalPrices.description,
            "commission": commissions.description,
            "status": statuses.description]
        
        println(APIAtlas.saveCombinations + SessionManager.accessToken())
        println(parameters)
        
        WebServiceManager.fireSaveCombinations(APIAtlas.saveCombinations + SessionManager.accessToken(), parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            self.hud?.hide(true)
            
            if successful {
                self.savingDataSuccessful(responseObject["message"] as! String)
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
//                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Strings.cannotProceed)
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
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
            
        })
        
    }
    
    func fireRefreshToken() {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireSaveCombination()
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                })
            }
        })
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
    
    func saveAction() {
        
        if filledAllRequirements() {
            self.fireSaveCombination()
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Strings.fillUpAllFields, title: Strings.cannotProceed)
        }
        
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func checkAction() {
        if filledAllRequirements() {
            self.fireSaveCombination()
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Strings.fillUpAllFields, title: Strings.cannotProceed)
        }
    }
    
}

extension ProductCombinationViewController: UITableViewDataSource, UITableViewDelegate, ProductCombination2TableViewCellDelegate, ProductCombination3TableViewCellDelegate {
    
    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return combinationModel.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.combinationModel[section].variantCombination.count + 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let noOfCombinations = self.combinationModel[indexPath.section].variantCombination.count

        if indexPath.row == noOfCombinations + 1 {
            let cell: ProductCombination2TableViewCell = tableView.dequeueReusableCellWithIdentifier("combinationCell2") as! ProductCombination2TableViewCell
            cell.delegate = self
            cell.tag = indexPath.section
            
            
            cell.originalPriceLabel.text = "\(Strings.originalPrice) (" + countryStoreModel.currency.symbol + ")"
            cell.originalTextField.text = self.originalPrices[indexPath.section]
            
            cell.discountLabel.text = "\(Strings.discount) (%)"
            cell.discountTextField.text = self.discounts[indexPath.section]
            
            cell.finalPriceLabel.text = "\(Strings.finalPrice) (" + countryStoreModel.currency.symbol + ")"
            cell.finalPriceTextField.text = "\(cell.originalTextField.text.doubleValue - (cell.originalTextField.text.doubleValue * (cell.discountTextField.text.doubleValue / 100)))"
            
            cell.commissionLabel.text = Strings.commission
            cell.commissionTextField.text = self.commissions[indexPath.section]
            
            return cell
        } else if indexPath.row == noOfCombinations + 2 {
            let cell: ProductCombination3TableViewCell = tableView.dequeueReusableCellWithIdentifier("combinationCell3") as! ProductCombination3TableViewCell
            cell.delegate = self
            cell.tag = indexPath.section
            
            cell.availableLabel.text = Strings.available
            if self.combinationModel[indexPath.section].status == 1 {
                cell.availableSwitch.on = true
            } else {
                cell.availableSwitch.on = false
            }
            
            return cell
        } else if indexPath.row == noOfCombinations {
            let cell: ProductCombinationTableViewCell = tableView.dequeueReusableCellWithIdentifier("combinationCell") as! ProductCombinationTableViewCell
            cell.titleLabel.text = "SKU"
            cell.valueLabel.text = self.combinationModel[indexPath.section].sku
            
            return cell
        }
        
        let cell: ProductCombinationTableViewCell = tableView.dequeueReusableCellWithIdentifier("combinationCell") as! ProductCombinationTableViewCell
        cell.titleLabel.text = self.combinationModel[indexPath.section].variantCombination[indexPath.row].name.capitalizedString
        cell.valueLabel.text = self.combinationModel[indexPath.section].variantCombination[indexPath.row].value.capitalizedString
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 40.0))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let textLabel: UILabel = UILabel(frame: CGRectMake(15, 0, headerView.frame.size.width - 15, headerView.frame.size.height))
        textLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        textLabel.textColor = UIColor.darkGrayColor()
        textLabel.text = "\(Strings.combination) \(section + 1)"
        headerView.addSubview(textLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let noOfCombinations = self.combinationModel[indexPath.section].variantCombination.count
        
        if indexPath.row == noOfCombinations + 1 {
            return 158.0
        } else if indexPath.row == noOfCombinations + 2 {
            return 70.0
        }
        
        return 44.0
    }
    
    // MARK: - Product Combination View Delegate 2
    
    func getText(view: ProductCombination2TableViewCell, section: Int, text: String, id: Int) {

        if id == TextFieldID.originalPrice {
            self.originalPrices[section] = text
        } else if id == TextFieldID.discount {
            self.discounts[section] = text
        } else if id == TextFieldID.finalPrice {
//            self.finalPrices[section] = String(stringInterpolationSegment: String(self.originalPrices[section]).doubleValue - (self.originalPrices[section].doubleValue * (=)String(stringInterpolationSegment: self.discounts).doubleValue / 100)
//self.finalPrices[section] = "\(self.originalPrices[section]).doubleValue = (self.originalPrices[section]).doubleValue * ()))"
            self.finalPrices[section] = "\(String(self.originalPrices[section]).doubleValue - (String(self.originalPrices[section]).doubleValue * (String(stringInterpolationSegment: self.discounts).doubleValue / 100)))"
        } else if id == TextFieldID.commision {
            self.commissions[section] = text
        }
        
    }
    
    // MARK: - Product Combination View Delegate 3
    
    func getSwitchValue(view: ProductCombination3TableViewCell, section: Int, value: Int) {
        self.statuses[section] = value
    }
    
}
