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

class ProductCombinationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellTitles = ["Finish", "Storage", "SKU"]
    let cellValues = ["Silver", "16GB", "G86712835-12"]
    
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
            originalPrices.append(String(combination.price))
            discounts.append(String(combination.discount))
            finalPrices.append(combination.discountedPrice)
            commissions.append(combination.commission)
            statuses.append(combination.status)
        }
        
        self.tableView.reloadData()
        
    }

    // MARK: - Functions
    
    func setupNavigationBar() {
        self.title = "Product Combinations"
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-back"), style: .Plain, target: self, action: "backAction")]
        self.navigationItem.rightBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-check"), style: .Plain, target: self, action: "checkAction")]
    }
    
    func setupTableView() {
        
        self.tableView.backgroundColor = Constants.Colors.backgroundGray
        
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 10.0))
        self.tableView.tableHeaderView = headerView
        
        let footerView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 80.0))
        let saveButton: UIButton = UIButton(frame: CGRectMake(15, 0, self.tableView.frame.size.width - 30, 50.0))
        saveButton.backgroundColor = Constants.Colors.pmYesGreenColor
        saveButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        saveButton.layer.cornerRadius = 3.0
        saveButton.setTitle("SAVE PRODUCT COMBINATIONS", forState: .Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.addTarget(self, action: "saveAction", forControlEvents: .TouchUpInside)
        footerView.addSubview(saveButton)
        self.tableView.tableFooterView = footerView
        
        // registering cells
        
        self.tableView.registerNib(UINib(nibName: "ProductCombinationTableViewCell", bundle: nil), forCellReuseIdentifier: "combinationCell")
        self.tableView.registerNib(UINib(nibName: "ProductCombination2TableViewCell", bundle: nil), forCellReuseIdentifier: "combinationCell2")
        self.tableView.registerNib(UINib(nibName: "ProductCombination3TableViewCell", bundle: nil), forCellReuseIdentifier: "combinationCell3")
    }
    
    
    // MARK: - Actions
    
    func saveAction() {
        
        for i in 0..<self.finalPrices.count {
            
            self.finalPrices[i] = String(stringInterpolationSegment: String(self.originalPrices[i]).doubleValue * String(stringInterpolationSegment: self.discounts[i]).doubleValue / 100)
            
        }
        
        let parameters = ["code": countryStoreModel.code,
                     "productId": productDetails.id,
                 "productUnitId": productUnitIds.description,
                         "price": originalPrices.description,
               "discountedPrice": finalPrices.description,
                    "commission": commissions.description,
                        "status": statuses.description]
        
        println(parameters)
        
        print("response > ")
        let url = "http://dev.seller.online.api.easydeal.ph/api/v3/ph/en/auth/country-setup/save-combinations?access_token=" + SessionManager.accessToken()
        WebServiceManager.fireSaveCombinations(url, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            println(responseObject)
            
        })
        
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func checkAction() {
        self.navigationController?.popViewControllerAnimated(true)
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
            
            
            cell.originalPriceLabel.text = "Original Price (" + countryStoreModel.currency.symbol + ")"
            cell.originalTextField.text = self.originalPrices[indexPath.section]
            
            cell.discountLabel.text = "Discount (" + countryStoreModel.currency.symbol + ")"
            cell.discountTextField.text = self.discounts[indexPath.section]
            
            cell.finalPriceLabel.text = "Final Price (" + countryStoreModel.currency.symbol + ")"
            cell.finalPriceTextField.text = "\(cell.originalTextField.text.doubleValue * cell.discountTextField.text.doubleValue / 100)"
            
            cell.commissionTextField.text = self.commissions[indexPath.section]
            
            return cell
        } else if indexPath.row == noOfCombinations + 2 {
            let cell: ProductCombination3TableViewCell = tableView.dequeueReusableCellWithIdentifier("combinationCell3") as! ProductCombination3TableViewCell
            cell.delegate = self
            cell.tag = indexPath.section
            
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
        textLabel.text = "Combination \(section + 1)"
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
            self.finalPrices[section] = String(stringInterpolationSegment: String(self.originalPrices[section]).doubleValue * String(stringInterpolationSegment: self.discounts).doubleValue / 100)
        } else if id == TextFieldID.commision {
            self.commissions[section] = text
        }
        
    }
    
    // MARK: - Product Combination View Delegate 3
    
    func getSwitchValue(view: ProductCombination3TableViewCell, section: Int, value: Int) {
        self.statuses[section] = value
    }
    
}
