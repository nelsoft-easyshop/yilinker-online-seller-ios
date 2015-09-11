//
//  CustomizedCategoryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CustomizedCategoryViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var parentCategory: [String] = []
    var subCategories: [NSArray] = []
    var categoryItems: [NSArray] = []
    
    var hud: MBProgressHUD?
    
    var customizedCategoriesModel: CustomizedCategoriesModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "CustomizedCategoryTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "CustomizedCategory")
        
        customizedNavigationBar()
        requestGetCustomizedCategories()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if customizedCategoriesModel != nil {
            requestGetCustomizedCategories()
        }
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
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addCategoryAction() {
        let addCustomizedCategory = AddCustomizedCategoryViewController(nibName: "AddCustomizedCategoryViewController", bundle: nil)
        addCustomizedCategory.title = "Add Customized Category"
        addCustomizedCategory.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addCustomizedCategory, animated: true)
    }
    
    // MARK: - Requests
    
    func requestGetCustomizedCategories() {
        if self.customizedCategoriesModel == nil {
            self.showHUD()
        }
        
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken()]

        manager.POST(APIAtlas.getCustomizedCategories, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.customizedCategoriesModel = CustomizedCategoriesModel.parseDataWithDictionary(responseObject as! NSDictionary)
            self.tableView.reloadData()
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
                self.hud?.hide(true)
        })
    }
    
    func requestDeleteCustomizedCategories(categoryId: Int) {
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken(),
                                          "categoryId": categoryId]
        
        manager.POST(APIAtlas.deleteCustomizedCategory, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            self.tableView.reloadData()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
                self.hud?.hide(true)
        })
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if customizedCategoriesModel == nil {
            return 0
        }
        
        return customizedCategoriesModel.customizedCategories.count//parentCategory.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CustomizedCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CustomizedCategory") as! CustomizedCategoryTableViewCell
        cell.selectionStyle = .None
        
        cell.parentCategoryLabel.text = customizedCategoriesModel.customizedCategories[indexPath.row].name
        cell.subCategoriesLabel.text = String(customizedCategoriesModel.customizedCategories[indexPath.row].categoryId)
        
        
//        let subCategoriesArray: NSArray = self.subCategories[indexPath.row]
//        var sub: String = ""
//        for i in 0..<subCategoriesArray.count {
//            sub += subCategoriesArray[i] as! String
//            if i != subCategoriesArray.count - 1 {
//                sub += ", "
//            }
//        }
//        cell.subCategoriesLabel.text = sub
        
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
        addCustomizedCategory.title = "Edit Customized Category"
        addCustomizedCategory.requestGetCategoryDetails(self.customizedCategoriesModel.customizedCategories[indexPath.row].categoryId)
        addCustomizedCategory.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addCustomizedCategory, animated: true)
        
        // to delete categories
//        requestDeleteCustomizedCategories(self.customizedCategoriesModel.customizedCategories[indexPath.row].categoryId)
    }
    
    // MARK: - Add Customized Category View Controller Delegate
    
//    func addCategory(parent: String, sub: NSArray, items: NSArray) {
//        
//        self.parentCategory.append(parent)
//        self.subCategories.append(sub)
//        self.categoryItems.append(items)
//        
//        self.tableView.reloadData()
//    }
    
    func passNewCategory(category: String) {
        
    }
    
}
