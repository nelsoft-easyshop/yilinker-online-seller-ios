//
//  AddCustomizedCategoryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol AddCustomizedCategoryViewControllerDelegate {
    func updateAddSubCategoryButtonTitle(text: String)
}

class AddCustomizedCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CCCategoryDetailsViewDelegate, ParentCategoryViewControllerDelegate, CCSubCategoriesViewDelegate, CCCategoryItemsViewDelegate, AddItemViewControllerDelegate, EditSubCategoriesViewControllerDelegate, EditItemsViewControllerDelegate {

    var delegate: AddCustomizedCategoryViewControllerDelegate?
    var categoryDetailsModel: CategoryDetailsModel!
    var productManagementProductModel: ProductManagementProductModel!
    var itemIndexes: [Int] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var headerView: UIView!
    var categoryDetailsView: CCCategoryDetailsView!
    var subCategoriesView: CCSubCategoriesView!
    var footerView: UIView!
    var categoryItemsView: CCCategoryItemsView!
    var itemImagesView: CCCItemImagesView!
    var seeAllItemsView: UIView!
    var newFrame: CGRect!
    
    var subCategoriesHeight: CGFloat = 46 // size of view height(45) + bottom margin (1)
    var subCategoriesItems: Int = 0
    
    var hud: MBProgressHUD?
    
    var parentId: Int = 0
    var subCategories: [NSDictionary] = []
    var products: [NSDictionary] = []
    var productIds: [Int] = []
    var customizedSubCategories: [SubCategoryModel] = []
    var customizedCategoryProducts: [CategoryProductModel] = []
    
    var newSubCategoryNames: [String] = []
    var parentCategoryIndex: Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizedNavigationBar()
        customizedViews()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        loadViewsWithDetails()
    }
    
    func initializeViews() {
        // HEADER
        getHeaderView().addSubview(getCategoryDetailsView())
        getHeaderView().addSubview(getSubCategoriesView())
        
        setPosition(self.subCategoriesView, from: self.categoryDetailsView)
        
        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.subCategoriesView.frame) + 1.0
        self.headerView.frame = newFrame
        
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
        
        
        // FOOTER
        getFooterView().addSubview(getCategoryItemsView())
        getFooterView().addSubview(getItemImageView())
        self.itemImagesView.hidden = true
        setPosition(self.itemImagesView, from: self.categoryItemsView)
        
        newFrame = self.footerView.frame
        newFrame.size.height = CGRectGetMaxY(self.itemImagesView.frame)
        self.footerView.frame = newFrame
        
        self.tableView.tableFooterView = nil
        self.tableView.tableFooterView = self.footerView
        
    }
    
    func applyDetails() {

        if self.categoryDetailsModel != nil {
            
            // Category Name
            self.categoryDetailsView.categoryNameTextField.text = self.categoryDetailsModel.categoryName
            
            // Parent Category
            if self.categoryDetailsModel.parentId == "" {
                self.categoryDetailsView.parentCategoryLabel.text = "NONE"
            } else {
                self.categoryDetailsView.parentCategoryLabel.text = self.categoryDetailsModel.parentId
            }
            
            // Sub Categories
            if self.customizedSubCategories.count != 0 {
                for i in 0..<self.customizedSubCategories.count {
                    let subCategoryDict: Dictionary = ["categoryName": self.customizedSubCategories[i].categoryName,
                        "products": "[]"]
                    self.subCategories.append(subCategoryDict)
                }

                self.subCategoriesView.setTitle("EDIT")
                self.tableView.reloadData()
            }
            
            // Category Products
            if self.customizedCategoryProducts.count != 0 {
                for i in 0..<self.categoryDetailsModel.products.count {
                    let id: Int = self.categoryDetailsModel.products[i].productId.toInt()!
                    self.productIds.append(id)
                }
                
                self.categoryItemsView.setItemButtonTitle("EDIT")
                self.itemImagesView.setProductsCategory(products: self.customizedCategoryProducts)
                self.itemImagesView.hidden = false
                
                getFooterView().addSubview(getSeeAllItemsView())
                setPosition(self.seeAllItemsView, from: self.itemImagesView)
                newFrame = self.footerView.frame
                newFrame.size.height = CGRectGetMaxY(self.seeAllItemsView.frame)
                self.footerView.frame = newFrame
                self.tableView.tableFooterView = nil
                self.tableView.tableFooterView = self.footerView
            }
        }
    }
    
    // MARK: Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
