//
//  ViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by @EasyShop.ph on 8/24/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let dashBoardHeaderIdentifier: String = "DashBoardHeaderCollectionViewCell"
    let dashBoardItemIdentifier: String = "DashBoardItemCollectionViewCell"

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loginBlockerView: UIView!
    
    var tableData: [String] = ["My\nStore", "Sales\nReport", "Transactions", "Product\nManagement", "Customized\nCategory", "Upload\nItem", "Followers", "Activity\nLog", "My\nPoints", "Resolution\nCenter", "Help", "Logout"]
    
    var tableImages: [String] = ["mystore", "report", "transaction", "product", "category", "uploadItem", "followers", "activityLog", "points", "resolution", "help", "logout"]
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController!.tabBar.tintColor = Constants.Colors.appTheme
        if !NSUserDefaults.standardUserDefaults().boolForKey("rememberMe") {
            SessionManager.setAccessToken("")
            let signInViewController = SignInViewController(nibName: "SignInViewController", bundle: nil)
            self.presentViewController(signInViewController, animated: false, completion: nil)
        }
        println(SessionManager.accessToken())
        registerNibs()
        initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true

        if SessionManager.isLoggedIn() {
            self.loginBlockerView.hidden = true
        } else {
            self.loginBlockerView.hidden = false
        }

        self.tabBarController?.tabBar.hidden = false
    }
    
    func initializeViews() {
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.Bottom
        }
        
        self.tabBarController!.tabBar.tintColor = Constants.Colors.appTheme
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 340.0)
        
        if screenHeight <= 480 {
            layout.itemSize = CGSize(width: ((screenWidth - 32)/4), height: (screenHeight * 0.22))
        } else {
            layout.itemSize = CGSize(width: ((screenWidth - 32)/4), height: (screenHeight * 0.19))
        }
        
        layout.sectionInset = UIEdgeInsetsMake(0, 16.0, 0, 16.0)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.bounces = false
        collectionView?.alwaysBounceVertical = true
    }
    
    func registerNibs() {
        var cellHeaderNib = UINib(nibName: dashBoardHeaderIdentifier, bundle: nil)
        self.collectionView?.registerNib(cellHeaderNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: dashBoardHeaderIdentifier)
        
        var cellNib = UINib(nibName: dashBoardItemIdentifier, bundle: nil)
        self.collectionView?.registerNib(cellNib, forCellWithReuseIdentifier: dashBoardItemIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return tableData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: DashBoardItemCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(dashBoardItemIdentifier, forIndexPath: indexPath) as! DashBoardItemCollectionViewCell
        
        cell.setText(tableData[indexPath.row])
        cell.setIconImage(UIImage(named: tableImages[indexPath.row])!)
        
        if tableImages[indexPath.row] == "uploadItem" {
            cell.iconView.backgroundColor = Constants.Colors.uploadViewColor
        } else {
            cell.iconView.backgroundColor = Constants.Colors.productPrice
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: dashBoardHeaderIdentifier, forIndexPath: indexPath) as! DashBoardHeaderCollectionViewCell
            headerView.setCoverPhoto("http://g.fastcompany.net/multisite_files/fastcompany/slideshow/2013/07/3014720-slide-i-1-after-five-years-beats-redesigns-studio-headphones.jpg")
            headerView.setProfilePhoto("http://cdn-www.xda-developers.com/wp-content/uploads/2011/10/beats-by_dr_dre-04.jpg")
            
            var gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = CGRectMake(0, 0, view.frame.width, 20)
            gradient.colors = [UIColor.grayColor().CGColor, UIColor.clearColor().CGColor]
            headerView.layer.insertSublayer(gradient, atIndex: 1)
            
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Clicked item \(tableData[indexPath.row])")
        if indexPath.row == 0 {
            var storeInfoViewController = StoreInfoViewController(nibName: "StoreInfoViewController", bundle: nil)
            self.navigationController?.pushViewController(storeInfoViewController, animated:true)
        } else if indexPath.row == 0 {
           
        } else if indexPath.row == 1 {
            var salesViewController = SalesReportViewController(nibName: "SalesReportViewController", bundle: nil)
            self.navigationController?.pushViewController(salesViewController, animated:true)
        } else if indexPath.row == 2 {
            let transaction = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
            transaction.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(transaction, animated: true)
        } else if indexPath.row == 3 {
            let productManagement = ProductManagementViewController(nibName: "ProductManagementViewController", bundle: nil)
            productManagement.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(productManagement, animated: true)
        } else if indexPath.row == 4 {
            var customizedCategory = CustomizedCategoryViewController(nibName: "CustomizedCategoryViewController", bundle: nil)
            self.navigationController?.pushViewController(customizedCategory, animated:true)
        } else if indexPath.row == 5 {
            let productUploadTableViewController: ProductUploadTableViewController = ProductUploadTableViewController(nibName: "ProductUploadTableViewController", bundle: nil)
            let navigationController: UINavigationController = UINavigationController(rootViewController: productUploadTableViewController)
            navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
            self.tabBarController!.presentViewController(navigationController, animated: true, completion: nil)
        } else if indexPath.row == 6 {
            var followerController = FollowersViewController(nibName: "FollowersViewController", bundle: nil)
            self.navigationController?.pushViewController(followerController, animated:true)
        } else if indexPath.row == 7 {
            var activityViewController = ActivityLogTableViewController(nibName: "ActivityLogTableViewController", bundle: nil)
            self.navigationController?.pushViewController(activityViewController, animated:true)
        } else if indexPath.row == 8 {
            var myPointsViewController = MyPointsTableViewController(nibName: "MyPointsTableViewController", bundle: nil)
            self.navigationController?.pushViewController(myPointsViewController, animated:true)
            
        } else if indexPath.row == 9 {
            let resolutionCenter = self.storyboard?.instantiateViewControllerWithIdentifier("ResolutionCenterViewController")
                as! ResolutionCenterViewController
            resolutionCenter.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(resolutionCenter, animated:true)
        } else if indexPath.row == 10 {
            
        } else if indexPath.row == 11 {
            var alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: "Logout", style: .Destructive, handler: { action in
                switch action.style{
                case .Default:
                    println("default")
                    
                case .Cancel:
                    println("cancel")
                    
                case .Destructive:
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "rememberMe")
                    let signInViewController = SignInViewController(nibName: "SignInViewController", bundle: nil)
                    self.presentViewController(signInViewController, animated: true, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}

