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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageTitle: [String] = ["All", "Active", "Inactive", "Drafts", "Deleted", "Under Review"]
    var selectedImage: [String] = ["all2", "active2", "inactive2", "drafts2", "deleted2", "review2"]
    var deSelectedImage: [String] = ["all", "active", "inactive", "drafts", "deleted", "review"]
    
    var selectedIndex: Int = 0
    var tableViewSectionHeight: CGFloat = 0
    var tableViewSectionTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeNavigationBar()
        self.searchBar.barTintColor = Constants.Colors.appTheme
        self.searchBar.tintColor = Constants.Colors.appTheme
        self.searchBar.barStyle = UIBarStyle.Default
        
        let nib = UINib(nibName: "ProductManagementTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "ProductManagementIdentifier")
        
        let nibCVC = UINib(nibName: "ProductManagementCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(nibCVC, forCellWithReuseIdentifier: "ProductManagementIdentifier")
        
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
        
        let buttonWidth: CGFloat = 80.0
        let lineThin: CGFloat = 0.5
        
        var tabLabel = UILabel(frame: CGRectZero)
        tabLabel.text = pageTitle[selectedIndex]
        tabLabel.textColor = UIColor.darkGrayColor()
        tabLabel.font = UIFont.systemFontOfSize(13.0)
        tabLabel.sizeToFit()
        tabLabel.center.y = sectionHeaderContainverView.center.y
        tabLabel.frame.origin.x = 10.0
        sectionHeaderContainverView.addSubview(tabLabel)
        
        var button1 = UIButton(frame: CGRectMake(self.view.frame.size.width - buttonWidth, 0, buttonWidth, sectionHeaderContainverView.frame.size.height))
        button1.titleLabel?.font = UIFont.systemFontOfSize(11.0)
        button1.setTitleColor(Constants.Colors.appTheme, forState: .Normal)
        button1.addTarget(self, action: "tabAction:", forControlEvents: .TouchUpInside)
        sectionHeaderContainverView.addSubview(button1)
        
        if selectedIndex == 1 {
            button1.setTitle("Disable All", forState: .Normal)
        } else if selectedIndex == 2 || selectedIndex == 3 {
            button1.setTitle("Delete All", forState: .Normal)
        
            if selectedIndex == 2 {
                var separatorLineView = UIView(frame: CGRectMake(button1.frame.origin.x - lineThin, 0, lineThin, sectionHeaderContainverView.frame.size.height - 10))
                separatorLineView.center.y = sectionHeaderContainverView.center.y
                separatorLineView.backgroundColor = UIColor.lightGrayColor()
                sectionHeaderContainverView.addSubview(separatorLineView)
                
                var restoreAllButton = UIButton(frame: CGRectMake(separatorLineView.frame.origin.x - buttonWidth, 0, buttonWidth, sectionHeaderContainverView.frame.size.height))
                restoreAllButton.setTitle("Restore All", forState: .Normal)
                restoreAllButton.titleLabel?.font = UIFont.systemFontOfSize(11.0)
                restoreAllButton.setTitleColor(Constants.Colors.appTheme, forState: .Normal)
                restoreAllButton.addTarget(self, action: "tabAction:", forControlEvents: .TouchUpInside)
                sectionHeaderContainverView.addSubview(restoreAllButton)
            }
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
            self.collectionView.transform = CGAffineTransformMakeTranslation(0.0, 44.0)
            self.tableView.transform = CGAffineTransformMakeTranslation(0.0, 44.0)
        } else {
            self.searchBar.endEditing(true)
            self.searchBar.hidden = true
            self.collectionView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
            self.tableView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
        }
        
    }
    
    func tabAction(sender: AnyObject) {

        if selectedIndex == 1 {
            println(pageTitle[selectedIndex] + " " + sender.titleLabel!!.text!)
        } else if selectedIndex == 2 {
            if sender.titleLabel!!.text == "Delete All" {
                println(pageTitle[selectedIndex] + " " + sender.titleLabel!!.text!)
            } else if sender.titleLabel!!.text == "Restore All" {
                println(pageTitle[selectedIndex] + " " + sender.titleLabel!!.text!)
            }
        } else if selectedIndex == 3 {
            println(pageTitle[selectedIndex] + " " + sender.titleLabel!!.text!)
        }
    }
    
} // ProductManagementViewController



extension ProductManagementViewController: UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
        cell.selectionStyle = .None
        cell.index = selectedIndex
        cell.clearCheckImage()
        
        return cell
    }
    
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewSectionHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let productDetails = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        self.navigationController?.pushViewController(productDetails, animated: true)
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductManagementCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("ProductManagementIdentifier", forIndexPath: indexPath) as! ProductManagementCollectionViewCell
        
        cell.titleLabel.text = pageTitle[indexPath.row].capitalizedString
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = .whiteColor()
            cell.setTextColor(Constants.Colors.appTheme)
            cell.setImage(selectedImage[indexPath.row])
        } else {
            cell.setTextColor(UIColor.whiteColor())
            cell.backgroundColor = Constants.Colors.appTheme
            cell.setImage(deSelectedImage[indexPath.row])
        }
        
        
        
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        
        if selectedIndex == 0 {
            self.tableViewSectionHeight = 0.0
        } else {
            self.tableViewSectionHeight = 40.0
        }
        
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return
            CGSize(width: self.view.frame.size.width / 6, height: 60)
    }
}
