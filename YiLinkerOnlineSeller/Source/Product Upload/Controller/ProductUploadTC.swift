//
//  ProductUploadTC.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 4/18/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductUploadTC: UITableViewController, ProductUploadUploadImageTVCDataSource, ProductUploadUploadImageTVCDelegate, ProductUploadTextFieldTableViewCellDelegate, ProductUploadTextViewTableViewCellDelegate, ProductUploadDimensionsAndWeightTableViewCellDelegate, ProductUploadFooterViewDelegate, ProductUploadBrandViewControllerDelegate, UzysAssetsPickerControllerDelegate, ProductUploadProductGroupTVCDelegate {
    
    // Variables// Models
    var conditions: [ConditionModel] = []
    var shippingCategories: [ConditionModel] = []
    var productModel: ProductModel = ProductModel()
    var hud: MBProgressHUD?
    var uploadType: UploadType = UploadType.NewProduct
    
    // Product Information
    var productName: String = ""
    var productShortDescription: String = ""
    var productCompleteDescription: String = ""
    
    // Product Details
    var productCategory: String = ""
    var productShippingCategory: String = ""
    var productBrand: String = ""
    var productCondition: String = ""
    var productSKU: String = ""
    var productGroup: String = ""
    
    // Product Dimensions and Weight
    var productLength: String = ""
    var productWidth: String = ""
    var productHeight: String = ""
    var productWeight: String = ""
    
    var dimensionsHeaderViewHeight: CGFloat = 41
    var productUploadWeightAndHeightCellHeight: CGFloat = 244
    var sectionPriceHeaderHeight: CGFloat = 41
    var sectionFourRows: Int = 2
    var productGroupCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "Product Upload"
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        //self.tableView.addGestureRecognizer(tap)
        
        self.addFooter()
        self.addPhoto()
        self.backButton()
        self.registerNib()
        
        // API Call
        self.fireGetProductConditions()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 || section == 3 || section == 4 {
            return 1
        } else if section == 1 {
            return 3
        } else {
            return 6
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else if indexPath.section == 1 {
            //Product Information Section
            if indexPath.row == 0 {
                return ProductUploadTableViewControllerConstant.normalcellHeight
            } else if indexPath.row == 1 {
                return ProductUploadTableViewControllerConstant.normalTextViewCellHeight
            } else {
                return ProductUploadTableViewControllerConstant.completeDescriptionHeight
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 5 {
                if self.productModel.productGroups.count == 0 {
                    return 100
                } else {
                    let rowInitialHeight: CGFloat = 18
                    let rowHeight: CGFloat = 82
                    
                    let cellCount: Int = self.productModel.productGroups.count
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
                return 75
            }
        } else if indexPath.section == 3 {
            return 44
        } else {
            return 245
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: ProductUploadImageTVC = self.tableView.dequeueReusableCellWithIdentifier("ProductUploadImageTVC") as! ProductUploadImageTVC
            cell.productModel = self.productModel
            cell.dataSource = self
            cell.delegate = self
            cell.collectionView.reloadData()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = true
                
                cell.cellTitleLabel.text = ProductUploadStrings.productName
                cell.cellTexField.text = self.productName
                
                cell.cellTexField.placeholder = ProductUploadStrings.productName
                
                cell.cellTitleLabel.required()
                cell.textFieldType = ProductTextFieldType.ProductName
                cell.delegate = self
                
                return cell
            } else if indexPath.row == 1 {
                let cell: ProductUploadTextViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier) as! ProductUploadTextViewTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = true
                
                cell.cellTitleLabel.text = ProductUploadStrings.shortDescription
                cell.productUploadTextView.text = self.productModel.shortDescription
                
                cell.cellTitleLabel.required()
                cell.textFieldType = ProductTextFieldType.ProductShortDescription
                cell.delegate = self
                
                return cell
            } else {
                let cell: ProductUploadTextViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier) as! ProductUploadTextViewTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = true
                
                cell.cellTitleLabel.text = ProductUploadStrings.completeDescription
                cell.productUploadTextView.text = self.productCompleteDescription
                
                cell.cellTitleLabel.required()
                cell.textFieldType = ProductTextFieldType.ProductCompleteDescription
                cell.delegate = self
                
                return cell
            }
        }  else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = self.checkIfSeller()
                
                cell.cellTitleLabel.text = ProductUploadStrings.category
                cell.cellTexField.text = ProductUploadStrings.selectCategory
                
                cell.cellTexField.rightView = self.addRightView("cell-right")
                cell.cellTexField.rightViewMode = UITextFieldViewMode.Always
                
                cell.cellTitleLabel.required()
                cell.textFieldType = ProductTextFieldType.Category
                cell.delegate = self
                
                if self.productModel.category.name != "" {
                    cell.cellTexField.text = self.productModel.category.name
                }
                
                return cell
            } else if indexPath.row == 1 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = self.checkIfSeller()
                
                cell.cellTitleLabel.text = "Shipping Category"
                cell.cellTexField.text = "Select Shipping Category"
                
                cell.cellTexField.rightView = self.addRightView("cell-right")
                cell.cellTexField.rightViewMode = UITextFieldViewMode.Always
                
                cell.cellTitleLabel.required()
                cell.textFieldType = ProductTextFieldType.ShippingCategory
                cell.delegate = self
                
                if self.productModel.shippingCategories.name != "" {
                    cell.cellTexField.text = self.productModel.shippingCategories.name
                }
            
                return cell
            } else if indexPath.row == 2 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = self.checkIfSeller()
                
                cell.cellTitleLabel.text = ProductUploadStrings.brand
                cell.cellTexField.text = ProductUploadStrings.addBrand
                
                cell.cellTexField.rightView = self.addRightView("arrow_down")
                cell.cellTexField.rightViewMode = UITextFieldViewMode.Always
                
                cell.textFieldType = ProductTextFieldType.Brand
                cell.delegate = self
            
                if self.productModel.brand.name != "" {
                    cell.cellTexField.text = self.productModel.brand.name
                }
                
                //cell.addTextFieldDelegate()
                
                return cell
            } else if indexPath.row == 3 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = self.checkIfSeller()
                
                cell.cellTitleLabel.text = ProductUploadStrings.condition
                cell.cellTexField.text = self.productCondition
                
                cell.cellTexField.placeholder = ProductUploadStrings.condition
                
                cell.cellTexField.rightView = self.addRightView("arrow_down")
                cell.cellTexField.rightViewMode = UITextFieldViewMode.Always
                
                cell.cellTitleLabel.required()
                cell.textFieldType = ProductTextFieldType.Condition
                cell.delegate = self

                var values: [String] = []
                
                if self.conditions.count != 0 {
                    for condition in self.conditions as [ConditionModel] {
                        values.append(condition.name)
                    }
                    
                    if indexPath.row == 3 {
                        cell.values = values
                        cell.addPicker()
                    }
                }
                
                return cell
            } else if indexPath.row == 4 {
                let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = self.checkIfSeller()
                
                cell.cellTitleLabel.text = "SKU[Stock Keeping Unit]"
                cell.cellTexField.text = self.productSKU
                
                cell.cellTexField.placeholder = "SKU"
                
                cell.cellTitleLabel.required()
                cell.textFieldType = ProductTextFieldType.ProductSKU
                cell.delegate = self
                
                if self.productModel.sku != "" {
                    cell.cellTexField.text = self.productModel.sku
                }
                
                return cell
            } else {
                /*let cell: ProductUploadTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextfieldTableViewCellNibNameAndIdentifier) as! ProductUploadTextFieldTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = self.checkIfSeller()
               
                cell.cellTitleLabel.text = "Product Group"//ProductUploadStrings.condition
                cell.cellTexField.text = "Product Group" //self.productModel.condition.name
                
                cell.textFieldType = ProductTextFieldType.Condition
                cell.delegate = self
            
                return cell*/
                let cell: ProductUploadProductGroupTVC = self.tableView.dequeueReusableCellWithIdentifier("ProductUploadProductGroupTVC") as! ProductUploadProductGroupTVC
                var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "selectProductGroups")
                cell.addGestureRecognizer(tap)
                if self.productModel.productGroups.count != 0 {
                    println(productModel.productGroups.count)
                    cell.attributes.removeAll(keepCapacity: false)
                    for i in 0..<self.productModel.productGroups.count {
                        cell.attributes.append(self.productModel.productGroups[i].name)
                    }
                } else {
                   cell.attributes.removeAll(keepCapacity: false)
                }
                cell.collectionView.reloadData()
                println(cell.frame)
                //cell.parentViewController = self.parentViewController
                cell.productModel = self.productModel
                cell.delegate = self
                
                return cell
            }
        } else if indexPath.section == 3 {
            let cell: ProductUploadButtonTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadButtonTableViewCellNibNameAndIdentifier) as! ProductUploadButtonTableViewCell
            cell.userInteractionEnabled = self.checkIfSeller()
            
            // TODO: Add delegate to button and add action to delegate methods
            cell.cellButton.setTitle("ADD MORE DETAILS ", forState: UIControlState.Normal)
            cell.cellButton.addTarget(self, action: "addMoreDetails:", forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        } else {
            let cell: ProductUploadDimensionsAndWeightTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadDimensionsAndWeightTableViewCellNibNameAndIdentifier) as! ProductUploadDimensionsAndWeightTableViewCell
            cell.delegate = self
           
            // TODO: Add delegate to textfields and add action to delegate methods
            cell.addTextFieldDelegate()
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ProductUploadTableHeaderView = XibHelper.puffViewWithNibName("ProductUploadTableHeaderView", index: 0) as! ProductUploadTableHeaderView
        
        if section == 1 {
            headerView.headerTitleLabel.text = ProductUploadStrings.productInformation
        } else if section == 2 {
            headerView.headerTitleLabel.text = ProductUploadStrings.productDetails
        } else if section == 3 {
            headerView.headerTitleLabel.text = ProductUploadStrings.dimensionsAndWeight //ProductUploadStrings.price
        } else if section == 4 {
            headerView.headerTitleLabel.text = ProductUploadStrings.dimensionsAndWeight //ProductUploadStrings.price
        } else if section == 5 {
            headerView.headerTitleLabel.text = ProductUploadStrings.dimensionsAndWeight
        }
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var sectionHeight: CGFloat = 0
        
        if section == 0 || section == 3 {
            sectionHeight = 0
        } else if section == 4 {
            return 41
        } else {
            sectionHeight = 41
        }
        return sectionHeight
    }
    
    // MARK: -
    // MARK: - Local Methods
    // MARK: - Add table view footer
    
    func addFooter() {
        let footerView: ProductUploadFooterView = XibHelper.puffViewWithNibName("ProductUploadFooterView", index: 0) as! ProductUploadFooterView
        self.tableView.tableFooterView = footerView
        footerView.delegate = self
    }
    
    // MARK: -
    // MARK: - Add More Details
    
    func addMoreDetails(sender: UIButton) {
        let productUploadAttributeListTableViewController: ProductUploadAttributeListVC = ProductUploadAttributeListVC(nibName: "ProductUploadAttributeListVC", bundle: nil)
        productUploadAttributeListTableViewController.productModel = self.productModel.copy()
        self.navigationController!.pushViewController(productUploadAttributeListTableViewController, animated: true)
    }
    
    // MARK: -
    // MARK: - Append dummy photo
    func addPhoto() {
        if self.uploadType == UploadType.EditProduct {
            let image: UIImage = UIImage(named: "addPhoto")!
            let serverImage: ServerUIImage  = ServerUIImage(data: UIImagePNGRepresentation(image)!)!
            self.productModel.editedImage.append(serverImage)
        } else {
            self.productModel.images.append(UIImage(named: "addPhoto")!)
        }
    }
    
    // MARK: -
    // MARK: - Add right view in textfield
    
    func addRightView(image: String) -> UIImageView {
        let arrow = UIImageView(image: UIImage(named: image))
        arrow.frame = CGRectMake(0.0, 0.0, arrow.image!.size.width+10.0, arrow.image!.size.height)
        arrow.contentMode = UIViewContentMode.Center
        
        return arrow
    }
    
    // MARK: -
    // MARK: - Navigation bar: Add Back Button in navigation bar
    
    func backButton() {
        //ProductCroppedImages.imagesCropped.removeAll(keepCapacity: false)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "back")
        customBackButton.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    // MARK: -
    // MARK: - Navigation bar back button action
    
    func back() {
        /*
        if self.productModel.name != "" {
            if ProductUploadCombination.draft {
                self.draft()
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }*/
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: -
    // MARK: - Product Brand
    
    func brand() {
        let brandViewController: ProductUploadBrandViewController = ProductUploadBrandViewController(nibName: "ProductUploadBrandViewController", bundle: nil)
        brandViewController.delegate = self
        self.navigationController!.pushViewController(brandViewController, animated: true)
    }
    
    // MARK: -
    // MARK: - Product Category
    
    func category() {
        let productUploadCategoryViewController: ProductUploadCategoryViewController = ProductUploadCategoryViewController(nibName: "ProductUploadCategoryViewController", bundle: nil)
        productUploadCategoryViewController.pageTitle = ProductUploadStrings.selectCategory
        productUploadCategoryViewController.userType = UserType.Seller
        productUploadCategoryViewController.productCategory = UploadProduct.ProductCategory
        self.navigationController!.pushViewController(productUploadCategoryViewController, animated: true)
    }
    
    // MARK: - 
    // MARK: Check if seller
    
    func checkIfSeller() -> Bool {
        if SessionManager.isSeller() {
            return true
        } else {
            return false
        }
    }
    
    // MARK: -
    // MARK: - Hide keyboard
    
    func hideKeyboard() {
        self.tableView.endEditing(true)
    }
    
    // MARK: -
    // MARK: - Register table view cells
    
    func registerNib() {
        let nib: UINib = UINib(nibName: "ProductUploadImageTVC", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "ProductUploadImageTVC")
        
        let nibTextField: UINib = UINib(nibName: "ProductUploadTextFieldTableViewCell", bundle: nil)
        self.tableView.registerNib(nibTextField, forCellReuseIdentifier: "ProductUploadTextFieldTableViewCell")
       
        let nibTextView: UINib = UINib(nibName: "ProductUploadTextViewTableViewCell", bundle: nil)
        self.tableView.registerNib(nibTextView, forCellReuseIdentifier: "ProductUploadTextViewTableViewCell")
        
        let nibAddDetails: UINib = UINib(nibName: "ProductUploadButtonTableViewCell", bundle: nil)
        self.tableView.registerNib(nibAddDetails, forCellReuseIdentifier: "ProductUploadButtonTableViewCell")
        
        let nibDimensions: UINib = UINib(nibName: "ProductUploadDimensionsAndWeightTableViewCell", bundle: nil)
        self.tableView.registerNib(nibDimensions, forCellReuseIdentifier: "ProductUploadDimensionsAndWeightTableViewCell")
        
        let nibProductGroup: UINib = UINib(nibName: ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nibProductGroup, forCellReuseIdentifier: ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier)
        
        let nib4: UINib = UINib(nibName: "ProductUploadProductGroupTVC", bundle: nil)
        self.tableView.registerNib(nib4, forCellReuseIdentifier: "ProductUploadProductGroupTVC")
    }
    
    // MARK: -
    // MARK: - Reload Tableview row in section 
    
    func reloadTableViewRowInSection(section: Int, row: Int) {
        let indexPath: NSIndexPath = NSIndexPath(forItem: row, inSection: section)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    // MARK: -
    // MARK: - Reupload Cell Collection View Data
    
    func reloadUploadCellCollectionViewData() {
        let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        let cell: ProductUploadImageTVC = self.tableView.cellForRowAtIndexPath(indexPath) as! ProductUploadImageTVC
        cell.collectionView.reloadData()
        
        var lastIndexPath: NSIndexPath = NSIndexPath()
        
        if self.uploadType == UploadType.EditProduct {
            lastIndexPath = NSIndexPath(forItem: self.productModel.editedImage.count - 1, inSection: 0)
        } else {
            lastIndexPath = NSIndexPath(forItem: self.productModel.images.count - 1, inSection: 0)
        }
        
        cell.collectionView.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
    }
    
    // MARK: -
    // MARK: - Replace Product Attribute With Attribute
    
    func replaceProductAttributeWithAttribute(attributes: [AttributeModel], combinations: [CombinationModel]) {
        self.productModel.attributes = attributes
        self.productModel.validCombinations = combinations
        self.updateCombinationListRow()
    }
    
    // MARK: -
    // MARK: - Selected Category
    
    func selectedCategory(categoryModel: CategoryModel) {
        self.productCategory = categoryModel.name
        self.productModel.category = categoryModel
        self.reloadTableViewRowInSection(2, row: 0)
    }
    
    // MARK: -
    // MARK: - Selected Category
    
    func selectedShippingCategory(shippingCategory: ConditionModel) {
        self.productShippingCategory = shippingCategory.name
        self.productModel.shippingCategories = shippingCategory
        self.reloadTableViewRowInSection(2, row: 1)
    }
    
    func selectedProductGroup(productGroups: [ConditionModel]) {
        self.productModel.productGroups = productGroups
        self.reloadTableViewRowInSection(2, row: 5)
    }
    
    func selectProductGroups() {
        println("Product groups")
        let productUploadCategoryViewController: ProductUploadCategoryViewController = ProductUploadCategoryViewController(nibName: "ProductUploadCategoryViewController", bundle: nil)
        productUploadCategoryViewController.pageTitle = ProductUploadStrings.selectCategory
        productUploadCategoryViewController.userType = UserType.Seller
        productUploadCategoryViewController.productCategory = UploadProduct.ProductGroups
        productUploadCategoryViewController.selectedProductGroups = self.productModel.productGroups
        self.navigationController!.pushViewController(productUploadCategoryViewController, animated: true)
    }
    
    // MARK: -
    // MARK: - Product Shipping Category
    // TODO: - Add/Reuse controller to select Product Shipping Category
    
    func selectedShippingCategory() {
        let productUploadCategoryViewController: ProductUploadCategoryViewController = ProductUploadCategoryViewController(nibName: "ProductUploadCategoryViewController", bundle: nil)
        productUploadCategoryViewController.pageTitle = ProductUploadStrings.selectCategory
        productUploadCategoryViewController.userType = UserType.Seller
        productUploadCategoryViewController.productCategory = UploadProduct.ShippingCategory
        self.navigationController!.pushViewController(productUploadCategoryViewController, animated: true)
    }
    
    // MARK: -
    // MARK: - Alert view
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
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
    
    // MARK: - Update Combination List Row
    func updateCombinationListRow() {
        if self.productModel.validCombinations.count == 0 {
            self.sectionFourRows = 2
            self.productUploadWeightAndHeightCellHeight = 245
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
    
    // MARK: -
    // MARK: - Delegate Methods
    // MARK: - Product Upload Upload Image Table View Cell Delegate method
    
    func productUploadUploadImageTableViewCell(numberOfCollectionViewRows cell: ProductUploadImageTVC) -> Int {
        if self.uploadType == UploadType.EditProduct {
            return self.productModel.editedImage.count
        } else {
            return self.productModel.images.count
        }
    }
    
    // MARK: -
    // MARK: - Upload Delegate
    
    func productUploadUploadImageTableViewCell(didSelecteRowAtIndexPath indexPath: NSIndexPath, cell: ProductUploadImageTVC) {
        println("tap image")
        
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
        
        /*if self.uploadType == UploadType.EditProduct {
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
        }*/
    }
    
    // MARK: -
    // MARK: - Product Upload Upload Image Table View Cell Delegate method
    
    func productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath indexPath: NSIndexPath, collectionView: UICollectionView) {
        /*if self.uploadType == UploadType.EditProduct {
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
        collectionView.deleteItemsAtIndexPaths([indexPath])*/
    }
    
    // MARK: -
    // MARK: - ProductUploadImageCollectionViewCell Delegate Method
    
    func productUploadUploadImageTableViewCell(didTapStarAtRowIndexPath indexPath: NSIndexPath, cell: ProductUploadImageCollectionViewCell, collectionView: UICollectionView) {
        collectionView.reloadData()
    }
    
    // MARK: -
    // MARK: - ProductUploadImageTVC Delegate Method
    
    func productUploadUploadImageTableViewCell(images cell: ProductUploadImageTVC) -> [UIImage] {
        
        if self.uploadType == UploadType.EditProduct {
            return self.productModel.editedImage
        } else {
            return self.productModel.images
        }
    }
    
    // MARK: -
    // MARK: - ProductUploadTextFieldTableViewCell Delegate Methods
    
    func productUploadTextFieldTableViewCell(textFieldDidChange text: String, cell: ProductUploadTextFieldTableViewCell, textFieldType: ProductTextFieldType) {
        if textFieldType ==  ProductTextFieldType.ProductName {
            self.productName  = text
            self.productModel.name = self.productName
        } else if textFieldType ==  ProductTextFieldType.Category {
            self.category()
        } else if textFieldType ==  ProductTextFieldType.Brand {
            self.brand()
        } else if textFieldType ==  ProductTextFieldType.ShippingCategory {
            self.selectedShippingCategory()
        } else if textFieldType ==  ProductTextFieldType.Condition {
            self.productCondition = text
            self.productModel.condition.name = self.productCondition
        } else if textFieldType ==  ProductTextFieldType.ProductSKU {
            self.productSKU = text
            self.productModel.sku = self.productSKU
        }
    }
    
    func productUploadTextViewTableViewCell(textFieldDidChange text: String, cell: ProductUploadTextViewTableViewCell, textFieldType: ProductTextFieldType) {
        
        if textFieldType ==  ProductTextFieldType.ProductShortDescription {
            self.productShortDescription = text
            self.productModel.shortDescription = self.productShortDescription
        } else if textFieldType ==  ProductTextFieldType.ProductCompleteDescription {
            self.productCompleteDescription = text
            self.productModel.completeDescription = self.productCompleteDescription
        }
    }
    
    // MARK: -
    // MARK: - ProductUploadDimensionsAndWeightTableViewCell Delegate Method
    // TODO: - Save values from the textfields in variables
    
    func productUploadDimensionsAndWeightTableViewCell(textFieldDidChange textField: UITextField, text: String, cell: ProductUploadDimensionsAndWeightTableViewCell) {
        
        if textField == cell.lengthTextField {
            self.productLength = text
            self.productModel.length = self.productLength
        } else if textField == cell.weightTextField {
            self.productWeight = text
            self.productModel.weigth = self.productWeight
        } else if textField == cell.widthTextField {
            self.productWidth = text
            self.productModel.width = self.productWidth
        } else {
            self.productHeight = text
            self.productModel.height = self.productHeight
        }
    }
    
    // MARK: - 
    // MARK: - ProductUploadFooterView Delegate Method
    // TODO: - Add action to upload product details
    
    func productUploadFooterView(didClickUpload view: ProductUploadFooterView) {
        
    }
    
    // MARK: -
    // MARK: - ProductUploadBrandViewController Delegate Method
    // TODO: - Store brand in a variable
    
    func productUploadBrandViewController(didSelectBrand brand: String, brandModel: BrandModel) {
        
        self.productBrand = brand
        self.productModel.brand.name = self.productBrand
        self.reloadTableViewRowInSection(2, row: 2)
    }
    
    // MARK: -
    // MARK: - ProductUploadProductGroupTVC Delegate Method
    
    func productUploadProductGroupTVC(didTapCell cell: ProductUploadProductGroupTVC, indexPath: NSIndexPath) {
        self.productModel.productGroups.removeAtIndex(indexPath.row)
        self.reloadTableViewRowInSection(2, row: 5)
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
                println(self.productModel.images.count - 1)
                self.productModel.isPrimaryPhoto.append(false)
                /*let storyboard = UIStoryboard(name: "FaImagePicker", bundle: nil)
                
                let faImagePicker = storyboard.instantiateViewControllerWithIdentifier("FaCropper") as! CropAssetViewController!
                faImagePicker.image = image
                faImagePicker.imageCount = ProductCroppedImages.imagesCropped.count - 1
                //faImagePicker.imagePickerDelegate = self
                faImagePicker.edgesForExtendedLayout = .None
                self.navigationController!.pushViewController(faImagePicker, animated: true)
                */
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
    
    // MARK: -
    // MARK: - REST API request
    // MARK: - GET METHOD: Fire Get Product Conditions
    /*
    *
    * (Parameters) - access_token
    *
    * Function to get product conditions
    *
    */
    
    func fireGetProductConditions() {
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
                    self.fireRefreshToken(UploadProduct.ProductConditions)
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
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            if uploadProduct == UploadProduct.ProductConditions {
                self.fireGetProductConditions()
            }
            
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}
