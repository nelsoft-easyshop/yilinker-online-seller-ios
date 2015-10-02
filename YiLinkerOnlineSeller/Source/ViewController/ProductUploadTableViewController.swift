//
//  ProductUploadTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/25/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

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
}

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
    
    
    static let uploadImagesKey = "images[]"
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
}

class ProductUploadTableViewController: UITableViewController, ProductUploadUploadImageTableViewCellDataSource, ProductUploadUploadImageTableViewCellDelegate, UzysAssetsPickerControllerDelegate, ProductUploadCategoryViewControllerDelegate, ProductUploadFooterViewDelegate, ProductUploadTextFieldTableViewCellDelegate, ProductUploadTextViewTableViewCellDelegate, ProductUploadPriceTableViewCellDelegate, ProductUploadDimensionsAndWeightTableViewCellDelegate, ProductUploadBrandViewControllerDelegate, ProductUploadQuantityTableViewCellDelegate, SuccessUploadViewControllerDelegate {
    
    var productModel: ProductModel = ProductModel()
    var sectionFourRows: Int = 2
    var sectionPriceHeaderHeight: CGFloat = 41
    var conditions: [ConditionModel] = []
    var hud: MBProgressHUD?
    var productUploadWeightAndHeightCellHeight: CGFloat = 244
    var dimensionsHeaderViewHeight: CGFloat = 41
    
    var uploadType: UploadType = UploadType.NewProduct
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton()
        self.title = Constants.ViewControllersTitleString.productUpload
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.register()
        self.addAddPhoto()
        self.footer()
        self.fireCondition()
        
