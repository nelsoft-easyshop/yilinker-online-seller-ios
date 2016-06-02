//
//  ProductUploadCombinationTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: - Constant variable declarations
struct PUCTVCConstant {
    static let productUploadCombinationHeaderTableViewCellNibNameAndIdentifier = "ProductUploadCombinationHeaderTableViewCell"
    static let productUploadCombinationTableViewCellNibNameAndIdentifier = "ProductUploadCombinationTableViewCell"
    static let productUploadCombinationFooterTableViewCellNibNameAndIdentifier = "ProductUploadCombinationFooterTableViewCell"
    static let productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier = "ProductUploadAttributeValuesCollectionViewCell"
    static let footerHeight: CGFloat = 261
}

// MARK: - Delegate
// ProductUploadCombinationTableViewController delegate methods
protocol ProductUploadCombinationTableViewControllerDelegate {
    func productUploadCombinationTableViewController(appendCombination combination: CombinationModel, isEdit: Bool, indexPath: NSIndexPath)
}

class ProductUploadCombinationTableViewController: UITableViewController, UzysAssetsPickerControllerDelegate, SaveButtonViewDelegate, ProductUploadCombinationFooterTVCDelegate, ProductUploadCombinationImagesVCDelegate {
    
    // Models
    var attributes: [AttributeModel]?
    var combination: CombinationModel = CombinationModel()
    var productModel: ProductModel?
    var productModelCombi: ProductModel = ProductModel()
    
    // Global variables
    var images: [UIImage] = []
    var combiImages: [String] = []
    var productImagesName: [String] = []
    var selectedIndexpath: NSIndexPath?
    
    var headerTitle: String = ""
    var weight: String = ""
    var height: String = ""
    var length: String = ""
    var width: String = ""
    
    var productImagesCount: Int = 0
    
    var hud: MBProgressHUD?
    var uploadType: UploadType = UploadType.NewProduct

    // Initialize ProductUploadCombinationTableViewControllerDelegate
    var delegate: ProductUploadCombinationTableViewControllerDelegate?
    var cellImage: ProductUploadCombinationFooterTVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigatrion bar title
        var title: String = ""
        if self.productModel != nil {
            title = StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_EDIT_LOCALIZE_KEY")
            let combination: CombinationModel = self.productModel!.validCombinations[self.selectedIndexpath!.section]
            self.combination = combination
        } else {
            title = StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_ADD_LOCALIZE_KEY")
        }
        
