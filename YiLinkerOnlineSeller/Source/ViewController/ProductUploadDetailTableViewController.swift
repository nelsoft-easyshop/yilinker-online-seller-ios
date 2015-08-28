//
//  ProductUploadDetailTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct PUDTConstant {
    static let productUploadDetailHeaderViewCollectionViewCellNibNameAndIdentifier = "ProductUploadDetailHeaderViewCollectionViewCell"
    static let productUploadAttributeCollectionViewCellNibNameAndIdentifier = "ProductUploadAttributeCollectionViewCell"
    static let productUploadDetailFooterTableViewCellNibNameAndIdentifier = "ProductUploadDetailFooterTableViewCell"
    static let productUploadDetailHeaderViewTableViewCellNibNameAndIdentifier = "ProductUploadDetailHeaderViewTableViewCell"
    static let productUploadAttributeTableViewCellNibNameAndIdentifier = "ProductUploadAttributeTableViewCell"
}

protocol ProductUploadDetailTableViewControllerDelegate {
    func productUploadDetailTableViewController(didPressSaveButtonWithAttributes attribute: AttributeModel)
}

class ProductUploadDetailTableViewController: UITableViewController, ProductUploadDetailFooterTableViewCellDelegate, ProductUploadDetailHeaderViewCollectionViewCellDelegate {
    
    var tempDetailName: String = ""
    var dynamicRowHeight: CGFloat = 0
    var delegate: ProductUploadDetailTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "endEditing")
        self.tableView.userInteractionEnabled = true
        self.tableView.addGestureRecognizer(tapRecognizer)
        self.backButton()
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
    
    func endEditing() {
        self.tableView.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: ProductUploadDetailHeaderViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUDTConstant.productUploadDetailHeaderViewTableViewCellNibNameAndIdentifier) as! ProductUploadDetailHeaderViewTableViewCell
            
            return cell
        } else if indexPath.row == 1 {
            let cell: ProductUploadAttributeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUDTConstant.productUploadAttributeTableViewCellNibNameAndIdentifier) as! ProductUploadAttributeTableViewCell
            
            return cell
        } else {
            let detailFooterViewCell: ProductUploadDetailFooterTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUDTConstant.productUploadDetailFooterTableViewCellNibNameAndIdentifier) as! ProductUploadDetailFooterTableViewCell
            
            detailFooterViewCell.delegate = self
            return detailFooterViewCell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 41
        } else if indexPath.row == 1 {
            return self.dynamicRowHeight
        } else {
            return 130
        }
    }
    
    func productUploadDetailHeaderViewCollectionViewCell(editingCellTextFieldWithText text: String) {
        self.tempDetailName = text
    }
    
    func productUploadDetailFooterTableViewCell(didPressSaveButton cell: ProductUploadDetailFooterTableViewCell) {
        let indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        let cell: ProductUploadDetailHeaderViewTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! ProductUploadDetailHeaderViewTableViewCell
        
        let collectionViewIndexPath: NSIndexPath = NSIndexPath(forItem: 1, inSection: indexPath.section)
        let attributeCell: ProductUploadAttributeTableViewCell = self.tableView.cellForRowAtIndexPath(collectionViewIndexPath) as! ProductUploadAttributeTableViewCell
        
        var attributeModel: AttributeModel = AttributeModel()
        attributeModel.definition = cell.cellTextField.text
        attributeModel.values = attributeCell.attributes
        
        self.delegate!.productUploadDetailTableViewController(didPressSaveButtonWithAttributes: attributeModel)
        
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func productUploadDetailFooterTableViewCell(didPressDoneButton cell: ProductUploadDetailFooterTableViewCell) {
        let cellPadding: CGFloat = 18
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
        
        let collectionViewIndexPath: NSIndexPath = NSIndexPath(forItem: 1, inSection: indexPath.section)
        let attributeCell: ProductUploadAttributeTableViewCell = self.tableView.cellForRowAtIndexPath(collectionViewIndexPath) as! ProductUploadAttributeTableViewCell
        attributeCell.attributes.append(cell.cellTextField.text)
        attributeCell.collectionView.reloadData()
        
        cell.cellTextField.text = ""
        cell.cellTextField.becomeFirstResponder()
        
        self.dynamicRowHeight = attributeCell.collectionViewContentSize().height + cellPadding
        
        self.tableView.beginUpdates()
        //self.tableView.reloadRowsAtIndexPaths([collectionViewIndexPath], withRowAnimation: UITableViewRowAnimation.None)
        self.tableView.endUpdates()
    }
    func productUploadDetailFooterTableViewCell(cell: ProductUploadDetailFooterTableViewCell, didSelectButton button: UIButton) {
        self.tableView.reloadData()
    }
}
