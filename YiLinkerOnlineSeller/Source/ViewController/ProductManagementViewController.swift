//
//  ProductManagementViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/25/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductManagementViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var pageTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeNavigationBar()
        self.searchBar.barTintColor = Constants.Colors.appTheme
        self.searchBar.tintColor = Constants.Colors.appTheme
        self.searchBar.barStyle = UIBarStyle.Default
//        self.scrollView.frame.origin.y = 0.0
//        self.scrollView.center = self.view.center
//        println(self.scrollView.center)
        
        let nib = UINib(nibName: "ProductManagementTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "ProductManagementIdentifier")
        
    }

    // MARK: - Methods
    
    func customizeNavigationBar() {

        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Product Management"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "search"), style: .Plain, target: self, action: "searchAction"), navigationSpacer]
        
//        //extending navigation bar
//        
//        self.navigationController?.navigationBar.translucent = false
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
//        self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
//        
//        //navigation bar shadow
//        self.view.layer.shadowOffset = CGSizeMake(0, 1.0 / UIScreen.mainScreen().scale)
//        self.view.layer.shadowRadius = 0
//        
//        self.view.layer.shadowColor = Constants.Colors.appTheme.CGColor
//        self.view.layer.shadowOpacity = 0.25

    }
    
    func sectionHeaderView() -> UIView {
        var sectionHeaderContainverView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        sectionHeaderContainverView.backgroundColor = UIColor.whiteColor()
        
        let title: String = "Active"
        let buttonWidth: CGFloat = 80.0
        let lineThin: CGFloat = 0.5
        
        var tabLabel = UILabel(frame: CGRectZero)
        tabLabel.text = title
        tabLabel.textColor = UIColor.darkGrayColor()
        tabLabel.font = UIFont.systemFontOfSize(13.0)
        tabLabel.sizeToFit()
        tabLabel.center.y = sectionHeaderContainverView.center.y
        tabLabel.frame.origin.x = 10.0
        sectionHeaderContainverView.addSubview(tabLabel)
        
        var disableDeleteAllButton = UIButton(frame: CGRectMake(self.view.frame.size.width - buttonWidth, 0, buttonWidth, sectionHeaderContainverView.frame.size.height))
        disableDeleteAllButton.setTitle("Disable All", forState: .Normal)
        disableDeleteAllButton.titleLabel?.font = UIFont.systemFontOfSize(11.0)
        disableDeleteAllButton.setTitleColor(Constants.Colors.appTheme, forState: .Normal)
        disableDeleteAllButton.addTarget(self, action: "sectionButton:", forControlEvents: .TouchUpInside)
        sectionHeaderContainverView.addSubview(disableDeleteAllButton)

        if pageTitle == "Inactive" {
            disableDeleteAllButton.setTitle("Delete All", forState: .Normal)
            var separatorLineView = UIView(frame: CGRectMake(disableDeleteAllButton.frame.origin.x - lineThin, 0, lineThin, sectionHeaderContainverView.frame.size.height - 10))
            separatorLineView.center.y = sectionHeaderContainverView.center.y
            separatorLineView.backgroundColor = UIColor.lightGrayColor()
            sectionHeaderContainverView.addSubview(separatorLineView)
            
            var restoreAllButton = UIButton(frame: CGRectMake(separatorLineView.frame.origin.x - buttonWidth, 0, buttonWidth, sectionHeaderContainverView.frame.size.height))
            restoreAllButton.setTitle("Restore All", forState: .Normal)
            restoreAllButton.titleLabel?.font = UIFont.systemFontOfSize(11.0)
            restoreAllButton.setTitleColor(Constants.Colors.appTheme, forState: .Normal)
            restoreAllButton.addTarget(self, action: "sectionButton:", forControlEvents: .TouchUpInside)
            sectionHeaderContainverView.addSubview(restoreAllButton)
        }
        
        var underlineView = UIView(frame: CGRectMake(0, sectionHeaderContainverView.frame.size.height - lineThin, sectionHeaderContainverView.frame.size.width, lineThin))
        underlineView.backgroundColor = UIColor.lightGrayColor()
        sectionHeaderContainverView.addSubview(underlineView)
        
        return sectionHeaderContainverView
    }
    
    // MARK: - Actions
    
    func backAction() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func searchAction() {
        if searchBar.hidden {
            self.searchBar.becomeFirstResponder()
            self.searchBar.hidden = false
            self.scrollView.transform = CGAffineTransformMakeTranslation(0.0, 44.0)
            self.tableView.transform = CGAffineTransformMakeTranslation(0.0, 44.0)
        } else {
            self.searchBar.endEditing(true)
            self.searchBar.hidden = true
            self.scrollView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
            self.tableView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
        }
        
    }
    
    func sectionButton(sender: AnyObject) {

        if sender.titleLabel!!.text == "Disable All" {
            
        } else if sender.titleLabel!!.text == "Delete All" {
            
        } else if sender.titleLabel!!.text == "Restore All" {
            
        }
    }
} // ProductManagementViewController



extension ProductManagementViewController: UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Search Bar Delegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProductManagementTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("ProductManagementIdentifier") as! ProductManagementTableViewCell
        
        return cell
    }
    
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let productDetails = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        self.navigationController?.pushViewController(productDetails, animated: true)
    }
}
