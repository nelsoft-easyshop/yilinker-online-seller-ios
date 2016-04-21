//
//  ProductUploadTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/25/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Constant strings variable declarations
struct ProductUploadStrings {
    static let uploadItem: String = StringHelper.localizedStringWithKey("UPLOAD_ITEM_LOCALIZE_KEY")
    static let productPhotos: String = StringHelper.localizedStringWithKey("PRODUCT_PHOTOS_LOCALIZE_KEY")
    static let addPhoto: String = StringHelper.localizedStringWithKey("ADD_PHOTO_LOCALIZE_KEY")
    
    static let productInformation: String = StringHelper.localizedStringWithKey("PRODUCT_INFORMATION_LOCALIZE_KEY")
    
    static let productName: String = StringHelper.localizedStringWithKey("PRODUCT_NAME_LOCALIZE_KEY")
    static let shortDescription: String = StringHelper.localizedStringWithKey("SHORT_DESCRIPTION_LOCALIZE_KEY")
    static let completeDescription: String = StringHelper.localizedStringWithKey("COMPLETE_DESCRIPTION_LOCALIZE_KEY")
    
    static let productDetails: String = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_LOCALIZE_KEY")

    static let selectCategory: String = StringHelper.localizedStringWithKey("SELECT_CATEGORY_LOCALIZE_KEY")
    static let category: String = StringHelper.localizedStringWithKey("CATEGORY_LOCALIZE_KEY")
    static let brand: String = StringHelper.localizedStringWithKey("BRAND_LOCALIZE_KEY")
    static let condition: String = StringHelper.localizedStringWithKey("CONDITION_LOCALIZE_KEY")
    
    static let addMore: String = StringHelper.localizedStringWithKey("ADD_MORE_LOCALIZE_KEY")
    static let addMoreDtails: String = StringHelper.localizedStringWithKey("ADD_MORE_DETAILS_LOCALIZE_KEY")
    static let addEdit: String = StringHelper.localizedStringWithKey("ADD_EDIT_MORE_DETAILS_LOCALIZE_KEY")
    
    static let quantity: String = StringHelper.localizedStringWithKey("QUANTITY_LOCALIZE_KEY")
    static let sku: String = StringHelper.localizedStringWithKey("SKU_LOCALIZE_KEY")
    
    static let price: String = StringHelper.localizedStringWithKey("PRICE_LOCALIZE_KEY")
    
    static let retailPrice: String = StringHelper.localizedStringWithKey("RETAIL_PRICE_LOCALIZE_KEY")
    static let discountedPrice: String = StringHelper.localizedStringWithKey("DISCOUNTED_PRICE_LOCALIZE_KEY")
    
    static let dimensionsAndWeight: String = StringHelper.localizedStringWithKey("DIMENSIONS_AND_WEIGHT_LOCALIZE_KEY")
    
    static let dimensionsAndWieghtMessageOne: String = StringHelper.localizedStringWithKey("DIMENSIONS_AND_WEIGHT_MESSAGE_ONE_LOCALIZE_KEY")
    static let dimensionsAndWieghtMessageTwo: String = StringHelper.localizedStringWithKey("DIMENSIONS_AND_WEIGHT_MESSAGE_TWO_LOCALIZE_KEY")
    
    static let length: String = StringHelper.localizedStringWithKey("LENGHT_LOCALIZE_KEY")
    static let weight: String = StringHelper.localizedStringWithKey("WEIGHT_LOCALIZE_KEY")
    static let width: String = StringHelper.localizedStringWithKey("WIDTH_LOCALIZE_KEY")
    static let height: String = StringHelper.localizedStringWithKey("HEIGHT_LOCALIZE_KEY")
    
    static let saveProductDetails: String = StringHelper.localizedStringWithKey("SAVE_PRODUCT_DETAILS_LOCALIZE_KEY")

    static let detailName: String = StringHelper.localizedStringWithKey("DETAIL_NAME_LOCALIZE_KEY")
    static let values: String = StringHelper.localizedStringWithKey("VALUES_LOCALIZE_KEY")
    static let valuesPlaceholder: String = StringHelper.localizedStringWithKey("VALUES_PLACEHODER_LOCALIZE_KEY")
    
    static let save: String = StringHelper.localizedStringWithKey("SAVE_LOCALIZE_KEY")
    
    static let proceedToCombination: String = StringHelper.localizedStringWithKey("PROCEED_TO_COMBINATION_LOCALIZE_KEY")
    
    static let saveDetails: String = StringHelper.localizedStringWithKey("SAVE_DETAILS_LOCALIZE_KEY")
    static let combination: String = StringHelper.localizedStringWithKey("COMBINATION_LOCALIZE_KEY")
    
    static let totalQuantity: String = StringHelper.localizedStringWithKey("TOTAL_QUANTITY_LOCALIZE_KEY")
    
    static let searchCategory: String = StringHelper.localizedStringWithKey("SEARCH_CATEGORY_LOCALIZE_KEY")
    
    static let warning: String = StringHelper.localizedStringWithKey("WARNING_LOCALIZE_KEY")
    static let warningRemoveAttribute: String = StringHelper.localizedStringWithKey("WARNING_REMOVE_ATTRIBUTE_LOCALIZE_KEY")
    static let incompleteProductDetails: String = StringHelper.localizedStringWithKey("INC_PRODUCT_DETAILS_LOCALIZE_KEY")
    
    static let retailMustBeGreater: String = StringHelper.localizedStringWithKey("RETAIL_MUST_BE_GREATER_LOCALIZE_KEY")
    
    static let attributeDef: String = StringHelper.localizedStringWithKey("ATTRIBUTE_DEF_LOCALIZE_KEY")
    static let alreadyExist: String = StringHelper.localizedStringWithKey("ALREADY_EXIST_LOCALIZE_KEY")
    
    static let combinationAlreadyExist: String = StringHelper.localizedStringWithKey("COMBINATION_ALREADY_EXIST_LOCALIZE_KEY")
    static let combinationRequired: String = StringHelper.localizedStringWithKey("COMBINATION_REQUIRED_LOCALIZE_KEY")
    static let attributeValuesRequired: String = StringHelper.localizedStringWithKey("ATTRIBUTE_VALUES_REQUIRED_LOCALIZE_KEY")
    
    static let insertOneImage: String = StringHelper.localizedStringWithKey("INSERT_ONE_IMAGE_LOCALIZE_KEY")
    static let productNameRequired: String = StringHelper.localizedStringWithKey("PRODUCT_NAME_REQUIRED_LOCALIZE_KEY")
    
    static let shortDescriptionRquired: String = StringHelper.localizedStringWithKey("SHORT_DESCRIPTION_REQUIRED_LOCALIZE_KEY")
    static let completeRequired: String = StringHelper.localizedStringWithKey("COMPLETE_DESCRIPTION_REQUIRED_LOCALIZE_KEY")
    static let categoryRequired: String = StringHelper.localizedStringWithKey("CATEGORY_REQUIRED_LOCALIZE_KEY")
    
    static let conditionRequired: String = StringHelper.localizedStringWithKey("CONDITION_REQUIRED_LOCALIZE_KEY")
    static let quantityRequired: String = StringHelper.localizedStringWithKey("QUANTITY_REQUIRED_LOCALIZE_KEY")
    static let retailPriceRequired: String = StringHelper.localizedStringWithKey("RETAIL_PRICE_REQUIRED_LOCALIZE_KEY")
    static let retailMustBeLarger: String = StringHelper.localizedStringWithKey("RETAIL_MUST_BE_LARGER_LOCALIZE_KEY")
    static let skuRequried: String = StringHelper.localizedStringWithKey("SKU_REQUIRED_LOCALIZE_KEY")
    
