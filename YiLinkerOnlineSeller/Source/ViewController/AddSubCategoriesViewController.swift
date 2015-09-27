//
//  AddSubCategoriesViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/2/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol AddSubCategoriesViewControllerDelegate {
    func addSubCategory(subCategory: SubCategoryModel, new: Bool)
    func updateSubCategory(subCategory: SubCategoryModel)
}

class AddSubCategoriesViewController: UIViewController, CCCategoryDetailsViewDelegate, CCCategoryItemsViewDelegate, AddItemViewControllerDelegate, EditItemsViewControllerDelegate, ParentCategoryViewControllerDelegate, UITextFieldDelegate {

    var hud: MBProgressHUD?
    
    var delegate: AddSubCategoriesViewControllerDelegate?
    var productManagementProductModel: ProductManagementProductModel!
    var subCategoriesProducts: [ProductManagementProductsModel] = []
    var itemIndexes: [Int] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var headerView: UIView!
    var categoryDetailsView: CCCategoryDetailsView!
    var categoryItemsView: CCCategoryItemsView!
    var itemImagesView: CCCItemImagesView!
    var seeAllItemsView: UIView!
    var newFrame: CGRect!
    var createdCategory: String = ""
    
    var numberOfList: Int = 10
    
    var subCategoryDetailModel: SubCategoryModel!
    var parentName: String = ""
    
    var isEditingSub: Bool = false
    var parameterSubCategoryModal: SubCategoryModel!
    var parameterParentName: String = ""
    var parameterCategoryId: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizedNavigationBar()
        customizedViews()
        
        loadViewsWithDetails()
        
