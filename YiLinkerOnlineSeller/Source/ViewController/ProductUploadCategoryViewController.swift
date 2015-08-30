//
//  ProductUploadCategoryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadCategoryViewControllerDelegate {
    func productUploadCategoryViewController(didSelectCategory category: String)
}

struct ProductUploadCategoryViewControllerConstant {
    static let productUploadCategoryTableViewCellNibNameAndIdentifier = "ProductUploadCategoryTableViewCell"
}

class ProductUploadCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var titles: [String] = ["Category 1", "Category 2", "Category 3", "Category 4", "Category 5", "Category 6", "Category 7", "Category 8", "Category 9", "Category 10", "Category 11", "Category 12", "Category 13", "Category 14"]
    
    var delegate: ProductUploadCategoryViewControllerDelegate?
    var categories: [CategoryModel] = []
    var pageTitle: String = ""
    var parentID: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton()
        self.searchButton()
        self.title = self.pageTitle
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.registerCell()
        self.fireCategoryWithParentID(self.parentID)
    }
    
    func fireCategoryWithParentID(parentID: Int) {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parentIDKey = "parentId"
        let accessTokenKey = "access_token"
        let parameters: NSDictionary = [accessTokenKey: SessionManager.accessToken(), parentIDKey: parentID]
        
        manager.GET(APIAtlas.categoryUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            let dictionary: NSDictionary = responseObject as! NSDictionary
            let isSuccessful = dictionary["isSuccessful"] as! Bool
            
            if isSuccessful {
                let data: NSArray = dictionary["data"] as! NSArray
                
                for categoryDictionary in data as! [NSDictionary] {
                    let categoryModel: CategoryModel = CategoryModel(uid: categoryDictionary["productCategoryId"] as! Int, name: categoryDictionary["name"] as! String, hasChildren: categoryDictionary["hasChildren"] as! String)
                    self.categories.append(categoryModel)
                }
            }
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Mismatch username and password", title: "Login Failed")
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                }
                
                SVProgressHUD.dismiss()
        })
    }
    
    
    func registerCell() {
        let nib: UINib = UINib(nibName: ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let categoryModel: CategoryModel = self.categories[indexPath.row]
        let cell: ProductUploadCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier) as! ProductUploadCategoryTableViewCell
        cell.categoryTitleLabel.text = categoryModel.name
        
        if categoryModel.hasChildren == "1" {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //self.delegate!.productUploadCategoryViewController(didSelectCategory: self.titles[indexPath.row])
        
        var categoryModel: CategoryModel = self.categories[indexPath.row]
        if categoryModel.hasChildren == "1" {
            let productUploadCategoryViewController: ProductUploadCategoryViewController = ProductUploadCategoryViewController(nibName: "ProductUploadCategoryViewController", bundle: nil)
            productUploadCategoryViewController.pageTitle = self.titles[indexPath.row]
            productUploadCategoryViewController.parentID = categoryModel.uid
            self.navigationController!.pushViewController(productUploadCategoryViewController, animated: true)
        } else {
            let uploadViewController: ProductUploadTableViewController = self.navigationController!.viewControllers[0] as! ProductUploadTableViewController
            uploadViewController.didSelecteCategory(categoryModel)
            self.navigationController!.popToRootViewControllerAnimated(true)
        }
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func searchButton() {
        var searchButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        searchButton.frame = CGRectMake(0, 0, 40, 40)
        searchButton.addTarget(self, action: "search", forControlEvents: UIControlEvents.TouchUpInside)
        let image: UIImage = UIImage(named: "search")!
        let tintedImage = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        searchButton.setImage(tintedImage, forState: UIControlState.Normal)
        searchButton.tintColor = UIColor.whiteColor()
        
        var customSearchButton:UIBarButtonItem = UIBarButtonItem(customView: searchButton)
        customSearchButton.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer, customSearchButton]
    }
    
    func search() {
        let modalStyle = UIModalTransitionStyle.CrossDissolve
        let searchViewController: ProductUploadSearchViewController = ProductUploadSearchViewController(nibName: "ProductUploadSearchViewController", bundle: nil)
        let navigationController: UINavigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
        searchViewController.modalTransitionStyle = modalStyle
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
}
