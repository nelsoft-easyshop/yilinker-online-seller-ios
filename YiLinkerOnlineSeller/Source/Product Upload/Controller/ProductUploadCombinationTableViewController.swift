//
//  ProductUploadCombinationTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Constant variable declarations
struct PUCTVCConstant {
    static let productUploadCombinationHeaderTableViewCellNibNameAndIdentifier = "ProductUploadCombinationHeaderTableViewCell"
    static let productUploadCombinationTableViewCellNibNameAndIdentifier = "ProductUploadCombinationTableViewCell"
    static let productUploadCombinationFooterTableViewCellNibNameAndIdentifier = "ProductUploadCombinationFooterTableViewCell"
    static let productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier = "ProductUploadAttributeValuesCollectionViewCell"
    static let footerHeight: CGFloat = 261
}

// MARK: Delegate
// ProductUploadCombinationTableViewController delegate methods
protocol ProductUploadCombinationTableViewControllerDelegate {
    func productUploadCombinationTableViewController(appendCombination combination: CombinationModel, isEdit: Bool, indexPath: NSIndexPath)
}

class ProductUploadCombinationTableViewController: UITableViewController, UzysAssetsPickerControllerDelegate, SaveButtonViewDelegate, ProductUploadCombinationFooterTVCDelegate {
    
    // Models
    var attributes: [AttributeModel]?
    var combination: CombinationModel = CombinationModel()
    var productModel: ProductModel?
    
    // Global variables
    var images: [UIImage] = []
    var selectedIndexpath: NSIndexPath?
    
    var headerTitle: String = ""
    var weight: String = ""
    var height: String = ""
    var length: String = ""
    var width: String = ""

    // Initialize ProductUploadCombinationTableViewControllerDelegate
    var delegate: ProductUploadCombinationTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigatrion bar title
        if self.productModel != nil {
            self.title = "Edit Combination"
            let combination: CombinationModel = self.productModel!.validCombinations[self.selectedIndexpath!.section]
            self.combination = combination
        } else {
            self.title = "Add Combination"
        }

        self.tableView.tableFooterView = self.footerView()
        
        self.addDummyPhoto()
        self.backButton()
        self.headerView()
        self.registerCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation bar
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
    
    // Navigation bar back button action
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: Private methods
    // Add dummy photo in self.image array
    func addDummyPhoto() {
        let viewController: ProductUploadTC = self.navigationController?.viewControllers[0] as! ProductUploadTC
        
        if viewController.uploadType == UploadType.NewProduct {
            if self.productModel != nil {
                self.images = self.productModel!.validCombinations[self.selectedIndexpath!.section].images
                self.images.append(UIImage(named: "addPhoto")!)
            } else {
                self.images.append(UIImage(named: "addPhoto")!)
            }
        } else {
            
            for image in self.images {
                let i: ServerUIImage = image as! ServerUIImage
            }
            
            if self.productModel != nil {
                self.images = self.productModel!.validCombinations[self.selectedIndexpath!.section].editedImages
                let image: UIImage = UIImage(named: "addPhoto")!
                let serverImage: ServerUIImage  = ServerUIImage(data: UIImagePNGRepresentation(image)!)!
                self.images.append(serverImage)
            } else {
                let image: UIImage = UIImage(named: "addPhoto")!
                let serverImage: ServerUIImage  = ServerUIImage(data: UIImagePNGRepresentation(image)!)!
                self.images.append(serverImage)
            }
        }
    }
    
    // MARK: - Footer View
    func footerView() -> SaveButtonView {
        let saveButtonView: SaveButtonView = XibHelper.puffViewWithNibName("SaveButtonView", index: 0) as! SaveButtonView
        saveButtonView.delegate = self
        return saveButtonView
    }
    
    // MARK: Header view
    // Add table view header
    func headerView() {
        let headerView: ProductUploadCombinationHeaderTableViewCell = XibHelper.puffViewWithNibName("ProductUploadCombinationHeaderTableViewCell", index: 0) as! ProductUploadCombinationHeaderTableViewCell
        self.tableView.tableHeaderView = headerView
        headerView.combinationLabel.text = self.headerTitle
    }
    