        if isEditingSub {
            if parameterSubCategoryModal != nil {
                populateFromLocal(parameterSubCategoryModal)
            } else {
                requestGetSubCategoryDetails(parentName: parameterParentName, categoryId: parameterCategoryId)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.categoryDetailsView.frame.size.width = self.view.frame.size.width
        self.categoryItemsView.frame.size.width = self.view.frame.size.width
    }
    
    // MARK: - Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeAction")
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "check"), style: .Plain, target: self, action: "checkAction"), navigationSpacer]
    }
    
    func customizedViews() {
        let nib = UINib(nibName: "AddItemTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AddItemTableViewCell")
        
        self.tableView.backgroundColor = Constants.Colors.backgroundGray
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func getHeaderView() -> UIView {
        if self.headerView == nil {
            self.headerView = UIView(frame: CGRectZero)
            self.headerView.autoresizesSubviews = false
            self.headerView.backgroundColor = Constants.Colors.backgroundGray
        }
        return self.headerView
    }
    
    func getCategoryDetailsView() -> CCCategoryDetailsView {
        if self.categoryDetailsView == nil {
            self.categoryDetailsView = XibHelper.puffViewWithNibName("CustomizedCategoryViewsViewController", index: 0) as! CCCategoryDetailsView
            self.categoryDetailsView.categoryNameTextField.becomeFirstResponder()
            self.categoryDetailsView.categoryNameTextField.delegate = self
            self.categoryDetailsView.delegate = self
            self.categoryDetailsView.frame.size.width = self.view.frame.size.width
            self.categoryDetailsView.frame.size.height = 100.0
        }
        return self.categoryDetailsView
    }
    
    func getCategoryItemsView() -> CCCategoryItemsView {
        if self.categoryItemsView == nil {
            self.categoryItemsView = XibHelper.puffViewWithNibName("CustomizedCategoryViewsViewController", index: 2) as! CCCategoryItemsView
            self.categoryItemsView.delegate = self
            self.categoryItemsView.frame.size.width = self.view.frame.size.width
        }
        return self.categoryItemsView
    }
    
    func getItemImageView() -> CCCItemImagesView {
        if self.itemImagesView == nil {
            self.itemImagesView = XibHelper.puffViewWithNibName("CustomizedCategoryViewsViewController", index: 3) as! CCCItemImagesView
            
            self.itemImagesView.frame.size.width = self.view.frame.size.width
        }
        return self.itemImagesView
    }
    
    func getSeeAllItemsView() -> UIView {
        self.seeAllItemsView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 45))
        self.seeAllItemsView.backgroundColor = UIColor.whiteColor()
        
        var seeAllItemsLabel = UILabel(frame: CGRectZero)
        seeAllItemsLabel.text = CategoryStrings.categorySeeAll + String(subCategoriesProducts.count) + CategoryStrings.categoryItems2
        seeAllItemsLabel.font = UIFont(name: "Panton-Bold", size: 12.0)
        seeAllItemsLabel.textColor = UIColor.darkGrayColor()
        seeAllItemsLabel.sizeToFit()
        seeAllItemsLabel.center = self.seeAllItemsView.center
        self.seeAllItemsView.addSubview(seeAllItemsLabel)
        
        var arrowImageView = UIImageView(frame: CGRectMake(CGRectGetMaxX(seeAllItemsLabel.frame), 18, 7, 10))
        arrowImageView.image = UIImage(named: "right2")
        self.seeAllItemsView.addSubview(arrowImageView)
        
        return self.seeAllItemsView
    }
    
    func loadViewsWithDetails() {
        self.getHeaderView().addSubview(getCategoryDetailsView())
        self.getHeaderView().addSubview(getCategoryItemsView())
        self.categoryDetailsView.parentCategoryLabel.text = createdCategory
        
        setUpViews()
    }
    
    func setUpViews() {
        setPosition(self.categoryItemsView, from: self.categoryDetailsView)
        
        newFrame = self.headerView.frame
        
//        if self.subCategoriesProducts.count != 0 {
//            if self.subCategoriesProducts.count != 0 {
//                setPosition(self.itemImagesView, from: self.categoryItemsView)
//                setPosition(self.seeAllItemsView, from: self.itemImagesView)
//                newFrame.size.height = CGRectGetMaxY(self.seeAllItemsView.frame) + 20.0
//            }
//        } else {
//            newFrame.size.height = CGRectGetMaxY(self.categoryItemsView.frame)
//        }
        
        newFrame.size.height = CGRectGetMaxY(self.categoryItemsView.frame) + 1
        self.headerView.frame = newFrame
        
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame)
        view.frame = newFrame
    }
    
    func populateFromLocal(subCategory: SubCategoryModel) {
        self.subCategoryDetailModel = subCategory
        
        for i in 0..<self.subCategoryDetailModel.products.count {
            let categoryProducts = ProductManagementProductsModel()
            categoryProducts.id = self.subCategoryDetailModel.products[i].productId
            categoryProducts.name = self.subCategoryDetailModel.products[i].productName
            categoryProducts.image = self.subCategoryDetailModel.products[i].image
            self.subCategoriesProducts.append(categoryProducts)
        }
        
        self.populateDetails()
        
        self.categoryDetailsView.frame.size.height = 153.0
        self.setUpViews()
    }
    
    func populateDetails() {
        self.categoryDetailsView.categoryNameTextField.text = subCategoryDetailModel.categoryName
        self.categoryDetailsView.parentCategoryLabel.text = subCategoryDetailModel.parentName

        self.populateItems()
    }
    
    func populateItems() {
        if self.subCategoriesProducts.count != 0 {
            self.categoryItemsView.setItemButtonTitle(CategoryStrings.categoryEdit)
//            self.getHeaderView().addSubview(getItemImageView())
//            self.getHeaderView().addSubview(getSeeAllItemsView())
//            self.itemImagesView.setProductsManagement(products: subCategoriesProducts)
        } else {
            self.categoryItemsView.setItemButtonTitle(CategoryStrings.categoryNewItems)
        }
        
        setUpViews()
        self.tableView.reloadData()
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    func closeAction() {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func checkAction() {
        
        var products: [CategoryProductModel] = []
        for i in 0..<self.subCategoriesProducts.count {
            var product = CategoryProductModel()
            product.productId = self.subCategoriesProducts[i].id
            product.productName = self.subCategoriesProducts[i].name
            product.image = self.subCategoriesProducts[i].image
            products.append(product)
        }
        
        if self.title == "Edit Category" {
            self.subCategoryDetailModel.categoryName = self.categoryDetailsView.categoryNameTextField.text
            self.subCategoryDetailModel.parentName = self.categoryDetailsView.parentCategoryLabel.text!
            self.subCategoryDetailModel.products = products
            self.subCategoryDetailModel.local = true
            delegate?.updateSubCategory(self.subCategoryDetailModel)
        } else {
            subCategoryDetailModel = SubCategoryModel(message: "",
                isSuccessful: true,
                categoryId: 0,
                categoryName: self.categoryDetailsView.categoryNameTextField.text,
                parentName: self.parentName,
                parentId: 0,
                sortOrder: 0,
                products: products,
                local: true)
            delegate?.addSubCategory(subCategoryDetailModel, new: true)
        }
        
        closeAction()
//        
//        var productIds: [Int] = []
//        for i in 0..<self.subCategoriesProducts.count {
//            productIds.append(self.subCategoriesProducts[i].id.toInt()!)
//        }
        
//        if self.subCategoryDetailModel.parentId == 0 {
//            println("Parent Category")
//            var parameters: NSDictionary = ["access_token": SessionManager.accessToken(),
//                                              "categoryId": self.subCategoryDetailModel.categoryId,
//                                            "categoryName": self.categoryDetailsView.categoryNameTextField.text,
//                                                "products": productIds]
//            println(parameters)
//            requestEditCustomizedCategoryWithDetail(parameters)
//        } else {
//            println("Sub Category")
//            var parameters: [NSDictionary] = []
//            parameters.append(["categoryId": self.subCategoryDetailModel.categoryId,
//                             "categoryName": self.categoryDetailsView.categoryNameTextField.text,
//                                 "products": productIds])
//            
//            let data = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
//            var categoryFormat: String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
//            
//            let params: NSDictionary = ["access_token": SessionManager.accessToken(),
//                                          "categories": categoryFormat]
//            
//            println(params)
//            requestEditCustomizedCategoryWithDetail(params)
//        }
        
        
//        if self.categoryDetailsView.categoryNameTextField.text != "" {
//            subCategoryDetailModel = SubCategoryModel(message: "",
//                isSuccessful: true,
//                categoryId: 0,
//                categoryName: categoryDetailsView.categoryNameTextField.text,
//                parentName: "",
//                parentId: 0,
//                sortOrder: 0,
//                products: [CategoryProductModel]())
//            
//            delegate?.addSubCategory(subCategoryDetailModel, categoryName: self.categoryDetailsView.categoryNameTextField.text.capitalizedString)
//        }
    }
    
    // MARK: - Request
    
    func requestGetSubCategoryDetails(#parentName: String, categoryId: Int) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken(),
                                          "categoryId": String(categoryId)]
        
        manager.POST(APIAtlas.getCategoryDetails, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            println(responseObject)
            
//            let subCategoryDetail: SubCategoryModel = SubCategoryModel.parseSubCategories(responseObject as! NSDictionary)
            self.subCategoryDetailModel = SubCategoryModel.parseSubCategories(responseObject as! NSDictionary)
            self.subCategoryDetailModel.parentName = parentName
            
//            self.subCategoryDetailModel = (SubCategoryModel(message: subCategoryDetail.message,
//                isSuccessful: subCategoryDetail.isSuccessful,
//                categoryId: subCategoryDetail.categoryId,
//                categoryName: subCategoryDetail.categoryName,
//                parentName: parentName,
//                parentId: subCategoryDetail.parentId,
//                sortOrder: subCategoryDetail.sortOrder,
//                products: subCategoryDetail.products))
            
            for i in 0..<self.subCategoryDetailModel.products.count {
                println(self.subCategoryDetailModel.products[i].image)
                let categoryProducts = ProductManagementProductsModel()
                categoryProducts.id = self.subCategoryDetailModel.products[i].productId
                categoryProducts.name = self.subCategoryDetailModel.products[i].productName
                categoryProducts.image = self.subCategoryDetailModel.products[i].image
                self.subCategoriesProducts.append(categoryProducts)
            }
            
            self.populateDetails()
            
            self.categoryDetailsView.frame.size.height = 153.0
            self.setUpViews()
//            self.categoryDetailsModel = CategoryDetailsModel.parseDataWithDictionary(responseObject as! NSDictionary)
//            self.customizedSubCategories = self.categoryDetailsModel.subcategories
//            self.customizedCategoryProducts = self.categoryDetailsModel.products
//            
//            for i in 0..<self.customizedCategoryProducts.count {
//                let categoryProducts = ProductManagementProductsModel()
//                categoryProducts.id = self.customizedCategoryProducts[i].productId
//                categoryProducts.name = self.customizedCategoryProducts[i].productName
//                categoryProducts.image = self.customizedCategoryProducts[i].image
//                self.selectedProductsModel.append(categoryProducts)
//            }
//            
//            self.initializeViews()
//            self.applyDetails()
            
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
                self.hud?.hide(true)
        })
    }
    
    // MARK: - Table View Data Source and Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategoriesProducts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        cell.selectionStyle = .None
