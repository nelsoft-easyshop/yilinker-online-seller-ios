//
//  ProductDetailsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct myConstant {
    static let cellIdentifier = "ProductDetailsIdentifier"
}

class ProductDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProductDescriptionViewDelegate {

    var headerView: UIView!
    var productImagesView: ProductImagesView!
    var productDescriptionView: ProductDescriptionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var newFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeNavigationBar()
        
        let nib = UINib(nibName: "ProductDetailsTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: myConstant.cellIdentifier)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadloadViewsWithDetails()
    }
    
    // MARK: - Init Views
    
    func getHeaderView() -> UIView {
        if self.headerView == nil {
            self.headerView = UIView(frame: CGRectZero)
            self.headerView.backgroundColor = Constants.Colors.backgroundGray
        }
        return self.headerView
    }
    
    func getProductImagesView() -> ProductImagesView {
        if self.productImagesView == nil {
            self.productImagesView = XibHelper.puffViewWithNibName("ProductDetailViews", index: 0) as! ProductImagesView
            
            self.productImagesView.frame.size.width = self.view.frame.size.width
        }
        return self.productImagesView
    }
    
    func getProductDescriptionView() -> ProductDescriptionView {
        if self.productDescriptionView == nil {
            self.productDescriptionView = XibHelper.puffViewWithNibName("ProductDetailViews", index: 1) as! ProductDescriptionView
            self.productDescriptionView.frame.size.width = self.view.frame.size.width
            self.productDescriptionView.delegate = self
        }
        return self.productDescriptionView
    }
    
    // MARK: - Methods
    
    func customizeNavigationBar() {
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Product Details"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton = UIBarButtonItem(image: UIImage(named: "back-white"), style: .Plain, target: self, action: "backAction")
        var editButton = UIBarButtonItem(image: UIImage(named: "edit"), style: .Plain, target: self, action: "editAction")
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, backButton]
        self.navigationItem.rightBarButtonItem = editButton
        
    }
    
    func loadloadViewsWithDetails() {
        // Adding views
        self.getHeaderView().addSubview(self.getProductImagesView())
        self.getHeaderView().addSubview(self.getProductDescriptionView())
        
        // Positioning Views
        self.setPosition(self.productDescriptionView, from: self.productImagesView)
        
        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.productDescriptionView.frame) + 15.0
        self.headerView.frame = newFrame
        
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame) + 15.0
        view.frame = newFrame
    }
    
    func sectionHeaderView() -> UIView {
        var sectionView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 45.0))
        sectionView.backgroundColor = UIColor.whiteColor()
        
        var titleLabel = UILabel(frame: CGRectMake(10.0, 0, self.view.frame.size.width - 10.0, sectionView.frame.size.height))
        titleLabel.text = "Title"
        titleLabel.font = UIFont.boldSystemFontOfSize(17.0)
        sectionView.addSubview(titleLabel)
        
        var underlineView = UIView(frame: CGRectMake(0, sectionView.frame.size.height - 1, self.view.frame.size.width, 1))
        underlineView.backgroundColor = Constants.Colors.backgroundGray
//        sectionView.addSubview(underlineView)
        
        return sectionView
    }
    
    // MARK: - Actions
    
    func backAction() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func editAction() {
        let alertController = UIAlertController(title: "YiLinker", message: "Goto Upload Page.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "CLOSE", style: .Destructive, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProductDetailsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(myConstant.cellIdentifier) as! ProductDetailsTableViewCell
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView()
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 10.0))
        footerView.backgroundColor = Constants.Colors.backgroundGray
        
        return footerView
    }

    // MARK: - Product Description Delegate
    
    func gotoDescriptionViewController(view: ProductDescriptionView) {
        let productDescription = ProductDescriptionViewController(nibName: "ProductDescriptionViewController", bundle: nil)
        self.navigationController?.presentViewController(productDescription, animated: true, completion: nil)
    }
}
