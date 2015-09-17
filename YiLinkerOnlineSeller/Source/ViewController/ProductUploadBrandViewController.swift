//
//  ProductUploadBrandViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadBrandViewControllerDelegate {
    func productUploadBrandViewController(didSelectBrand brand: String, brandModel: BrandModel)
}

class ProductUploadBrandViewController: UIViewController, UITabBarControllerDelegate, UITableViewDataSource {
    
    @IBOutlet weak var brandTextField: UITextField!    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ProductUploadBrandViewControllerDelegate?
    var brands: NSMutableArray = NSMutableArray()
    var selectedBrandModel: BrandModel = BrandModel(name: "", brandId: 0)
    var searchTask: NSURLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.backButton()
        self.checkButton()
        self.title = "Add Brand"
        
        self.registerCell()
        
        self.brandTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        let footerView: UIView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = footerView
    }
    
    func backButton() {
        let backButton:UIButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        let customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    
    func checkButton() {
        let checkButton:UIButton = UIButton(type: UIButtonType.Custom)
        checkButton.frame = CGRectMake(0, 0, 40, 40)
        checkButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check"), forState: UIControlState.Normal)
        let customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer, customCheckButton]
    }
    
    
    func fireBrandWithKeyWord(keyWord: String) {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken(), "brandKeyword": keyWord]
        
        if self.searchTask != nil {
            self.searchTask!.cancel()
        }
        
        self.searchTask = manager.GET(APIAtlas.brandUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            let dictionary: NSDictionary = responseObject as! NSDictionary
            let isSuccessful = dictionary["isSuccessful"] as! Bool
            let data: [NSDictionary] = dictionary["data"] as! [NSDictionary]
            if isSuccessful {
                self.brands.removeAllObjects()
                for brandDictionary in data {
                    let brandModel: BrandModel = BrandModel(name: brandDictionary["name"] as! String, brandId: brandDictionary["brandId"] as! Int)
                    self.brands.addObject(brandModel)
                }
                self.tableView.reloadData()
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                if error.code != NSURLErrorCancelled {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "RefreshToken Expired/ No available API for refershing accessToken", title: "Server Error")
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    }
                }
            })
    }
    
    
    func textFieldDidChange(sender: UITextField) {
        self.fireBrandWithKeyWord(sender.text!)
    }
    
    func registerCell() {
        let nib: UINib = UINib(nibName: ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier)
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func check() {
        self.delegate!.productUploadBrandViewController(didSelectBrand: self.brandTextField.text!, brandModel: self.selectedBrandModel)
        self.back()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.brands.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let brandModel: BrandModel = self.brands.objectAtIndex(indexPath.row) as! BrandModel
        let cell: ProductUploadCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(ProductUploadCategoryViewControllerConstant.productUploadCategoryTableViewCellNibNameAndIdentifier) as! ProductUploadCategoryTableViewCell
        cell.categoryTitleLabel.text = brandModel.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let brandModel: BrandModel = self.brands.objectAtIndex(indexPath.row) as! BrandModel
        self.selectedBrandModel = brandModel
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.brandTextField.text = brandModel.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Dealloc
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
}
