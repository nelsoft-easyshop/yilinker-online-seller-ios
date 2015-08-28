//
//  ProductUploadTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/25/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct ProductUploadTableViewControllerConstant {
    static let productUploadUploadImageTableViewCellNibNameAndIdentifier = "ProductUploadUploadImageTableViewCell"
    static let productUploadUploadImageTableViewCellHeight: CGFloat = 165
    
    static let prodcuctUploadHeaderTableViewCellNibNameAndIdentifier = "ProductUploadTableViewController"
    static let productUploadTextfieldTableViewCellNibNameAndIdentifier = "ProductUploadTextFieldTableViewCell"
    static let productUploadTextViewTableViewCellNibNameAndIdentifier = "ProductUploadTextViewTableViewCell"
    static let productUploadPriceTableViewCellNibNameAndIdentifier = "ProductUploadPriceTableViewCell"
    static let productUploadButtonTableViewCellNibNameAndIdentifier = "ProductUploadButtonTableViewCell"
    static let productUploadQuantityTableViewCellNibNameAndIdentifier = "ProductUploadQuantityTableViewCell"
    static let productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier = "ProductUploadDimensionsAndWeightTableViewCell"
    static let productUploadAttributeSummaryTableVieCellNibNameAndIdentifier = "ProductUploadAttributeSummaryTableViewCell"
    
    static let normalcellHeight: CGFloat = 72
    static let normalTextViewCellHeight: CGFloat = 80
    
    static let completeDescriptionHeight: CGFloat = 170
    static let priceCellHeight: CGFloat = 73
    static let buttonCellHeight: CGFloat = 41
    
    static let quantityHeight: CGFloat = 59
    
    static let productUploadWeightAndHeightCellHeight: CGFloat = 244
}

class ProductUploadTableViewController: UITableViewController, ProductUploadUploadImageTableViewCellDataSource, ProductUploadUploadImageTableViewCellDelegate, UzysAssetsPickerControllerDelegate, ProductUploadCategoryViewControllerDelegate {
    