        self.title = title
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
        } else {
            let cell: ProductUploadCombinationFooterTVC = self.tableView.dequeueReusableCellWithIdentifier("ProductUploadCombinationFooterTVC") as! ProductUploadCombinationFooterTVC
            
            if self.productModel != nil {
                
                cell.images = self.images
                cell.combiImages = self.combiImages
                
                let combination: CombinationModel = self.productModel!.validCombinations[self.selectedIndexpath!.section]
                
                cell.weightTextField.text = combination.weight
                cell.lengthTextField.text = combination.length
                cell.heightTextField.text = combination.height
                cell.widthTextField.text = combination.width
                cell.skuTextField.text = combination.sku
                cell.availableSwitch.setOn(combination.isAvailable, animated: true)
            } else {
                cell.images = self.images
                cell.availableSwitch.setOn(false, animated: true)
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.viewController = self
            cell.delegate = self
      
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
            return 294
        }
    }
    
    // MARK: -
    // MARK: - Private methods
    // MARK: - Add dummy photo in self.image array
    
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
                self.combiImages = self.productModel!.validCombinations[self.selectedIndexpath!.section].imagesId
                self.productImagesName = self.productModel!.validCombinations[self.selectedIndexpath!.section].imagesId
            } else {
                let image: UIImage = UIImage(named: "addPhoto")!
                let serverImage: ServerUIImage  = ServerUIImage(data: UIImagePNGRepresentation(image)!)!
                self.images.append(serverImage)
                self.productImagesName = []
            }
        }
    }
    
    // MARK: -
    // MARK: - Navigation bar
    // MARK: - Add back button in navigation bar
    
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
    // MARK: - Navigation bar back button action
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: -
    // MARK: - Footer View
    
    func footerView() -> SaveButtonView {
        let saveButtonView: SaveButtonView = XibHelper.puffViewWithNibName("SaveButtonView", index: 0) as! SaveButtonView
        saveButtonView.delegate = self
        return saveButtonView
    }
    
    // MARK: -
    // MARK: - Get combination images
    
    func getCombinationImages() {
        
        let indexPath: NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        
        // Pass 'self.images' to ProductUploadCombinationFooterTableViewCell 'images'
        let cell: ProductUploadCombinationFooterTVC = self.tableView.cellForRowAtIndexPath(indexPath) as! ProductUploadCombinationFooterTVC
        cell.images = self.images
        
        let lastIndexPath: NSIndexPath = NSIndexPath(forItem: self.images.count - 1, inSection: 0)
        cell.collectionView.reloadData()
        cell.collectionView.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
        self.cellImage = cell
        
        var uploadedImages: [UIImage] = []
        
        for images in self.images {
            uploadedImages.append(images)
        }
        
        if uploadedImages.count != 0 {
            uploadedImages.removeLast()
        }
        
        self.productImagesCount = 0
        self.fireUploadProductMainImages(uploadedImages[self.productImagesCount])
    }
    
    // MARK: -
    // MARK: - Header view
    // MARK: - Add table view header
    
    func headerView() {
        let headerView: ProductUploadCombinationHeaderTableViewCell = XibHelper.puffViewWithNibName("ProductUploadCombinationHeaderTableViewCell", index: 0) as! ProductUploadCombinationHeaderTableViewCell
        self.tableView.tableHeaderView = headerView
        headerView.combinationLabel.text = self.headerTitle
    }
    
    // MARK: -
    // MARK: - Register table view cells
    
    func registerCell() {
        let footerNib: UINib = UINib(nibName: PUCTVCConstant.productUploadCombinationFooterTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(footerNib, forCellReuseIdentifier: PUCTVCConstant.productUploadCombinationFooterTableViewCellNibNameAndIdentifier)
        
        let combinationCell: UINib = UINib(nibName: PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(combinationCell, forCellReuseIdentifier: PUCTVCConstant.productUploadCombinationTableViewCellNibNameAndIdentifier)
        
        let valuesNib: UINib = UINib(nibName: PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(valuesNib, forCellReuseIdentifier: PUCTVCConstant.productUploadAttributeValluesCollectionViewCellNibNameAndIdentifier)
        
        let weightAndHeightNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(weightAndHeightNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier)
        
        let skuDimensionsAndWeightNib: UINib = UINib(nibName: ProductUploadCombinationFooterTVCConstant.productUploadCombinationFooterTVCNibAndIdentifier, bundle: nil)
        self.tableView.registerNib(skuDimensionsAndWeightNib, forCellReuseIdentifier: ProductUploadCombinationFooterTVCConstant.productUploadCombinationFooterTVCNibAndIdentifier)
    }
    
    // MARK: -
    // MARK: - Save details
    
    func saveDetails() {
        let cell: ProductUploadCombinationFooterTVC = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! ProductUploadCombinationFooterTVC
        
        self.combination.images = cell.uploadedImages()
        self.combination.imagesId = cell.combiImagesName()
        
        let cell2: ProductUploadCombinationTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProductUploadCombinationTableViewCell
        
        let combination2: CombinationModel = cell2.data()
        self.combination.attributes = combination2.attributes
        
        // Check if SKU is already used
        // SKU's must be unique
        if self.productModel == nil {
            /*if find(ProductSku.SKUS, self.combination.sku) != nil {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_SKU_AVAILABLE_LOCALIZE_KEY"), title: Constants.Localized.invalid)
            } else {
                self.delegate!.productUploadCombinationTableViewController(appendCombination: self.combination, isEdit: false,  indexPath: NSIndexPath())
                ProductSku.SKUS.append(self.combination.sku)
                self.navigationController?.popViewControllerAnimated(true)
            }*/
            self.delegate!.productUploadCombinationTableViewController(appendCombination: self.combination, isEdit: false, indexPath: NSIndexPath())
        } else {
            /*
            ProductSku.SKUS[self.selectedIndexpath!.section] = ""
            if find(ProductSku.SKUS, self.combination.sku) != nil {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_SKU_AVAILABLE_LOCALIZE_KEY"), title: Constants.Localized.invalid)
            } else {
                self.delegate!.productUploadCombinationTableViewController(appendCombination: self.combination, isEdit: true, indexPath: self.selectedIndexpath!)
                ProductSku.SKUS[self.selectedIndexpath!.section] = self.combination.sku
                self.navigationController?.popViewControllerAnimated(true)
            }*/
            self.delegate!.productUploadCombinationTableViewController(appendCombination: self.combination, isEdit: true, indexPath: self.selectedIndexpath!)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: -
    // MARK: - Alert view
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    // MARK: -
    // MARK: - Show HUD
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
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
        
        var notice: String = StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_NOTICE_LOCALIZE_KEY")
        var message: String = StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_MESSAGE_LOCALIZE_KEY")
        var main: String = StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_MAIN_IMAGES_LOCALIZE_KEY")
        var gallery: String = StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_GALLERY_LOCALIZE_KEY")
        var cancel: String = StringHelper.localizedStringWithKey("PRODUCT_UPLOAD_CANCEL_LOCALIZE_KEY")
        
        // create the alert
        let alert = UIAlertController(title: notice, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add the actions (buttons)
        // Open product's main images
        
        alert.addAction(UIAlertAction(title: main, style: UIAlertActionStyle.Default, handler: {
            action in
            let productUploadCombiImages: ProductUploadCombinationImagesVC = ProductUploadCombinationImagesVC(nibName: "ProductUploadCombinationImagesVC", bundle: nil)
            productUploadCombiImages.productModel = self.productModelCombi
            productUploadCombiImages.delegate = self
            
            let navigationController: UINavigationController = UINavigationController(rootViewController: productUploadCombiImages)
            navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
            
            self.presentViewController(navigationController, animated: true, completion: nil)
        }))
        
        // Dismiss the alert view
        
        alert.addAction(UIAlertAction(title: cancel, style: UIAlertActionStyle.Cancel, handler: {
            action in
            print("cancel")
        }))
        
        // Call the UzysAssetsPickerController
        
        alert.addAction(UIAlertAction(title: gallery, style: UIAlertActionStyle.Destructive, handler: {
            action in
            let picker: UzysAssetsPickerController = UzysAssetsPickerController()
            let maxCount: Int = 6
            
            let imageLimit: Int = maxCount - self.images.count
            picker.delegate = self
            picker.maximumNumberOfSelectionVideo = 0
            picker.maximumNumberOfSelectionPhoto = 100
            UzysAssetsPickerController.setUpAppearanceConfig(self.uzyConfig())
            
            self.presentViewController(picker, animated: true, completion: nil)
        }))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
        
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
            } else {
                self.combination.sku = text
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
    // MARK: - ProductUploadIsAvailableTableViewCell Delegate Method - productUploadIsAvailableTableViewCell
    
    func productUploadIsAvailableTableViewCell(switchValueChanged sender: UISwitch, value: Bool, cell: ProductUploadCombinationFooterTVC) {
        self.combination.isAvailable = value
    }
    
    // MARK: -
    // MARK: - ProductUploadCombinationImagesVC Delegate Method 
    
    func productUploadCombinationImagesVC(productModel: ProductModel, indexes: [Int]) {
        
        var count: Int = 0
        
        if productModel.images.count != 0 {
            count = productModel.images.count-1
        } else {
            count = productModel.editedImage.count-1
            productModel.images = productModel.editedImage
        }
        
        for i in 0..<count {
            if contains(indexes, i) {
                self.images.insert(productModel.images[i], atIndex: 0)
                self.combiImages.insert(productModel.productMainImagesModel[i].imageName, atIndex: 0)
            }
        }
        
        let indexPath: NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        
        // Pass 'self.images' to ProductUploadCombinationFooterTableViewCell 'images'
        let cell: ProductUploadCombinationFooterTVC = self.tableView.cellForRowAtIndexPath(indexPath) as! ProductUploadCombinationFooterTVC
        cell.images = self.images
        cell.combiImages = self.combiImages
        
        let lastIndexPath: NSIndexPath = NSIndexPath(forItem: self.images.count-1, inSection: 0)
        cell.collectionView.reloadData()
        cell.collectionView.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
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
            
            self.productImagesName.append("")
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
                self.images.insert(image, atIndex: 0)
            }
        }
        
        self.getCombinationImages()
    }
    
    func uzysAssetsPickerControllerDidCancel(picker: UzysAssetsPickerController!) {
        
    }
    
    func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker: UzysAssetsPickerController!) {
        
    }
    
    // MARK: -
    // MARK: - SaveButtonView Delegate method
    
    func saveButtonView(didClickButtonWithView view: SaveButtonView) {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            if self.combination.sku == "" {
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
                self.saveDetails()
            }
        }
    }
    
    // MARK: -
    // MARK: - POST METHOD: Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    * Function to refresh token to get another access token
    *
    */
    
    func fireRefreshToken(uploadProduct: UploadProduct) {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireUploadProductMainImages(self.productModel!.images[self.productImagesCount])
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    
                })
            }
        })
    }
    
    func fireUploadProductMainImages(image: UIImage) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.showHUD()
        var parameters: NSMutableDictionary = ["type" : "product"]
       
        WebServiceManager.fireProductUploadImageRequestWithUrlV2(APIAtlas.uploadImagesUrl+"?access_token=\(SessionManager.accessToken())", parameters: parameters, image: image, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                /*if uploadType == UploadType.Draft {
                    ProductUploadEdit.edit = false
                    self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyDraft)
                } else if uploadType == UploadType.EditProduct {
                    ProductUploadEdit.edit = false
                    self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyEdited)
                } else {
                    self.success()
                }*/
                
                if let success = responseObject["isSuccessful"] as? Bool {
                    if success {
                        if let dictionary: NSDictionary = responseObject["data"] as? NSDictionary {
                            if let fileName = dictionary["fileName"] as? String {
                                self.productImagesName.append(fileName)
                                var oldFileName: String = ""
                               
                                if self.uploadType == UploadType.NewProduct {
                                    self.productImagesName.append(fileName)
                                    oldFileName = fileName
                                } else {
                                    if self.productImagesName.count == 0 {
                                        if self.productImagesName[self.productImagesCount] == "" {
                                            self.productImagesName[self.productImagesCount] = fileName
                                            oldFileName = fileName
                                        } else {
                                            oldFileName = self.productImagesName[self.productImagesCount]
                                        }
                                    } else {
                                        if self.productImagesName[self.productImagesCount] == "" {
                                            self.productImagesName[self.productImagesCount] = fileName
                                            oldFileName = fileName
                                        } else {
                                            oldFileName = self.productImagesName[self.productImagesCount]
                                        }
                                    }
                                }
                                
                                let imageData: NSData = UIImagePNGRepresentation(image)
                                let serverImage: ServerUIImage = ServerUIImage(data: imageData)!
                                
                                if !contains(self.combiImages, oldFileName) {
                                    self.combiImages.append(oldFileName)
                                }
                                
                                self.productModel!.validCombinations[self.selectedIndexpath!.section].editedImages.append(serverImage)
                                self.productModel!.editedImage.append(serverImage)
                                
                                self.productImagesCount++
                                if self.uploadType == UploadType.NewProduct {
                                    if self.productImagesCount !=  self.productModel!.images.count-1 {
                                        self.fireUploadProductMainImages(self.images[self.productImagesCount])
                                    } else {
                                        self.cellImage?.images = self.images
                                        self.cellImage?.images.removeLast()
                                        self.cellImage?.combiImages = self.combiImages
                                    }
                                } else {
                                    if self.productImagesCount != self.images.count-1 {
                                        self.fireUploadProductMainImages(self.images[self.productImagesCount])
                                    } else {
                                        self.cellImage?.images = self.images
                                        self.cellImage?.images.removeLast()
                                        self.cellImage?.combiImages = self.combiImages
                                    }
                                }
                            }
                        }
                    }
                }
                
                self.hud?.hide(true)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            } else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(UploadProduct.ProductMainImages)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        })
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