    // MARK: Register table view cells
    func registerCell() {
        let footerNib: UINib = UINib(nibName: PUCTVCConstant.productUploadCombinationFooterTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(footerNib, forCellReuseIdentifier: PUCTVCConstant.productUploadCombinationFooterTableViewCellNibNameAndIdentifier)
        
        let combinationCell: UINib = UINib(nibName: PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(combinationCell, forCellReuseIdentifier: PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier)
        
        let valuesNib: UINib = UINib(nibName: PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(valuesNib, forCellReuseIdentifier: PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier)
        
        let weightAndHeightNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(weightAndHeightNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier)
        
        let skuDimensionsAndWeightNib: UINib = UINib(nibName: "ProductUploadCombinationFooterTVC", bundle: nil)
        self.tableView.registerNib(skuDimensionsAndWeightNib, forCellReuseIdentifier: "ProductUploadCombinationFooterTVC")
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
        } /* else if indexPath.row == 1 {
            let cell: ProductUploadCombinationFooterTableViewCell = tableView.dequeueReusableCellWithIdentifier(PUCTVCConstant.productUploadCombinationFooterTableViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadCombinationFooterTableViewCell
            cell.delegate = self
            
            if self.productModel != nil {
                let combination: CombinationModel = self.productModel!.validCombinations[self.selectedIndexpath!.section]
                cell.images = self.images
                cell.discountedPriceTextField.text = combination.discountedPrice
                cell.quantityTextField.text = combination.quantity
                cell.retailPriceTextField.text = combination.retailPrice
                cell.skuTextField.text = combination.sku
            } else {
                cell.images = self.images
                cell.quantityTextField.text = self.combination.quantity
            }
            cell.viewController = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        } */
        else {
            let cell: ProductUploadCombinationFooterTVC = self.tableView.dequeueReusableCellWithIdentifier("ProductUploadCombinationFooterTVC") as! ProductUploadCombinationFooterTVC
            
            if self.productModel != nil {
                
                cell.images = self.images
                
                let combination: CombinationModel = self.productModel!.validCombinations[self.selectedIndexpath!.section]
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.weightTextField.text = combination.weight
                cell.lengthTextField.text = combination.length
                cell.heightTextField.text = combination.height
                cell.widthTextField.text = combination.width
            } else {
                cell.images = self.images
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.viewController = self
            cell.delegate = self
            /*
            let cell: ProductUploadDimensionsAndWeightTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier) as! ProductUploadDimensionsAndWeightTableViewCell

            if self.productModel != nil {
                let combination: CombinationModel = self.productModel!.validCombinations[self.selectedIndexpath!.section]
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.weightTextField.text = combination.weight
                cell.lengthTextField.text = combination.length
                cell.heightTextField.text = combination.height
                cell.widthTextField.text = combination.width
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            */
            
            return cell
        }
    }
    
    // MARK: -
    // MARK: - Table view data source method
    
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
            return 320
        }
    }
    
    // MARK: -
    // MARK: - ProductUploadCombinationFooterTVCDelegate Method - productUploadCombinationFooterTVC
    
    func productUploadCombinationFooterTVC(didClickDoneButton cell: ProductUploadCombinationFooterTVC, sku: String, length: String, width: String, height: String, weight: String, uploadImages: [UIImage]) {
        let cell: ProductUploadCombinationTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProductUploadCombinationTableViewCell
        
        let combination: CombinationModel = cell.data()
        
        combination.images = uploadImages
        combination.length = length
        combination.width = width
        combination.sku = sku
        combination.weight = weight
        
        if self.productModel == nil {
            self.delegate!.productUploadCombinationTableViewController(appendCombination: combination, isEdit: false, indexPath: NSIndexPath())
        } else {
            self.delegate!.productUploadCombinationTableViewController(appendCombination: combination, isEdit: true, indexPath: self.selectedIndexpath!)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: -
    // MARK: - ProductUploadCombinationFooterTVC Delegate Method - productUploadCombinationFooterTVC
    
    func productUploadCombinationFooterTVC(didClickUploadImage cell: ProductUploadCombinationFooterTVC) {
        let picker: UzysAssetsPickerController = UzysAssetsPickerController()
        let maxCount: Int = 6
        
        let imageLimit: Int = maxCount - self.images.count
        picker.delegate = self
        picker.maximumNumberOfSelectionVideo = 0
        picker.maximumNumberOfSelectionPhoto = 100
        UzysAssetsPickerController.setUpAppearanceConfig(self.uzyConfig())
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: - ProductUploadCombinationFooterTVC Delegate Method - productUploadSkuDimensionsAndWeightTableViewCell
    
    func productUploadSkuDimensionsAndWeightTableViewCell(textFieldDidChange textField: UITextField, text: String, cell:
        ProductUploadCombinationFooterTVC) {
            if textField == cell.weightTextField {
                self.combination.weight = text
            } else if textField == cell.heightTextField {
                self.combination.height = text
            } else if textField == cell.lengthTextField {
                self.combination.length = text
            } else if textField == cell.widthTextField {
                self.combination.width = text
            }
    }
    
    // MARK: -
    // MARK: - ProductUploadCombinationFooterTableViewCell Delegate Method
    
    func productUploadCombinationFooterTVC(didDeleteUploadImage cell: ProductUploadCombinationFooterTVC, indexPath: NSIndexPath) {
        if self.productModel == nil {
            
            let viewController: ProductUploadTC = self.navigationController?.viewControllers[0] as! ProductUploadTC
            
            if viewController.uploadType == UploadType.NewProduct {
                self.images.removeAtIndex(indexPath.row)
            } else {
                self.images.removeAtIndex(indexPath.row)
            }
            
        } else {
            self.images.removeAtIndex(indexPath.row)
            if indexPath.row < self.productModel!.validCombinations[self.selectedIndexpath!.section].imagesId.count {
                if !contains(ProductUploadCombination.deleted, self.productModel!.validCombinations[self.selectedIndexpath!.section].imagesId[indexPath.row]) {
                    ProductUploadCombination.deleted.append(self.productModel!.validCombinations[self.selectedIndexpath!.section].imagesId[indexPath.row])
                }
            }
            
            if indexPath.row < self.productModel!.validCombinations[self.selectedIndexpath!.section].images.count {
                self.productModel!.validCombinations[self.selectedIndexpath!.section].images.removeAtIndex(indexPath.row)
            }
            
        }
    }
    
    // MARK: -
    // MARK: - UzysAssetsPickerController
    // MARK: - UzysAssetsPickerController data source and delegate methods
    
    func uzyConfig() -> UzysAppearanceConfig {
        let config: UzysAppearanceConfig = UzysAppearanceConfig()
        config.finishSelectionButtonColor = Constants.Colors.appTheme
        return config
    }
    
    func uzysAssetsPickerController(picker: UzysAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        let assetsLibrary = ALAssetsLibrary()
        let alaSset: ALAsset = assets[0] as! ALAsset
        
        for allaSset in assets as! [ALAsset] {
            let viewController: ProductUploadTC = self.navigationController?.viewControllers[0] as! ProductUploadTC
            
            if viewController.uploadType == UploadType.NewProduct {
                // Insert selected images on the first index of self.images array
                let image: UIImage = UIImage(CGImage: allaSset.defaultRepresentation().fullScreenImage().takeUnretainedValue())!
                self.images.insert(image, atIndex: 0)
            } else {
                // Insert selected images in the last index of self.images array
                // Set ServerUIImage 'isNew' to 'true' for all newly added images
                let image: ServerUIImage = ServerUIImage(CGImage: allaSset.defaultRepresentation().fullScreenImage().takeUnretainedValue())!
                image.isNew = true
                image.isRemoved = false
                image.isCombination = true
                self.images.insert(image, atIndex: self.images.count - 1)
            }
        }
        
        let indexPath: NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        
        // Pass 'self.images' to ProductUploadCombinationFooterTableViewCell 'images'
        let cell: ProductUploadCombinationFooterTVC = self.tableView.cellForRowAtIndexPath(indexPath) as! ProductUploadCombinationFooterTVC
        cell.images = self.images
        
        let lastIndexPath: NSIndexPath = NSIndexPath(forItem: self.images.count - 1, inSection: 0)
        cell.collectionView.reloadData()
        cell.collectionView.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
    }
    
    func uzysAssetsPickerControllerDidCancel(picker: UzysAssetsPickerController!) {
        
    }
    
    func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker: UzysAssetsPickerController!) {
        
    }
    
    // MARK: SaveButtonView Delegate method
    func saveButtonView(didClickButtonWithView view: SaveButtonView) {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            // Error valiadtion if any of the required fields is empty
            if self.combination.retailPrice == "" {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.retailPriceRequired, title: ProductUploadStrings.incompleteProductDetails)
            } else if self.combination.quantity == "" {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.quantityRequired, title: ProductUploadStrings.incompleteProductDetails)
            } else if self.combination.sku == "" {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.skuRequried, title: ProductUploadStrings.incompleteProductDetails)
            } else if self.combination.length == "" {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.lengthRequried, title: ProductUploadStrings.incompleteProductDetails)
            } else if self.combination.weight == "" {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.weightRequried, title: ProductUploadStrings.incompleteProductDetails)
            } else if self.combination.width == "" {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.widthRequried, title: ProductUploadStrings.incompleteProductDetails)
            } else if self.combination.height == "" {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.heightRequried, title: ProductUploadStrings.incompleteProductDetails)
            } else {
                if self.combination.discountedPrice.toInt() > self.combination.retailPrice.toInt() {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_PRICE_LOCALIZE_KEY"), title: Constants.Localized.invalid)
                    self.combination.discountedPrice = self.combination.retailPrice
                } else {
                    let cell: ProductUploadCombinationFooterTVC = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! ProductUploadCombinationFooterTVC
                    
                    self.combination.images = cell.uploadedImages()
                    
                    let cell2: ProductUploadCombinationTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProductUploadCombinationTableViewCell
                    
                    let combination2: CombinationModel = cell2.data()
                    self.combination.attributes = combination2.attributes
                    
                    // Check if SKU is already used
                    // SKU's must be unique
                    if self.productModel == nil {
                        if find(ProductSku.SKUS, self.combination.sku) != nil {
                            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_SKU_AVAILABLE_LOCALIZE_KEY"), title: Constants.Localized.invalid)
                        } else {
                            self.delegate!.productUploadCombinationTableViewController(appendCombination: self.combination, isEdit: false, indexPath: NSIndexPath())
                            ProductSku.SKUS.append(self.combination.sku)
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    } else {
                        ProductSku.SKUS[self.selectedIndexpath!.section] = ""
                        if find(ProductSku.SKUS, self.combination.sku) != nil {
                            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_SKU_AVAILABLE_LOCALIZE_KEY"), title: Constants.Localized.invalid)
                        } else {
                            self.delegate!.productUploadCombinationTableViewController(appendCombination: self.combination, isEdit: true, indexPath: self.selectedIndexpath!)
                            ProductSku.SKUS[self.selectedIndexpath!.section] = self.combination.sku
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }
                }
            }
        }
    }
    
    // Dealloc
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    
    /*
    // MARK: ProductUploadCombinationFooterTableViewCell Delegate methods
    func productUploadCombinationFooterTVC(didClickDoneButton cell: ProductUploadCombinationFooterTVC, sku: String, quantity: String, discountedPrice: String, retailPrice: String, uploadImages: [UIImage]) {
        self.tableView.endEditing(true)
        self.tableView.reloadData()
        
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
        
         self.navigationController?.popViewControllerAnimated(true)
    }*/
    
    /*
    // MARK: ProductUploadDimensionsAndWeightTableViewCell Delegate Method
    func productUploadDimensionsAndWeightTableViewCell(textFieldDidChange textField: UITextField, text: String, cell: ProductUploadDimensionsAndWeightTableViewCell) {
        if textField.isEqual(cell.weightTextField) {
            self.combination.weight = text
        } else if textField.isEqual(cell.heightTextField) {
            self.combination.height = text
        } else if textField.isEqual(cell.lengthTextField) {
            self.combination.length = text
        } else if textField.isEqual(cell.widthTextField) {
            self.combination.width = text
        }
    }*/
}