    var uploadImages: [UIImage] = []
    var productModel: ProductModel = ProductModel()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton()
        self.title = "Product Upload"
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        self.register()
        self.addAddPhoto()
        //self.gestureEndEditing()
    }
    
    func gestureEndEditing() {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyBoard")
        self.tableView.userInteractionEnabled = true
        self.tableView.addGestureRecognizer(gesture)
    }
    
    func hideKeyBoard() {
        self.tableView.endEditing(true)
    }
    
    func addAddPhoto() {
        self.uploadImages.append(UIImage(named: "addPhoto")!)
    }
    
    func register() {
        let nib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadUploadImageTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadUploadImageTableViewCellNibNameAndIdentifier)
        
        let productUploadTextFieldNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier, bundle: nil)

        self.tableView.registerNib(productUploadTextFieldNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier)
        
        
        let productHeaderNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.prodcuctUploadHeaderTableViewCellNibNameAndIdentifier, bundle: nil)
        
        self.tableView.registerNib(productHeaderNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.prodcuctUploadHeaderTableViewCellNibNameAndIdentifier)
        
        let productTextViewNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(productTextViewNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier)

        let productPriceNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadPriceTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(productPriceNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadPriceTableViewCellNibNameAndIdentifier)
        
        let productUploadButtonNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadButtonTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(productUploadButtonNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadButtonTableViewCellNibNameAndIdentifier)
        
        let quantityNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadQuantityTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(quantityNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadQuantityTableViewCellNibNameAndIdentifier)
        
        let weightAndHeightNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(weightAndHeightNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier)
        
        let attributeNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadAttributeSummaryTableVieCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(attributeNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadAttributeSummaryTableVieCellNibNameAndIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        //return 5
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        } else if section == 2 {
            //Product Details 6
            return 3
        } else if section == 3 {
            if self.productModel.validCombinations.count == 0 {
                return 3
            } else {
                return self.productModel.validCombinations.count + 2
            }
        } else if section == 3 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var sectionHeight: CGFloat = 0
        
        if section == 0 {
            sectionHeight = 0
        } else if section == 3 {
            sectionHeight = 0
        } else {
            sectionHeight = 41
        }
        return sectionHeight
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ProductUploadTableHeaderView = XibHelper.puffViewWithNibName("ProductUploadTableHeaderView", index: 0) as! ProductUploadTableHeaderView

        if section == 1 {
            headerView.headerTitleLabel.text = "Product Information"
        } else if section == 2 {
            headerView.headerTitleLabel.text = "Product Details"
        } else if section == 3 {
            headerView.headerTitleLabel.text = "Price"
        } else if section == 4 {
            headerView.headerTitleLabel.text = "Dimensions and Weight"
        }
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return ProductUploadTableViewControllerConstant.productUploadUploadImageTableViewCellHeight
        } else if indexPath.section == 1 {
            if indexPath.row == 0 { //Product Information
                return ProductUploadTableViewControllerConstant.normalcellHeight
            } else if indexPath.row == 1 {
                return ProductUploadTableViewControllerConstant.normalTextViewCellHeight
            } else {
                return ProductUploadTableViewControllerConstant.completeDescriptionHeight
            }
            //Product Details
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return ProductUploadTableViewControllerConstant.normalcellHeight
            } else if indexPath.row == 1 {
                return ProductUploadTableViewControllerConstant.normalcellHeight
            } else if indexPath.row == 2 {
                return ProductUploadTableViewControllerConstant.normalcellHeight
            } else if indexPath.row == 3 {
                return ProductUploadTableViewControllerConstant.buttonCellHeight
            } else if indexPath.row == 4 {
                return ProductUploadTableViewControllerConstant.quantityHeight
            } else {
               return ProductUploadTableViewControllerConstant.normalcellHeight
            }
            
        } else if indexPath.section == 3 {
            var height: CGFloat = 0
            
            if self.productModel.validCombinations.count != 0  {
                if indexPath.row <= self.productModel.validCombinations.count {
                    height = 41
                } else {
                    height = ProductUploadTableViewControllerConstant.priceCellHeight
                }

            } else {
                height = ProductUploadTableViewControllerConstant.priceCellHeight
            }
            
            return height
        } else if indexPath.section == 4 {
            return ProductUploadTableViewControllerConstant.productUploadWeightAndHeightCellHeight
        } else {
            return ProductUploadTableViewControllerConstant.normalcellHeight
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: ProductUploadUploadImageTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadUploadImageTableViewCellNibNameAndIdentifier) as! ProductUploadUploadImageTableViewCell
            cell.dataSource = self
            cell.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            } else if indexPath.row == 1 {
                let cell: ProductUploadTextViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier) as! ProductUploadTextViewTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.cellTitleLabel.text = "Short Description"
                
                return cell
            } else if indexPath.row == 2 {
                let cell: ProductUploadTextViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier) as! ProductUploadTextViewTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.cellTitleLabel.text = "Complete Description"
                
                return cell
            } else {
                let cell: ProductUploadTextViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier) as! ProductUploadTextViewTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.cellTitleLabel.text = "Category*"
                cell.cellTexField.placeholder = "Select Category"
                
                let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "category")
                cell.cellTexField.userInteractionEnabled = true
                cell.cellTexField.superview!.addGestureRecognizer(tapGestureRecognizer)
                cell.cellTexField.enabled = false
                
                return cell
            } else if indexPath.row == 1 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.cellTitleLabel.text = "Brand"
                cell.cellTexField.placeholder = "Brand"
                
                let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "brand")
                cell.cellTexField.userInteractionEnabled = true
                cell.cellTexField.superview!.addGestureRecognizer(tapGestureRecognizer)
                cell.cellTexField.enabled = false
                
                cell.addTextFieldDelegate()
                
                return cell
            } else {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.cellTitleLabel.text = "Condition"
                cell.cellTexField.placeholder = "Select the condition of the product"
                
                let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "brand")
                cell.cellTexField.userInteractionEnabled = true
                cell.cellTexField.superview!.addGestureRecognizer(tapGestureRecognizer)
                cell.cellTexField.enabled = false
                
                cell.addTextFieldDelegate()
                
                return cell
            }
        } else if indexPath.section == 3 {
            if self.productModel.validCombinations.count == 0 {
                if indexPath.row == 0 {
                    let cell: ProductUploadButtonTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadButtonTableViewCellNibNameAndIdentifier) as! ProductUploadButtonTableViewCell
                    cell.cellButton.setTitle("ADD MORE DETAILS", forState: UIControlState.Normal)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.cellButton.addTarget(self, action: "addMoreDetails:", forControlEvents: UIControlEvents.TouchUpInside)
                    return cell
                } else if indexPath.row == 1 {
                    let cell: ProductUploadQuantityTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadQuantityTableViewCellNibNameAndIdentifier) as! ProductUploadQuantityTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    return cell
                } else {
                    let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.cellTitleLabel.text = "SKU"
                    cell.cellTexField.placeholder = "SKU"
                    return cell
                }
            } else {
                let totalQuantityCell: Int = 1
                if indexPath.row != self.productModel.validCombinations.count + totalQuantityCell {
                    let cell: ProductUploadAttributeSummaryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadAttributeSummaryTableVieCellNibNameAndIdentifier) as! ProductUploadAttributeSummaryTableViewCell

                    if indexPath.row < self.productModel.validCombinations.count {
                        let combination: CombinationModel = self.productModel.validCombinations[indexPath.row]
                        
                        cell.cellQuantityLabel.text = "x" + combination.quantity
                        
                        var title: String = ""
                        
                        for dictionary in self.productModel.validCombinations[indexPath.row].attributes as [NSMutableDictionary] {
                            let value: String = dictionary["value"] as! String
                            title = title + value + ", "
                        }
                        
                        title = dropLast(title)
                        cell.cellTitleLabel.text = title
                    } else {
                        var totalQuantity: Int = 0
                        
                        for combination in self.productModel.validCombinations as [CombinationModel] {
                            totalQuantity = totalQuantity + combination.quantity.toInt()!
                        }
                        
                        cell.cellQuantityLabel.text = "x" + "\(totalQuantity)"
                        
                        var title: String = "TOTAL QUANTITY"
                        cell.cellTitleLabel.text = title
                        let defaultFontSize: CGFloat = 14
                        cell.cellTitleLabel.font = UIFont(name:"Panton-Bold", size: defaultFontSize)
                    }
                    
                    return cell
                } else {
                    let cell: ProductUploadButtonTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadButtonTableViewCellNibNameAndIdentifier) as! ProductUploadButtonTableViewCell
                    cell.cellButton.setTitle("ADD/EDIT MORE DETAILS", forState: UIControlState.Normal)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.cellButton.addTarget(self, action: "addMoreDetails:", forControlEvents: UIControlEvents.TouchUpInside)
                    return cell
                }
            }
            
        } else if indexPath.section == 4 {
            if indexPath.row == 0 {
                let cell: ProductUploadPriceTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadPriceTableViewCellNibNameAndIdentifier) as! ProductUploadPriceTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.cellTitleLabel.text = "Retail Price*"
                cell.cellTextField.placeholder = "0.00"
                
                return cell
            } else {
                let cell: ProductUploadPriceTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadPriceTableViewCellNibNameAndIdentifier) as! ProductUploadPriceTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.cellTitleLabel.text = "Discounted Price*"
                cell.cellTextField.placeholder = "0.00"
                
                return cell
            }
        } else {
            let cell: ProductUploadDimensionsAndWeightTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier) as! ProductUploadDimensionsAndWeightTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        }
    }
    
    func category() {
        let productUploadCategoryViewController: ProductUploadCategoryViewController = ProductUploadCategoryViewController(nibName: "ProductUploadCategoryViewController", bundle: nil)
        productUploadCategoryViewController.delegate = self
        productUploadCategoryViewController.pageTitle = "Select Category"
        self.navigationController!.pushViewController(productUploadCategoryViewController, animated: true)
    }
    
    func brand() {
        let brandViewController: ProductUploadBrandViewController = ProductUploadBrandViewController(nibName: "ProductUploadBrandViewController", bundle: nil)
        self.navigationController!.pushViewController(brandViewController, animated: true)
    }
    
    func addMoreDetails(sender: UIButton) {
        /*let productUploadDetailViewController: ProductUploadDetailTableViewController = ProductUploadDetailTableViewController(nibName: "ProductUploadDetailTableViewController", bundle: nil)
        self.navigationController!.pushViewController(productUploadDetailViewController, animated: true)*/
        let productUploadAttributeListTableViewController: ProductUploadAttributeListTableViewController = ProductUploadAttributeListTableViewController(nibName: "ProductUploadAttributeListTableViewController", bundle: nil)
        productUploadAttributeListTableViewController.productModel = self.productModel.copy()
        self.navigationController!.pushViewController(productUploadAttributeListTableViewController, animated: true)
    }
    
    func productUploadCategoryViewController(didSelectCategory category: String) {
        println(category)
    }
    
    func backButton() {
        var customBackButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "back")
        customBackButton.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Upload Cell Datasource
    func productUploadUploadImageTableViewCell(numberOfCollectionViewRows cell: ProductUploadUploadImageTableViewCell) -> Int {
        return self.uploadImages.count
    }
    
    //Upload Delegate
    func productUploadUploadImageTableViewCell(didSelecteRowAtIndexPath indexPath: NSIndexPath, cell: ProductUploadUploadImageTableViewCell) {
        if indexPath.row == self.uploadImages.count - 1 && self.uploadImages.count <= 5 {
            let picker: UzysAssetsPickerController = UzysAssetsPickerController()
            let maxCount: Int = 6
            
            let imageLimit: Int = maxCount - self.uploadImages.count
            picker.delegate = self
            picker.maximumNumberOfSelectionVideo = 0
            picker.maximumNumberOfSelectionPhoto = 100
            UzysAssetsPickerController.setUpAppearanceConfig(self.uzyConfig())
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath indexPath: NSIndexPath, collectionView: UICollectionView) {
        self.uploadImages.removeAtIndex(indexPath.row)
        collectionView.deleteItemsAtIndexPaths([indexPath])
    }
    
    func uzyConfig() -> UzysAppearanceConfig {
        let config: UzysAppearanceConfig = UzysAppearanceConfig()
        config.finishSelectionButtonColor = Constants.Colors.appTheme
        return config
    }
    
    func productUploadUploadImageTableViewCell(images cell: ProductUploadUploadImageTableViewCell) -> [UIImage] {
        return self.uploadImages
    }
    
    //UzzyPickerDelegate
    
    func uzysAssetsPickerController(picker: UzysAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        let assetsLibrary = ALAssetsLibrary()
        let alaSset: ALAsset = assets[0] as! ALAsset

        for allaSset in assets as! [ALAsset] {
            let image: UIImage = UIImage(CGImage: allaSset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())!
            self.uploadImages.insert(image, atIndex: 0)
        }
        
        self.reloadUploadCellCollectionViewData()
    }
    
    func reloadUploadCellCollectionViewData() {
        let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell: ProductUploadUploadImageTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! ProductUploadUploadImageTableViewCell
        cell.collectionView.reloadData()
        
//        var row: Int = 0
//        
//        let maxCount: Int = 4
//        
//        if self.uploadImages.count <= 5 {
//            row = self.uploadImages.count - 1
//        } else {
//            row = maxCount
//        }
//
//        if self.uploadImages.count == 6 {
//            self.uploadImages.removeLast()
//            cell.isImageIsFull = true
//        } else {
//            cell.isImageIsFull = false
//        }
//        
        let lastIndexPath: NSIndexPath = NSIndexPath(forItem: self.uploadImages.count - 1, inSection: 0)
        cell.collectionView.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
    }
    
    func uzysAssetsPickerControllerDidCancel(picker: UzysAssetsPickerController!) {
        
    }
    
    func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker: UzysAssetsPickerController!) {
        
    }
    
    func replaceProductAttributeWithAttribute(attributes: [AttributeModel], combinations: [CombinationModel]) {
        self.productModel.attributes = attributes
        self.productModel.validCombinations = combinations
        
        let range: NSRange = NSMakeRange(3, 1)
        let section: NSIndexSet = NSIndexSet(indexesInRange: range)
        self.tableView.reloadSections(section, withRowAnimation: UITableViewRowAnimation.Bottom)
    }
}
