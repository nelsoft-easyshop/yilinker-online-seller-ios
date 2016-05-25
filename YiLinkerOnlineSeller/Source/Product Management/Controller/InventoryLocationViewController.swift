//
//  InventoryLocationViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 4/21/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class InventoryLocationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var sectionTitles = ["Inventory Location", "Is COD Available?", "Logistics", "Shipping Cost"]
    let locations = ["6th Floor pacific tower, Five E-com Cnter, Mall of Asia Pacific Drive, 1300 Pasay City, philippines",
        "8/F Marc 2000 Tower, 1980 San Andress Street Malate, Manila, Philippines",
        "1660 Bulacan Street, Santa, Cruz Manila, Philippines"]
    let cods = ["Yes", "No"]
    let logistics = ["YiLinker Express", "Other Third Party Logistics"]
    var cellValues: [NSArray] = []
    
    var isPrimary: Bool = true
    
//    var selectedValues: [String] = ["", "", "", ""]
    var selectedLocationIndex = -1
    var isCOD = false
    var logistic = ""
    var shippingFee = "0.00"
    
    
    var productDetails: CSProductModel!
    var warehousesModel: [CSProductWarehousesModel] = []
    var logisticsModel: [CSLogisticsModel] = []
    var code: String = ""
    var sections = 2
    var initialValues = true
    var selectedLogisticId = -1
    
    // flags
    var isLocal: Bool = false
    var isLogisticThirdParty: Bool = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        setupNavigationBar()
        setupTableView()
        cellValues = [locations, cods, logistics]
