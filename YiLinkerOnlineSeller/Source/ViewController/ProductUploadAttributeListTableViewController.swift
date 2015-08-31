//
//  ProductUploadAttributeListTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct PUALTVConstant {
    static let pUAttributeSetHeaderTableViewCellNibNameAndIdentifier = "PUAttributeSetHeaderTableViewCell"
}

class ProductUploadAttributeListTableViewController: UIViewController, ProductUploadDetailTableViewControllerDelegate, ProductUploadAddFooterViewDelegate, PUAttributeSetHeaderTableViewCellDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    var productModel: ProductModel = ProductModel()
    var dynamicRowHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.productModel.attributes.count == 0 {
            let productUploadDetailViewController: ProductUploadDetailTableViewController = ProductUploadDetailTableViewController(nibName: "ProductUploadDetailTableViewController", bundle: nil)
            productUploadDetailViewController.delegate = self
            self.navigationController!.pushViewController(productUploadDetailViewController, animated: true)
        }
        
        self.title = "Attribute List"
        
        self.registerCell()
        self.backButton()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let addMoreTableViewFooter: ProductUploadAddFooterView = XibHelper.puffViewWithNibName("ProductUploadAddFooterView", index: 0) as! ProductUploadAddFooterView
        addMoreTableViewFooter.delegate = self
        self.tableView.tableFooterView = addMoreTableViewFooter
    }
    
    func productUploadAddFooterView(didSelectAddMore view: UIView) {
        let productUploadDetailViewController: ProductUploadDetailTableViewController = ProductUploadDetailTableViewController(nibName: "ProductUploadDetailTableViewController", bundle: nil)
        productUploadDetailViewController.delegate = self
        self.navigationController!.pushViewController(productUploadDetailViewController, animated: true)
    }
    
    func PUAttributeAddFooterView(didSelectAddMore view: UIView) {
        let productUploadDetailViewController: ProductUploadDetailTableViewController = ProductUploadDetailTableViewController(nibName: "ProductUploadDetailTableViewController", bundle: nil)
        productUploadDetailViewController.delegate = self
        self.navigationController!.pushViewController(productUploadDetailViewController, animated: true)
    }
    
    func registerCell() {
        let nib4: UINib = UINib(nibName: PUDTConstant.productUploadAttributeTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib4, forCellReuseIdentifier: PUDTConstant.productUploadAttributeTableViewCellNibNameAndIdentifier)
        
        let nib: UINib = UINib(nibName: PUALTVConstant.pUAttributeSetHeaderTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: PUALTVConstant.pUAttributeSetHeaderTableViewCellNibNameAndIdentifier)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.productModel.attributes.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: PUAttributeSetHeaderTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUALTVConstant.pUAttributeSetHeaderTableViewCellNibNameAndIdentifier) as! PUAttributeSetHeaderTableViewCell
            
            let attributeModel: AttributeModel = self.productModel.attributes[indexPath.section]
            cell.delegate = self
            cell.attributeDefinitionLabel!.text = attributeModel.definition
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        } else {
            let cell: ProductUploadAttributeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUDTConstant.productUploadAttributeTableViewCellNibNameAndIdentifier) as! ProductUploadAttributeTableViewCell
            
            let attributeModel: AttributeModel = self.productModel.attributes[indexPath.section]
            
            cell.attributes = attributeModel.values
            cell.collectionView.reloadData()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.userInteractionEnabled = false
            return cell
        }
    }


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { 
        let rowInitialHeight: CGFloat = 18
        
        if indexPath.row == 0 {
            return 44
        } else if indexPath.row == 1 {
            let rowHeight: CGFloat = 52
            
            let cellCount: Int = self.productModel.attributes[indexPath.section].values.count
            var numberOfRows: CGFloat = CGFloat(cellCount) / 3
            
            if numberOfRows == 0 {
                numberOfRows = 1
            } else if floor(numberOfRows) != numberOfRows {
                numberOfRows++
            }
            
            var dynamicHeight: CGFloat = floor(numberOfRows) * rowHeight
            
            var cellHeight: CGFloat = rowInitialHeight + dynamicHeight
            
            return cellHeight
        } else {
            return 44
        }
    }
    
    func productUploadDetailTableViewController(didPressSaveButtonWithAttributes attribute: AttributeModel, indexPath: NSIndexPath, productModel: ProductModel) {
        var attributeIsAvailable: Bool = false
        self.productModel = productModel
        for productAttribute in self.productModel.attributes as [AttributeModel] {
            if productAttribute.definition == attribute.definition {
                attributeIsAvailable = true
            }
        }
        
        if attributeIsAvailable {
            self.productModel.attributes[indexPath.section] = attribute
        } else {
            self.productModel.attributes.append(attribute)
        }

        self.tableView.reloadData()
    }
    
    func productUploadDetailTableViewController(didPressSaveButtonWithAttributes attribute: AttributeModel, indexPath: NSIndexPath) {
        var attributeIsAvailable: Bool = false
        for productAttribute in self.productModel.attributes as [AttributeModel] {
            if productAttribute.definition == attribute.definition {
                attributeIsAvailable = true
            }
        }
        
        if attributeIsAvailable {
            self.productModel.attributes[indexPath.section] = attribute
        } else {
            if self.productModel.validCombinations.count != 0 {
                for (index, combination) in enumerate(self.productModel.validCombinations) {
                    self.productModel.validCombinations.removeAtIndex(0)
                }
            }
            
            self.productModel.attributes.append(attribute)
        }

        
        self.tableView.reloadData()
    }
    
    @IBAction func proceedToCombination(sender: AnyObject) {
        let productUploadCombinationListViewController: ProductUploadCombinationListViewController = ProductUploadCombinationListViewController(nibName: "ProductUploadCombinationListViewController", bundle: nil)
        productUploadCombinationListViewController.productModel = self.productModel
        self.navigationController!.pushViewController(productUploadCombinationListViewController, animated: true)
    }
    
    func pUAttributeSetHeaderTableViewCell(didClickDelete cell: PUAttributeSetHeaderTableViewCell) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
        let range: NSRange = NSMakeRange(indexPath.section, 1)
        let section: NSIndexSet = NSIndexSet(indexesInRange: range)
        
        let deletedAttribute: AttributeModel = self.productModel.attributes[indexPath.section]
        let attributeTitle: String = deletedAttribute.definition
        
        for combination in self.productModel.validCombinations {
            for dictionary in combination.attributes {
                if attributeTitle == dictionary["name"] as! String {
                    for (index, c) in enumerate(self.productModel.validCombinations) {
                        self.productModel.validCombinations.removeAtIndex(0)
                    }
                }
            }
        }
        
        self.productModel.attributes.removeAtIndex(indexPath.section)
        self.tableView.beginUpdates()
        self.tableView.deleteSections(section, withRowAnimation: UITableViewRowAnimation.Left)
        self.tableView.endUpdates()
        self.tableView.reloadData()
    }
    
    func pUAttributeSetHeaderTableViewCell(didClickEdit cell: PUAttributeSetHeaderTableViewCell) {
        let productUploadDetailViewController: ProductUploadDetailTableViewController = ProductUploadDetailTableViewController(nibName: "ProductUploadDetailTableViewController", bundle: nil)
        productUploadDetailViewController.selectedIndexPath = self.tableView.indexPathForCell(cell)!
        productUploadDetailViewController.delegate = self
        productUploadDetailViewController.productModel = self.productModel.copy()
        self.navigationController!.pushViewController(productUploadDetailViewController, animated: true)
    }
}
