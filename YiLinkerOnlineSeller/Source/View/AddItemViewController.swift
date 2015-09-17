//
//  AddItemViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate {
    func addProductItems(productModel: ProductManagementProductModel, itemIndexes: [Int], products: [ProductManagementProductsModel])
}

class AddItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var delegate: AddItemViewControllerDelegate?
    var productModel: ProductManagementProductModel!
    var productModelEdit: [CategoryProductModel] = []
    
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var selectedItemIDs: [String] = []
    var selectedProductsModel: [ProductManagementProductsModel] = []
    var selectedItemIDsIndex: [Int] = []
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if selectedItemIDsIndex.count == 0 {
//            requestGetProductList("")
//        }
        
//        if selectedProductsModel.count == 0 {
            requestGetProductList("")
//        }
        customizedNavigationBar()
        customizedViews()
        
        let nib = UINib(nibName: "AddItemTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AddItemTableViewCell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        println(self.selectedItemIDs)
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
        
        let searchImage = UIImageView(image: UIImage(named: "search2"))
        searchImage.frame = CGRectMake(0.0, 0.0,40.0, 40.0)
        searchImage.contentMode = UIViewContentMode.Center
        searchBarTextField.leftView = searchImage
        searchBarTextField.leftViewMode = UITextFieldViewMode.Always
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: - Actions
    
    func closeAction() {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func checkAction() {
//        if self.selectedItemIDs.count != 0 {
//            delegate?.updateCategoryImages(self.productModel, itemIDs: self.selectedItemIDs)
//        }

//        if self.selectedItemIDsIndex.count != 0 {
//            delegate?.addProductItems(self.productModel, itemIndexes: self.selectedItemIDsIndex, products: selectedItemIDs)
//        }
        
        if selectedItemIDs.count != 0 {
//            delegate?.addProductItems(self.productModel, itemIndexes: self.selectedItemIDsIndex, products: selectedItemIDs)
            for i in 0..<self.productModel.products.count {
                if self.selectedItemIDs.contains(self.productModel.products[i].id) {
                    selectedProductsModel.append(self.productModel.products[i])
                }
            }
            delegate?.addProductItems(self.productModel, itemIndexes: selectedItemIDsIndex, products: selectedProductsModel)
        }
        
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
                                        "status": "2",
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
        
//        if productModelEdit.count != 0 {
//            for i in 0..<productModelEdit.count {
//                if i == self.productModelEdit[indexPath.row].productId {
//                    
//                }
//            }
//        }
        
        cell.setProductImage(self.productModel.products[indexPath.row].image)
        cell.itemNameLabel.text = self.productModel.products[indexPath.row].name
//        cell.vendorLabel.text = self.productModel.products[indexPath.row].category
        
//        if (find(selectedItemIDsIndex, indexPath.row) != nil) {
//            cell.updateStatusImage(true)
//        } else {
//            cell.updateStatusImage(false)
//        }
        
        if (selectedItemIDs.indexOf(productModel.products[indexPath.row].id) != nil) {
            cell.updateStatusImage(true)
        } else {
            cell.updateStatusImage(false)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: AddItemTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! AddItemTableViewCell
//        let productId: Int = self.productModel.products[indexPath.row].id.toInt()!

        if cell.addImageView?.image == UIImage(named: "addItem") {
            cell.updateStatusImage(true)
            selectedItemIDs.append(self.productModel.products[indexPath.row].id)
//            selectedItemIDsIndex.append(indexPath.row)
        } else {
            cell.updateStatusImage(false)
            selectedItemIDs = selectedItemIDs.filter({$0 != self.productModel.products[indexPath.row].id})
//            selectedItemIDsIndex = selectedItemIDsIndex.filter({$0 != indexPath.row})
        }
        
        print(selectedItemIDs)
//        println(selectedItemIDsIndex)

    }
    

}
