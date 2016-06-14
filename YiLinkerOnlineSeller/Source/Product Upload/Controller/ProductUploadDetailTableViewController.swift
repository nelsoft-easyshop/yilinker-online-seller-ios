//
//  ProductUploadDetailTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Constant variables declarations
struct PUDTConstant {
    static let productUploadDetailHeaderViewCollectionViewCellNibNameAndIdentifier = "ProductUploadDetailHeaderViewCollectionViewCell"
    static let productUploadAttributeCollectionViewCellNibNameAndIdentifier = "ProductUploadAttributeCollectionViewCell"
    static let productUploadDetailFooterTableViewCellNibNameAndIdentifier = "ProductUploadDetailFooterTableViewCell"
    static let productUploadDetailHeaderViewTableViewCellNibNameAndIdentifier = "ProductUploadDetailHeaderViewTableViewCell"
    static let productUploadAttributeTableViewCellNibNameAndIdentifier = "ProductUploadAttributeTableViewCell"
}

// MARK: Delegate
// ProductUploadDetailTableViewController Delegate method
protocol ProductUploadDetailTableViewControllerDelegate {
    func productUploadDetailTableViewController(didPressSaveButtonWithAttributes attribute: AttributeModel, indexPath: NSIndexPath, productModel: ProductModel, isEdit: Bool)
    func productUploadDetailTableViewController(didPressSaveButtonWithAttributes attribute: AttributeModel, indexPath: NSIndexPath)
}

class ProductUploadDetailTableViewController: UITableViewController, ProductUploadDetailFooterTableViewCellDelegate, ProductUploadDetailHeaderViewCollectionViewCellDelegate, ProductUploadAttributeTableViewCellDelegate, ProductUploadDetailHeaderViewTableViewCellDelegate {
    
    // Models
    var productModel: ProductModel?
    var productModelCombi: ProductModel?
    
    // Global variables
    var dynamicRowHeight: CGFloat = 0
    var tempDetailName: String = ""
    
    var deletedCells: [NSIndexPath] = []
    var unsavedCells: [NSIndexPath] = []
    var unsavedValues: [String] = []
    var valuesDeletedButCancelled: [String] = []
    
    var selectedIndexPath: NSIndexPath = NSIndexPath.new()
    var isCancel: Bool = false
    var isDeleted: Bool = true
    
