//
//  ProductUploadTC.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 4/18/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class ProductUploadTC: UITableViewController, ProductUploadUploadImageTVCDataSource, ProductUploadUploadImageTVCDelegate, ProductUploadTextFieldTableViewCellDelegate, ProductUploadTextViewTableViewCellDelegate, ProductUploadDimensionsAndWeightTableViewCellDelegate, ProductUploadFooterViewDelegate, ProductUploadBrandViewControllerDelegate, UzysAssetsPickerControllerDelegate, ProductUploadProductGroupTVCDelegate, ProductUploadQuantityTableViewCellDelegate, SuccessUploadViewControllerDelegate {
    
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
    var primaryPhoto: String = ""
    var productImagesName: [String] = []
    var productImages: String = ""
    var productImagesCount: Int = 0
    var productIsDraft: Bool = false
    var cellImage: ProductUploadImageTVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if self.uploadType == UploadType.EditProduct {
            self.title = "Edit Product"
        } else {
            self.title = "Product Upload"
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        //self.tableView.addGestureRecognizer(tap)
        
        self.addFooter()
        self.addPhoto()
        self.backButton()
        self.registerNib()
        
        ProductUploadImageTVCConstant.uploadImages.removeAll(keepCapacity: false)
        // API Call
        self.fireGetProductConditions()
        
        // Primary Photo
        if self.productModel.isPrimaryPhoto.count != 0 {
            for (index, isPrimary) in enumerate(self.productModel.isPrimaryPhoto) {
                if isPrimary {
                    self.primaryPhoto = "\(index)"
                }
            }
        }
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
        if section == 0 || section == 4 {
            return 1
        } else if section == 1 {
            return 3
        } else if section == 3 {
            if self.productModel.validCombinations.count == 0 {
                return 1
            } else {
                return self.productModel.validCombinations.count + 1
            }
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
            if self.productModel.validCombinations.count != 0 {
                return 0
            } else {
                return 245
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: ProductUploadImageTVC = self.tableView.dequeueReusableCellWithIdentifier("ProductUploadImageTVC") as! ProductUploadImageTVC
            self.cellImage = cell
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
                cell.cellTexField.text = self.productModel.name
                
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
                
                if self.productModel.shortDescription != "" {
                    cell.productUploadTextView.text = self.productModel.shortDescription
                }
                
                cell.cellTitleLabel.required()
                cell.textFieldType = ProductTextFieldType.ProductShortDescription
                cell.delegate = self
                
                return cell
            } else {
                let cell: ProductUploadTextViewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadTextViewTableViewCellNibNameAndIdentifier) as! ProductUploadTextViewTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.userInteractionEnabled = true
                
                cell.cellTitleLabel.text = ProductUploadStrings.completeDescription
                
                if self.productModel.completeDescription != "" {
                    cell.productUploadTextView.text = self.productModel.completeDescription
                }
                
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
            
            if self.productModel.validCombinations.count == 0 {
                //if indexPath.row == 0 {
                    let cell: ProductUploadButtonTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadButtonTableViewCellNibNameAndIdentifier) as! ProductUploadButtonTableViewCell
                    cell.userInteractionEnabled = self.checkIfSeller()
                    
                    // TODO: Add delegate to button and add action to delegate methods
                    cell.cellButton.setTitle("ADD MORE DETAILS ", forState: UIControlState.Normal)
                    cell.cellButton.addTarget(self, action: "addMoreDetails:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    return cell
               // }
            } else {
                let totalQuantityCell: Int = 1
                if indexPath.row != self.productModel.validCombinations.count {
                    let cell: ProductUploadAttributeSummaryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadAttributeSummaryTableVieCellNibNameAndIdentifier) as! ProductUploadAttributeSummaryTableViewCell
                    
                    if indexPath.row < self.productModel.validCombinations.count {
                        let combination: CombinationModel = self.productModel.validCombinations[indexPath.row]
                        
                        cell.cellQuantityLabel.text = "" //"x" + combination.quantity
                        
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
                    }
                    
                    cell.userInteractionEnabled = self.checkIfSeller()
                   
                    return cell
                } else {
                    let cell: ProductUploadButtonTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadTableViewControllerConstant.productUploadButtonTableViewCellNibNameAndIdentifier) as! ProductUploadButtonTableViewCell
                    cell.userInteractionEnabled = self.checkIfSeller()
                    
                    // TODO: Add delegate to button and add action to delegate methods
                    cell.cellButton.setTitle("ADD MORE DETAILS ", forState: UIControlState.Normal)
                    cell.cellButton.addTarget(self, action: "addMoreDetails:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    return cell
                }
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
            
            cell.userInteractionEnabled = self.checkIfSeller()
            
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
        productUploadAttributeListTableViewController.productModel = self.productModel
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
        self.productIsDraft = true
        
        if self.productModel.name != "" {
            self.draftModal()
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
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
    
    // MARK: - Draft Alert
    func draftModal() {
        let alertController = UIAlertController(title: ProductUploadStrings.uploadItem, message: ProductUploadStrings.saveAsDraft, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: Constants.Localized.no, style: .Cancel) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: Constants.Localized.yes, style: .Default) { (action) in
             self.fireUploadProduct()
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
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
        
        let quantityNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadQuantityTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(quantityNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadQuantityTableViewCellNibNameAndIdentifier)
        
        let attributeNib: UINib = UINib(nibName: ProductUploadTableViewControllerConstant.productUploadAttributeSummaryTableVieCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(attributeNib, forCellReuseIdentifier: ProductUploadTableViewControllerConstant.productUploadAttributeSummaryTableVieCellNibNameAndIdentifier)
    }
    
    // MARK: - Call SuccessViewController
    func success() {
        let successViewController: SuccessUploadViewController = SuccessUploadViewController(nibName: "SuccessUploadViewController", bundle: nil)
        successViewController.delegate = self
        self.presentViewController(successViewController, animated: true, completion: nil)
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
        //let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        //let cell: ProductUploadImageTVC = self.tableView.cellForRowAtIndexPath(indexPath) as! ProductUploadImageTVC
        self.cellImage!.productModel = self.productModel
        self.cellImage!.collectionView.reloadData()
        
        var lastIndexPath: NSIndexPath = NSIndexPath()
        
        if self.uploadType == UploadType.EditProduct {
            lastIndexPath = NSIndexPath(forItem: self.productModel.editedImage.count - 1, inSection: 0)
        } else {
            lastIndexPath = NSIndexPath(forItem: self.productModel.images.count - 1, inSection: 0)
        }
        
        self.cellImage!.collectionView.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
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
    
    func updateModelUnsuccessfulUpload() {
        for i in 0..<self.productModel.productMainImagesModel.count {
            var productMainImagesModel: ProductMainImagesModel?
            if self.productModel.productMainImagesModel[i].imageStatus == true && self.productModel.productMainImagesModel[i].imageFailed == false {
                productMainImagesModel = ProductMainImagesModel(image: self.productModel.productMainImagesModel[i].image, imageName: self.productModel.productMainImagesModel[i].imageName, imageStatus: true, imageFailed: false)
            } else if self.productModel.productMainImagesModel[i].imageStatus == false && self.productModel.productMainImagesModel[i].imageFailed == false {
                productMainImagesModel = ProductMainImagesModel(image: self.productModel.productMainImagesModel[i].image, imageName: self.productModel.productMainImagesModel[i].imageName, imageStatus: false, imageFailed: true)
            } else if self.productModel.productMainImagesModel[i].imageStatus == false && self.productModel.productMainImagesModel[i].imageFailed == true {
                productMainImagesModel = ProductMainImagesModel(image: self.productModel.productMainImagesModel[i].image, imageName: self.productModel.productMainImagesModel[i].imageName, imageStatus: false, imageFailed: true)
            }
            self.productModel.productMainImagesModel[i] = productMainImagesModel!
        }
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
        if self.uploadType == UploadType.NewProduct {
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
        } else {
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
        }
    }
    
    // MARK: -
    // MARK: - Product Upload Upload Image Table View Cell Delegate method
    // TODO: - Fixed error deleting unsuccessful upload. Index out of bound
    func productUploadUploadImageTableViewCell(didDeleteAtRowIndexPath indexPath: NSIndexPath, cell: ProductUploadImageTVC, collectionView: UICollectionView) {
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
        //ProductUploadImageTVCConstant.uploadImages.removeAtIndex(indexPath.row)
        self.productModel.mainImagesName[indexPath.row] = ""
        self.productModel.productMainImagesModel.removeAtIndex(indexPath.row)
        
        if self.uploadType == UploadType.NewProduct {
            self.productModel.images.removeAtIndex(indexPath.row)
        } else {
            self.productModel.editedImage.removeAtIndex(indexPath.row)
            if self.primaryPhoto == "\(indexPath.row)" {
                self.primaryPhoto = ""
                self.productModel.isPrimaryPhoto.removeAtIndex(indexPath.row)
                cell.selectedPrimaryPhoto = []
            }
        }
        
        collectionView.deleteItemsAtIndexPaths([indexPath])
        cell.productModel?.isPrimaryPhoto = self.productModel.isPrimaryPhoto
        collectionView.reloadData()
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    // MARK: -
    // MARK: - ProductUploadImageCollectionViewCell Delegate Method
    
    func productUploadUploadImageTableViewCell(didTapStarAtRowIndexPath indexPath: NSIndexPath, cell: ProductUploadImageCollectionViewCell, collectionView: UICollectionView, primaryPhoto: String) {
        println("primary photo: \(primaryPhoto)")
        self.primaryPhoto = primaryPhoto
        collectionView.reloadData()
    }
    
    func productUploadUploadImageTableViewCell(didTapReuploadAtRowIndexPath indexPath: NSIndexPath, cell: ProductUploadImageCollectionViewCell, collectionView: UICollectionView) {
        self.fireUploadProductMainImages(self.productModel.productMainImagesModel[indexPath.row].image)
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
        //self.getProductGroups()
        //self.getProductAttributes()
        //self.getMainImages()
        self.productIsDraft = false
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
        } else if self.productModel.shippingCategories.uid == -1 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.shippingCategoryRequired, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.condition == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.conditionRequired, title: ProductUploadStrings.incompleteProductDetails)
        }  else if self.productModel.sku == "" && self.productModel.validCombinations.count == 0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.skuRequried, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.length == "" && self.productModel.validCombinations.count == 0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.lengthRequried, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.weigth == "" && self.productModel.validCombinations.count == 0  {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.weightRequried, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.width == "" && self.productModel.validCombinations.count == 0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.widthRequried, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.productModel.height == "" && self.productModel.validCombinations.count == 0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: ProductUploadStrings.heightRequried, title: ProductUploadStrings.incompleteProductDetails)
        } else if self.primaryPhoto == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Please select a primary image.", title: ProductUploadStrings.incompleteProductDetails)
        } else {
            self.fireUploadProduct()
        }
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
    
    // MARK: -
    // MARK: - Quantity Table View Cell Delegate Method
    
    func productUploadQuantityTableViewCell(textFieldDidChange text: String, cell: ProductUploadQuantityTableViewCell) {
        if let val = text.toInt() {
            self.productModel.quantity = text.toInt()!
        }
    }
    
    // MARK: -
    // MARK: - Success Upload View Controller Delegate method
    
    func successUploadViewController(didTapDashBoard viewController: SuccessUploadViewController) {
        self.tableView.hidden = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func successUploadViewController(didTapUploadAgain viewController: SuccessUploadViewController) {
        for (index, images) in enumerate(self.productModel.images) {
            self.productModel.images.removeLast()
        }
        
        self.productModel = ProductModel()
        self.addPhoto()
        self.fireGetProductConditions()
        self.tableView.reloadData()
        self.updateCombinationListRow()
        self.tableView.setContentOffset(CGPointZero, animated: true)
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
                
                self.productModel.isPrimaryPhoto.append(false)
                self.productModel.mainImagesName.append("")
                var productMainImagesModel: ProductMainImagesModel = ProductMainImagesModel(image: image, imageName: "", imageStatus: false, imageFailed: false)
                
                if self.productModel.productMainImagesModel.count == 0 {
                    self.productModel.productMainImagesModel.append(productMainImagesModel)
                } else {
                    self.productModel.productMainImagesModel.insert(productMainImagesModel, atIndex: self.productModel.productMainImagesModel.count)
                }
                
            } else {
                // Insert iamges in 'productModel' array of images
                // Call CropAssetViewController to crop images
                let representation: ALAssetRepresentation = allaSset.defaultRepresentation()
                let image: UIImage = UIImage(CGImage: allaSset.defaultRepresentation().fullScreenImage().takeUnretainedValue(), scale: 1.0, orientation: UIImageOrientation.Up)!
                
                self.productModel.images.insert(image, atIndex: self.productModel.images.count - 1)
                self.productModel.isPrimaryPhoto.append(false)
                var productMainImagesModel: ProductMainImagesModel = ProductMainImagesModel(image: image, imageName: "", imageStatus: false, imageFailed: false)
                
                if self.productModel.productMainImagesModel.count == 0 {
                    self.productModel.productMainImagesModel.append(productMainImagesModel)
                } else {
                    self.productModel.productMainImagesModel.insert(productMainImagesModel, atIndex: self.productModel.productMainImagesModel.count)
                }
                
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
        self.productImagesName.removeAll(keepCapacity: false)
        self.getMainImages()
        
        //self.tableView.reloadData()
        //self.reloadTable()
    }
    
    // MARK: - Uzy Delegate
    func uzysAssetsPickerControllerDidCancel(picker: UzysAssetsPickerController!) {
        
    }
    
    func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker: UzysAssetsPickerController!) {
        
    }
    
    func getMainImages() {
        var data: [NSData] = []
        
        var uploadedImages: [UIImage] = []
        
        // Main Images
        for images in self.productModel.images {
            uploadedImages.append(images)
        }
        
        for images in self.productModel.editedImage {
            uploadedImages.append(images)
        }
        
        if uploadedImages.count != 0 {
            uploadedImages.removeLast()
        }
        
        // Attributes Images
        /*for combination in self.productModel.validCombinations {
            if self.uploadType == UploadType.NewProduct {
                for image in combination.images {
                    uploadedImages.append(image)
                }
            }
        }*/

        self.productImagesCount = 0
        self.fireUploadProductMainImages(uploadedImages[self.productImagesCount])
    }
    
    func getProductGroups() -> String {
        var productGroups: [String] = []
       
        for i in 0..<self.productModel.productGroups.count {
            productGroups.append("\(self.productModel.productGroups[i].name)")
        }

        let data = NSJSONSerialization.dataWithJSONObject(productGroups, options: nil, error: nil)
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        return string as! String
        
    }
    
    func getProductImages(count: Int) -> String {
        var productImages: [NSMutableDictionary] = []
        
        for i in 0..<count-1 {
            var imageStatus: Bool = self.productModel.productMainImagesModel[i].imageStatus
            if imageStatus {
                var dictionary: NSMutableDictionary = NSMutableDictionary()
                dictionary["name"] = self.productModel.productMainImagesModel[i].imageName
                if self.primaryPhoto == "\(i)" {
                    dictionary["isPrimary"] = true
                } else {
                    dictionary["isPrimary"] = false
                }
                productImages.append(dictionary)
            }
        }
        
        return self.formatToJson(productImages)
    }
    
    // MARK: - Property
    // Return a formatted string containing dictionary of combinations with values and keys
    func getProductAttributes() -> String {
        var productAttributes: [NSMutableDictionary] = []
        
        for combination in self.productModel.validCombinations {
            let dictionary: NSMutableDictionary = NSMutableDictionary()
            dictionary["attributes"] = combination.attributes
            dictionary["sku"] = combination.sku
            
            var imageNames: [NSMutableDictionary] = []
            
            for (index, image) in enumerate(combination.images) {
                //var x: Int = counter
                var imageDictionary: NSMutableDictionary = ["name" : combination.imagesId[index]]
                imageNames.append(imageDictionary)
            }
            
            for (index, image) in enumerate(combination.editedImages) {
                //var x: Int = counter
                for (index2, mainImage) in enumerate(self.productModel.editedImage) {
                    if mainImage.uid == image.uid {
                        var imageDictionary: NSMutableDictionary = ["name" : combination.imagesId[index]]
                        if !contains(imageNames, imageDictionary) {
                            imageNames.append(imageDictionary)
                        }
                    }
                }
            }
            
            dictionary["images"] = imageNames
            dictionary["weight"] = (combination.weight as NSString).doubleValue
            dictionary["length"] = (combination.length as NSString).doubleValue
            dictionary["width"] = (combination.width as NSString).doubleValue
            dictionary["height"] = (combination.height as NSString).doubleValue
            dictionary["isActive"] = combination.isAvailable
            
            if self.uploadType == UploadType.EditProduct || self.uploadType == UploadType.Draft {
                dictionary["productUnitId"] = combination.productUnitId
            }
            
            productAttributes.append(dictionary)
        }

        return self.formatToJson(productAttributes)
    }
    
    func formatToJson(dictionary: [NSMutableDictionary]) -> String {
        let data = NSJSONSerialization.dataWithJSONObject(dictionary, options: nil, error: nil)
        let string: String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        let finalJsonString: String = string.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return finalJsonString
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
    
    func fireUploadProduct() {
        self.showHUD()
        
        if self.uploadType == UploadType.NewProduct {
            if self.productModel.images.count-1 == self.productImagesName.count {
                self.productImages = self.getProductImages(self.productModel.images.count)
                println("\(self.getProductImages(self.productModel.images.count))")
            }
        } else {
            if (self.productModel.editedImage.count-1 == self.productImagesName.count) || (self.productImagesCount == 0) {
                self.productImages = self.getProductImages(self.productModel.editedImage.count)
                println("\(self.getProductImages(self.productModel.editedImage.count))")
            }
        }
        
        var parameters: NSMutableDictionary = NSMutableDictionary()
        
        var url: String = ""
        if self.uploadType == UploadType.NewProduct {
            url = APIAtlas.uploadProductUrl
            parameters = ["name" : self.productModel.name,
                "shortDescription" : self.productModel.shortDescription,
                "description" : self.productModel.completeDescription,
                "youtubeVideoUrl" : "https://www.youtube.com/watch?v=SSAhYXby1ao",
                "productConditionId" : self.productModel.condition.uid,
                "productCategoryId" : self.productModel.category.uid,
                "shippingCategoryId" : self.productModel.shippingCategories.uid,
                "brand" : self.productModel.brand.name,
                "productGroups" : "\(self.getProductGroups())",
                "productImages" : self.productImages,
                "productUnits" : self.getProductAttributes(),
                "isDraft" : self.productIsDraft]
        } else {
            url = APIAtlas.uploadProductEditUrl
            parameters = ["name" : self.productModel.name,
                "shortDescription" : self.productModel.shortDescription,
                "description" : self.productModel.completeDescription,
                "youtubeVideoUrl" : self.productModel.youtubeVideoUrl,
                "productConditionId" : self.productModel.condition.uid,
                "productCategoryId" : self.productModel.category.uid,
                "shippingCategoryId" : self.productModel.shippingCategories.uid,
                "brand" : self.productModel.brand.name,
                "productGroups" : "\(self.getProductGroups())",
                "productImages" : self.productImages,
                "productUnits" : self.getProductAttributes(),
                "productId" : self.productModel.uid]
            self.productIsDraft = true
        }
        
        WebServiceManager.fireProductUploadRequestWithUrl(url+"?access_token=\(SessionManager.accessToken())", parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if let success = responseObject["isSuccessful"] as? Bool {
                    if success {
                        println(responseObject)
                        if !self.productIsDraft {
                            self.success()
                        } else {
                           self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                }
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(UploadProduct.ProductUpload)
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
    
    func fireUploadProductMainImages(image: UIImage) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
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
                                    self.productModel.mainImagesName.append(fileName)
                                    oldFileName = fileName
                                } else {
                                    if self.productModel.mainImagesName.count == 0 {
                                        if self.productModel.mainImagesName[self.productImagesCount] == "" {
                                            self.productModel.mainImagesName[self.productImagesCount] = fileName
                                            oldFileName = fileName
                                        } else {
                                            oldFileName = self.productModel.mainImagesName[self.productImagesCount]
                                        }
                                    } else {
                                        if self.productModel.mainImagesName[self.productImagesCount] == "" {
                                            self.productModel.mainImagesName[self.productImagesCount] = fileName
                                            oldFileName = fileName
                                        } else {
                                            oldFileName = self.productModel.mainImagesName[self.productImagesCount]
                                        }
                                    }
                                }
                                
                                var productMainImagesModel: ProductMainImagesModel = ProductMainImagesModel(image: image, imageName: oldFileName, imageStatus: true, imageFailed: false)
                                //self.productModel.productMainImagesModel.removeAtIndex(self.productImagesCount)
                                self.productModel.productMainImagesModel[self.productImagesCount] = productMainImagesModel
                                
                                self.reloadUploadCellCollectionViewData()
                                
                                self.productImagesCount++
                                if self.uploadType == UploadType.NewProduct {
                                    if self.productImagesCount !=  self.productModel.images.count-1 {
                                        self.fireUploadProductMainImages(self.productModel.images[self.productImagesCount])
                                    }
                                } else {
                                    if self.productImagesCount !=  self.productModel.editedImage.count-1 {
                                        self.fireUploadProductMainImages(self.productModel.editedImage[self.productImagesCount])
                                    }
                                }
                            }
                        }
                    }
                    
                    self.reloadUploadCellCollectionViewData()
                } else {
                    self.updateModelUnsuccessfulUpload()
                }
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                println("\(self.productImagesName)")
            } else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.updateModelUnsuccessfulUpload()
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
            } else if uploadProduct == UploadProduct.ProductMainImages {
                self.fireUploadProductMainImages(self.productModel.images[self.productImagesCount])
            } else {
                self.fireUploadProduct()
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
