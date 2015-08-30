//
//  ProductUploadCombinationTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct PUCTVCConstant {
    static let productUploadCombinationHeaderTableViewCellNibNameAndIdentifier = "ProductUploadCombinationHeaderTableViewCell"
    static let productUploadCombinationTableViewCellNibNameAndIdentifier = "ProductUploadCombinationTableViewCell"
    static let productUploadCombinationFooterTableViewCellNibNameAndIdentifier = "ProductUploadCombinationFooterTableViewCell"
    static let productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier = "ProductUploadAttributeValuesCollectionViewCell"
   
    static let footerHeight: CGFloat = 331
}

protocol ProductUploadCombinationTableViewControllerDelegate {
    func productUploadCombinationTableViewController(appendCombination combination: CombinationModel, isEdit: Bool, indexPath: NSIndexPath)
}

class ProductUploadCombinationTableViewController: UITableViewController, ProductUploadCombinationFooterTableViewCellDelegate, UzysAssetsPickerControllerDelegate {
    
    var attributes: [AttributeModel]?
    var delegate: ProductUploadCombinationTableViewControllerDelegate?
    var images: [UIImage] = []
    var selectedIndexpath: NSIndexPath?
    var productModel: ProductModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton()
        self.title = "Add Combination"
        
        let headerView: ProductUploadCombinationHeaderTableViewCell = XibHelper.puffViewWithNibName("ProductUploadCombinationHeaderTableViewCell", index: 0) as! ProductUploadCombinationHeaderTableViewCell
        self.tableView.tableHeaderView = headerView
        self.images.append(UIImage(named: "addPhoto")!)
        self.registerCell()
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
    
    func registerCell() {
        let footerNib: UINib = UINib(nibName: PUCTVCConstant.productUploadCombinationFooterTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(footerNib, forCellReuseIdentifier: PUCTVCConstant.productUploadCombinationFooterTableViewCellNibNameAndIdentifier)
        
        let combinationCell: UINib = UINib(nibName: PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(combinationCell, forCellReuseIdentifier: PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier)
        
        let valuesNib: UINib = UINib(nibName: PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(valuesNib, forCellReuseIdentifier: PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier)
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 2
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: ProductUploadCombinationTableViewCell = tableView.dequeueReusableCellWithIdentifier(PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadCombinationTableViewCell
            cell.attributes = self.attributes!
            if self.productModel != nil {
                cell.selectedIndexPath = self.selectedIndexpath
                cell.productModel = self.productModel!.copy()
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            return cell
        } else {
            let cell: ProductUploadCombinationFooterTableViewCell = tableView.dequeueReusableCellWithIdentifier(PUCTVCConstant.productUploadCombinationFooterTableViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadCombinationFooterTableViewCell
            cell.delegate = self
            cell.images = self.images
            
            if self.productModel != nil {
                let combination: CombinationModel = self.productModel!.validCombinations[self.selectedIndexpath!.section]
                combination.images.append(UIImage(named: "addPhoto")!)
                cell.images = combination.images
                cell.discountedPriceTextField.text = combination.discountedPrice
                cell.quantityTextField.text = combination.quantity
                cell.retailPriceTextField.text = combination.retailPrice
                cell.skuTextField.text = combination.sku
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    func productUploadCombinationFooterTableViewCell(didClickDoneButton cell: ProductUploadCombinationFooterTableViewCell, sku: String, quantity: String, discountedPrice: String, retailPrice: String, uploadImages: [UIImage]) {
        let cell: ProductUploadCombinationTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProductUploadCombinationTableViewCell
        let combination: CombinationModel = cell.data()
        combination.images = uploadImages
        combination.quantity = quantity
        combination.discountedPrice = discountedPrice
        combination.sku = sku
        combination.retailPrice = retailPrice
        if self.productModel == nil {
            self.delegate!.productUploadCombinationTableViewController(appendCombination: combination, isEdit: false, indexPath: NSIndexPath())
        } else {
            self.delegate!.productUploadCombinationTableViewController(appendCombination: combination, isEdit: true, indexPath: self.selectedIndexpath!)
        }
        
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func productUploadCombinationFooterTableViewCell(didClickUploadImage cell: ProductUploadCombinationFooterTableViewCell) {
        let picker: UzysAssetsPickerController = UzysAssetsPickerController()
        let maxCount: Int = 6
        
        let imageLimit: Int = maxCount - self.images.count
        picker.delegate = self
        picker.maximumNumberOfSelectionVideo = 0
        picker.maximumNumberOfSelectionPhoto = 100
        UzysAssetsPickerController.setUpAppearanceConfig(self.uzyConfig())
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func uzyConfig() -> UzysAppearanceConfig {
        let config: UzysAppearanceConfig = UzysAppearanceConfig()
        config.finishSelectionButtonColor = Constants.Colors.appTheme
        return config
    }
    
    //UzzyPickerDelegate
    
    func uzysAssetsPickerController(picker: UzysAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        let assetsLibrary = ALAssetsLibrary()
        let alaSset: ALAsset = assets[0] as! ALAsset
        
        for allaSset in assets as! [ALAsset] {
            let image: UIImage = UIImage(CGImage: allaSset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())!
            self.images.insert(image, atIndex: 0)
        }
        
        let indexPath: NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        
        let cell: ProductUploadCombinationFooterTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! ProductUploadCombinationFooterTableViewCell
        cell.images = self.images
        
        let lastIndexPath: NSIndexPath = NSIndexPath(forItem: self.images.count - 1, inSection: 0)
        cell.collectionView.reloadData()
        cell.collectionView.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
    }
    
    func uzysAssetsPickerControllerDidCancel(picker: UzysAssetsPickerController!) {
        
    }
    
    func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker: UzysAssetsPickerController!) {
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let rowInitialHeight: CGFloat = 14
        if indexPath.row == 0 {
            
            let rowHeight: CGFloat = 95
            
            let cellCount: Int = self.attributes!.count
            
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
            return PUCTVCConstant.footerHeight
        }
    }
    
    func productUploadCombinationFooterTableViewCell(didDeleteUploadImage cell: ProductUploadCombinationFooterTableViewCell, indexPath: NSIndexPath) {
        if self.productModel == nil {
            self.images.removeAtIndex(indexPath.row)
        } else {
            if indexPath.row < self.productModel!.validCombinations[self.selectedIndexpath!.section].images.count {
                self.productModel!.validCombinations[self.selectedIndexpath!.section].images.removeAtIndex(indexPath.row)
            }
            
        }
    }
    
}