    // Initialize ProductUploadDetailTableViewControllerDelegate
    var delegate: ProductUploadDetailTableViewControllerDelegate?
    var detailFooterViewCell: ProductUploadDetailFooterTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Add tap gesture recognizer to tableview to dismiss keyboard when tap outside the view
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "endEditing")
        self.tableView.userInteractionEnabled = true
        self.tableView.addGestureRecognizer(tapRecognizer)
        
        self.backButton()
        self.registerCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: -
    // MARK: - Navigation bar
    // Add back button in navigation bar
    
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
    // MARK: - Navigation bar button action
    
    func back() {
        if self.deletedCells.count != 0 {
            self.productUploadDetailFooterTableViewCell(didPressSaveButton: self.detailFooterViewCell!)
        } else {
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    func endEditing() {
        self.tableView.endEditing(true)
    }
    
    // MARK: -
    // MARK: - Register table view cells
    
    func registerCell() {
        let nib: UINib = UINib(nibName: ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier)
        
        let nib2: UINib = UINib(nibName: PUDTConstant.productUploadDetailFooterTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib2, forCellReuseIdentifier: PUDTConstant.productUploadDetailFooterTableViewCellNibNameAndIdentifier)
        
        let nib3: UINib = UINib(nibName: PUDTConstant.productUploadDetailHeaderViewTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib3, forCellReuseIdentifier: PUDTConstant.productUploadDetailHeaderViewTableViewCellNibNameAndIdentifier)
        
        let nib4: UINib = UINib(nibName: PUDTConstant.productUploadAttributeTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib4, forCellReuseIdentifier: PUDTConstant.productUploadAttributeTableViewCellNibNameAndIdentifier)
    }

    // MARK: -
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: ProductUploadDetailHeaderViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUDTConstant.productUploadDetailHeaderViewTableViewCellNibNameAndIdentifier) as! ProductUploadDetailHeaderViewTableViewCell
           
            if self.productModel != nil {
                cell.cellTextField.text = self.productModel!.attributes[self.selectedIndexPath.section].definition
                cell.edited = true
            } else {
                cell.edited = false
            }
            
            cell.delegate = self
           
            return cell
        } else if indexPath.row == 1 {
            let cell: ProductUploadAttributeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUDTConstant.productUploadAttributeTableViewCellNibNameAndIdentifier) as! ProductUploadAttributeTableViewCell
            
            if self.productModel != nil {
                cell.attributes = self.productModel!.attributes[self.selectedIndexPath.section].values
            }
            
            //cell.parentViewController = self
            cell.delegate = self
            
            return cell
        } else {
            let detailFooterViewCell: ProductUploadDetailFooterTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUDTConstant.productUploadDetailFooterTableViewCellNibNameAndIdentifier) as! ProductUploadDetailFooterTableViewCell
            detailFooterViewCell.delegate = self
            self.detailFooterViewCell = detailFooterViewCell
            
            return detailFooterViewCell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 41
        } else if indexPath.row == 1 {
            if self.productModel == nil {
                return self.dynamicRowHeight
            } else {
                let rowInitialHeight: CGFloat = 18
                let rowHeight: CGFloat = 52
                
                let cellCount: Int = self.productModel!.attributes[self.selectedIndexPath.section].values.count
                
                var numberOfRows: CGFloat = CGFloat(cellCount) / 3
                
                if numberOfRows == 0 {
                    numberOfRows = 1
                } else if floor(numberOfRows) != numberOfRows {
                    numberOfRows++
                }
                
                var dynamicHeight: CGFloat = floor(numberOfRows) * rowHeight
                
                var cellHeight: CGFloat = rowInitialHeight + dynamicHeight
                
                return cellHeight
            }
        } else {
            return 130
        }
    }
    
    // MARK: -
    // MARK: - ProductUploadDetailHeaderViewCollectionViewCell Delegate method
  
    func productUploadDetailHeaderViewCollectionViewCell(editingCellTextFieldWithText text: String) {
        self.tempDetailName = text
    }
    
    // MARK: -
    // MARK: - ProductUploadDetailFooterTableViewCell Delegate method
    // MARK: - Save the changes made in product details
    
    func productUploadDetailFooterTableViewCell(didPressSaveButton cell: ProductUploadDetailFooterTableViewCell) {
        if self.productModel != nil || self.isCancel == true {
            for (index, path) in enumerate(self.deletedCells) {
                if self.productModel!.attributes.count != 0 && self.productModel!.attributes.count < path.section && self.productModel!.attributes[selectedIndexPath.section].values.count < path.row {
                    self.productModel!.attributes[selectedIndexPath.section].values.removeAtIndex(path.row)
                }
            }
        }
        
        let indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell: ProductUploadDetailHeaderViewTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! ProductUploadDetailHeaderViewTableViewCell
        
        let collectionViewIndexPath: NSIndexPath = NSIndexPath(forItem: 1, inSection: indexPath.section)
        let attributeCell: ProductUploadAttributeTableViewCell = self.tableView.cellForRowAtIndexPath(collectionViewIndexPath) as! ProductUploadAttributeTableViewCell
        
        if attributeCell.attributes.count != 0 && cell.cellTextField.text != "" {
            var attributeModel: AttributeModel = AttributeModel()
            attributeModel.definition = CommonHelper.firstCharacterUppercaseString(cell.cellTextField.text)
            attributeModel.values = attributeCell.attributes
            
            // Remove unsaved attribute value
            for (index, path) in enumerate(self.unsavedCells) {
                if attributeCell.attributes.count != 0 && self.isCancel == true {
                    self.productModel!.attributes[path.section].values.removeAtIndex(self.productModel!.attributes[path.section].values.count-1)
                    attributeModel.values = self.productModel!.attributes[path.section].values
                }
            }
            
            // Add deleted attribute values when cancelled
            for (index, path) in enumerate(self.deletedCells) {
                if attributeCell.attributes.count != 0 && self.isDeleted == false && self.isCancel == true {
                    attributeModel.values.insert(self.valuesDeletedButCancelled[index], atIndex: path.row)
                }
            }
            
            if self.productModel != nil {
                self.delegate!.productUploadDetailTableViewController(didPressSaveButtonWithAttributes: attributeModel, indexPath: self.selectedIndexPath, productModel: self.productModelCombi!, isEdit: true)
            } else {
                self.delegate!.productUploadDetailTableViewController(didPressSaveButtonWithAttributes: attributeModel, indexPath: self.selectedIndexPath)
            }
            
            self.navigationController!.popViewControllerAnimated(true)
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.attributeValuesRequired)
        }
    }
    
    // MARK: -
    // MARK: - ProductUploadDetailFooterTableViewCell Delegate method
    // MARK: - Save attribute value after clicking the keyboard's "DONE" key
    
    func productUploadDetailFooterTableViewCell(didPressDoneButton cell: ProductUploadDetailFooterTableViewCell) {
        let cellPadding: CGFloat = 18
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
        let collectionViewIndexPath: NSIndexPath = NSIndexPath(forItem: 1, inSection: indexPath.section)
        var isValid: Bool = true
        
        let attributeCell: ProductUploadAttributeTableViewCell = self.tableView.cellForRowAtIndexPath(collectionViewIndexPath) as! ProductUploadAttributeTableViewCell

        // Iterate in product attributes to check if the newly added attribute is already added
        for attribute in attributeCell.attributes {
            if (attribute as NSString).lowercaseString == (cell.cellTextField.text).lowercaseString {
                isValid = false
                break
            }
        }
        
        // Check if 'isValid' is false, add the attribute in the product model
        // Else, show alert view that the attribute is already taken
        if isValid {
            let value: String = CommonHelper.firstCharacterUppercaseString(cell.cellTextField.text)
            attributeCell.attributes.append(value)
            
            // Save values in an array of strings and indexpaths
            if self.productModel != nil {
                // Capitalize the first letter of the string
                let value: String = CommonHelper.firstCharacterUppercaseString(cell.cellTextField.text)
                self.productModel!.attributes[self.selectedIndexPath.section].values.append(value)
                var index: NSIndexPath = NSIndexPath(forRow: self.productModel!.attributes[self.selectedIndexPath.section].values.count-1, inSection: self.selectedIndexPath.section)
                self.unsavedCells.append(index)
                self.unsavedValues.append(value)
            }
            
            attributeCell.collectionView.reloadData()
            
            cell.cellTextField.text = ""
            cell.cellTextField.becomeFirstResponder()
            
            self.dynamicRowHeight = attributeCell.collectionViewContentSize().height + cellPadding
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.attributeAlreadyExist, title: Constants.Localized.error)
        }
    }
    
    // MARK: -
    // MARK: - ProductUploadDetailFooterTableViewCell Delegate method
    // MARK: - Cancel the combination
    
    func productUploadDetailFooterTableViewCell(didPressCancelButton cell: ProductUploadDetailFooterTableViewCell) {
        self.isCancel = true
        self.isDeleted = false
        self.productUploadDetailFooterTableViewCell(didPressSaveButton: cell)
    }
    
    // MARK: -
    // MARK: - ProductUploadDetailFooterTableViewCell Delegate method
    
    func productUploadDetailFooterTableViewCell(cell: ProductUploadDetailFooterTableViewCell, didSelectButton button: UIButton) {
        self.tableView.reloadData()
    }
    
    // MARK: -
    // MARK: - ProductUploadAttributeTableViewCell Delegate method
    // MARK: - Delete cell when tapped one cell. Store all the indexpath of the deleted attribute
    
    func productUploadAttributeTableViewCell(didTapCell cell: ProductUploadAttributeTableViewCell, indexPath: NSIndexPath) {
        self.isDeleted = true
        self.valuesDeletedButCancelled.append(cell.attributes[indexPath.row])
        self.deletedCells.append(indexPath)
    }
    
    // MARK: -
    // MARK: - ProductUploadDetailHeaderViewTableViewCell Delegate method
    
    func productUploadDetailHeaderViewTableViewCell(didEndEditing productUploadDetailHeaderViewTableViewCell: ProductUploadDetailHeaderViewTableViewCell, text: String) {
    }
    
    // MARK: -
    // MARK: - Dealloc
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
}
