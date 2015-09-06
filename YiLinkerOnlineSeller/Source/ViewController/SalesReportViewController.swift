//
//  SalesReportViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class SalesReportViewController: UIViewController, UISearchBarDelegate {
    
    var recentProductsController: RecentProductsTableViewController?
    var salesReportController: SalesReportTableViewController?
    
    @IBOutlet weak var searchHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var salesReportsView: UIView!
    @IBOutlet weak var salesReportImageView: UIImageView!
    @IBOutlet weak var salesReportLabel: UILabel!
    @IBOutlet weak var recentOrdersView: UIView!
    @IBOutlet weak var recentOrdersImageView: UIImageView!
    @IBOutlet weak var recentOrdersLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var searchButton: UIButton!
    
    var currentView: String = "salesReportsView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViewControllers()
        initializeViews()
        initializeNavigationBar()
        initializeTapGesture()
        
        changeViewController(salesReportController!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViewControllers() {
        recentProductsController = RecentProductsTableViewController(nibName: "RecentProductsTableViewController", bundle: nil)
        
        salesReportController = SalesReportTableViewController(nibName: "SalesReportTableViewController", bundle: nil)
    }
    
    func initializeViews() {
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.searchBar.delegate = self
    }
    
    func initializeNavigationBar() {
        self.title = "Report"
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        searchButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        searchButton.frame = CGRectMake(0, 0, 25, 25)
        searchButton.addTarget(self, action: "search", forControlEvents: UIControlEvents.TouchUpInside)
        searchButton.setImage(UIImage(named: "search-white"), forState: UIControlState.Normal)
        searchButton.hidden = true
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: searchButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func search() {
        setSearchBarHidden(false)
    }
    
    func initializeTapGesture() {
        let tapReport = UITapGestureRecognizer()
        tapReport.addTarget(self, action: "tabTapped:")
        salesReportsView.addGestureRecognizer(tapReport)
        
        let tapOrders = UITapGestureRecognizer()
        tapOrders.addTarget(self, action: "tabTapped:")
        recentOrdersView.addGestureRecognizer(tapOrders)
    }
    
    func tabTapped(sender: UITapGestureRecognizer) {
        let senderView: UIView = sender.view!
        
        if senderView == salesReportsView {
            setSearchBarHidden(true)
            searchButton.hidden = true
            
            salesReportsView.backgroundColor = UIColor.whiteColor()
            salesReportLabel.textColor = Constants.Colors.productPrice
            salesReportImageView.image = UIImage(named: "salesReport")
            
            recentOrdersView.backgroundColor = Constants.Colors.productPrice
            recentOrdersLabel.textColor = UIColor.whiteColor()
            recentOrdersImageView.image = UIImage(named: "recentOrders2")
            
            if currentView != "salesReportsView" {
                changeViewController(salesReportController!)
                currentView = "salesReportsView"
            }
        } else {
            searchButton.hidden = false
            
            salesReportsView.backgroundColor = Constants.Colors.productPrice
            salesReportLabel.textColor = UIColor.whiteColor()
            salesReportImageView.image = UIImage(named: "salesReport2")
            
            recentOrdersView.backgroundColor = UIColor.whiteColor()
            recentOrdersLabel.textColor = Constants.Colors.productPrice
            recentOrdersImageView.image = UIImage(named: "recentOrders")
            
            if currentView != "recentOrdersView" {
                changeViewController(recentProductsController!)
                currentView = "recentOrdersView"
            }
        }
        
    }
    
    //Change of View Controller
    func changeViewController(viewController: UIViewController) {
        self.addChildViewController(viewController)
        viewController.view.frame = self.containerView.frame
        viewController.view.frame.origin.y = 0
        containerView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
    
    // Mark: - UISearchBarDelegate
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.sizeToFit()
        self.searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.sizeToFit()
        self.searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        setSearchBarHidden(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    // Hide Show Search bar
    func setSearchBarHidden(hidden: Bool) {
        if hidden {
            UIView.animateWithDuration(0.5, animations: {
                self.searchHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
            self.searchBar.resignFirstResponder()
            self.searchBar.text = ""
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.searchHeightConstraint.constant = 44
                self.view.layoutIfNeeded()
            })
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
