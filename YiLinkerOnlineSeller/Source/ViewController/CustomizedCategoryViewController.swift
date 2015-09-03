//
//  CustomizedCategoryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CustomizedCategoryViewController: UIViewController, UITableViewDataSource, AddCustomizedCategoryViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var parentCategory: [String] = []
    var subCategories: [NSArray] = []
    var categoryItems: [NSArray] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "CustomizedCategoryTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "CustomizedCategory")
        
        customizedNavigationBar()

    }

    // MARK: - Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Customized Category"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "addCategory"), style: .Plain, target: self, action: "addCategoryAction"), navigationSpacer]
    }

    // MARK: - Actions
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addCategoryAction() {
        let addCustomizedCategory = AddCustomizedCategoryViewController(nibName: "AddCustomizedCategoryViewController", bundle: nil)
        addCustomizedCategory.delegate = self
        var rootViewController = UINavigationController(rootViewController: addCustomizedCategory)
        self.navigationController?.presentViewController(rootViewController, animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentCategory.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CustomizedCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CustomizedCategory") as! CustomizedCategoryTableViewCell
        cell.selectionStyle = .None

//        let subCategoriesString = ", ".join(subCategoriesArray)
        
        cell.parentCategoryLabel.text = self.parentCategory[indexPath.row]

        let subCategoriesArray: NSArray = self.subCategories[indexPath.row]
        var sub: String = ""
        for i in 0..<subCategoriesArray.count {
            sub += subCategoriesArray[i] as! String
            if i != subCategoriesArray.count - 1 {
                sub += ", "
            }
        }
        cell.subCategoriesLabel.text = sub
        
//        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        cell.selectionStyle = .None
//        cell.textLabel?.text = "Sub Category " + String(indexPath.row)
//        cell.textLabel?.font = UIFont(name: "Panton-Bold", size: 12.0)
//        cell.textLabel?.textColor = Constants.Colors.hex666666
//        cell.detailTextLabel.text = "Sub Categories"
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let addCustomizedCategory = AddCustomizedCategoryViewController(nibName: "AddCustomizedCategoryViewController", bundle: nil)
        addCustomizedCategory.subCategoriesItems = 4
        addCustomizedCategory.imageItems = 5
        addCustomizedCategory.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addCustomizedCategory, animated: true)
    }
    
    // MARK: - Add Customized Category View Controller Delegate
    
    func addCategory(parent: String, sub: NSArray, items: NSArray) {
        
        self.parentCategory.append(parent)
        self.subCategories.append(sub)
        self.categoryItems.append(items)
        
        self.tableView.reloadData()
    }
    
    func passNewCategory(category: String) {
        
    }
    
}