//        location = locations[0]
        logistic = logistics[0]

        // sections
        // selectedIndex
        for i in 0..<warehousesModel.count {
            if isPrimary && warehousesModel[i].priority == 1 || !isPrimary && warehousesModel[i].priority == 2 {
                selectedLocationIndex = i
                break
            }
        }
        
        refreshData()
    }
    
    // MARK: - Functions
    
    func setupNavigationBar() {
        self.title = "Inventory Location"
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-back"), style: .Plain, target: self, action: "backAction")]
        self.navigationItem.rightBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-check"), style: .Plain, target: self, action: "checkAction")]
    }
    
    func setupTableView() {
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = Constants.Colors.backgroundGray
        
        let footerView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 100.0))
        let saveButton: UIButton = UIButton(frame: CGRectMake(15, 5, self.tableView.frame.size.width - 30, 50.0))
        saveButton.backgroundColor = Constants.Colors.pmYesGreenColor
        saveButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        saveButton.layer.cornerRadius = 2.0
        saveButton.setTitle("SAVE INVENTORY LOCATION", forState: .Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.addTarget(self, action: "saveAction", forControlEvents: .TouchUpInside)
        footerView.addSubview(saveButton)
        self.tableView.tableFooterView = footerView
        
        // registering cells
        
        self.tableView.registerNib(UINib(nibName: "InventoryLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "locationId")
    }
    
    func getShippingFeeValue() -> String {
        var indexPath = NSIndexPath(forRow: 0, inSection: 3)
        if !isLocal {
           indexPath = NSIndexPath(forRow: 0, inSection: 2)
        }
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! InventoryLocationTableViewCell
        
        if cell.inputTextField.text == "" {
            shippingFee = "0.00"
        } else {
            shippingFee = cell.inputTextField.text
        }
        
        return shippingFee
    }
    
    func setSectionsWithIndex(index: Int) {
        
        if warehousesModel[index].is_local {
            self.sections = 3
            sectionTitles = ["Inventory Location", "Is COD Available?", "Logistics", "Shipping Cost"]
        } else {
            self.sections = 2
            sectionTitles = ["Inventory Location", "Logistics", "Shipping Cost"]
        }
    }
    
    func refreshData() {
        
        if selectedLocationIndex != -1 {
            
            sections = 2
            isLocal = false
            isLogisticThirdParty = false
            
            let warehouse = self.warehousesModel[selectedLocationIndex]
            
            // isCOD
            isCOD = warehouse.is_cod
            
            // logistic
            if warehouse.logistic != nil {
                self.selectedLogisticId = warehouse.logistic.id
            } else {
                self.selectedLogisticId = -1
            }
            
            // flags
            isLocal = warehouse.is_local
            if warehouse.logistic.id == 2 {
                isLogisticThirdParty = true
            }
            
            shippingFee = self.warehousesModel[selectedLocationIndex].handlingFee
            
            if isLocal {
                sections = 3
                sectionTitles = ["Inventory Location", "Is COD Available?", "Logistics", "Shipping Cost"]
            } else {
                sections = 2
                sectionTitles = ["Inventory Location", "Logistics", "Shipping Cost"]
            }
            
            if isLogisticThirdParty {
                sections += 1
            }
            
        }
        
    }
    
    // MARK: - Actions
    
    func saveAction() {
        
        var priority = ""
        if isPrimary {
            priority = "1"
        } else if !isPrimary {
            priority = "2"
        } else {
            priority = "0"
        }
        
        if isLogisticThirdParty {
            shippingFee = getShippingFeeValue()
        } else {
            shippingFee = "0.0"
        }
        
        let parameters = ["code": code,
                     "productId": productDetails.id,
                 "userWarehouse": warehousesModel[selectedLocationIndex].user_warehouse.id,
                     "logistics": selectedLogisticId,
                         "isCod": isCOD,
                   "handlingFee": shippingFee,
                      "priority": priority]
        
        println(parameters)
        
        let url = "http://dev.seller.online.api.easydeal.ph/api/v3/ph/en/auth/country-setup/setwarehouse?access_token=" + SessionManager.accessToken()
        WebServiceManager.fireSetWarehouse(url, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
        
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

extension InventoryLocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.warehousesModel.count
        } else if section == 1 {
            if !isLocal {
                return logisticsModel.count
            }
            return cods.count
        } else if section == 2 {
            if !isLocal {
                return 1
            }
            return logisticsModel.count
        } else if section == 3 {
            return 1
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: InventoryLocationTableViewCell = tableView.dequeueReusableCellWithIdentifier("locationId") as! InventoryLocationTableViewCell
        
        cell.selectionStyle = .None
        cell.checkImageView.hidden = true
        cell.inputTextField.hidden = true
        cell.label.hidden = false
        cell.backgroundColor = UIColor.whiteColor()
        
        if indexPath.section == 0 { // Inventory Location
            cell.label.text = self.warehousesModel[indexPath.row].user_warehouse.address
            if isPrimary && self.warehousesModel[indexPath.row].priority == 1 && selectedLocationIndex == -1 ||
               !isPrimary && self.warehousesModel[indexPath.row].priority == 2 && selectedLocationIndex == -1 ||
               selectedLocationIndex == indexPath.row {
                cell.checkImageView.hidden = false
            }
        } else if indexPath.section == 1 { // COD
            if isLocal {
                cell.label.text = cods[indexPath.row]
                if isCOD && indexPath.row == 0 || !isCOD && indexPath.row == 1 && selectedLocationIndex != -1 {
                    cell.checkImageView.hidden = false
                }
            } else {
                cell.label.text = logistics[indexPath.row]
                if logisticsModel[indexPath.row].id == selectedLogisticId {
                    cell.checkImageView.hidden = false
                }
            }
        } else if indexPath.section == 2 { // Logistics
            if isLocal {
                cell.label.text = logistics[indexPath.row]
                if logisticsModel[indexPath.row].id == selectedLogisticId {
                    cell.checkImageView.hidden = false
                }
            } else {
                if isLogisticThirdParty {
                    cell.label.hidden = true
                    cell.inputTextField.hidden = false
                    cell.checkImageView.hidden = true
                    cell.inputTextField.text = shippingFee
                    cell.backgroundColor = UIColor.clearColor()
                }
            }
        } else if indexPath.section == 3 { // Shipping Cost
            if isLogisticThirdParty {
                cell.label.hidden = true
                cell.inputTextField.hidden = false
                cell.checkImageView.hidden = true
                cell.inputTextField.text = shippingFee
                cell.backgroundColor = UIColor.clearColor()
            }
        }
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 40.0))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let textLabel: UILabel = UILabel(frame: CGRectMake(10, 0, headerView.frame.size.width - 15, headerView.frame.size.height))
        textLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        textLabel.textColor = UIColor.darkGrayColor()
        textLabel.text = sectionTitles[section]
        
        if isPrimary && section == 0 {
            textLabel.text = textLabel.text! + " (PRIMARY)"
        } else if !isPrimary && section == 0 {
            textLabel.text = textLabel.text! + " (SECONDARY)"
        }
        headerView.addSubview(textLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! InventoryLocationTableViewCell
        
        if cell.checkImageView.hidden == true {
            if indexPath.section == 0 {
                selectedLocationIndex = indexPath.row
                refreshData()
            } else if indexPath.section == 1 {
                if isLocal {
                    if indexPath.row == 0 {
                        isCOD = true
                    } else {
                        isCOD = false
                    }
                } else {
                    selectedLogisticId = logisticsModel[indexPath.row].id
                    
                    if selectedLogisticId == 2 {
//                        if sections < 3 {
                            sections += 1
//                        }
                        isLogisticThirdParty = true
                    } else {
                        if sections > 2 {
                            if !(sections == 3 && isLocal) {
                                sections -= 1
                            }
                        }
                        isLogisticThirdParty = false
                    }
                }
            } else if indexPath.section == 2 {
                
                selectedLogisticId = logisticsModel[indexPath.row].id
                
                if selectedLogisticId == 2 {
//                    if sections < 3 {
                        sections += 1
//                    }
                    isLogisticThirdParty = true
                } else {
                    if sections > 2 {
                        if !(sections == 3 && isLocal) {
                            sections -= 1
                        }
                    }
                    isLogisticThirdParty = false
                }
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let selectedIndexPaths = indexPathsForSelectedRowsInSection(indexPath.section)

        if selectedIndexPaths?.count == 1 {
            tableView.deselectRowAtIndexPath(selectedIndexPaths!.first!, animated: false)
        }
        
        return indexPath
    }
    
    func indexPathsForSelectedRowsInSection(section: Int) -> [NSIndexPath]? {
        return (tableView.indexPathsForSelectedRows() as? [NSIndexPath])?.filter({ (indexPath) -> Bool in
            indexPath.section == section
        })
    }
}