//
//  EdititemsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class EdititemsViewController: UIViewController, AddItemViewControllerDelegate, RemovedItemTableViewCellDelegate {
    
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
    
    // MARK: - Actions
    
    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkAction() {
        closeAction()
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
//        self.selectedIndex = indexPath.row
//        
//        let cell: AddItemTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! AddItemTableViewCell
//        if cell.addImageView?.image == UIImage(named: "addItem") {
//            cell.updateStatusImage(true)
//            selectedItem++
//        } else {
//            cell.updateStatusImage(false)
//            selectedItem--
//        }
        

//        if cell.addImageView?.image == UIImage(named: "addItem") {
//            cell.updateStatusImage(true)
//            selectedItemIDs.append(self.productModel.products[indexPath.row].id)
//            selectedItemIDsIndex.append(indexPath.row)
//        } else {
//            cell.updateStatusImage(false)
//            selectedItemIDs = selectedItemIDs.filter({$0 != self.productModel.products[indexPath.row].id})
//            selectedItemIDsIndex = selectedItemIDsIndex.filter({$0 != indexPath.row})
//        }
    }

    // MARK - Removed Item Table View Cell Delegate
    
    func addSelectedItems(index: Int) {
//        self.itemsToRemoved = self.itemsToRemoved.filter({$0 != index})
        self.selectedItemIDsIndex = self.selectedItemIDsIndex.filter({$0 != index})
        println(self.selectedItemIDsIndex)
    }
    
    func removeSelectedItems(index: Int) {
        self.selectedItemIDsIndex.append(index)
        println(self.selectedItemIDsIndex)
//        self.itemsToRemoved.append(index)
    }
    
    // MARK: - Add Item View Controller Delegate
    
    func updateEditItems(itemIndexes: [Int]) {
        self.selectedItemIDsIndex = itemIndexes
        self.tableView.reloadData()
    }
    
    func updateCategoryImages(productModel: ProductManagementProductModel, itemIndexes: [Int]) {
        
    }
}
