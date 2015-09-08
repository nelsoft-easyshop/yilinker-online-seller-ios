//
//  ParentCategoryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ParentCategoryViewControllerDelegate {
    func updateParentCategory(parentCategory: String, parentId: Int, parentIndex: Int)
}

class ParentCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: ParentCategoryViewControllerDelegate?
    var customizedCategoriesModel: CustomizedCategoriesModel!
    
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var selectedIndex: Int = -1

    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        requestGetCustomizedCategories()
        customizedNavigationBar()
        customizedViews()
        
    }
    
    // MARK: - Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Parent Category"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeAction")
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "check"), style: .Plain, target: self, action: "checkAction"), navigationSpacer]
    }
    
    func customizedViews() {
        self.searchBarTextField.layer.cornerRadius = searchBarTextField.frame.size.height / 2
        
        var searchImage = UIImageView(image: UIImage(named: "search2"))
        searchImage.frame = CGRectMake(0.0, 0.0,40.0, 40.0)
        searchImage.contentMode = UIViewContentMode.Center
        searchBarTextField.leftView = searchImage
        searchBarTextField.leftViewMode = UITextFieldViewMode.Always
        
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
    
    // MARK: - Requests
    
    func requestGetCustomizedCategories() {
        self.showHUD()
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
    
    // MARK: - Actions
    
    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkAction() {
        if self.selectedIndex != -1 {
            delegate?.updateParentCategory(customizedCategoriesModel.customizedCategories[selectedIndex].name,
                                 parentId: customizedCategoriesModel.customizedCategories[selectedIndex].categoryId,
                              parentIndex: selectedIndex)
        } else {
            delegate?.updateParentCategory("NONE", parentId: 0, parentIndex: -1)
        }
        
        closeAction()
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.customizedCategoriesModel != nil {
            return self.customizedCategoriesModel.customizedCategories.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
        
        cell.selectionStyle = .None
        cell.textLabel?.text = customizedCategoriesModel.customizedCategories[indexPath.row].name
        cell.textLabel?.font = UIFont(name: "Panton", size: 12.0)
        
        if selectedIndex == indexPath.row {
            var check = UIImageView(frame: CGRectMake(0, 0, 10, 10))
            check.image = UIImage(named: "checkCategory")
            cell.accessoryView = check
        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.selectedIndex == indexPath.row {
            self.selectedIndex = -1
        } else {
            self.selectedIndex = indexPath.row
        }
        self.tableView.reloadData()
    }
    
    
    
}
