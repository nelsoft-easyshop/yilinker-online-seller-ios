//
//  AddSubCategoriesViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/2/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol AddSubCategoriesViewControllerDelegate {
    func addSubCategory(category: String)
}

class AddSubCategoriesViewController: UIViewController, CCCategoryItemsViewDelegate, AddItemViewControllerDelegate {

    var delegate: AddSubCategoriesViewControllerDelegate?
    var productManagementProductModel: ProductManagementProductModel!
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
    
    // MARK: - Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Add Sub Categories"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeAction")
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "check"), style: .Plain, target: self, action: "checkAction"), navigationSpacer]
    }
    
    func customizedViews() {
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
            //            self.categoryDetailsView.delegate = self
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
        self.getHeaderView().addSubview(getCategoryItemsView())
        self.categoryDetailsView.parentCategoryLabel.text = createdCategory
        
        setUpViews()
    }
    
    func setUpViews() {
        setPosition(self.categoryItemsView, from: self.categoryDetailsView)
        
        newFrame = self.headerView.frame
        
        if self.productManagementProductModel != nil {
            if self.productManagementProductModel.products.count != 0 {
                setPosition(self.itemImagesView, from: self.categoryItemsView)
                setPosition(self.seeAllItemsView, from: self.itemImagesView)
                newFrame.size.height = CGRectGetMaxY(self.seeAllItemsView.frame) + 20.0
            }
        } else {
            newFrame.size.height = CGRectGetMaxY(self.categoryItemsView.frame)
        }
        
        self.headerView.frame = newFrame
        
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame)
        view.frame = newFrame
    }
    
    func populateItems() {
        if self.productManagementProductModel != nil {
            self.categoryItemsView.addNewItemButton.setTitle("EDIT", forState: .Normal)
            self.getHeaderView().addSubview(getItemImageView())
            self.getHeaderView().addSubview(getSeeAllItemsView())
            self.itemImagesView.setProductsManagement(products: self.productManagementProductModel.products, selectedItems: self.itemIndexes)
        }
        
        setUpViews()
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func closeAction() {
        self.dismissViewControllerAnimated(false, completion: nil)
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func checkAction() {
        if self.categoryDetailsView.categoryNameTextField.text != "" {
            delegate?.addSubCategory(self.categoryDetailsView.categoryNameTextField.text.capitalizedString)
        }
        
        closeAction()
    }
    
    // MARK: - Table View Data Source and Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfList
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = .None
        cell.textLabel?.text = "Sub Category " + String(indexPath.row)
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
    
    // MARK: - Category Items View Delegate
    
    func gotoAddItem() {
        let addItem = AddItemViewController(nibName: "AddItemViewController", bundle: nil)
        addItem.delegate = self
        var root = UINavigationController(rootViewController: addItem)
        self.navigationController?.presentViewController(root, animated: true, completion: nil)
    }
    
    func gotoEditItem() {
        let editItem = EdititemsViewController(nibName: "EdititemsViewController", bundle: nil)
        editItem.updateListOfItems(self.productManagementProductModel, itemIndexes: self.itemIndexes)
        var root = UINavigationController(rootViewController: editItem)
        self.navigationController?.presentViewController(root, animated: false, completion: nil)
    }
    
    // MARK: Add Item View Controller Delegate
    
    func updateCategoryImages(productModel: ProductManagementProductModel, itemIndexes: [Int]) {
        self.productManagementProductModel = productModel
        self.itemIndexes = itemIndexes
        populateItems()
    }
    
    func updateEditItems(itemIndexes: [Int]) {
    }
    
    
}