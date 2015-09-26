//
//  EdititemsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol EditItemsViewControllerDelegate {
//    func updateProductItems(productModel: ProductManagementProductModel, itemIndexes: [Int], products: [ProductManagementProductsModel])
    func updateProductItems(products: [ProductManagementProductsModel])
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
    
    var productModelEdit: [CategoryProductModel] = []
    
    var productModel: ProductManagementProductModel!
    var selectedItemIDsIndex: [Int] = []
    var itemsToRemoved: [Int] = []
    
    var subCategoriesProducts: [ProductManagementProductsModel] = []
    
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
    
    func updateListEdit(productsEdit: [CategoryProductModel]) {
        self.productModelEdit = productsEdit
    }
    
    func showAddItemView() {
        self.title = "Remove Items"
        self.clearAllButton.hidden = false
        self.bottomBarView.hidden = false
        self.removingItems = true
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        self.tableView.reloadData()
    }
    
    func showEditItemView() {
        self.title = "Edit Items"
        self.itemsToRemoved = []
        self.bottomBarView.hidden = true
        self.clearAllButton.hidden = true
        self.removingItems = false
        self.tableView.contentInset = UIEdgeInsetsZero
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func closeAction() {
        if self.title != "Edit items" {
            self.navigationController?.popViewControllerAnimated(false)
        }
    }
    
    func checkAction() {
//        delegate?.updateProductItems(self.productModel, itemIndexes: self.selectedItemIDsIndex, products: subCategoriesProducts)
        delegate?.updateProductItems(subCategoriesProducts)
        closeAction()
    }
    
    @IBAction func clearAllAction(sender: AnyObject!) {
        
//        self.selectedItemIDsIndex = []
//        self.tableView.reloadData()
//        self.cancel(nil)
        self.productModelEdit = []
        self.subCategoriesProducts = []
        showEditItemView()
    }
    
    @IBAction func removeItemsAction(sender: AnyObject) {
//        self.clearAllButton.hidden = false
//        self.bottomBarView.hidden = false
//        self.removingItems = true
        
        if subCategoriesProducts.count != 0 {
           showAddItemView()
        }

    }
    
    @IBAction func addItem(sender: AnyObject) {
        let addItem = AddItemViewController(nibName: "AddItemViewController", bundle: nil)
        addItem.delegate = self
        addItem.selectedProductsModel = subCategoriesProducts
//        addItem.selectedItemIDsIndex = selectedItemIDsIndex
        addItem.productModel = productModel
        addItem.productModelEdit = self.productModelEdit
        self.navigationController?.pushViewController(addItem, animated: false)
    }
    
    @IBAction func removedSelectedAction(sender: AnyObject) {
        
        for i in 0..<itemsToRemoved.count {
            subCategoriesProducts.removeAtIndex(itemsToRemoved[i])
        }
        showEditItemView()
    }
    
    @IBAction func cancel(sender: AnyObject!) {
        self.title = "Edit Items"
        showEditItemView()
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productModelEdit.count != 0 {
            return productModelEdit.count
        } else if self.subCategoriesProducts.count != 0 {
            return self.subCategoriesProducts.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if removingItems {
            let cell: RemovedItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("RemovedItem") as! RemovedItemTableViewCell
            cell.delegate = self
            cell.selectionStyle = .None
            cell.tag = indexPath.row
            cell.deselected()
            
            if productModelEdit.count != 0 {
                cell.setProductImage(self.productModelEdit[indexPath.row].image)
                cell.itemLabel.text = self.productModelEdit[indexPath.row].productName
            } else if subCategoriesProducts.count != 0 {
                cell.setProductImage(self.subCategoriesProducts[indexPath.row].image)
                cell.itemLabel.text = self.subCategoriesProducts[indexPath.row].name
            } else {
                cell.setProductImage(self.productModel.products[indexPath.row].image)
                cell.itemLabel.text = self.productModel.products[indexPath.row].name
            }
            
            return cell
            
        } else {
            let cell: AddItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AddItemTableViewCell") as! AddItemTableViewCell
            cell.selectionStyle = .None
            
            if productModelEdit.count != 0 {
                cell.setProductImage(self.productModelEdit[indexPath.row].image)
                cell.itemNameLabel.text = self.productModelEdit[indexPath.row].productName
            } else if subCategoriesProducts.count != 0 {
                cell.setProductImage(self.subCategoriesProducts[indexPath.row].image)
                cell.itemNameLabel.text = self.subCategoriesProducts[indexPath.row].name
            } else {
                cell.setProductImage(self.productModel.products[indexPath.row].image)
                cell.itemNameLabel.text = self.productModel.products[indexPath.row].name
            }
            
//           cell.vendorLabel.text = self.productModel.products[indexPath.row].category
//            cell.addImageView.image = UIImage(named: "right2")
            cell.addImageView.hidden = true
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    // MARK - Removed Item Table View Cell Delegate
    
    func addSelectedItems(index: Int) {
//        self.itemsToRemoved.append(self.subCategoriesProducts[index].id)
        self.itemsToRemoved.append(index)
    }
    
    func removeSelectedItems(index: Int) {
//        self.itemsToRemoved = self.itemsToRemoved.filter({$0 != self.subCategoriesProducts[index].id})
        self.itemsToRemoved = self.itemsToRemoved.filter({$0 != index})
    }
    
    // MARK: - Add Item View Controller Delegate
    
    func addProductItems(productModel: ProductManagementProductModel, itemIndexes: [Int], products: [ProductManagementProductsModel]) {
        println("From Add Item to Edit Item \(products)")
        self.selectedItemIDsIndex = itemIndexes
        self.subCategoriesProducts = products
        self.tableView.reloadData()
    }
    
}
