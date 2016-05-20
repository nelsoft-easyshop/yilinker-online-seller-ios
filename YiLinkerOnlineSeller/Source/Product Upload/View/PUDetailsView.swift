//
//  PUDetailsView.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 4/22/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol PUDetailsViewDelegate {
    func puDetailsView(text: String)
    func puDetailsView(didPressSaveButtonWithAttributes attribute: AttributeModel, indexPath: NSIndexPath, productModel: ProductModel)
    func puDetailsView(didPressSaveButtonWithAttributes attribute: AttributeModel, indexPath: NSIndexPath)
}

class PUDetailsView: UIView, UITableViewDelegate, UITableViewDataSource, ProductUploadDetailHeaderViewTableViewCellDelegate, ProductUploadAttributeTableViewCellDelegate, ProductUploadDetailFooterTableViewCellDelegate {

    // TableView
    @IBOutlet weak var tableView: UITableView!
    
    var parentViewController: ProductUploadDetailTableViewController?
    var cell: ProductUploadDetailHeaderViewTableViewCell?
    // Models
    var productModel: ProductModel?
    
    // Variables
    var dynamicRowHeight: CGFloat = 0
    var tempDetailName: String = ""
    
    var deletedCells: [NSIndexPath] = []
    var selectedIndexPath: NSIndexPath = NSIndexPath.new()
    
    var delegate: PUDetailsViewDelegate?
    
    override func awakeFromNib() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.registerCell()
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
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: ProductUploadDetailHeaderViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUDTConstant.productUploadDetailHeaderViewTableViewCellNibNameAndIdentifier) as! ProductUploadDetailHeaderViewTableViewCell
            self.cell = cell
            
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
            println(cell.frame)
            //cell.parentViewController = self.parentViewController
            cell.productModel = self.productModel
            cell.delegate = self
            
            return cell
        } else {
            let detailFooterViewCell: ProductUploadDetailFooterTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUDTConstant.productUploadDetailFooterTableViewCellNibNameAndIdentifier) as! ProductUploadDetailFooterTableViewCell
            
            detailFooterViewCell.delegate = self
            return detailFooterViewCell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
    // MARK: - ProductUploadDetailHeaderViewTableViewCell Delegate method
    
    func productUploadDetailHeaderViewTableViewCell(didEndEditing productUploadDetailHeaderViewTableViewCell: ProductUploadDetailHeaderViewTableViewCell, text: String) {
        self.delegate!.puDetailsView(text)
        self.tempDetailName = text
    }
    
    // MARK: -
    // MARK: - ProductUploadAttributeTableViewCell Delegate Method
    
    func productUploadAttributeTableViewCell(didTapCell cell: ProductUploadAttributeTableViewCell, indexPath: NSIndexPath) {
        self.deletedCells.append(indexPath)
    }
    
    // MARK: -
    // MARK: - ProductUploadDetailFooterTableViewCell Delegate Methods
    
    func productUploadDetailFooterTableViewCell(cell: ProductUploadDetailFooterTableViewCell, didSelectButton button:  UIButton) {
        if self.productModel != nil {
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
            if self.productModel != nil {
                self.delegate?.puDetailsView(didPressSaveButtonWithAttributes: attributeModel, indexPath: self.selectedIndexPath, productModel: self.productModel!)
            } else {
                self.delegate!.puDetailsView(didPressSaveButtonWithAttributes: attributeModel, indexPath: self.selectedIndexPath)
            }
            
            //self.navigationController!.popViewControllerAnimated(true)
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.attributeValuesRequired)
        }
    }
    
    func productUploadDetailFooterTableViewCell(didPressDoneButton cell: ProductUploadDetailFooterTableViewCell) {
        let cellPadding: CGFloat = 18
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
        
        let collectionViewIndexPath: NSIndexPath = NSIndexPath(forItem: 1, inSection: indexPath.section)
        let attributeCell: ProductUploadAttributeTableViewCell = self.tableView.cellForRowAtIndexPath(collectionViewIndexPath) as! ProductUploadAttributeTableViewCell
        var isValid: Bool = true
        
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
            
            if self.productModel != nil {
                // Capitalize the first letter of the string
                let value: String = CommonHelper.firstCharacterUppercaseString(cell.cellTextField.text)
                self.productModel!.attributes[self.selectedIndexPath.section].values.append(value)
            }
            
            attributeCell.collectionView.reloadData()
            
            cell.cellTextField.text = ""
            cell.cellTextField.becomeFirstResponder()
            
            self.dynamicRowHeight = attributeCell.collectionViewContentSize().height + cellPadding
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        } else {
            println(ProductUploadStrings.attributeAlreadyExist)
            //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.attributeAlreadyExist, title: Constants.Localized.error)
        }
    }
    
    func productUploadDetailFooterTableViewCell(didPressSaveButton cell: ProductUploadDetailFooterTableViewCell) {
        if self.productModel != nil {
            for (index, path) in enumerate(self.deletedCells) {
                self.productModel!.attributes[selectedIndexPath.section].values.removeAtIndex(path.row)
                /*if self.productModel!.attributes.count != 0 && self.productModel!.attributes.count < path.section && self.productModel!.attributes[selectedIndexPath.section].values.count < path.row {
                    self.productModel!.attributes[selectedIndexPath.section].values.removeAtIndex(path.row)
                }*/
            }
        }
        let indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell: ProductUploadDetailHeaderViewTableViewCell = self.cell!
        
        let collectionViewIndexPath: NSIndexPath = NSIndexPath(forItem: 1, inSection: indexPath.section)
        let attributeCell: ProductUploadAttributeTableViewCell = self.tableView.cellForRowAtIndexPath(collectionViewIndexPath) as! ProductUploadAttributeTableViewCell
        
        if attributeCell.attributes.count != 0 && cell.cellTextField.text != "" {
            var attributeModel: AttributeModel = AttributeModel()
            attributeModel.definition = CommonHelper.firstCharacterUppercaseString(cell.cellTextField.text)
            attributeModel.values = attributeCell.attributes
            if self.productModel != nil {
                self.delegate?.puDetailsView(didPressSaveButtonWithAttributes: attributeModel, indexPath: self.selectedIndexPath, productModel: self.productModel!)
            } else {
                self.delegate!.puDetailsView(didPressSaveButtonWithAttributes: attributeModel, indexPath: self.selectedIndexPath)
            }
            
            //self.navigationController!.popViewControllerAnimated(true)
        } else {
            println(ProductUploadStrings.attributeValuesRequired)
            //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.attributeValuesRequired)
        }
    }
    
    func puDetailsViewEdit(productModel: ProductModel) {
        self.productModel = productModel
        self.tableView.reloadData()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
