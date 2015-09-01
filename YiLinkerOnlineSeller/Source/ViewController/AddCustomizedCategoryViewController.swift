//
//  AddCustomizedCategoryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class AddCustomizedCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var headerView: UIView!
    var categoryDetailsView: CCCategoryDetailsView!
    var footerView: UIView!
    var categoryItemsView: CCCategoryItemsView!
    var itemImagesView: CCCItemImagesView!
    var seeAllItemsView: UIView!
    var newFrame: CGRect!
    
    var subCategoriesItems: Int = 0
    var imageItems: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizedNavigationBar()
        customizedViews()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        loadViewsWithDetails()
    }
    // MARK: Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Customized Category"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeAction")
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "check"), style: .Plain, target: self, action: "checkAction"), navigationSpacer]
    }
    
    func customizedViews() {
        let nib = UINib(nibName: "AddCustomizedCategoryTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AddCustomizedCategory")
        self.tableView.backgroundColor = Constants.Colors.backgroundGray
    }
    
    func getHeaderView() -> UIView {
        if self.headerView == nil {
            self.headerView = UIView(frame: CGRectZero)
            self.headerView.autoresizesSubviews = false
            self.headerView.backgroundColor = Constants.Colors.backgroundGray
        }
        return self.headerView
    }
    
    func getCategoryDetailsView() -> CCCategoryDetailsView {
        if self.categoryDetailsView == nil {
            self.categoryDetailsView = XibHelper.puffViewWithNibName("CustomizedCategoryViewsViewController", index: 0) as! CCCategoryDetailsView
            self.categoryDetailsView.frame.size.width = self.view.frame.size.width
        }
        return self.categoryDetailsView
    }
    
    func getFooterView() -> UIView {
        if self.footerView == nil {
            self.footerView = UIView(frame: CGRectZero)
            self.footerView.autoresizesSubviews = false
            self.footerView.backgroundColor = Constants.Colors.backgroundGray
        }
        return self.footerView
    }
    
    func getCategoryItemsView() -> CCCategoryItemsView {
        if self.categoryItemsView == nil {
            self.categoryItemsView = XibHelper.puffViewWithNibName("CustomizedCategoryViewsViewController", index: 2) as! CCCategoryItemsView

            self.categoryItemsView.frame.size.width = self.view.frame.size.width
        }
        return self.categoryItemsView
    }
    
    func getItemImageView() -> CCCItemImagesView {
        if self.itemImagesView == nil {
            self.itemImagesView = XibHelper.puffViewWithNibName("CustomizedCategoryViewsViewController", index: 3) as! CCCItemImagesView
            self.itemImagesView.frame.size.width = self.view.frame.size.width
        }
        return self.itemImagesView
    }
    
    func getSeeAllItemsView() -> UIView {
        self.seeAllItemsView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 45))
        self.seeAllItemsView.backgroundColor = UIColor.whiteColor()
        
        var seeAllItemsLabel = UILabel(frame: CGRectZero)
        seeAllItemsLabel.text = "See all " + "20" + " items   "
        seeAllItemsLabel.font = UIFont(name: "Panton-Bold", size: 12.0)
        seeAllItemsLabel.textColor = UIColor.darkGrayColor()
        seeAllItemsLabel.sizeToFit()
        seeAllItemsLabel.center = self.seeAllItemsView.center
        self.seeAllItemsView.addSubview(seeAllItemsLabel)
        
        var arrowImageView = UIImageView(frame: CGRectMake(CGRectGetMaxX(seeAllItemsLabel.frame), 18, 7, 10))
        arrowImageView.image = UIImage(named: "right2")
        self.seeAllItemsView.addSubview(arrowImageView)
        
        return self.seeAllItemsView
    }
    
    func loadViewsWithDetails() {
        self.getHeaderView().addSubview(getCategoryDetailsView())
        
        self.getFooterView().addSubview(getCategoryItemsView())
        if imageItems != 0 {
            self.categoryItemsView.addNewItemButton.setTitle("EDIT", forState: .Normal)
            self.getFooterView().addSubview(getItemImageView())
            self.getFooterView().addSubview(getSeeAllItemsView())
        }
        
        setUpViews()
    }
    
    func setUpViews() {
        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.categoryDetailsView.frame)
        self.headerView.frame = newFrame
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
        
        newFrame = self.footerView.frame
        
        if imageItems != 0 {
            setPosition(self.itemImagesView, from: self.categoryItemsView)
            setPosition(self.seeAllItemsView, from: self.itemImagesView)
            newFrame.size.height = CGRectGetMaxY(self.seeAllItemsView.frame) + 20.0
        } else {
            newFrame.size.height = CGRectGetMaxY(self.categoryItemsView.frame)
        }
        
        self.footerView.frame = newFrame
        self.tableView.tableFooterView = nil
        self.tableView.tableFooterView = self.footerView
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame)
        if view == self.seeAllItemsView {
            newFrame.origin.y += 1
        }
        view.frame = newFrame
    }

    // MARK: - Actions
    
    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func checkAction() {
        
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var subCategoriesView = XibHelper.puffViewWithNibName("CustomizedCategoryViewsViewController", index: 1) as! CCSubCategoriesView
        if subCategoriesItems != 0 {
            subCategoriesView.setTitle("EDIT")
        }
        
        return subCategoriesView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategoriesItems
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AddCustomizedCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AddCustomizedCategory") as! AddCustomizedCategoryTableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    

}
