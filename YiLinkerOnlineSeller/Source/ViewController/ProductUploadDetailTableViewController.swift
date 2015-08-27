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
}

class ProductUploadDetailTableViewController: UITableViewController, ProductUploadDetailFooterTableViewCellDelegate, ProductUploadDetailHeaderViewCollectionViewCellDelegate {
    
    var tempDetailName: String = ""
    var dynamicRowHeight: CGFloat = 41
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "endEditing")
        self.tableView.userInteractionEnabled = true
        self.tableView.addGestureRecognizer(tapRecognizer)
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
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: ProductUploadDetailHeaderViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(PUDTConstant.productUploadDetailHeaderViewTableViewCellNibNameAndIdentifier) as! ProductUploadDetailHeaderViewTableViewCell
            
            return cell
        } else if indexPath.row == 1 {
            let cell: ProductUploadCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier) as! ProductUploadCategoryTableViewCell
            
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
    
    func productUploadDetailFooterTableViewCell(didPressDoneButton cell: ProductUploadDetailFooterTableViewCell) {
        self.tableView.beginUpdates()
        self.dynamicRowHeight = dynamicRowHeight + 50
        self.tableView.endUpdates()
    }
    func productUploadDetailFooterTableViewCell(cell: ProductUploadDetailFooterTableViewCell, didSelectButton button: UIButton) {
        self.tableView.reloadData()
    }
}