    static let weightRequried: String = StringHelper.localizedStringWithKey("WEIGHT_REQUIRED_LOCALIZE_KEY")
    static let lengthRequried: String = StringHelper.localizedStringWithKey("LENGTH_REQUIRED_LOCALIZE_KEY")
    static let widthRequried: String = StringHelper.localizedStringWithKey("WIDTH_REQUIRED_LOCALIZE_KEY")
    static let heightRequried: String = StringHelper.localizedStringWithKey("HEIGHT_REQUIRED_LOCALIZE_KEY")
    static let attributeAlreadyExist: String = StringHelper.localizedStringWithKey("ATTRIBUTE_ALREADY_EXIST_LOCALIZE_KEY")
    
    static let successfullyEdited: String = StringHelper.localizedStringWithKey("SUCCESSFULLY_EDITED_LOCALIZE_KEY")
    static let successfullyDraft: String = StringHelper.localizedStringWithKey("SUCCESSFULLY_DRAFT_LOCALIZE_KEY")
    static let successfullyUploaded: String = StringHelper.localizedStringWithKey("SUCCESSFULLY_UPLOADED_LOCALIZE_KEY")
    
    static let saveAsDraft: String = StringHelper.localizedStringWithKey("SAVE_DRAFT_LOCALIZE_KEY")
    
    static let uploadAgain: String = StringHelper.localizedStringWithKey("UPLOAD_AGAIN_LOCALIZE_KEY")
    static let backToDashboard: String = StringHelper.localizedStringWithKey("BACK_TO_DASHBOARD_LOCALIZE_KEY")
    
    static var cropped: [UIImage] = []
}

// MARK: Constant variable declarations
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
    
    static let uploadImagesKey = "imageDetails"
    static let uploadConditionKey = "condition"
    static let uploadTitleKey = "title"
    static let uploadBrandKey = "brand"
    static let uploadCategoryKey = "productCategory"
    static let uploadQuantityKey = "quantity"
    static let uploadPriceKey = "price"
    static let uploadAccessTokenKey = "access_token"
    static let uploadPropertyKey = "productProperties"
    static let uploadShortDescriptionkey = "shortDescription"
    static let uploadDescriptionKey = "description"
    static let uploadDiscountedPriceKey = "discountedPrice"
    static let uploadProductUnitId = "productUnitId"
}

struct ProductUploadCombination {
    static var parameters: NSMutableDictionary?
    static var url: String = ""
    static var datas: [NSData] = []
    static var indexes: [Int] = []
    static var deleted: [String] = []
    static var draft: Bool = false
}

class ProductUploadTableViewController: UITableViewController, ProductUploadUploadImageTableViewCellDataSource, ProductUploadUploadImageTableViewCellDelegate, UzysAssetsPickerControllerDelegate, ProductUploadFooterViewDelegate, ProductUploadTextFieldTableViewCellDelegate, ProductUploadTextViewTableViewCellDelegate, ProductUploadPriceTableViewCellDelegate, ProductUploadDimensionsAndWeightTableViewCellDelegate, ProductUploadBrandViewControllerDelegate, ProductUploadQuantityTableViewCellDelegate, SuccessUploadViewControllerDelegate {
    
    // Models
    var conditions: [ConditionModel] = []
    var productModel: ProductModel = ProductModel()
    
    // Global variables
    var oldEditedImages: [ServerUIImage] = []
    var uploadType: UploadType = UploadType.NewProduct
    
    var hud: MBProgressHUD?
    var croppedImages: [UIImage] = []
    
    var dimensionsHeaderViewHeight: CGFloat = 41
    var productUploadWeightAndHeightCellHeight: CGFloat = 244
    var sectionPriceHeaderHeight: CGFloat = 41
    
    var combinationImagesArray: [Int] = []
    var imagesToUpload: Int = 0
    var removedImages: Int = 0
    var sectionFourRows: Int = 2
    var deletedImagesId: [String] = []
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Set navigation bar title
        if self.uploadType == UploadType.EditProduct {
            self.title = Constants.ViewControllersTitleString.productEdit
            let oldImages: [ServerUIImage] = self.productModel.editedImage
            self.oldEditedImages = oldImages
        } else {
            self.title = Constants.ViewControllersTitleString.productUpload
        }
        
        if self.productModel.validCombinations.count != 0 {
           self.updateCombinationListRow()
        }
        
        self.backButton()
        self.register()
        self.addAddPhoto()
        self.footer()
        