//        cell.textLabel?.text = subCategoriesProducts[indexPath.row].name
//        cell.textLabel?.font = UIFont(name: "Panton-Bold", size: 12.0)
//        cell.textLabel?.textColor = Constants.Colors.hex666666

        let cell: AddItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AddItemTableViewCell") as! AddItemTableViewCell
        cell.selectionStyle = .None
        
        cell.setProductImage(self.subCategoriesProducts[indexPath.row].image)
        cell.itemNameLabel.text = self.subCategoriesProducts[indexPath.row].name
//        cell.vendorLabel.text = self.subCategoriesProducts[indexPath.row].category
        cell.addImageView.hidden = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    // MARK: - Category Items View Delegate
    
    func gotoAddItem() {
        let addItem = AddItemViewController(nibName: "AddItemViewController", bundle: nil)
        addItem.delegate = self
        self.navigationController?.pushViewController(addItem, animated: false)
    }
    
    func gotoEditItem() {
        let editItem = EdititemsViewController(nibName: "EdititemsViewController", bundle: nil)
        editItem.delegate = self
        editItem.subCategoriesProducts = subCategoriesProducts
        self.navigationController?.pushViewController(editItem, animated: false)
    }
    
    // MARK: Add Item View Controller Delegate

    func addProductItems(productModel: ProductManagementProductModel, itemIndexes: [Int], products: [ProductManagementProductsModel]) {
        self.productManagementProductModel = productModel
        self.itemIndexes = itemIndexes
        self.subCategoriesProducts = products
        populateItems()
    }
    
    // MARK: Edit Item View Controller Delegate
    
