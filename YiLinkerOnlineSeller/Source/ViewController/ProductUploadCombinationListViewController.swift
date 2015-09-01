//
//  ProductUploadCombinationListViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct PUCLVCConstant {
    static let productUploadCombinationHeaderTableViewCellNibNameAndIdentifier = "ProductUploadCombinationHeaderTableViewCell"
    static let productUploadCombinationTableViewCellNibNameAndIdentifier = "ProductUploadCombinationTableViewCell"
    static let productUploadCombinationFooterTableViewCellNibNameAndIdentifier = "ProductUploadCombinationFooterTableViewCell"
    static let productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier = "ProductUploadAttributeValluesCollectionViewCell"
    static let productUploadPlainCombinationTableViewCellNibNameAndIdentifier = "ProductUploadPlainDetailCombinationTableViewCell"
}

class ProductUploadCombinationListViewController: UIViewController, ProductUploadAddFooterViewDelegate, ProductUploadCombinationTableViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, PUAttributeSetHeaderTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var productModel: ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.footerView()
        self.backButton()
        self.title = "Attribute Combination"
        self.registerCell()
    }

    func registerCell() {
        let footerNib: UINib = UINib(nibName: PUCTVCConstant.productUploadCombinationFooterTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(footerNib, forCellReuseIdentifier: PUCTVCConstant.productUploadCombinationFooterTableViewCellNibNameAndIdentifier)
        
        let combinationCell: UINib = UINib(nibName: PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(combinationCell, forCellReuseIdentifier: PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier)
        
        let valuesNib: UINib = UINib(nibName: PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(valuesNib, forCellReuseIdentifier: PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier)
        
        let combinationPlainNib: UINib = UINib(nibName: PUCLVCConstant.productUploadPlainCombinationTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(combinationPlainNib, forCellReuseIdentifier: PUCLVCConstant.productUploadPlainCombinationTableViewCellNibNameAndIdentifier)
        
        let nib: UINib = UINib(nibName: PUALTVConstant.pUAttributeSetHeaderTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: PUALTVConstant.pUAttributeSetHeaderTableViewCellNibNameAndIdentifier)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.productModel!.validCombinations.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 41
        } else if indexPath.row == 1 {
            let rowHeight: CGFloat = 95
            let rowInitialHeight: CGFloat = 14
            
            var attributes: [AttributeModel] = []
            for dictionary in  self.productModel!.validCombinations[indexPath.section].attributes as [NSMutableDictionary] {
                let attributeModel: AttributeModel = AttributeModel()
                attributeModel.definition = dictionary["name"] as! String
                attributeModel.values = [dictionary["value"] as! String]
                attributes.append(attributeModel)
            }
            
            let cellCount: Int = attributes.count
            
            
            var numberOfRows: CGFloat = CGFloat(cellCount) / 2
            
            if numberOfRows == 0 {
                numberOfRows = 1
            } else if floor(numberOfRows) != numberOfRows {
                numberOfRows++
            }
            
            var dynamicHeight: CGFloat = floor(numberOfRows) * rowHeight
            
            var cellHeight: CGFloat = rowInitialHeight + dynamicHeight
            
            return cellHeight
        } else {
            return 271
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: PUAttributeSetHeaderTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUALTVConstant.pUAttributeSetHeaderTableViewCellNibNameAndIdentifier) as! PUAttributeSetHeaderTableViewCell
            cell.delegate = self
            cell.attributeDefinitionLabel!.text = "Combination \(indexPath.section + 1)"
            return cell
        } else if indexPath.row == 1 {
            let cell: ProductUploadCombinationTableViewCell = tableView.dequeueReusableCellWithIdentifier(PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadCombinationTableViewCell
            var attributes: [AttributeModel] = []
            for dictionary in  self.productModel!.validCombinations[indexPath.section].attributes as [NSMutableDictionary] {
                let attributeModel: AttributeModel = AttributeModel()
                attributeModel.definition = dictionary["name"] as! String
                attributeModel.values = [dictionary["value"] as! String]
                attributes.append(attributeModel)
            }
            cell.attributes = attributes
            cell.collectionView.reloadData()
            cell.userInteractionEnabled = false
            return cell
        } else {
            let cell: ProductUploadPlainDetailCombinationTableViewCell = tableView.dequeueReusableCellWithIdentifier(PUCLVCConstant.productUploadPlainCombinationTableViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadPlainDetailCombinationTableViewCell
            
            let combination: CombinationModel = self.productModel!.validCombinations[indexPath.section]
            cell.collectionView.reloadData()
            cell.images = combination.images
            cell.skuTextField.text = combination.sku
            cell.quantityTextField.text = combination.quantity
            cell.retailPriceTextField.text = combination.retailPrice
            cell.discountedPriceTextField.text = combination.discountedPrice
            
            cell.skuTextField.enabled = false
            cell.quantityTextField.enabled = false
            cell.retailPriceTextField.enabled = false
            cell.discountedPriceTextField.enabled = false
            cell.userInteractionEnabled = false
            return cell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func footerView() {
        let addMoreTableViewFooter: ProductUploadAddFooterView = XibHelper.puffViewWithNibName("ProductUploadAddFooterView", index: 0) as! ProductUploadAddFooterView
        addMoreTableViewFooter.delegate = self
        self.tableView.tableFooterView = addMoreTableViewFooter
    }
    
    func backButton() {
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
    
    func productUploadAddFooterView(didSelectAddMore view: UIView) {
        let productUploadCombinationTableViewController: ProductUploadCombinationTableViewController = ProductUploadCombinationTableViewController(nibName: "ProductUploadCombinationTableViewController", bundle: nil)
        productUploadCombinationTableViewController.attributes = self.productModel!.attributes
        productUploadCombinationTableViewController.delegate = self
        var counter: Int = 0
        if self.productModel != nil {
           counter = self.productModel!.validCombinations.count
        }
        
        productUploadCombinationTableViewController.headerTitle = "Combination \(counter + 1)"
        self.navigationController!.pushViewController(productUploadCombinationTableViewController, animated: true)
    }
    
    func productUploadCombinationTableViewController(appendCombination combination: CombinationModel, isEdit: Bool, indexPath: NSIndexPath) {
        
      /*  var combinationIsAvailable: Bool = true

        var values: [String] = []
        var selectedValues: [String] = []
        var index: Int = 0
        
        for var x = 0; x < combination.attributes.count; x++ {
            var dictionary: NSMutableDictionary = combination.attributes[x]
            selectedValues.append(dictionary["value"] as! String)
        }
        
        for attributeCombination in self.productModel!.validCombinations as [CombinationModel] {
            values = []
            for var x = 0; x < attributeCombination.attributes.count; x++ {
                var dictionary: NSMutableDictionary = attributeCombination.attributes[x]
                values.append(dictionary["value"] as! String)
            }
            
            let set1: NSSet = NSSet(array: selectedValues)
            let set2: NSSet = NSSet(array: values)
            
            if set1.isEqualToSet(set2 as Set<NSObject>) {
                combinationIsAvailable = false
                break
            } else {
                index++
            }
        }*/
        
        var isValidCombination: Bool = true
        
        if self.productModel != nil && !isEdit {
            for combinationLoop in self.productModel!.validCombinations {
                if combinationLoop.attributes == combination.attributes {
                    isValidCombination = false
                    break
                }
            }
        }
        
        if isValidCombination {
            if !isEdit {
                self.productModel!.validCombinations.append(combination)
            } else {
                self.productModel!.validCombinations[indexPath.section] = combination
            }
            
            self.tableView.reloadData()
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Combination already exist.", title: "Error")
        }
    }
    @IBAction func saveDetails(sender: AnyObject) {
        if self.productModel!.validCombinations.count == 0 {
             UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Combinations are required.", title: "Incomplete Product Details")
        } else {
            let productUploadTableViewController: ProductUploadTableViewController
            = self.navigationController!.viewControllers[0] as! ProductUploadTableViewController
            productUploadTableViewController.replaceProductAttributeWithAttribute(self.productModel!.attributes, combinations: self.productModel!.validCombinations)
            self.navigationController!.popToRootViewControllerAnimated(true)
        }
    }
    
    func pUAttributeSetHeaderTableViewCell(didClickDelete cell: PUAttributeSetHeaderTableViewCell) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
        let range: NSRange = NSMakeRange(indexPath.section, 1)
        let section: NSIndexSet = NSIndexSet(indexesInRange: range)
        
        self.productModel!.validCombinations.removeAtIndex(indexPath.section)
        self.tableView.beginUpdates()
        self.tableView.deleteSections(section, withRowAnimation: UITableViewRowAnimation.Left)
        self.tableView.endUpdates()
        self.tableView.reloadData()
    }
    
   func pUAttributeSetHeaderTableViewCell(didClickEdit cell: PUAttributeSetHeaderTableViewCell) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
    
        let productUploadCombinationTableViewController: ProductUploadCombinationTableViewController = ProductUploadCombinationTableViewController(nibName: "ProductUploadCombinationTableViewController", bundle: nil)
        productUploadCombinationTableViewController.attributes = self.productModel!.attributes
        productUploadCombinationTableViewController.productModel = self.productModel!.copy()
        productUploadCombinationTableViewController.selectedIndexpath = indexPath
        productUploadCombinationTableViewController.delegate = self
        self.navigationController!.pushViewController(productUploadCombinationTableViewController, animated: true)
    }
}