        self.fireCondition()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation bar
    // MARK: - Add Back Button in navigation bar
    func backButton() {
        ProductCroppedImages.imagesCropped.removeAll(keepCapacity: false)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "back")
        customBackButton.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    //MARK: - Navigation bar back button action
    func back() {
        if self.productModel.name != "" {
            if ProductUploadCombination.draft {
                self.draft()
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: Private Methods
    // Append dummy photo
    func addAddPhoto() {
        if self.uploadType == UploadType.EditProduct {
            let image: UIImage = UIImage(named: "addPhoto")!
            let serverImage: ServerUIImage  = ServerUIImage(data: UIImagePNGRepresentation(image)!)!
            self.productModel.editedImage.append(serverImage)
        } else {
            self.productModel.images.append(UIImage(named: "addPhoto")!)
        }
    }
    
    // MARK: - Add More Details
    func addMoreDetails(sender: UIButton) {
        /*let productUploadDetailViewController: ProductUploadDetailTableViewController = ProductUploadDetailTableViewController(nibName: "ProductUploadDetailTableViewController", bundle: nil)
        self.navigationController!.pushViewController(productUploadDetailViewController, animated: true)*/
        let productUploadAttributeListTableViewController: ProductUploadAttributeListTableViewController = ProductUploadAttributeListTableViewController(nibName: "ProductUploadAttributeListTableViewController", bundle: nil)
        productUploadAttributeListTableViewController.productModel = self.productModel.copy()
        self.navigationController!.pushViewController(productUploadAttributeListTableViewController, animated: true)
    }
   
    // MARK: - Select Category
    func didSelecteCategory(categoryModel: CategoryModel) {
        self.productModel.category = categoryModel
        let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 2)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    // MARK: - Draft Alert
    func draft() {
        let alertController = UIAlertController(title: ProductUploadStrings.uploadItem, message: ProductUploadStrings.saveAsDraft, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: Constants.Localized.no, style: .Cancel) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: Constants.Localized.yes, style: .Default) { (action) in
            self.fireUploadWithUploadType(UploadType.Draft)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    // MARK: - Brand
    func brand() {
        let brandViewController: ProductUploadBrandViewController = ProductUploadBrandViewController(nibName: "ProductUploadBrandViewController", bundle: nil)
        brandViewController.delegate = self
        self.navigationController!.pushViewController(brandViewController, animated: true)
    }
    
    // MARK: - Category
    func category() {
        let productUploadCategoryViewController: ProductUploadCategoryViewController = ProductUploadCategoryViewController(nibName: "ProductUploadCategoryViewController", bundle: nil)
        productUploadCategoryViewController.pageTitle = ProductUploadStrings.selectCategory
        productUploadCategoryViewController.userType = UserType.Seller
        self.navigationController!.pushViewController(productUploadCategoryViewController, animated: true)
    }
    
    // MARK: - Dismiss Controller Toast Message
    func dismissControllerWithToastMessage(message: String) {
        self.tableView.endEditing(true)
        self.navigationController?.view.makeToast(message)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            //self.navigationController?.popViewControllerAnimated(true)
            ProductUploadEdit.isPreview = false
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // Add table view footer
    func footer() {
        let footerView: ProductUploadFooterView = XibHelper.puffViewWithNibName("ProductUploadFooterView", index: 0) as! ProductUploadFooterView
        self.tableView.tableFooterView = footerView
        footerView.delegate = self
    }
    
    // Add tap gesture recognizer to hide keyboard when tap outside the view
    func gestureEndEditing() {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyBoard")
        self.tableView.userInteractionEnabled = true
        self.tableView.addGestureRecognizer(gesture)
    }
    
    // Hide/dismiss the keyboard
    func hideKeyBoard() {
        self.tableView.endEditing(true)
    }
    
    // MARK: Register table view cells
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
    
    // MARK: Reload table view
    func reloadTable(){
        self.tableView.reloadData()
    }
    
    // MARK: - Reupload Cell Collection View Data
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
        var lastIndexPath: NSIndexPath = NSIndexPath()
        
        if self.uploadType == UploadType.EditProduct {
            lastIndexPath = NSIndexPath(forItem: self.productModel.editedImage.count - 1, inSection: 0)
        } else {
            lastIndexPath = NSIndexPath(forItem: self.productModel.images.count - 1, inSection: 0)
        }
        
        cell.collectionView.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
    }
    
    func replaceProductAttributeWithAttribute(attributes: [AttributeModel], combinations: [CombinationModel]) {
        self.productModel.attributes = attributes
        self.productModel.validCombinations = combinations
        self.updateCombinationListRow()
    }
    
    // MARK: Alert view
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    // MARK: Show HUD
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
    
    // MARK: - Call SuccessViewController
    func success() {
        let successViewController: SuccessUploadViewController = SuccessUploadViewController(nibName: "SuccessUploadViewController", bundle: nil)
        successViewController.delegate = self
        self.presentViewController(successViewController, animated: true, completion: nil)
    }
    
    // MARK: - Update Combination List Row
    func updateCombinationListRow() {
        if self.productModel.validCombinations.count == 0 {
            self.sectionFourRows = 2
            self.productUploadWeightAndHeightCellHeight = 244
            self.dimensionsHeaderViewHeight = 41
        } else {
            self.sectionFourRows = 0
            self.productUploadWeightAndHeightCellHeight = 0
            self.dimensionsHeaderViewHeight = 0
        }
        
        self.sectionPriceHeaderHeight = 0
        self.tableView.clipsToBounds = true
        self.tableView.reloadData()
    }
    
    // MARK: - Property
    // Return a formatted string containing dictionary of combinations with values and keys
    func property(mainImageCount: Int) -> String {
        var array: [NSMutableDictionary] = []
        
        var counter: Int = mainImageCount
        
        counter = self.imagesToUpload
        
        for combination in self.productModel.validCombinations {
            let dictionary: NSMutableDictionary = NSMutableDictionary()
            dictionary["attribute"] = combination.attributes
            dictionary["price"] = (combination.retailPrice as NSString).doubleValue
            dictionary["discountedPrice"] = (combination.discountedPrice as NSString).doubleValue
            dictionary["quantity"] = combination.quantity.toInt()
            dictionary["sku"] = combination.sku
            
            var arrayNumber: [Int] = []
            if self.uploadType == UploadType.EditProduct {
                for (index, image) in enumerate(combination.editedImages) {
                    if image.isNew {
                        var x: Int = counter
                        counter++
                        arrayNumber.append(x)
                    } else {
                        arrayNumber.append(counter)
                        counter++
                    }
                }
            } else {
                for (index, image) in enumerate(combination.images) {
                    var x: Int = counter
                    counter++
                    arrayNumber.append(x)
                }
            }
            
            dictionary["images"] = arrayNumber
            dictionary["unitWeight"] = (combination.weight as NSString).doubleValue
            dictionary["unitLength"] = (combination.length as NSString).doubleValue
            dictionary["unitWidth"] = (combination.width as NSString).doubleValue
            dictionary["unitHeight"] = (combination.height as NSString).doubleValue
            
            if self.uploadType == UploadType.EditProduct || self.uploadType == UploadType.Draft {
                dictionary["productUnitId"] = combination.productUnitId
            }
            
            array.append(dictionary)
        }
        
        let data = NSJSONSerialization.dataWithJSONObject(array, options: nil, error: nil)
        let string: String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        let finalJsonString: String = string.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        return finalJsonString
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        //return 5
        return 6
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
        } else if section == 4 {
            return sectionFourRows
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
        } else if section == 4 {
            return sectionPriceHeaderHeight
        } else {
            sectionHeight = self.dimensionsHeaderViewHeight
        }
        return sectionHeight
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ProductUploadTableHeaderView = XibHelper.puffViewWithNibName("ProductUploadTableHeaderView", index: 0) as! ProductUploadTableHeaderView

        if section == 1 {
            headerView.headerTitleLabel.text = ProductUploadStrings.productInformation
        } else if section == 2 {
            headerView.headerTitleLabel.text = ProductUploadStrings.productDetails
        } else if section == 3 {
            headerView.headerTitleLabel.text = ProductUploadStrings.price
        } else if section == 4 {
            headerView.headerTitleLabel.text = ProductUploadStrings.price
        } else if section == 5 {
            headerView.headerTitleLabel.text = ProductUploadStrings.dimensionsAndWeight
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
            return ProductUploadTableViewControllerConstant.priceCellHeight
        } else {
            return self.productUploadWeightAndHeightCellHeight
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: ProductUploadUploadImageTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadUploadImageTableViewCellNibNameAndIdentifier) as! ProductUploadUploadImageTableViewCell
            cell.dataSource = self
            cell.delegate = self
            cell.collectionView.reloadData()
            cell.selectionStyle = UITableViewCellSelectionStyle.None

            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.cellTitleLabel.text = ProductUploadStrings.productName
                cell.cellTitleLabel.required()
                cell.cellTexField.placeholder = ProductUploadStrings.productName
                cell.cellTexField.text = self.productModel.name
                cell.textFieldType = ProductTextFieldType.ProductName
                
                if SessionManager.isSeller() {
                    cell.userInteractionEnabled = true
                } else {
                    cell.userInteractionEnabled = true
                }
                
                return cell
            } else if indexPath.row == 1 {
                let cell: ProductUploadTextViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier) as! ProductUploadTextViewTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.textFieldType = ProductTextFieldType.ProductShortDescription
                cell.cellTitleLabel.text = ProductUploadStrings.shortDescription
                cell.cellTitleLabel.required()
                cell.productUploadTextView.text = self.productModel.shortDescription
                
                if SessionManager.isSeller() {
                    cell.userInteractionEnabled = true
                } else {
                    cell.userInteractionEnabled = true
                }
                
                return cell
            } else if indexPath.row == 2 {
                let cell: ProductUploadTextViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier) as! ProductUploadTextViewTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.textFieldType = ProductTextFieldType.ProductCompleteDescription
                cell.cellTitleLabel.text = ProductUploadStrings.completeDescription
                cell.cellTitleLabel.required()
                cell.productUploadTextView.text = self.productModel.completeDescription
                
                if SessionManager.isSeller() {
                    cell.userInteractionEnabled = true
                } else {
                    cell.userInteractionEnabled = true
                }
                
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
                cell.cellTitleLabel.text = ProductUploadStrings.category
                cell.cellTexField.placeholder = ProductUploadStrings.selectCategory
                cell.cellTexField.text = self.productModel.category.name
                cell.textFieldType = ProductTextFieldType.Category
                cell.delegate = self
                cell.cellTitleLabel.required()
                if self.productModel.category.name != "" {
                    cell.cellTexField.text = self.productModel.category.name
                }
                
                if SessionManager.isSeller() {
                    cell.userInteractionEnabled = true
                } else {
                    cell.userInteractionEnabled = false
                }
                
                return cell
            } else if indexPath.row == 1 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.cellTitleLabel.text = ProductUploadStrings.brand
                cell.cellTexField.placeholder = ProductUploadStrings.brand
                cell.delegate = self
                cell.cellTexField.text = self.productModel.brand.name
                cell.textFieldType = ProductTextFieldType.Brand
                if self.productModel.brand.name != "" {
                    cell.cellTexField.text = self.productModel.brand.name
                }
                
                cell.addTextFieldDelegate()
                
                if SessionManager.isSeller() {
                    cell.userInteractionEnabled = true
                } else {
                    cell.userInteractionEnabled = false
                }
                
                return cell
            } else {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.cellTitleLabel.text = ProductUploadStrings.condition
                cell.cellTexField.placeholder = ProductUploadStrings.condition
                cell.textFieldType = ProductTextFieldType.Condition
                cell.delegate = self
                cell.cellTitleLabel.required()
                cell.cellTexField.text = self.productModel.condition.name
                var values: [String] = []
                
                if self.conditions.count != 0 {
                    for condition in self.conditions as [ConditionModel] {
                        values.append(condition.name)
                    }
                    
                    if indexPath.row == 2 {
                        cell.values = values
                        cell.addPicker()
                    }
                }
                
                if SessionManager.isSeller() {
                    cell.userInteractionEnabled = true
                } else {
                    cell.userInteractionEnabled = false
                }
                
                return cell
            }
        } else if indexPath.section == 3 {
            if self.productModel.validCombinations.count == 0 {
                if indexPath.row == 0 {
                    let cell: ProductUploadButtonTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadButtonTableViewCellNibNameAndIdentifier) as! ProductUploadButtonTableViewCell
                    cell.cellButton.setTitle(ProductUploadStrings.addMoreDtails, forState: UIControlState.Normal)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.cellButton.addTarget(self, action: "addMoreDetails:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    if SessionManager.isSeller() {
                        cell.userInteractionEnabled = true
                    } else {
                        cell.userInteractionEnabled = false
                    }
                    
                    return cell
                } else if indexPath.row == 1 {
                    let cell: ProductUploadQuantityTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadQuantityTableViewCellNibNameAndIdentifier) as! ProductUploadQuantityTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.delegate = self
                    
                    cell.cellTextField.text = "\(self.productModel.quantity)"
                    
                    if SessionManager.isSeller() {
                        cell.userInteractionEnabled = true
                    } else {
                        cell.userInteractionEnabled = false
                    }
                    
                    return cell
                } else {
                    let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.cellTitleLabel.text = ProductUploadStrings.sku
                    cell.cellTexField.placeholder = ProductUploadStrings.sku
                    cell.cellTitleLabel.required()
                    cell.delegate = self
                    cell.textFieldType = ProductTextFieldType.ProductSKU
                    cell.cellTexField.text = self.productModel.sku
                    
                    if SessionManager.isSeller() {
                        cell.userInteractionEnabled = true
                    } else {
                        cell.userInteractionEnabled = false
                    }
                    
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
                        
                        if title != "" {
                            title = dropLast(title)
                            title = dropLast(title)
                        }
                        
                        cell.cellTitleLabel.text = title
                    } else {
                        var totalQuantity: Int = 0
                        
                        for combination in self.productModel.validCombinations as [CombinationModel] {
                            totalQuantity = totalQuantity + combination.quantity.toInt()!
                        }
                        
                        cell.cellQuantityLabel.text = "x" + "\(totalQuantity)"
                        
                        var title: String = ProductUploadStrings.totalQuantity
                        cell.cellTitleLabel.text = title
                        let defaultFontSize: CGFloat = 14
                        cell.cellTitleLabel.font = UIFont(name:"Panton-Bold", size: defaultFontSize)
                    }
                    
                    if SessionManager.isSeller() {
                        cell.userInteractionEnabled = true
                    } else {
                        cell.userInteractionEnabled = false
                    }
                    
                    return cell
                } else {
                    let cell: ProductUploadButtonTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadButtonTableViewCellNibNameAndIdentifier) as! ProductUploadButtonTableViewCell
                    cell.cellButton.setTitle(ProductUploadStrings.addEdit, forState: UIControlState.Normal)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.cellButton.addTarget(self, action: "addMoreDetails:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    if SessionManager.isSeller() {
                        cell.userInteractionEnabled = true
                    } else {
                        cell.userInteractionEnabled = false
                    }
                    
                    return cell
                }
            }
            
        } else if indexPath.section == 4 {
            if indexPath.row == 0 {
                let cell: ProductUploadPriceTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadPriceTableViewCellNibNameAndIdentifier) as! ProductUploadPriceTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.textFieldType = ProductTextFieldType.ProductRetailPrice
                cell.cellTitleLabel.text = ProductUploadStrings.retailPrice
                cell.cellTitleLabel.required()
                cell.cellTextField.placeholder = "0.00"
              
                if self.productModel.retailPrice == "0" || self.productModel.retailPrice == "" {
                    cell.cellTextField.text = ""
                } else {
                    cell.cellTextField.text = self.productModel.retailPrice
                }
                
                if SessionManager.isSeller() {
                    cell.userInteractionEnabled = true
                } else {
                    cell.userInteractionEnabled = false
                }
                
                return cell
            } else {
                let cell: ProductUploadPriceTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadPriceTableViewCellNibNameAndIdentifier) as! ProductUploadPriceTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.textFieldType = ProductTextFieldType.ProductDiscountPrice
                cell.cellTitleLabel.text = ProductUploadStrings.discountedPrice
                cell.cellTextField.placeholder = "0.00"
                cell.cellTextField.text = self.productModel.discoutedPrice
                
                if SessionManager.isSeller() {
                    cell.userInteractionEnabled = true
                } else {
                    cell.userInteractionEnabled = false
                }
                
                return cell
            }
        } else {
            let cell: ProductUploadDimensionsAndWeightTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier) as! ProductUploadDimensionsAndWeightTableViewCell
            cell.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.weightTextField.text = self.productModel.weigth
            //cell.weightLabel.required()
            cell.lengthTextField.text = self.productModel.length
            //cell.lengthlabel.required()
            cell.heightTextField.text = self.productModel.height
            //cell.heightLabel.required()
            cell.widthTextField.text = self.productModel.width
            //cell.widthLabel.required()
            
            if self.productModel.validCombinations.count != 0 {
                cell.hidden = true
            } else {
                cell.hidden = false
            }
            
            if SessionManager.isSeller() {
                cell.userInteractionEnabled = true
            } else {
                cell.userInteractionEnabled = false
            }
            
            return cell
        }
    }
    
    // MARK: - Product Uplaod Brand View Controller Delegate Method
    func productUploadBrandViewController(didSelectBrand brand: String, brandModel: BrandModel) {
        if brandModel.name != brand {
            self.productModel.brand = BrandModel(name: brand, brandId: 1)
        } else {
            self.productModel.brand = brandModel
        }
        
        let indexPath: NSIndexPath = NSIndexPath(forItem: 1, inSection: 2)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    // MARK: - Product Upload Upload Image Table View Cell Delegate method
    func productUploadUploadImageTableViewCell(numberOfCollectionViewRows cell: ProductUploadUploadImageTableViewCell) -> Int {
        if self.uploadType == UploadType.EditProduct {
            return self.productModel.editedImage.count
        } else {
            return self.productModel.images.count
        }
    }
    
    //MARK: - Upload Delegate
    func productUploadUploadImageTableViewCell(didSelecteRowAtIndexPath indexPath: NSIndexPath, cell: ProductUploadUploadImageTableViewCell) {
        if self.uploadType == UploadType.EditProduct {
            if indexPath.row == self.productModel.editedImage.count - 1 && self.productModel.editedImage.count <= 5 {
                let picker: UzysAssetsPickerController = UzysAssetsPickerController()
                let maxCount: Int = 6
                
                let imageLimit: Int = maxCount - self.productModel.images.count
                picker.delegate = self
                picker.maximumNumberOfSelectionVideo = 0
                picker.maximumNumberOfSelectionPhoto = 100
                UzysAssetsPickerController.setUpAppearanceConfig(self.uzyConfig())
                self.presentViewController(picker, animated: true, completion: nil)
            }

        } else {
            if indexPath.row == self.productModel.images.count - 1 && self.productModel.images.count <= 5 {
                let picker: UzysAssetsPickerController = UzysAssetsPickerController()
                let maxCount: Int = 6
                
                let imageLimit: Int = maxCount - self.productModel.images.count
                picker.delegate = self
                picker.maximumNumberOfSelectionVideo = 0
                picker.maximumNumberOfSelectionPhoto = 100
                UzysAssetsPickerController.setUpAppearanceConfig(self.uzyConfig())
                self.presentViewController(picker, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Product Upload Upload Image Table View Cell Delegate method
    func productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath indexPath: NSIndexPath, collectionView: UICollectionView) {
        if self.uploadType == UploadType.EditProduct {
            if self.productModel.editedImage[indexPath.row].uid != "" {
                if !contains(self.deletedImagesId, self.productModel.editedImage[indexPath.row].uid) {
                    self.deletedImagesId.append(self.productModel.editedImage[indexPath.row].uid)
                }
            }
            self.productModel.editedImage.removeAtIndex(indexPath.row)
        } else {
            self.productModel.images.removeAtIndex(indexPath.row)
            ProductCroppedImages.imagesCropped.removeAtIndex(indexPath.row)
        }
        collectionView.deleteItemsAtIndexPaths([indexPath])
    }

    func productUploadUploadImageTableViewCell(didTapStarAtRowIndexPath indexPath: NSIndexPath, cell: ProductUploadImageCollectionViewCell) {
        cell.starButton.setBackgroundImage(UIImage(named: "active2"), forState: UIControlState.Normal)
    }
    func productUploadUploadImageTableViewCell(images cell: ProductUploadUploadImageTableViewCell) -> [UIImage] {
        if self.uploadType == UploadType.EditProduct {
            return self.productModel.editedImage
        } else {
            return self.productModel.images
        }
    }

    // MARK: UzysAssetsPickerView Controller Data Source and Delegate methods
    // MARK: - Uzy Config
    func uzyConfig() -> UzysAppearanceConfig {
        let config: UzysAppearanceConfig = UzysAppearanceConfig()
        config.finishSelectionButtonColor = Constants.Colors.appTheme
        return config
    }
    
    // MARK: - Uzzy Picker Delegate
    func uzysAssetsPickerController(picker: UzysAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        let assetsLibrary = ALAssetsLibrary()
        let alaSset: ALAsset = assets[0] as! ALAsset

        for allaSset in assets as! [ALAsset] {
            
            if self.uploadType == UploadType.EditProduct {
                // Insert newly added images in 'productModel' editedImages,
                // Set 'isNew' to true
                let image: ServerUIImage = ServerUIImage(CGImage: allaSset.defaultRepresentation().fullScreenImage().takeUnretainedValue())!
                image.isNew = true
                image.isRemoved = false
                self.productModel.editedImage.insert(image, atIndex: self.productModel.editedImage.count - 1)
            } else {
                // Insert iamges in 'productModel' array of images
                // Call CropAssetViewController to crop images
                let representation: ALAssetRepresentation = allaSset.defaultRepresentation()
                let image: UIImage = UIImage(CGImage: allaSset.defaultRepresentation().fullScreenImage().takeUnretainedValue(), scale: 1.0, orientation: UIImageOrientation.Up)!
                
                self.productModel.images.insert(image, atIndex: self.productModel.images.count - 1)
                
                let storyboard = UIStoryboard(name: "FaImagePicker", bundle: nil)
                
                let faImagePicker = storyboard.instantiateViewControllerWithIdentifier("FaCropper") as! CropAssetViewController!
                faImagePicker.image = image
                faImagePicker.imageCount = ProductCroppedImages.imagesCropped.count - 1
                //faImagePicker.imagePickerDelegate = self
                faImagePicker.edgesForExtendedLayout = .None
                self.navigationController!.pushViewController(faImagePicker, animated: true)
            }
        }
    
        self.reloadUploadCellCollectionViewData()
        //self.tableView.reloadData()
        //self.reloadTable()
    }
    
    // MARK: - Uzy Delegate
    func uzysAssetsPickerControllerDidCancel(picker: UzysAssetsPickerController!) {
        
    }
    
    func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker: UzysAssetsPickerController!) {
        
    }
    
    // MARK: - Product Upload Footer View Delegate method
    func productUploadFooterView(didClickUpload view: ProductUploadFooterView) {
        var count: Int = 0
        if self.uploadType == UploadType.EditProduct {
            count = self.productModel.editedImage.count
        } else {
            count = self.productModel.images.count
        }
        
        // Error validation, catch error if any of the required textfield is empty
        if count == 1 {
          UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.insertOneImage, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.name == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.productNameRequired, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.shortDescription == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.shortDescriptionRquired, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.completeDescription == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.completeRequired, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.category.name == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.categoryRequired, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.condition == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.conditionRequired, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.quantity == 0 && self.productModel.validCombinations.count == 0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.quantityRequired, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.retailPrice == "" && self.productModel.validCombinations.count == 0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.retailPriceRequired, title: ProductUploadStrings.incompleteProductDetails)
        } else if (self.productModel.retailPrice as NSString).doubleValue < (self.productModel.discoutedPrice as NSString).doubleValue {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.retailMustBeLarger, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.sku == "" && self.productModel.validCombinations.count == 0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.skuRequried, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.length == "" && self.productModel.validCombinations.count == 0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.lengthRequried, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.weigth == "" && self.productModel.validCombinations.count == 0  {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.weightRequried, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.width == "" && self.productModel.validCombinations.count == 0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.widthRequried, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.height == "" && self.productModel.validCombinations.count == 0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.heightRequried, title: ProductUploadStrings.incompleteProductDetails)
        } else {
            self.fireUploadWithUploadType(self.uploadType)
        }
    }
    
    // MARK: - Product Upload Text Field Table View Cell Delegate method
    func productUploadTextFieldTableViewCell(textFieldDidChange text: String, cell: ProductUploadTextFieldTableViewCell, textFieldType: ProductTextFieldType) {
        if textFieldType == ProductTextFieldType.ProductName {
            self.productModel.name = text
        } else if textFieldType == ProductTextFieldType.ProductSKU {
            self.productModel.sku = text
        } else if textFieldType == ProductTextFieldType.Condition {
            var selectedIndex: Int = 0
            
            for (index, condition) in enumerate(self.conditions) {
                if condition.name == text {
                    selectedIndex = index
                }
            }
            self.productModel.condition = self.conditions[selectedIndex]
        } else if textFieldType == ProductTextFieldType.Brand {
            self.brand()
        } else if textFieldType == ProductTextFieldType.Category {
            self.category()
        }
    }
    
    // MARK: - Product Upload Text View Table View Cell Delegate
    func productUploadTextViewTableViewCell(textFieldDidChange text: String, cell: ProductUploadTextViewTableViewCell, textFieldType: ProductTextFieldType) {
        if textFieldType == ProductTextFieldType.ProductShortDescription {
            self.productModel.shortDescription = text
        } else if textFieldType == ProductTextFieldType.ProductCompleteDescription {
            self.productModel.completeDescription = text
        }
    }
    
    // MARK: - Price Table View Cell Delegate Method
    func productUploadPriceTableViewCell(textFieldDidChange text: String, cell: ProductUploadPriceTableViewCell, textFieldType: ProductTextFieldType) {
        if textFieldType == ProductTextFieldType.ProductRetailPrice {
            self.productModel.retailPrice = text
            self.productModel.discoutedPrice = text
            
            let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
            let cell: ProductUploadPriceTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)) as! ProductUploadPriceTableViewCell
            
            cell.cellTextField.text = text
            
        } else if textFieldType == ProductTextFieldType.ProductDiscountPrice {
            self.productModel.discoutedPrice = text
        }
    }
    
    // MARK: - Dimensions And Weight Table View Cell Delegate Method
    func productUploadDimensionsAndWeightTableViewCell(textFieldDidChange textField: UITextField, text: String, cell: ProductUploadDimensionsAndWeightTableViewCell) {
        if textField.isEqual(cell.weightTextField) {
            self.productModel.weigth = text
        } else if textField.isEqual(cell.heightTextField) {
            self.productModel.height = text
        } else if textField.isEqual(cell.lengthTextField) {
            self.productModel.length = text
        } else if textField.isEqual(cell.widthTextField) {
            self.productModel.width = text
        }
    }
    
    // MARK: - Quantity Table View Cell Delegate Method
    func productUploadQuantityTableViewCell(textFieldDidChange text: String, cell: ProductUploadQuantityTableViewCell) {
        if let val = text.toInt() {
           self.productModel.quantity = text.toInt()!
        }
    }
    
    // MARK: - Success Upload View Controller Delegate method
    func successUploadViewController(didTapDashBoard viewController: SuccessUploadViewController) {
        self.tableView.hidden = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func successUploadViewController(didTapUploadAgain viewController: SuccessUploadViewController) {
        for (index, images) in enumerate(self.productModel.images) {
            self.productModel.images.removeLast()
        }
        
        for (index, images) in enumerate(ProductCroppedImages.imagesCropped) {
            ProductCroppedImages.imagesCropped.removeLast()
        }
        
        self.productModel = ProductModel()
        self.addAddPhoto()
        self.fireCondition()
        self.tableView.reloadData()
        self.updateCombinationListRow()
        self.tableView.setContentOffset(CGPointZero, animated: true)
    }
    
    // MARK: -
    // MARK: - REST API request
    // MARK: POST METHOD - Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    * Function to refresh token to get another access token
    *
    */
    func fireRefreshToken() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in

            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.fireCondition()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else {
                    self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                }
                self.hud?.hide(true)
        })

    }
    
    // MARK: POST METHOD - Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    * Function to refresh token to get another access token
    *
    */
    func fireRefreshToken2() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.fireUploadWithUploadType(self.uploadType)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else {
                    self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                }
                self.hud?.hide(true)
        })
    }
    
    // MARK: POST METHOD - Fire Upload With Upload Type
    /*
    *
    * (Parameters) - imageDetails, condition, title, brand, productCategory, quantity, price, access_token
    *              - productProperties, shortDescription, description, discountedPrice, productUnitId
    *
    * Function to upload the newly created / edited product
    *
    */
    func fireUploadWithUploadType(uploadType: UploadType) {
        var editedImages: [ServerUIImage] = []
        var mainImages: [ServerUIImage] = []
        var combinationCounter: Int = 0
        
        for editedImage in  self.productModel.editedImage {
            //editedImages.append(editedImage)
            editedImages.insert(editedImage, atIndex: combinationCounter)
            combinationCounter++
        }
        
        if uploadType == UploadType.EditProduct {
            editedImages.removeLast()
            combinationCounter--
        }
        
        mainImages = editedImages
        //Comparing of oldEditedImages and editedImages
        if uploadType == UploadType.EditProduct {
            for (index, oldImage) in enumerate(self.oldEditedImages) {
                var isNew: Bool = false
                var isDeleted: Bool = true
                
                for image in editedImages {
                    //If oldEditedImages id is in the editedImages then don't update model
                    if oldImage.uid == image.uid {
                        println("old image uid: \(oldImage.uid)")
                        isDeleted = false
                        break
                    }
                }
                
                if contains(self.deletedImagesId, oldImage.uid) {
                    oldImage.isRemoved = true
                    oldImage.isNew = false
                    println("old image uid: \(oldImage.uid)")
                    //editedImages.append(oldImage)
                    editedImages.insert(oldImage, atIndex: combinationCounter)
                    combinationCounter++
                }
            }
        }
        
        var datas: [NSData] = []
        
        var uploadedImages: [UIImage] = []
        
        for images in self.productModel.images {
            uploadedImages.append(images)
        }
        
        var productUploadedImagesCount: Int = 0
        
        if uploadedImages.count != 0 {
            uploadedImages.removeLast()
        }
        
        if self.uploadType == UploadType.EditProduct {
            self.imagesToUpload = editedImages.count
        } else {
            self.imagesToUpload = uploadedImages.count
        }
        
        var imagesKey: [NSDictionary] = []
        
        var combinationImagesId: [String] = []
        for combination in self.productModel.validCombinations {
            if combination.images.count == 0 {
                for image in  self.productModel.oldEditedCombinationImages {
                    if self.uploadType == UploadType.NewProduct {
                        uploadedImages.append(image)
                    } else if self.uploadType == UploadType.EditProduct {
                        println("\(combination.images.count) id: \(image.uid) - removed: \(image.isRemoved) - new: \(image.isNew) - size: \(image.size.height)")
                        if (!contains(combinationImagesId, image.uid) && !contains(ProductUploadCombination.deleted, image.uid)) || image.isNew == true {
                            //Working
                            //editedImages.append(image)
                            editedImages.insert(image, atIndex: combinationCounter)
                            combinationImagesId.append(image.uid)
                            combinationCounter++
                        }
                    }
                }
            } else {
                for image in combination.images {
                    if self.uploadType == UploadType.NewProduct {
                        uploadedImages.append(image)
                    } else if self.uploadType == UploadType.EditProduct {
                        var serverImages: ServerUIImage = image as! ServerUIImage
                        println("\(combination.images.count) --- id: \(serverImages.uid) - removed: \(serverImages.isRemoved) - new: \(serverImages.isNew)")
                        
                        if !contains(ProductUploadCombination.deleted, serverImages.uid) && !contains(combinationImagesId, serverImages.uid) || serverImages.isNew == true{
                            //Working
                            //editedImages.append(serverImages)
                            editedImages.insert(serverImages, atIndex: combinationCounter)
                            combinationImagesId.append(serverImages.uid)
                            combinationCounter++
                        } else if !contains(combinationImagesId, serverImages.uid) {
                            editedImages.insert(serverImages, atIndex: combinationCounter)
                            combinationImagesId.append(serverImages.uid)
                            combinationCounter++
                        }
                    }
                }
            }
        }
        
        println("main images + combi images \(editedImages)")
        println("main images + combi images count \(editedImages.count)")
        // This is for checking old images in combination that has been deleted.
        if self.uploadType == UploadType.EditProduct {
            //for oldImage in self.productModel.oldEditedCombinationImages {
            
            /*println("old image uid: \(oldImage.uid)")
            
            var isDeleted: Bool = true
            for image in editedImages {
                if image.uid == oldImage.uid {
                    isDeleted = false
                    break
                }
            }
            
            if isDeleted == true {
                oldImage.isNew = false
                oldImage.isRemoved = true
                editedImages.append(oldImage)
            }*/
            
            for (index, oldImage) in enumerate(self.productModel.oldEditedCombinationImages) {
                var isNew: Bool = false
                var isDeleted: Bool = true
                var imageId: String = ""
                for image in editedImages {
                    //If oldEditedImages id is in the editedImages then don't update model
                    /* Working
                    if image.uid == oldImage.uid {
                        println("old image uid: \(oldImage.uid)")
                        isDeleted = false
                        break
                    }
                    */
                    println("image \(image.uid) \(image.isRemoved) \(image.isNew)")
                    println("old image \(oldImage.uid) \(oldImage.isRemoved) \(oldImage.isNew)")
                    if image.uid == oldImage.uid {
                        println("old image uid: \(oldImage.uid)")
                        isDeleted = false
                        break
                    }
                }
                
                /* working
                if contains(ProductUploadCombination.deleted, oldImage.uid) {
                    oldImage.isRemoved = true
                    oldImage.isNew = false
                    println("old image uid: \(oldImage.uid)")
                    editedImages.append(oldImage)
                }*/
                
                if contains(ProductUploadCombination.deleted, oldImage.uid)  {
                    oldImage.isRemoved = true
                    oldImage.isNew = false
                    println("old image uid: \(oldImage.uid)")
                    //Working
                    //editedImages.append(oldImage)
                    editedImages.insert(oldImage, atIndex: combinationCounter)
                    combinationCounter++
                }
            }
        }
        
        var mainImageCount: Int = uploadedImages.count
        
        if self.uploadType == UploadType.EditProduct {
            //mainImageCount = self.productModel.editedImage.count
            mainImageCount = 0
            
            for image in self.productModel.editedImage {
                if image.isNew {
                    mainImageCount++
                }
            }
        }
        
        /* Removed - from Alvin's changes
        if self.uploadType == UploadType.EditProduct {
            var counter: Int = 0
            for image in editedImages as [ServerUIImage] {
                if image.uid != "" && image.isRemoved == false && image.isNew == false {
                //let data: NSData = UIImageJPEGRepresentation(image, 1)
                counter++
                //datas.append(data)
                } else if image.isNew == true {
                    //let data: NSData = UIImageJPEGRepresentation(image, 1)
                    ProductUploadCombination.indexes.append(counter)
                    counter++
                    // datas.append(data)
                }
            }
        } else {
            for image in uploadedImages as [UIImage] {
                let data: NSData = UIImageJPEGRepresentation(image, 1)
                datas.append(data)
            }
        }*/
        
        var customBrand: String = ""
        
        if self.productModel.brand.brandId != 0 {
            customBrand = self.productModel.brand.name
        }
        
        if self.productModel.discoutedPrice == "" {
            self.productModel.discoutedPrice == "0"
        }
        var categoryId: String = "\(self.productModel.category.uid)"
        
        var height: String = "\(self.productModel.height)"
        var width: String = "\(self.productModel.width)"
        var length: String = "\(self.productModel.length)"
        var weight: String = "\(self.productModel.weigth)"
        
        if height == "" {
            height = "0"
        }
        
        if width == "" {
            width = "0"
        }
        
        if length == "" {
            length = "0"
        }
        
        if weight == "" {
            weight = "0"
        }
        
        if categoryId == "0" {
            categoryId = ""
        }
        
        if self.uploadType == UploadType.EditProduct {
            imagesKey.removeAll(keepCapacity: true)
            
            for (index, image) in enumerate(editedImages) {
                if image.uid == "" && image.isRemoved == false && image.isNew == false {
                    // editedImages.removeAtIndex(index)
                }
            }
            var deletedIndexes: [Int] = []
            var newImageCounter: Int = 0
           
            /*
            if self.uploadType == UploadType.EditProduct {
                for var x = 0; x < editedImages.count; x++ {
                    if contains(deletedIndexes, x) {
                        editedImages.removeAtIndex(x)
                        x = editedImages.count
                    }
                }
            }
            */
            
            var imagesAdded: [String] = []
            for var x = 0; x < editedImages.count; x++ {
                //if !contains(deletedIndexes, x) {
                let image: ServerUIImage = editedImages[x]
                //if !contains(imagesAdded, image.uid) || image.isNew == true {
                var dictionary: NSMutableDictionary = NSMutableDictionary()
                dictionary["imageId"] = newImageCounter
                dictionary["isNew"] = image.isNew
                dictionary["isRemoved"] = image.isRemoved
                dictionary["oldId"] = image.uid
                self.removedImages++
                newImageCounter++
                println("\(image.uid) \(image.isRemoved) \(image.isNew)")
                deletedIndexes.append(x)
                let data = NSJSONSerialization.dataWithJSONObject(dictionary, options: nil, error: nil)
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
                imagesKey.append(dictionary)
                let data2: NSData = UIImageJPEGRepresentation(image, 0.7)
                //datas.insert(data2, atIndex: x)
                datas.append(data2)
                imagesAdded.append(image.uid)
            }
            
            //WORKING - commented due to error in deleting combi images
            /*
            for var x = 0; x < editedImages.count; x++ {
                if !contains(deletedIndexes, x) {
                    let image: ServerUIImage = editedImages[x]
                    var dictionary: NSMutableDictionary = NSMutableDictionary()
                    dictionary["imageId"] = newImageCounter
                    dictionary["isNew"] = image.isNew
                    dictionary["isRemoved"] = image.isRemoved
                    dictionary["oldId"] = image.uid
            
                    if image.isNew {
                        let data = NSJSONSerialization.dataWithJSONObject(dictionary, options: nil, error: nil)
                        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        imagesKey.append(dictionary)
            
                        let data2: NSData = UIImageJPEGRepresentation(image, 1)
                        datas.append(data2)
                        //datas.insert(data2, atIndex: x)
                        newImageCounter++
                    }
                }
            }*/
            
        } else {
            for image in uploadedImages as [UIImage] {
                let data: NSData = UIImageJPEGRepresentation(image, 1)
                datas.append(data)
            }
        }
        
        let dataString = NSJSONSerialization.dataWithJSONObject(imagesKey, options: nil, error: nil)
        let jsonString: String = NSString(data: dataString!, encoding: NSUTF8StringEncoding)! as! String
        let finalJsonString: String = jsonString.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let parameters: NSMutableDictionary = [ProductUploadTableViewControllerConstant.uploadPriceKey: self.productModel.retailPrice,
            ProductUploadTableViewControllerConstant.uploadShortDescriptionkey: self.productModel.shortDescription,
            ProductUploadTableViewControllerConstant.uploadDescriptionKey: self.productModel.completeDescription,
            ProductUploadTableViewControllerConstant.uploadPriceKey: self.productModel.retailPrice,
            ProductUploadTableViewControllerConstant.uploadDiscountedPriceKey: self.productModel.discoutedPrice,
            ProductUploadTableViewControllerConstant.uploadQuantityKey: self.productModel.quantity,
            ProductUploadTableViewControllerConstant.uploadCategoryKey: categoryId,
            ProductUploadTableViewControllerConstant.uploadBrandKey: self.productModel.brand.brandId,
            ProductUploadTableViewControllerConstant.uploadTitleKey: self.productModel.name,
            ProductUploadTableViewControllerConstant.uploadConditionKey: self.productModel.condition.uid,
            ProductUploadTableViewControllerConstant.uploadPropertyKey: self.property(mainImageCount),
            ProductUploadTableViewControllerConstant.uploadImagesKey: finalJsonString,
            "customBrand": customBrand,
            "isFreeShipping": false,
            "height": height,
            "width": width,
            "weight": weight,
            "length": length,
            "sku": self.productModel.sku]
        
        if self.uploadType == UploadType.EditProduct || self.uploadType == UploadType.Draft {
            parameters["productId"] = self.productModel.uid
            parameters[ProductUploadTableViewControllerConstant.uploadProductUnitId] = self.productModel.productUnitId
        }
        
        let manager: APIManager = APIManager.sharedInstance
        
        var url: String = ""
        
        if uploadType == UploadType.Draft {
            self.uploadType = UploadType.Draft
            url = "\(APIAtlas.uploadDraftUrl)?access_token=\(SessionManager.accessToken())"
        } else if uploadType == UploadType.NewProduct {
            self.uploadType = UploadType.NewProduct
            url = "\(APIAtlas.uploadUrl)?access_token=\(SessionManager.accessToken())"
        } else if uploadType == UploadType.EditProduct {
            self.uploadType = UploadType.EditProduct
            url = "\(APIAtlas.uploadEditUrl)?access_token=\(SessionManager.accessToken())"
        }
        
        println("parameters: \(url)")
        
        let data2 = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        let string2 = NSString(data: data2!, encoding: NSUTF8StringEncoding)
        println("parameters: \(string2)")
        
        let productDetailsViewController: ProductDetailsViewController = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        
        if uploadType == UploadType.EditProduct {
            self.productModel.editedImage.removeAll(keepCapacity: false)
            for i in 0..<mainImages.count {
                if !mainImages[i].isRemoved {
                    self.productModel.editedImage.append(mainImages[i])
                    productDetailsViewController.imagesToEdit.append(mainImages[i])
                }
            }
        } else {
            for i in 0..<uploadedImages.count {
                productDetailsViewController.imagesToEdit.append(uploadedImages[i])
            }
        }
        
        if self.uploadType == UploadType.EditProduct {
            productDetailsViewController.uploadType = UploadType.EditProduct
        } else if self.uploadType == UploadType.Draft {
            productDetailsViewController.uploadType = UploadType.Draft
        } else {
            productDetailsViewController.uploadType = UploadType.NewProduct
        }
        
        ProductUploadCombination.parameters = parameters
        ProductUploadCombination.url = url
        ProductUploadCombination.datas = datas
        
        let alertController = UIAlertController(title: ProductUploadStrings.uploadItem, message: "Do you want to proceed?", preferredStyle: .Alert)
        
        if uploadType == UploadType.EditProduct {
            
            let cancelAction = UIAlertAction(title: Constants.Localized.no, style: .Cancel) { (action) in
              
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: Constants.Localized.yes, style: .Default) { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
                productDetailsViewController.productModel = self.productModel
                productDetailsViewController.uploadType = UploadType.EditProduct
                ProductUploadEdit.uploadType = self.uploadType
                ProductUploadEdit.isPreview = true
            }
            
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
            }
        } else if uploadType == UploadType.NewProduct {
            let cancelAction = UIAlertAction(title: Constants.Localized.no, style: .Cancel) { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: Constants.Localized.yes, style: .Default) { (action) in
                productDetailsViewController.productModel = self.productModel
                ProductUploadEdit.isPreview = true
                ProductUploadEdit.uploadType = self.uploadType
                productDetailsViewController.uploadType = UploadType.NewProduct
                self.navigationController?.pushViewController(productDetailsViewController, animated: true)
            }
            
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
            }
        } else {
            self.upload(self.uploadType)
        }
    }
    
    func upload(uploadType: UploadType) -> Bool {
        self.showHUD()
        
        var uploaded: Bool = false
        
        WebServiceManager.fireProductUploadImageRequestWithUrl(ProductUploadCombination.url, parameters: ProductUploadCombination.parameters!, data: ProductUploadCombination.datas, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if uploadType == UploadType.Draft {
                    ProductUploadEdit.edit = false
                    self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyDraft)
                } else if uploadType == UploadType.EditProduct {
                    ProductUploadEdit.edit = false
                    self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyEdited)
                } else {
                    self.success()
                }
                uploaded = true
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                    uploaded = false
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken2()
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                    uploaded = false
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    uploaded = false
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    uploaded = false
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                    uploaded = false
                }
            }
        })
        
        /*
        let manager: APIManager = APIManager.sharedInstance
        manager.POST(ProductUploadCombination.url, parameters: ProductUploadCombination.parameters, constructingBodyWithBlock: { (formData: AFMultipartFormData) -> Void in
            for (index, data) in enumerate(ProductUploadCombination.datas) {
                println("multipart index: \(index)")
                formData.appendPartWithFileData(data, name: "images[]", fileName: "\(index)", mimeType: "image/jpeg")
            }
            
            }, success: { (NSURLSessionDataTask, response: AnyObject) -> Void in
                self.hud?.hide(true)
                let dictionary: NSDictionary = response as! NSDictionary
                
                if dictionary["isSuccessful"] as! Bool == true {
                    if uploadType == UploadType.Draft {
                        ProductUploadEdit.edit = false
                        self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyDraft)
                    } else if uploadType == UploadType.EditProduct {
                        ProductUploadEdit.edit = false
                        self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyEdited)
                    } else {
                        self.success()
                    }
                } else {
                    self.showAlert(Constants.Localized.invalid, message: dictionary["message"] as! String)
                }
                uploaded = true
                println(response)
            }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                let data = NSJSONSerialization.dataWithJSONObject(error.userInfo!, options: nil, error: nil)
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
                println("error response: \(string)")
                if task.statusCode == 401 {
                    self.fireRefreshToken2()
                } else {
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        self.showAlert(Constants.Localized.error, message: errorModel.message)
                    } else {
                        self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                    }
                    self.tableView.reloadData()
                    uploaded = false
                }
                self.hud?.hide(true)
        }*/
        return uploaded
    }
    
    // MARK: -
    // MARK: - REST API request
    // MARK: GET METHOD - Fire Conditions
    /*
    *
    * (Parameters) - access_token
    *
    * Function to get product conditions
    *
    */
    func fireCondition() {
        self.conditions.removeAll(keepCapacity: true)
        self.showHUD()
        
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken()]
        
        WebServiceManager.fireGetProductUploadRequestWithUrl(APIAtlas.conditionUrl, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                let conditionParseModel: ConditionParserModel = ConditionParserModel.parseDataFromDictionary(responseObject as! NSDictionary)
                
                let uidKey = "productConditionId"
                let nameKey = "name"
                
                for dictionary in conditionParseModel.data as [NSDictionary] {
                    let condition: ConditionModel = ConditionModel(uid: dictionary[uidKey] as! Int, name: dictionary[nameKey] as! String)
                    self.conditions.append(condition)
                }
                
                let indexPath: NSIndexPath = NSIndexPath(forItem: 2, inSection: 2)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                self.productModel.condition = self.conditions[0]
                
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
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
        
        /*
        let manager: APIManager = APIManager.sharedInstance
        manager.GET(APIAtlas.conditionUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let conditionParseModel: ConditionParserModel = ConditionParserModel.parseDataFromDictionary(responseObject as! NSDictionary)
            
            let uidKey = "productConditionId"
            let nameKey = "name"
            
            if conditionParseModel.isSuccessful {
                for dictionary in conditionParseModel.data as [NSDictionary] {
                    let condition: ConditionModel = ConditionModel(uid: dictionary[uidKey] as! Int, name: dictionary[nameKey] as! String)
                    self.conditions.append(condition)
                }
                
                let indexPath: NSIndexPath = NSIndexPath(forItem: 2, inSection: 2)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
            
            self.productModel.condition = self.conditions[0]
            
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                } else {
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        self.showAlert(Constants.Localized.error, message: errorModel.message)
                    } else {
                        self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                    }
                }
                
                self.hud?.hide(true)
        })*/
    }
    
    // Dealloc
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
}