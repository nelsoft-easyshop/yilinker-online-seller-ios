//
//  AddItemViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate {
    func updateCategoryImages(numberOfImages: Int)
}

class AddItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var delegate: AddItemViewControllerDelegate?
    var productModel: ProductManagementProductModel!
    
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex: Int = -1
    var selectedItem: Int = 0
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        requestGetProductList("")
        customizedNavigationBar()
        customizedViews()
        
        let nib = UINib(nibName: "AddItemTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AddItemTableViewCell")
    }

    // MARK: - Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Add Item"
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
    
    // MARK: - Actions
    
    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkAction() {
        delegate?.updateCategoryImages(selectedItem)
        closeAction()
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
    
    func requestGetProductList(key: String) {
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken(),
                                        "status": "5",
                                        "keyword": key]
        
        manager.POST(APIAtlas.managementGetProductList, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in

            self.productModel = ProductManagementProductModel.parseDataWithDictionary(responseObject as! NSDictionary)
            self.tableView.reloadData()
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                self.hud?.hide(true)
        })
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.productModel != nil {
            return self.productModel.products.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AddItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AddItemTableViewCell") as! AddItemTableViewCell
        cell.selectionStyle = .None
        
        cell.setProductImage(self.productModel.products[indexPath.row].image)
        cell.itemNameLabel.text = self.productModel.products[indexPath.row].name
//        cell.vendorLabel.text = self.productModel.products[indexPath.row].category
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndex = indexPath.row
        
        let cell: AddItemTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! AddItemTableViewCell
        if cell.addImageView?.image == UIImage(named: "addItem") {
            cell.updateStatusImage(true)
            selectedItem++
        } else {
            cell.updateStatusImage(false)
            selectedItem--
        }

    }
    

}