        if self.uploadType == UploadType.EditProduct {
            self.updateCombinationListRow()
        }
    }
    
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
    
    func fireCondition() {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken()]
        
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
                
                self.hud?.hide(true)
        })
    }
    
    func gestureEndEditing() {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyBoard")
        self.tableView.userInteractionEnabled = true
        self.tableView.addGestureRecognizer(gesture)
    }
    
    func footer() {
        let footerView: ProductUploadFooterView = XibHelper.puffViewWithNibName("ProductUploadFooterView", index: 0) as! ProductUploadFooterView
        self.tableView.tableFooterView = footerView
        footerView.delegate = self
    }
    
    func hideKeyBoard() {
        self.tableView.endEditing(true)
    }
    
    func addAddPhoto() {
        self.productModel.images.append(UIImage(named: "addPhoto")!)
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
                return cell
            } else if indexPath.row == 1 {
                let cell: ProductUploadTextViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier) as! ProductUploadTextViewTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.textFieldType = ProductTextFieldType.ProductShortDescription
                cell.cellTitleLabel.text = ProductUploadStrings.shortDescription
                cell.cellTitleLabel.required()
                cell.productUploadTextView.text = self.productModel.shortDescription
                return cell
            } else if indexPath.row == 2 {
                let cell: ProductUploadTextViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier) as! ProductUploadTextViewTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.textFieldType = ProductTextFieldType.ProductCompleteDescription
                cell.cellTitleLabel.text = ProductUploadStrings.completeDescription
                cell.cellTitleLabel.required()
                cell.productUploadTextView.text = self.productModel.completeDescription
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
                
                return cell
            } else if indexPath.row == 1 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.cellTitleLabel.text = ProductUploadStrings.brand
                cell.cellTexField.placeholder = ProductUploadStrings.brand
                cell.delegate = self
                cell.cellTitleLabel.required()
                cell.cellTexField.text = self.productModel.brand.name
                cell.textFieldType = ProductTextFieldType.Brand
                if self.productModel.brand.name != "" {
                    cell.cellTexField.text = self.productModel.brand.name
                }
                
                cell.addTextFieldDelegate()
                
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
                    
                    cell.values = values
                    cell.addPicker()
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
                    return cell
                } else if indexPath.row == 1 {
                    let cell: ProductUploadQuantityTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadQuantityTableViewCellNibNameAndIdentifier) as! ProductUploadQuantityTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.delegate = self
                    cell.cellTextField.text = "\(self.productModel.quantity)"
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
                    
                    return cell
                } else {
                    let cell: ProductUploadButtonTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadButtonTableViewCellNibNameAndIdentifier) as! ProductUploadButtonTableViewCell
                    cell.cellButton.setTitle(ProductUploadStrings.addEdit, forState: UIControlState.Normal)
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.cellButton.addTarget(self, action: "addMoreDetails:", forControlEvents: UIControlEvents.TouchUpInside)
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
                cell.cellTextField.text = self.productModel.retailPrice
                return cell
            } else {
                let cell: ProductUploadPriceTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadPriceTableViewCellNibNameAndIdentifier) as! ProductUploadPriceTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.textFieldType = ProductTextFieldType.ProductDiscountPrice
                cell.cellTitleLabel.text = ProductUploadStrings.discountedPrice
                cell.cellTextField.placeholder = "0.00"
                cell.cellTextField.text = self.productModel.discoutedPrice
                return cell
            }
        } else {
            let cell: ProductUploadDimensionsAndWeightTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier) as! ProductUploadDimensionsAndWeightTableViewCell
            cell.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.weightTextField.text = self.productModel.weigth
            cell.lengthTextField.text = self.productModel.length
            cell.heightTextField.text = self.productModel.height
            cell.widthTextField.text = self.productModel.width
            
            if self.productModel.validCombinations.count != 0 {
                cell.hidden = true
            } else {
                cell.hidden = false
            }
            
            return cell
        }
    }
    
    func category() {
        let productUploadCategoryViewController: ProductUploadCategoryViewController = ProductUploadCategoryViewController(nibName: "ProductUploadCategoryViewController", bundle: nil)
        productUploadCategoryViewController.delegate = self
        productUploadCategoryViewController.pageTitle = ProductUploadStrings.selectCategory
        productUploadCategoryViewController.userType = UserType.Seller
        self.navigationController!.pushViewController(productUploadCategoryViewController, animated: true)
    }
    
    func brand() {
        let brandViewController: ProductUploadBrandViewController = ProductUploadBrandViewController(nibName: "ProductUploadBrandViewController", bundle: nil)
        brandViewController.delegate = self
        self.navigationController!.pushViewController(brandViewController, animated: true)
    }
    
    func productUploadBrandViewController(didSelectBrand brand: String, brandModel: BrandModel) {
        if brandModel.name != brand {
            self.productModel.brand = BrandModel(name: brand, brandId: 1)
        } else {
            self.productModel.brand = brandModel
        }
        
        let indexPath: NSIndexPath = NSIndexPath(forItem: 1, inSection: 2)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
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
        if self.productModel.name != "" {
            self.draft()
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }

    }
    
    //Upload Cell Datasource
    func productUploadUploadImageTableViewCell(numberOfCollectionViewRows cell: ProductUploadUploadImageTableViewCell) -> Int {
        return self.productModel.images.count
    }
    
    //Upload Delegate
    func productUploadUploadImageTableViewCell(didSelecteRowAtIndexPath indexPath: NSIndexPath, cell: ProductUploadUploadImageTableViewCell) {
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
    
    func productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath indexPath: NSIndexPath, collectionView: UICollectionView) {
        self.productModel.images.removeAtIndex(indexPath.row)
        collectionView.deleteItemsAtIndexPaths([indexPath])
    }
    
    func uzyConfig() -> UzysAppearanceConfig {
        let config: UzysAppearanceConfig = UzysAppearanceConfig()
        config.finishSelectionButtonColor = Constants.Colors.appTheme
        return config
    }
    
    func productUploadUploadImageTableViewCell(images cell: ProductUploadUploadImageTableViewCell) -> [UIImage] {
        return self.productModel.images
    }
    
    //UzzyPickerDelegate
    
    func uzysAssetsPickerController(picker: UzysAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        let assetsLibrary = ALAssetsLibrary()
        let alaSset: ALAsset = assets[0] as! ALAsset

        for allaSset in assets as! [ALAsset] {
            let image: UIImage = UIImage(CGImage: allaSset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())!
            self.productModel.images.insert(image, atIndex: 0)
        }
        
        self.reloadUploadCellCollectionViewData()
        self.tableView.reloadData()
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
        let lastIndexPath: NSIndexPath = NSIndexPath(forItem: self.productModel.images.count - 1, inSection: 0)
        cell.collectionView.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
    }
    
    func uzysAssetsPickerControllerDidCancel(picker: UzysAssetsPickerController!) {
        
    }
    
    func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker: UzysAssetsPickerController!) {
        
    }
    
    func replaceProductAttributeWithAttribute(attributes: [AttributeModel], combinations: [CombinationModel]) {
        self.productModel.attributes = attributes
        self.productModel.validCombinations = combinations
        self.updateCombinationListRow()
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
    
    func productUploadFooterView(didClickUpload view: ProductUploadFooterView) {
        if self.productModel.images.count == 1 {
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
    
    func productUploadTextViewTableViewCell(textFieldDidChange text: String, cell: ProductUploadTextViewTableViewCell, textFieldType: ProductTextFieldType) {
        if textFieldType == ProductTextFieldType.ProductShortDescription {
            self.productModel.shortDescription = text
        } else if textFieldType == ProductTextFieldType.ProductCompleteDescription {
            self.productModel.completeDescription = text
        }
    }
    
    func productUploadPriceTableViewCell(textFieldDidChange text: String, cell: ProductUploadPriceTableViewCell, textFieldType: ProductTextFieldType) {
        if textFieldType == ProductTextFieldType.ProductRetailPrice {
            self.productModel.retailPrice = text
        } else if textFieldType == ProductTextFieldType.ProductDiscountPrice {
            self.productModel.discoutedPrice = text
        }
    }
    
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
    
    func productUploadQuantityTableViewCell(textFieldDidChange text: String, cell: ProductUploadQuantityTableViewCell) {
        if let val = text.toInt() {
           self.productModel.quantity = text.toInt()!
            println(text.toInt())
        }
    }
    
     func didSelecteCategory(categoryModel: CategoryModel) {
        self.productModel.category = categoryModel
        let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 2)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    func fireUploadWithUploadType(uploadType: UploadType) {
        var datas: [NSData] = []
        
        var productUploadedImagesCount: Int = 0

        if self.productModel.images.count != 0 {
            self.productModel.images.removeLast()
        }

        let mainImageCount: Int = self.productModel.images.count
        
        var imagesKey: [String] = []
        
        for var x = 0; x < mainImageCount; x++ {
            imagesKey.append("\(x)")
        }
        
        for combination in self.productModel.validCombinations {
            for image in combination.images {
                self.productModel.images.append(image)
            }
        }
        
        for image in self.productModel.images as [UIImage] {
            let data: NSData = UIImageJPEGRepresentation(image, 1)
            datas.append(data)
        }
        
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
        ProductUploadTableViewControllerConstant.uploadImagesKey: imagesKey,
        "customBrand": customBrand,
        "isFreeShipping": false,
        "height": height,
        "width": width,
        "weight": weight,
        "length": length]
        
        if self.productModel.uid != "0" {
            parameters["productId"] = self.productModel.uid
        }
        
        let manager: APIManager = APIManager.sharedInstance
        
        self.showHUD()
        
        var url: String = ""
        
        if uploadType == UploadType.Draft {
            url = "\(APIAtlas.uploadDraftUrl)?access_token=\(SessionManager.accessToken())"
        } else if uploadType == UploadType.NewProduct {
            url = "\(APIAtlas.uploadUrl)?access_token=\(SessionManager.accessToken())"
        } else if uploadType == UploadType.EditProduct {
            url = "\(APIAtlas.uploadEditUrl)?access_token=\(SessionManager.accessToken())"
        }
        
        manager.POST(url, parameters: parameters, constructingBodyWithBlock: { (formData: AFMultipartFormData) -> Void in
            for (index, data) in enumerate(datas) {
                println("index: \(index)")
                formData.appendPartWithFileData(data, name: "images[]", fileName: "\(index)", mimeType: "image/jpeg")
            }
            
            }, success: { (NSURLSessionDataTask, response: AnyObject) -> Void in
                self.hud?.hide(true)
                let dictionary: NSDictionary = response as! NSDictionary
                
                if dictionary["isSuccessful"] as! Bool == true {
                    if uploadType == UploadType.Draft {
                        self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyDraft)
                    } else if uploadType == UploadType.EditProduct {
                        self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyEdited)
                    } else {
                        self.success()
                    }
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: dictionary["message"] as! String, title: Constants.Localized.serverError)
                }
                
                
                println(response)
        }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
            let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
            println(error.userInfo)
            if task.statusCode == 401 {
               self.fireRefreshToken2()
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
            }
            self.hud?.hide(true)
        }
    }
    
    func dismissControllerWithToastMessage(message: String) {
        self.navigationController?.view.makeToast(message)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func success() {
        let successViewController: SuccessUploadViewController = SuccessUploadViewController(nibName: "SuccessUploadViewController", bundle: nil)
        successViewController.delegate = self
        self.presentViewController(successViewController, animated: true, completion: nil)
    }
    
    func successUploadViewController(didTapDashBoard viewController: SuccessUploadViewController) {
        self.tableView.hidden = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func successUploadViewController(didTapUploadAgain viewController: SuccessUploadViewController) {
        for (index, images) in enumerate(self.productModel.images) {
            self.productModel.images.removeLast()
        }
        
        self.addAddPhoto()
        self.productModel = ProductModel()
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPointZero, animated: true)
    }
    
    func property(mainImageCount: Int) -> NSString {
        var array: [NSMutableDictionary] = []
        var counter: Int = mainImageCount
        for combination in self.productModel.validCombinations {
             let dictionary: NSMutableDictionary = NSMutableDictionary()
            dictionary["attribute"] = combination.attributes
            dictionary["price"] = (combination.retailPrice as NSString).doubleValue
            dictionary["discountedPrice"] = (combination.discountedPrice as NSString).doubleValue
            dictionary["quantity"] = combination.quantity.toInt()
            dictionary["sku"] = combination.sku
            
            var arrayNumber: [String] = []
            
            for (index, image) in enumerate(combination.images) {
                var x: Int = counter
                counter++
                arrayNumber.append("\(x)")
            }
            //dictionary["images"] = arrayNumber
            dictionary["images"] = "\(arrayNumber)"
            dictionary["unitWeight"] = (combination.weight as NSString).doubleValue
            dictionary["unitLength"] = (combination.length as NSString).doubleValue
            dictionary["unitWidth"] = (combination.width as NSString).doubleValue
            dictionary["unitHeight"] = (combination.height as NSString).doubleValue
            
            array.append(dictionary)
        }
       
        let data = NSJSONSerialization.dataWithJSONObject(array, options: nil, error: nil)
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        println(string)
        return string!
    }
    
    
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
                self.hud?.hide(true)
        })

    }
    
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
                self.hud?.hide(true)
        })
    }
    
    // Dealloc
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    
    // Mark: - Draft Alert 
    
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
}
