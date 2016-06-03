//
//  ProductUploadAttributeListVC.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 4/22/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadAttributeListVCDelegate {
    func puDetailsView(didPressSaveButtonWithAttributes attribute: AttributeModel, indexPath: NSIndexPath)
}

class ProductUploadAttributeListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ProductUploadDetailTableViewControllerDelegate, ProductUploadAddFooterViewDelegate, PUAttributeSetHeaderTableViewCellDelegate, PUDetailsViewDelegate {
    
    // Buttonssd
    @IBOutlet weak var footerButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // Models
    var productModel: ProductModel?
    
    // Global variables
    var dynamicRowHeight: CGFloat = 0
    var delegate:ProductUploadAttributeListVCDelegate?
    var cellIsInEdit: Bool = false
    var addMoreTableViewFooter: PUDetailsView?
    
    var uploadType: UploadType = UploadType.NewProduct
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar title
        self.title = Constants.ViewControllersTitleString.atttributeList
        
        if self.productModel!.attributes.count == 0 {
            self.productDetails()
        }
        
        self.backButton()
        self.registerCell()
        self.addTableViewFooter()
        self.changeButtonName()
        self.initTableView()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button actions
    @IBAction func proceedToCombination(sender: AnyObject) {
        if self.productModel!.attributes.count != 0 {
            let productUploadCombinationListViewController: ProductUploadCombinationListViewController = ProductUploadCombinationListViewController(nibName: "ProductUploadCombinationListViewController", bundle: nil)
            productUploadCombinationListViewController.productModel = self.productModel
            productUploadCombinationListViewController.uploadType = self.uploadType
            self.navigationController!.pushViewController(productUploadCombinationListViewController, animated: true)
        } else {
            let productUploadTableViewController: ProductUploadTC
            = self.navigationController?.viewControllers[0] as! ProductUploadTC
            productUploadTableViewController.replaceProductAttributeWithAttribute(self.productModel!.attributes, combinations: self.productModel!.validCombinations)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    // MARK: -
    // MARK: - Local methods
    // MARK: - Add tableview footer
    
    func addTableViewFooter() {
        let addMoreTableViewFooter: ProductUploadAddFooterView = XibHelper.puffViewWithNibName("ProductUploadAddFooterView", index: 0) as! ProductUploadAddFooterView
        addMoreTableViewFooter.delegate = self
        self.tableView.tableFooterView = addMoreTableViewFooter
    }
    
    // MARK: -
    // MARK: - Navigation bar
    
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
    
    // MARK: -
    // MARK: - Navigation bar action method for back button

    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    // MARK: -
    // MARK: - Change button name
    
    func changeButtonName() {
        if self.productModel!.attributes.count == 0 {
            self.footerButton.backgroundColor = Constants.Colors.transactionGrey
            self.footerButton.userInteractionEnabled = false
        } else {
            self.footerButton.backgroundColor = Constants.Colors.selectedGreenColor
            self.footerButton.userInteractionEnabled = true
        }
        self.footerButton.setTitle(ProductUploadStrings.proceedToCombination, forState: UIControlState.Normal)
    }
    
    // MARK: -
    // MARK: -
    
    func checkAvailability(attribute: AttributeModel) -> Bool {
        var isAvailable: Bool = false
        for productAttribute in self.productModel!.attributes as [AttributeModel] {
            if (productAttribute.definition).lowercaseString == attribute.definition.lowercaseString {
                isAvailable = true
            }
        }
        return isAvailable
    }
    
    // MARK: -
    // MARK: - Init tableview 
    
    func initTableView() {
        // Initialize tableview
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: -
    // MARK: - Product details
    
    func productDetails() {
        let productUploadDetailViewController: ProductUploadDetailTableViewController = ProductUploadDetailTableViewController(nibName: "ProductUploadDetailTableViewController", bundle: nil)
        productUploadDetailViewController.delegate = self
        self.navigationController!.pushViewController(productUploadDetailViewController, animated: true)
    }
    
    // MARK: -
    // MARK: - Register table view cells
    
    func registerCell() {
        let nib4: UINib = UINib(nibName: PUDTConstant.productUploadAttributeTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib4, forCellReuseIdentifier: PUDTConstant.productUploadAttributeTableViewCellNibNameAndIdentifier)
        
        let nib: UINib = UINib(nibName: PUALTVConstant.pUAttributeSetHeaderTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: PUALTVConstant.pUAttributeSetHeaderTableViewCellNibNameAndIdentifier)
    }
    
    // MARK: -
    // MARK: - Remove table view footer
    
    func removeFooter() {
        self.tableView.tableFooterView = nil
        self.tableView.tableFooterView = self.addMoreTableViewFooter!
    }
    
    // MARK: -
    // MARK: - ProductUploadAddFooterView Delegate methods
    // Calls ProductUploadDetailTableViewController
    
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
    
    // MARK: -
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.productModel!.attributes.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: PUAttributeSetHeaderTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUALTVConstant.pUAttributeSetHeaderTableViewCellNibNameAndIdentifier) as! PUAttributeSetHeaderTableViewCell
            
            let attributeModel: AttributeModel = self.productModel!.attributes[indexPath.section]
            cell.delegate = self
            cell.attributeDefinitionLabel!.text = attributeModel.definition
            
            if self.cellIsInEdit {
                cell.userInteractionEnabled = false
            } else {
                cell.userInteractionEnabled = true
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        } else {
            let cell: ProductUploadAttributeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUDTConstant.productUploadAttributeTableViewCellNibNameAndIdentifier) as! ProductUploadAttributeTableViewCell
            
            let attributeModel: AttributeModel = self.productModel!.attributes[indexPath.section]
            
            cell.attributes = attributeModel.values
            cell.collectionView.reloadData()
            cell.parentViewController = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.userInteractionEnabled = false
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let rowInitialHeight: CGFloat = 18
        
        if indexPath.row == 1 {
            let rowHeight: CGFloat = 52
            
            let cellCount: Int = self.productModel!.attributes[indexPath.section].values.count
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
    
    // MARK: -
    // MARK: - ProductUploadDetailTableViewController delegate method
    
    func productUploadDetailTableViewController(didPressSaveButtonWithAttributes attribute: AttributeModel, indexPath: NSIndexPath, productModel: ProductModel) {
        var attributeIsAvailable: Bool = self.checkAvailability(attribute)
        
        self.productModel! = productModel
        
        if attributeIsAvailable {
            self.productModel!.attributes[indexPath.section] = attribute
        } else {
            self.productModel!.attributes.append(attribute)
        }
        
        self.tableView.reloadData()
        self.changeButtonName()
    }
    
    // MARK: -
    // MARK: - ProductUploadDetailTableViewController delegate method
    
    func productUploadDetailTableViewController(didPressSaveButtonWithAttributes attribute: AttributeModel, indexPath: NSIndexPath) {
        var attributeIsAvailable: Bool = self.checkAvailability(attribute)
        
        if attributeIsAvailable {
            if self.productModel!.attributes.count > indexPath.section {
                self.productModel!.attributes[indexPath.section] = attribute
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "\(ProductUploadStrings.attributeDef) \(attribute.definition) \(ProductUploadStrings.alreadyExist)", title: Constants.Localized.error)
            }
        } else {
            if self.productModel!.validCombinations.count != 0 {
                for (index, combination) in enumerate(self.productModel!.validCombinations) {
                    self.productModel!.validCombinations.removeAtIndex(0)
                }
            }
            
            self.productModel!.attributes.append(attribute)
        }
        
        self.tableView.reloadData()
        self.changeButtonName()
    }
    
    // MARK: -
    // MARK: - ProductUploadAttributeSetHeaderTableViewCell delegate methods
    // MARK: - Delete an attribute
    
    func pUAttributeSetHeaderTableViewCell(didClickDelete cell: PUAttributeSetHeaderTableViewCell) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
        let range: NSRange = NSMakeRange(indexPath.section, 1)
        let section: NSIndexSet = NSIndexSet(indexesInRange: range)
        
        let deletedAttribute: AttributeModel = self.productModel!.attributes[indexPath.section]
        let attributeTitle: String = deletedAttribute.definition
        
        for combination in self.productModel!.validCombinations {
            for dictionary in combination.attributes {
                if attributeTitle == dictionary["name"] as! String {
                    for (index, c) in enumerate(self.productModel!.validCombinations) {
                        self.productModel!.validCombinations.removeAtIndex(0)
                    }
                }
            }
        }
        
        self.productModel!.attributes.removeAtIndex(indexPath.section)
        self.tableView.beginUpdates()
        self.tableView.deleteSections(section, withRowAnimation: UITableViewRowAnimation.Fade)
        self.tableView.endUpdates()
        self.tableView.reloadData()
        self.changeButtonName()
    }
    
    // MARK: -
    // MARK: - PUAttributeSetHeaderTableViewCell Delegate method
    // MARK: - Edit an attribute
    
    func pUAttributeSetHeaderTableViewCell(didClickEdit cell: PUAttributeSetHeaderTableViewCell) {
        /*self.tableView.tableFooterView = nil
        let addMoreTableViewFooter: PUDetailsView = XibHelper.puffViewWithNibName("PUDetailsView", index: 0) as! PUDetailsView
        addMoreTableViewFooter.delegate = self
        addMoreTableViewFooter.productModel = self.productModel!.copy()
        addMoreTableViewFooter.selectedIndexPath = self.tableView.indexPathForCell(cell)!
        addMoreTableViewFooter.puDetailsViewEdit(self.productModel!.copy())
        addMoreTableViewFooter.parentViewController = self
        
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
        let range: NSRange = NSMakeRange(indexPath.section, 1)
        let section: NSIndexSet = NSIndexSet(indexesInRange: range)
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.tableView.numberOfSections()
            var numberOfRows: Int = 0
            
            if numberOfSections > 0 {
                numberOfRows = self.tableView.numberOfRowsInSection(numberOfSections-1)
            }
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        })
        self.cellIsInEdit = true
        self.productModel!.attributes.removeAtIndex(self.tableView.indexPathForCell(cell)!.section)
        self.tableView.deleteSections(section, withRowAnimation: UITableViewRowAnimation.Left)
        self.tableView.reloadData()
        self.tableView.tableFooterView = addMoreTableViewFooter*/
        
        let productUploadDetailViewController: ProductUploadDetailTableViewController = ProductUploadDetailTableViewController(nibName: "ProductUploadDetailTableViewController", bundle: nil)
        productUploadDetailViewController.selectedIndexPath = self.tableView.indexPathForCell(cell)!
        productUploadDetailViewController.delegate = self
        productUploadDetailViewController.productModelCombi = self.productModel!
        productUploadDetailViewController.productModel = self.productModel!.copy()
        self.navigationController!.pushViewController(productUploadDetailViewController, animated: true)
    }
    
    // MARK: -
    // MARK: - PUDetailsView Delegate Method
    
    func puDetailsView(text: String) {
        
    }
    
    func puDetailsView(didPressSaveButtonWithAttributes attribute: AttributeModel, indexPath: NSIndexPath, productModel: ProductModel) {
        
        var attributeIsAvailable: Bool = self.checkAvailability(attribute)
        self.productModel!.attributes = productModel.attributes

        
        if attributeIsAvailable {
            self.productModel!.attributes[indexPath.section] = attribute
        } else {
            self.productModel!.attributes[indexPath.section] = attribute
        }
        
        self.tableView.reloadData()
        self.changeButtonName()
        self.cellIsInEdit = false
        self.removeFooter()
    }
    
    func puDetailsView(didPressSaveButtonWithAttributes attribute: AttributeModel, indexPath: NSIndexPath) {
        
        var attributeIsAvailable: Bool = self.checkAvailability(attribute)
        
        if attributeIsAvailable {
            if self.productModel!.attributes.count > indexPath.section {
                self.productModel!.attributes[indexPath.section] = attribute
                self.tableView.reloadData()
                self.changeButtonName()
                self.removeFooter()
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "\(ProductUploadStrings.attributeDef) \(attribute.definition) \(ProductUploadStrings.alreadyExist)", title: Constants.Localized.error)
            }
        } else {
            if self.productModel!.validCombinations.count != 0 {
                for (index, combination) in enumerate(self.productModel!.validCombinations) {
                    self.productModel!.validCombinations.removeAtIndex(0)
                }
            }
            
            self.productModel!.attributes.append(attribute)
           
            self.tableView.reloadData()
            self.changeButtonName()
            self.removeFooter()
        }
    }
    
    func puDetailsView(didPressCancelButtonWithAttributes productModel: ProductModel, indexPath: NSIndexPath) {
        self.productModel = productModel
        self.cellIsInEdit = false
        self.tableView.reloadData()
        self.changeButtonName()
        self.removeFooter()
    }
    
    // Dealloc
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }


}
