//
//  EditSubCategoriesViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/2/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol EditSubCategoriesViewControllerDelegate {
    func addSubCategories(controller: EditSubCategoriesViewController, subCategories: [NSDictionary], categoryNames: [String])
}

class EditSubCategoriesViewController: UIViewController, AddSubCategoriesViewControllerDelegate, CCCategoryItemsViewDelegate, EditSubCategoriesRemovedTableViewCellDelegate {

    var delegate: EditSubCategoriesViewControllerDelegate?
    var subCategories: [NSDictionary] = []
    var tempSubCategories: [NSDictionary] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var bottomBarView: UIView!
    
    var categories: [String] = []
    var categoriesToBeRemove: [Int] = []

    var removeSubCategories: Bool = false
    var createdCategory: String = ""
    
    var subCategoriesEdit: [SubCategoryModel] = []
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizedNavigationBar()
        customizedViews()
        
        let nib = UINib(nibName: "EditSubCategoriesRemovedTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "EditSubCategoriesRemoved")
    }

    // MARK: - Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Edit Sub Categories"
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
    
    func getSubCategoriesEdit(subCategoryModel: [SubCategoryModel]) {
        self.categories = []
        for i in 0..<subCategoryModel.count {
//            self.categories.append(subCategoryModel[i].categoryName)
            let subCategoryDict: Dictionary = ["categoryName": subCategoryModel[i].categoryName,
                                                   "products": []]
            addSubCategory(subCategoryDict, categoryName: subCategoryModel[i].categoryName)
        }
    }
    
    func showAddSubView() {
        self.clearAllButton.hidden = false
        self.bottomBarView.hidden = false
        self.removeSubCategories = true
        
        self.tableView.reloadData()
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        self.tableView.reloadData()
    }
    
    func showEditSubView() {
        self.categoriesToBeRemove = []
        self.bottomBarView.hidden = true
        self.clearAllButton.hidden = true
        self.removeSubCategories = false
        self.tableView.contentInset = UIEdgeInsetsZero
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func closeAction() {
        self.dismissViewControllerAnimated(false, completion: nil)
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func checkAction() {
        delegate?.addSubCategories(self, subCategories: subCategories, categoryNames: categories)
        closeAction()
    }
    
    @IBAction func clearAllAction(sender: AnyObject) {
        categories = []
        showEditSubView()
    }
    
    @IBAction func removeCategoriesAction(sender: AnyObject) {
        if categories.count != 0 {
            showAddSubView()
        }
    }
    
    @IBAction func addCategories(sender: AnyObject) {
        let addSubCategoryViewController = AddSubCategoriesViewController(nibName: "AddSubCategoriesViewController", bundle: nil)
        addSubCategoryViewController.delegate = self
        addSubCategoryViewController.createdCategory = createdCategory
        var rootViewController = UINavigationController(rootViewController: addSubCategoryViewController)
        self.navigationController?.presentViewController(rootViewController, animated: false, completion: nil)
    }
    
    @IBAction func removedSelectedAction(sender: AnyObject) {

        for i in 0..<categoriesToBeRemove.count {
            self.categories = self.categories.filter({$0 != self.categories[self.categoriesToBeRemove[i]]})
        }
        
        showEditSubView()
    }
    
    @IBAction func cancel(sender: AnyObject!) {
        showEditSubView()
    }
    
    // MARK: - Requests
    
    func requestEditCustomizedCategories(categoryId: Int) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken(),
                                        "categoryId": "1"]
        
        manager.POST(APIAtlas.getCategoryDetails, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in

//            self.customizedCategoriesModel = CustomizedCategoriesModel.parseDataWithDictionary(responseObject as! NSDictionary)
//            self.tableView.reloadData()
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
                self.hud?.hide(true)
        })
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if subCategoriesEdit.count != 0 {
//            return subCategoriesEdit.count
//        } else if categories.count != 0 {
//            return categories.count
//        }
        
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        if self.removeSubCategories {
            let cell: EditSubCategoriesRemovedTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("EditSubCategoriesRemoved") as! EditSubCategoriesRemovedTableViewCell
            cell.selectionStyle = .None
            cell.tag = indexPath.row
            cell.delegate = self
            cell.subCategoryLabel.text = categories[indexPath.row]
            
            if self.categoriesToBeRemove.count == 0 {
                cell.deselected()
            }
            
            return cell
        } else {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
            cell.selectionStyle = .None
            cell.textLabel?.text = categories[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Panton-Bold", size: 12.0)
            cell.textLabel?.textColor = Constants.Colors.hex666666
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        }
        
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
    
    // MARK: - Add Sub Category View Controller Delegate
    
    func addSubCategory(subCategory: NSDictionary, categoryName: String) {
        subCategories.append(subCategory)
        categories.append(categoryName)
        if self.tableView != nil {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Category Items View Delegate 
    
    func gotoAddItem() {
        let addItem = AddItemViewController(nibName: "AddItemViewController", bundle: nil)
        //        addItem.delegate = self
        var root = UINavigationController(rootViewController: addItem)
        self.navigationController?.presentViewController(root, animated: true, completion: nil)
    }
    
    func gotoEditItem() {
        
    }
    
    // MARK: - Edit Sub Categories Removed Table View Cell Delegate
    
    func addThisItemToBeRemove(index: Int) {
        categoriesToBeRemove.append(index)
    }
    
    func removeThisItemToBeRemove(index: Int) {
        categoriesToBeRemove = categoriesToBeRemove.filter({$0 != index})
    }

}