//    func updateProductItems(productModel: ProductManagementProductModel, itemIndexes: [Int], products: [ProductManagementProductsModel]) {
//        self.productManagementProductModel = productModel
//        self.itemIndexes = itemIndexes
//        self.subCategoriesProducts = products
//        println(self.subCategoriesProducts)
//        
//        populateItems()
//
//    }
    
    func updateProductItems(products: [ProductManagementProductsModel]) {
        self.subCategoriesProducts = products
        populateItems()
    }
    
    // MARK: - Category Details Delegate
    
    func gotoParentCategory() {
        let parentCategory = ParentCategoryViewController(nibName: "ParentCategoryViewController", bundle: nil)
        parentCategory.delegate = self
        parentCategory.selectedParentId = subCategoryDetailModel.parentId
        self.navigationController?.pushViewController(parentCategory, animated: true)
    }
    
    // MARK: - Parent Category View Controller Delegate
    
    func updateParentCategory(parentCategory: String, parentId: Int) {
        
        self.subCategoryDetailModel.parentName = parentCategory
        self.subCategoryDetailModel.parentId = parentId
        
        self.categoryDetailsView.parentCategoryLabel.text = parentCategory
//        populateDetails()
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.categoryDetailsView.categoryNameTextField.resignFirstResponder()
        return true
    }
}