//        self.title = "Customized Category"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeAction")
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "check"), style: .Plain, target: self, action: "checkAction"), navigationSpacer]
    }
    
    func customizedViews() {
        let nib = UINib(nibName: "AddCustomizedCategoryTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AddCustomizedCategory")
        self.tableView.backgroundColor = Constants.Colors.backgroundGray
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
            self.categoryDetailsView.delegate = self
            self.categoryDetailsView.frame.size.width = self.view.frame.size.width
        }
        return self.categoryDetailsView
    }
    
    func getSubCategoriesView() -> CCSubCategoriesView {
        if self.subCategoriesView == nil {
            subCategoriesView = XibHelper.puffViewWithNibName("CustomizedCategoryViewsViewController", index: 1) as! CCSubCategoriesView
            subCategoriesView.delegate = self
            self.subCategoriesView.frame.size.width = self.view.frame.size.width
        }
        return self.subCategoriesView
    }
    
    func getFooterView() -> UIView {
        if self.footerView == nil {
            self.footerView = UIView(frame: CGRectZero)
            self.footerView.autoresizesSubviews = false
            self.footerView.backgroundColor = Constants.Colors.backgroundGray
        }
        return self.footerView
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
        if customizedCategoryProducts.count != 0 {
            seeAllItemsLabel.text = "See all " + String(self.customizedCategoryProducts.count) + " items   "
        } else if itemIndexes.count != 0 {
            seeAllItemsLabel.text = "See all " + String(self.itemIndexes.count) + " items   "
        } else {
            seeAllItemsLabel.text = "See all 0 items   "
            self.seeAllItemsView.hidden = false
        }
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
        self.getHeaderView().addSubview(getSubCategoriesView())
        self.getFooterView().addSubview(getCategoryItemsView())

        setUpViews()
    }
    
    func setUpViews() {
        // ------ HEADER
        newFrame = self.headerView.frame
        if self.parentCategoryIndex == -1 {
            setPosition(self.subCategoriesView, from: self.categoryDetailsView)
            newFrame.size.height = CGRectGetMaxY(self.subCategoriesView.frame) + 1.0
        } else {
            newFrame.size.height = CGRectGetMaxY(self.categoryDetailsView.frame)
        }
        self.headerView.frame = newFrame
        
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
        
//        // ------ FOOTER
//        
        newFrame = self.footerView.frame

        if self.customizedCategoryProducts.count != 0 || self.productIds.count != 0 {
            setPosition(self.itemImagesView, from: self.categoryItemsView)
            setPosition(self.seeAllItemsView, from: self.itemImagesView)
            newFrame.size.height = CGRectGetMaxY(self.seeAllItemsView.frame) + 20.0
        } else {
            newFrame.size.height = CGRectGetMaxY(self.categoryItemsView.frame)
        }

        self.footerView.frame = newFrame
        self.tableView.tableFooterView = nil
        self.tableView.tableFooterView = self.footerView
        
        self.tableView.reloadData()
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame)
        view.frame = newFrame
    }

    func populateDetails() {
        
        if self.productIds.count != 0 {
            self.categoryItemsView.addNewItemButton.setTitle("EDIT", forState: .Normal)
            self.getFooterView().addSubview(getItemImageView())
            self.getFooterView().addSubview(getSeeAllItemsView())
            self.itemImagesView.setProductsManagement(products: self.productManagementProductModel.products, selectedItems: self.itemIndexes)
        } else if self.productIds.count == 0 {
            
            self.categoryItemsView.addNewItemButton.setTitle("ADD NEW ITEM", forState: .Normal)
            if self.itemImagesView != nil {
                self.itemImagesView.removeFromSuperview()
            }

            if self.seeAllItemsView != nil {
                self.seeAllItemsView.hidden = true
                self.seeAllItemsView.removeFromSuperview()
            }
        }
        
        setUpViews()
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
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }   
    
    func checkAction() {
        
        if self.categoryDetailsView.categoryNameTextField.text != "" {
            
            if self.title == "Add Customized Category" {
                requestAddCustomizedCategory()
            } else if self.title == "Edit Customized Category" {
                requestEditCustomizedCategory()
            }

        }
    }
    
    func formattedString(dictionary: String) -> String {
        var stringCategories: String = dictionary
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("\"", withString: "", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("\n", withString: "\"", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString(" = ", withString: "\":\"", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString(";", withString: "", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("products", withString: ",\"products", options: nil,
            range: nil)
        
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("categoryId", withString: ",\"categoryId", options: nil,
            range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("categoryName", withString: ",\"categoryName", options: nil,
            range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("parentId", withString: ",\"parentId", options: nil,
            range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("sortOrder", withString: ",\"sortOrder", options: nil,
            range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("subcategories", withString: ",\"subcategories", options: nil,
            range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("    ", withString: "", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("\"[", withString: "[", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("]\"", withString: "]", options: nil, range: nil)
        
        return stringCategories
    }
    
    func formattedEditCategory(dictionary: String) -> String {
        var stringCategories: String = dictionary
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString(";\n", withString: "", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("\"", withString: "", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("\n", withString: "\"", options: nil, range: nil)
//        stringCategories = stringCategories.stringByReplacingOccurrencesOfString(" = ", withString: "\":\"", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("categoryId = ", withString: "\"categoryId\": ", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("categoryName = ", withString: ",\"categoryName\": \"", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("parentId = ", withString: "\",\"parentId\": ", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("sortOrder = ", withString: ",\"sortOrder\": ", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("products = ", withString: ",\"products\": ", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("subcategories = ", withString: ",\"subcategories\": ", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("    ", withString: "", options: nil, range: nil)
//        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("\"[", withString: "[", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("\\", withString: "\"", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("[{\"", withString: "[{", options: nil, range: nil)
        stringCategories = stringCategories.stringByReplacingOccurrencesOfString(": [{,\"", withString: ": [{\"", options: nil, range: nil)
//        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("]\"", withString: "]", options: nil, range: nil)
//        stringCategories = stringCategories.stringByReplacingOccurrencesOfString("]\"", withString: "]", options: nil, range: nil)
//        }\")}]
        return stringCategories
    }
    
    // MARK: - Requests
    
    func requestGetCategoryDetails(categoryId: Int) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken(),
            "categoryId": String(categoryId)]
        
        manager.POST(APIAtlas.getCategoryDetails, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.categoryDetailsModel = CategoryDetailsModel.parseDataWithDictionary(responseObject as! NSDictionary)
            self.customizedSubCategories = self.categoryDetailsModel.subcategories
            self.customizedCategoryProducts = self.categoryDetailsModel.products

            self.initializeViews()
            self.applyDetails()
            
//            self.getFooterView().addSubview(self.getItemImageView())
//            self.getFooterView().addSubview(self.getSeeAllItemsView())
//            
//            self.setPosition(self.itemImagesView, from: self.categoryItemsView)
//            self.setPosition(self.seeAllItemsView, from: self.itemImagesView)
//            self.newFrame.size.height = CGRectGetMaxY(self.seeAllItemsView.frame) + 20.0
//            
//            self.itemImagesView.backgroundColor = .redColor()
//            
//            self.newFrame = self.footerView.frame
//            self.footerView.frame = self.newFrame
//            self.tableView.tableFooterView = nil
//            self.tableView.tableFooterView = self.footerView
//            
//            self.tableView.reloadData()
//            
//            println(self.customizedCategoryProducts[0].image)
//            
//            self.itemImagesView.setProductsCategory(products: self.customizedCategoryProducts)
//            
//            
//            self.populateDetails()

            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
                self.hud?.hide(true)
        })
    }
    
    func requestAddCustomizedCategory() {
        self.showHUD()
        var manager = APIManager.sharedInstance
        
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken(),
            "categoryName": self.categoryDetailsView.categoryNameTextField.text,
            "parentId": self.parentId,
            "products": self.productIds.description,
            "subcategories": self.formattedString(self.subCategories.description)]
        
        println(parameters)
            
        manager.POST(APIAtlas.addCustomizedCategory, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.hud?.hide(true)
            
            if responseObject["isSuccessful"] as! Bool {
                self.closeAction()
            } else {
                self.showAlert(title: "Error", message: responseObject["message"] as! String)
            }
            
            if responseObject["isSuccessful"] as! Bool {
                self.closeAction()
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in

                if error.userInfo != nil {
                    println(error.userInfo)
                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                        if jsonResult["message"] != nil {
                            self.showAlert(title: jsonResult["message"] as! String, message: nil)
                        } else {
                            self.showAlert(title: "Something went wrong", message: nil)
                        }
                    }
                } else {
                    self.showAlert(title: "Something went wrong", message: nil)
                }
                self.hud?.hide(true)
        })
    }
    
    func requestEditCustomizedCategory() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        
        var parameters: [NSDictionary] = []
        parameters.append(["categoryId": self.categoryDetailsModel.categoryId,
            "categoryName": self.categoryDetailsView.categoryNameTextField.text,
            "parentId": self.parentId,
            "products": self.productIds,
            "subcategories": self.subCategories])

        let data = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        var editedCategory: String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        
        let params: NSDictionary = ["access_token": SessionManager.accessToken(),
                                      "categories": editedCategory]
        
        println(params)
        
        manager.POST(APIAtlas.editCustomizedCategory, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.hud?.hide(true)
            
            if responseObject["isSuccessful"] as! Bool {
                self.closeAction()
            } else {
                self.showAlert(title: "Error", message: responseObject["message"] as! String)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                if error.userInfo != nil {
                    println(error.userInfo)
                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                        if jsonResult["message"] != nil {
                            self.showAlert(title: jsonResult["message"] as! String, message: nil)
                        } else {
                            self.showAlert(title: "Something went wrong", message: nil)
                        }
                    }
                } else {
                    self.showAlert(title: "Something went wrong", message: nil)
                }
                self.hud?.hide(true)
        })
    }
    
    // MARK: - Table View Data Source and Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.title == "Edit Customized Category" {
            if self.newSubCategoryNames.count != 0 {
                return self.newSubCategoryNames.count
            } else if self.categoryDetailsModel != nil {
                return self.customizedSubCategories.count
            }
        } else if self.title == "Add Customized Category" {
            if self.newSubCategoryNames.count != 0 {
                return self.newSubCategoryNames.count
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell: AddCustomizedCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AddCustomizedCategory") as!  AddCustomizedCategoryTableViewCell
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
        
        if self.newSubCategoryNames.count != 0 {
            cell.textLabel?.text = self.newSubCategoryNames[indexPath.row]
        } else if self.customizedSubCategories.count != 0 {
            cell.textLabel?.text = self.customizedSubCategories[indexPath.row].categoryName
        } else {
            cell.textLabel?.text = "Sub Categories here"
        }
        
        cell.textLabel?.font = UIFont(name: "Panton-Bold", size: 12.0)
        cell.textLabel?.textColor = Constants.Colors.hex666666
        
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
    
    // MARK: - Category Details Delegate
    
    func gotoParentCategory() {
        let parentCategory = ParentCategoryViewController(nibName: "ParentCategoryViewController", bundle: nil)
        parentCategory.selectedIndex = self.parentCategoryIndex
        parentCategory.delegate = self
        var root = UINavigationController(rootViewController: parentCategory)
        self.navigationController?.presentViewController(root, animated: false, completion: nil)
    }
    
    // MARK: - Parent Category View Controller Delegate
    
    func updateParentCategory(parentCategory: String, parentId: Int, parentIndex: Int) {
        self.parentId = parentId
        self.parentCategoryIndex = parentIndex
        self.categoryDetailsView.parentCategoryLabel.text = parentCategory
        self.newSubCategoryNames = []
        self.subCategories = []
        
        if parentIndex != -1 {
            if self.subCategoriesView != nil {
                self.subCategoriesView.removeFromSuperview()
            }
        } else {
            self.getHeaderView().addSubview(self.getSubCategoriesView())
            if self.newSubCategoryNames.count != 0 {
                self.subCategoriesView.setTitle("EDIT")
            } else {
                self.subCategoriesView.setTitle("ADD SUB CATEGORY")
            }
        }
        
        setUpViews()
//        self.tableView.reloadData()
    }
    
    // MARK: - Sub Categories Delegate
    
    func gotoEditSubCategories() {
        let subCategories = EditSubCategoriesViewController(nibName: "EditSubCategoriesViewController", bundle: nil)

        if self.newSubCategoryNames.count != 0 {
            subCategories.categories = self.newSubCategoryNames
            subCategories.subCategories = self.subCategories
        } else if self.customizedSubCategories.count != 0 {
            subCategories.getSubCategoriesEdit(customizedSubCategories)
        } else {
            
        }
        
        subCategories.delegate = self
        var root = UINavigationController(rootViewController: subCategories)
        self.navigationController?.presentViewController(root, animated: false, completion: nil)
    }
    
    // MARK: - Category Items View Controller Delegate
    
    func gotoAddItem() {
        let addItem = AddItemViewController(nibName: "AddItemViewController", bundle: nil)
        addItem.delegate = self
        var root = UINavigationController(rootViewController: addItem)
        self.navigationController?.presentViewController(root, animated: false, completion: nil)
    }
    
    func gotoEditItem() {
        let editItem = EdititemsViewController(nibName: "EdititemsViewController", bundle: nil)
        editItem.delegate = self
       
        if self.categoryDetailsModel != nil {
            editItem.updateListEdit(self.customizedCategoryProducts)
        } else if self.productManagementProductModel != nil {
            editItem.subCategoriesProducts = productIds
            editItem.updateListOfItems(self.productManagementProductModel, itemIndexes: self.itemIndexes)
        }
        
        var root = UINavigationController(rootViewController: editItem)
        self.navigationController?.presentViewController(root, animated: false, completion: nil)
    }
    
    // MARK: - Add Item View Controller Delegate

    func addProductItems(productModel: ProductManagementProductModel, itemIndexes: [Int], products: [Int]) {
        self.productManagementProductModel = productModel
        self.itemIndexes = itemIndexes
        self.productIds = products
        populateDetails()
    }
    
    // MARK: Edit Item View Controller Delegate
    
    func updateProductItems(productModel: ProductManagementProductModel, itemIndexes: [Int], products: [Int]) {
        self.productManagementProductModel = productModel
        self.itemIndexes = itemIndexes
        self.productIds = products
        populateDetails()
    }
    
    // MARK: - Edit Sub Categories View Controller
    
    func addSubCategories(controller: EditSubCategoriesViewController, subCategories: [NSDictionary], categoryNames: [String]) {
        self.subCategories = subCategories
        self.newSubCategoryNames = categoryNames
        
        if self.newSubCategoryNames.count != 0 {
            self.subCategoriesView.setTitle("EDIT")
        } else {
            self.subCategoriesView.setTitle("ADD SUB CATEGORY")
        }
        
        self.tableView.reloadData()
    }
    
}

