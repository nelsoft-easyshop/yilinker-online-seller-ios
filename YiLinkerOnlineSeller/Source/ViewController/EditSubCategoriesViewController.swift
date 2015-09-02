//
//  EditSubCategoriesViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/2/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol EditSubCategoriesViewControllerDelegate {
    func addSubCategories(controller: EditSubCategoriesViewController, categories: NSArray)
}

class EditSubCategoriesViewController: UIViewController, AddSubCategoriesViewControllerDelegate, CCCategoryItemsViewDelegate, EditSubCategoriesRemovedTableViewCellDelegate {

    var delegate: EditSubCategoriesViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var bottomBarView: UIView!
    
    var categories: [String] = []
    var categoriesToBeRemove: [Int] = []
    var numberOfList: Int = 0
    var removeSubCategories: Bool = false
    var createdCategory: String = ""
    
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
    
    // MARK: - Actions
    
    func closeAction() {
        self.dismissViewControllerAnimated(false, completion: nil)
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func checkAction() {
        delegate?.addSubCategories(self, categories: self.categories)
        closeAction()
    }
    
    @IBAction func clearAllAction(sender: AnyObject) {
        categories = []
    }
    
    @IBAction func removeCategoriesAction(sender: AnyObject) {
        if categories.count != 0 {
            self.clearAllButton.hidden = false
            self.bottomBarView.hidden = false
            self.removeSubCategories = true
            
            self.tableView.reloadData()
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        }
    }
    
    @IBAction func addCategories(sender: AnyObject) {
        let addSubCategoryViewController = AddSubCategoriesViewController(nibName: "AddSubCategoriesViewController", bundle: nil)
        addSubCategoryViewController.delegate = self
        addSubCategoryViewController.createdCategory = createdCategory
        var rootViewController = UINavigationController(rootViewController: addSubCategoryViewController)
        self.navigationController?.presentViewController(rootViewController, animated: false, completion: nil)
//        self.navigationController?.pushViewController(addSubCatetory, animated: true)
        
//        loadViewsWithDetails()
//        numberOfList = 0
//        self.topBarView.hidden = true
//        self.tableView.transform = CGAffineTransformMakeTranslation(0, 0)
//        self.tableView.reloadData()
    }
    
    @IBAction func removedSelectedAction(sender: AnyObject) {

        for i in 0..<categoriesToBeRemove.count {
            println(categoriesToBeRemove[i])
            categories.removeAtIndex(categoriesToBeRemove[i])
            let cell: EditSubCategoriesRemovedTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: categoriesToBeRemove[i], inSection: 0)) as! EditSubCategoriesRemovedTableViewCell
            cell.checkImageView.hidden = false
            cell.checkAction(UIGestureRecognizer())
        }
        
        //        categoriesToBeRemove = []
        if categories.count == 0 {
            self.removeSubCategories = true
            cancel(nil)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func cancel(sender: AnyObject!) {
        self.bottomBarView.hidden = true
        self.clearAllButton.hidden = true
        self.removeSubCategories = false
        self.tableView.contentInset = UIEdgeInsetsZero
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
        self.tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.removeSubCategories {
            let cell: EditSubCategoriesRemovedTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("EditSubCategoriesRemoved") as! EditSubCategoriesRemovedTableViewCell
            cell.selectionStyle = .None
            cell.tag = indexPath.row
            cell.delegate = self
            
            cell.subCategoryLabel.text = categories[indexPath.row]
            
            return cell
        } else {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
            
            cell.selectionStyle = .None
            cell.textLabel?.text = categories[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Panton-Bold", size: 12.0)
            cell.textLabel?.textColor = Constants.Colors.hex666666
            
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
    
    func addSubCategory(category: String) {
        categories.append(category)
        self.tableView.reloadData()
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
    
    func updateCategoryItems(index: Int) {
        categoriesToBeRemove.append(index)
    }

}
