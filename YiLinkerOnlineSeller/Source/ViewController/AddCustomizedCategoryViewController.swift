//
//  AddCustomizedCategoryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol AddCustomizedCategoryViewControllerDelegate {
    func addCategory(parent: String, sub: NSArray, items: NSArray)
}

class AddCustomizedCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CCCategoryDetailsViewDelegate, ParentCategoryViewControllerDelegate, CCSubCategoriesViewDelegate, CCCategoryItemsViewDelegate, AddItemViewControllerDelegate, EditSubCategoriesViewControllerDelegate {

    var delegate: AddCustomizedCategoryViewControllerDelegate?
    var categoryDetailsModel: CategoryDetailsModel!
    
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
    var imageItems: Int = 0
    
    var hud: MBProgressHUD?
    
    var subCategories: [String] = []
    
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
    
    // MARK: Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Customized Category"
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
        seeAllItemsLabel.text = "See all " + "20" + " items   "
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
        self.getFooterView().addSubview(getCategoryItemsView())
        
        setUpViews()
    }
    
    func setUpViews() {
        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.categoryDetailsView.frame)
        self.headerView.frame = newFrame
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
        
        newFrame = self.footerView.frame
        
        if self.categoryDetailsModel != nil {
            if self.categoryDetailsModel.products.count != 0 {
                setPosition(self.itemImagesView, from: self.categoryItemsView)
                setPosition(self.seeAllItemsView, from: self.itemImagesView)
                newFrame.size.height = CGRectGetMaxY(self.seeAllItemsView.frame) + 20.0
            }
        } else {
            newFrame.size.height = CGRectGetMaxY(self.categoryItemsView.frame)
        }
        
        self.footerView.frame = newFrame
        self.tableView.tableFooterView = nil
        self.tableView.tableFooterView = self.footerView
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame)
        if view == self.seeAllItemsView {
            newFrame.origin.y += 1
        }
        view.frame = newFrame
    }

    func populateDetails() {
        self.categoryDetailsView.categoryNameTextField.text = self.categoryDetailsModel.categoryName
        if self.categoryDetailsModel.parentId == "" {
            self.categoryDetailsView.parentCategoryLabel.text = "NONE"
        } else {
            self.categoryDetailsView.parentCategoryLabel.text = self.categoryDetailsModel.parentId
        }
        
        if self.categoryDetailsModel.subcategories.count != 0 {
            self.subCategoriesView.addSubCategoryButton.setTitle("EDIT", forState: .Normal)
            self.subCategoriesView.setTitle("EDIT")
        }
        
        if self.categoryDetailsModel.products.count != 0 {
            self.categoryItemsView.addNewItemButton.setTitle("EDIT", forState: .Normal)
            self.getFooterView().addSubview(getItemImageView())
            self.getFooterView().addSubview(getSeeAllItemsView())
            self.itemImagesView.setItemsImages(self.categoryDetailsModel.products)
            
        }
        
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
    
    // MARK: - Actions
    
    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func checkAction() {
        if self.categoryDetailsView.parentCategoryLabel.text != "" {
            if self.categoryDetailsView.parentCategoryLabel.text == "NONE" {
                delegate?.addCategory(self.categoryDetailsView.categoryNameTextField.text.capitalizedString, sub: subCategories, items: [])
            } else {
                delegate?.addCategory(self.categoryDetailsView.parentCategoryLabel.text!.capitalizedString, sub: [self.categoryDetailsView.categoryNameTextField.text.capitalizedString], items: [])
            }
            closeAction()
        }
        
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
            self.populateDetails()
            
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
                self.hud?.hide(true)
        })
    }
    
    func requestAdCustomizedCategory(categoryId: Int) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken(),
            "categoryId": String(categoryId)]
        
        manager.POST(APIAtlas.addCustomizedCategory, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject)
            
            self.categoryDetailsModel = CategoryDetailsModel.parseDataWithDictionary(responseObject as! NSDictionary)
            self.populateDetails()
            
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
                self.hud?.hide(true)
        })
    }
    
    // MARK: - Table View Data Source and Delegates
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerSectionContainer = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, subCategoriesHeight))
        headerSectionContainer.backgroundColor = Constants.Colors.backgroundGray
        
        subCategoriesView = XibHelper.puffViewWithNibName("CustomizedCategoryViewsViewController", index: 1) as! CCSubCategoriesView
        subCategoriesView.delegate = self
//        subCategoriesView.setTitle("EDIT")
        headerSectionContainer.addSubview(subCategoriesView)
        
        return headerSectionContainer
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return subCategoriesHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.categoryDetailsModel != nil {
             self.categoryDetailsModel.subcategories.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell: AddCustomizedCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AddCustomizedCategory") as!  AddCustomizedCategoryTableViewCell
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
        
        cell.textLabel?.text = self.subCategories[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Panton-Bold", size: 12.0)
        cell.textLabel?.textColor = Constants.Colors.hex666666
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: - Category Details Delegate 
    
    func gotoParentCategory() {
        let parentCategory = ParentCategoryViewController(nibName: "ParentCategoryViewController", bundle: nil)
        parentCategory.delegate = self
        var root = UINavigationController(rootViewController: parentCategory)
        self.navigationController?.presentViewController(root, animated: false, completion: nil)
    }
    
    // MARK: - Parent Category View Controller Delegate
    
    func updateParentCategory(parentCategory: String) {
        self.categoryDetailsView.parentCategoryLabel.text = parentCategory
        subCategoriesHeight = 0.0
        self.subCategories = []
        self.tableView.reloadData()
    }
    
    // MARK: - Sub Categories Delegate
    
    func gotoEditSubCategories() {
        let subCategories = EditSubCategoriesViewController(nibName: "EditSubCategoriesViewController", bundle: nil)
        subCategories.delegate = self
        subCategories.createdCategory = self.categoryDetailsView.categoryNameTextField.text.capitalizedString
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
        var root = UINavigationController(rootViewController: editItem)
        self.navigationController?.presentViewController(root, animated: false, completion: nil)
    }
    
    // MARK: - Add Item View Controller Delegate
    
    func updateCategoryImages(numberOfImages: Int) {
        self.imageItems = numberOfImages
        loadViewsWithDetails()
    }
    
    // MARK: - Edit Sub Categories View Controller
    
    func addSubCategories(controller: EditSubCategoriesViewController, categories: NSArray) {
        self.subCategories = categories as! [String]
        self.tableView.reloadData()
    }
    
}

