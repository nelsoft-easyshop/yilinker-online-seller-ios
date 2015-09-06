//
//  EdititemsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol EditItemsViewControllerDelegate {
    func updateProductItems(productModel: ProductManagementProductModel, itemIndexes: [Int], products: [Int])
}

class EdititemsViewController: UIViewController, AddItemViewControllerDelegate, RemovedItemTableViewCellDelegate {
    var delegate: EditItemsViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var bottomBarView: UIView!
    
    var selectedIndex: Int = -1
    var selectedItem: Int = 0
    var removingItems: Bool = false
    
    var productModel: ProductManagementProductModel!
    var selectedItemIDsIndex: [Int] = []
    var itemsToRemoved: [Int] = []
    
    var subCategoriesProducts: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        customizedNavigationBar()
        customizedViews()
        
        let nib = UINib(nibName: "AddItemTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AddItemTableViewCell")
        let removedCell = UINib(nibName: "RemovedItemTableViewCell", bundle: nil)
        self.tableView.registerNib(removedCell, forCellReuseIdentifier: "RemovedItem")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        println("Edit Items > \(self.subCategoriesProducts)")
    }
    // MARK: - Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Edit Items"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeAction")
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "check"), style: .Plain, target: self, action: "checkAction"), navigationSpacer]
    }
    
    func customizedViews() {
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func updateListOfItems(productModel: ProductManagementProductModel, itemIndexes: [Int]) {
        self.productModel = productModel
        self.selectedItemIDsIndex = itemIndexes
        
//        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func closeAction() {
        if self.title != "Edit items" {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func checkAction() {
        if self.title != "Edit items" {
            println("From Edit Items > \(subCategoriesProducts)")
            delegate?.updateProductItems(self.productModel, itemIndexes: self.selectedItemIDsIndex, products: subCategoriesProducts)
            closeAction()
        }
    }
    
    @IBAction func clearAllAction(sender: AnyObject) {
        self.selectedItemIDsIndex = []
        self.tableView.reloadData()
        self.cancel(nil)
    }
    
    @IBAction func removeItemsAction(sender: AnyObject) {
        self.clearAllButton.hidden = false
        self.bottomBarView.hidden = false
        self.removingItems = true
        self.title = "Remove Items"
        self.tableView.reloadData()
    }
    
    @IBAction func addItem(sender: AnyObject) {
        let addItem = AddItemViewController(nibName: "AddItemViewController", bundle: nil)
        addItem.delegate = self
        addItem.selectedItemIDs = subCategoriesProducts
        addItem.selectedItemIDsIndex = selectedItemIDsIndex
        addItem.productModel = productModel
        var rootViewController = UINavigationController(rootViewController: addItem)
        self.navigationController?.presentViewController(rootViewController, animated: false, completion: nil)
    }
    
    @IBAction func removedSelectedAction(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    @IBAction func cancel(sender: AnyObject!) {
        self.bottomBarView.hidden = true
        self.clearAllButton.hidden = true
        self.removingItems = false
        self.title = "Edit Items"
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedItemIDsIndex.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if removingItems {
            let cell: RemovedItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("RemovedItem") as! RemovedItemTableViewCell
            cell.delegate = self
            cell.selectionStyle = .None
            cell.tag = indexPath.row
            cell.deselected()
            
            cell.setProductImage(self.productModel.products[indexPath.row].image)
            cell.itemLabel.text = self.productModel.products[indexPath.row].name
            
            return cell
            
        } else {
            let cell: AddItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AddItemTableViewCell") as! AddItemTableViewCell
            cell.selectionStyle = .None
            
            cell.setProductImage(self.productModel.products[indexPath.row].image)
            cell.itemNameLabel.text = self.productModel.products[indexPath.row].name
//           cell.vendorLabel.text = self.productModel.products[indexPath.row].category
            cell.addImageView.image = UIImage(named: "right2")
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    // MARK - Removed Item Table View Cell Delegate
    
    func addSelectedItems(index: Int) {
        self.selectedItemIDsIndex = self.selectedItemIDsIndex.filter({$0 != index})
    }
    
    func removeSelectedItems(index: Int) {
        self.selectedItemIDsIndex.append(index)
    }
    
    // MARK: - Add Item View Controller Delegate
    
    func addProductItems(productModel: ProductManagementProductModel, itemIndexes: [Int], products: [Int]) {
        println("From Add Item to Edit Item \(products)")
        self.selectedItemIDsIndex = itemIndexes
        self.subCategoriesProducts = products
        self.tableView.reloadData()
    }
    
}
