//
//  PayoutViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 1/29/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutViewController: UIViewController {

    // Xibs
    @IBOutlet weak var tabsCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    // Tabs
    var pageTitle: [String] = ["WITHDRAW", "REQUESTS", "RECORD", "EARNINGS"]
    var selectedImage: [String] = ["withdraw", "request", "record", "earning"]
    var deselectedImage: [String] = ["withdraw2", "request2", "record2", "earning2"]
    var selectedIndex: Int = 0
    
    // Controllers
    var withdrawVC: PayoutBalanceWithdrawalViewController?
    var requestVC: PayoutSummaryViewController?
    var recordVC: PayoutBalanceRecordViewController?
    var earningVC: SelectDateViewController?
    // Arrays of view controllers
    var viewControllers = [UIViewController]()
    // Current View Controller
    var currentChildViewController: UIViewController?
    // Child controllers frame
    var containerViewFrame: CGRect?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        initViewControllers()
        
        // called this to resize the buttons
        self.tabsCollectionView.reloadData()
        
    } // view did load
    
    override func viewDidLayoutSubviews() {
        self.containerViewFrame = containerView.bounds
    }
    
    // MARK: - Functions
    
    // MARK: - Setup Views
    func setupViews() {
        
        // Collection View
        self.tabsCollectionView.backgroundColor = Constants.Colors.appTheme
        
        // Collection View Cell
        let nibCVC = UINib(nibName: "ProductManagementCollectionViewCell", bundle: nil)
        self.tabsCollectionView.registerNib(nibCVC, forCellWithReuseIdentifier: "ProductManagementIdentifier")
        
        // Navigation Bar
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Balance Withdrawal"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        self.tabsCollectionView.reloadData()
    }
    
    // MARK: - Init View Controllers
    func initViewControllers() {
        withdrawVC = PayoutBalanceWithdrawalViewController(nibName: "PayoutBalanceWithdrawalViewController", bundle: nil)
        requestVC = PayoutSummaryViewController(nibName: "PayoutSummaryViewController", bundle: nil)
        recordVC = PayoutBalanceRecordViewController(nibName: "PayoutBalanceRecordViewController", bundle: nil)
        earningVC = SelectDateViewController(nibName: "SelectDateViewController", bundle: nil)
        
        self.viewControllers.append(withdrawVC!)
        self.viewControllers.append(requestVC!)
        self.viewControllers.append(recordVC!)
        self.viewControllers.append(earningVC!)
        
        // set withdraw view controller as default view
        setSelectedViewControllerWithIndex(0, transition: UIViewAnimationOptions.TransitionNone)
    }
    
    //MARK: - Set Selected View Controller With Index
    // This function is for executing child view logic code
    func setSelectedViewControllerWithIndex(index: Int, transition: UIViewAnimationOptions) {
        let viewController: UIViewController = viewControllers[index]
        setSelectedViewController(viewController, transition: transition)
    }
    
    //MARK: - Set Selected View Controller
    func setSelectedViewController(viewController: UIViewController, transition: UIViewAnimationOptions) {
        self.view.layoutIfNeeded()
        self.addChildViewController(viewController)
        self.view.layoutIfNeeded()
        self.addChildViewController(viewController)
        viewController.view.frame = self.containerViewFrame!
        
        self.containerView.addSubview(viewController.view)
        
        if self.currentChildViewController != nil {
            self.transitionFromViewController(self.currentChildViewController!, toViewController: viewController, duration: 0, options: transition, animations: nil) { (Bool) -> Void in
                viewController.didMoveToParentViewController(self)
                if !(self.currentChildViewController == viewController) {
                    if self.isViewLoaded() {
                        self.currentChildViewController?.willMoveToParentViewController(self)
                        self.currentChildViewController?.view.removeFromSuperview()
                        self.currentChildViewController?.removeFromParentViewController()
                    }
                }
                
                self.currentChildViewController = viewController
            }
        } else {
            viewController.didMoveToParentViewController(self)
            self.currentChildViewController = viewController
        }
    }
    
    // MARK: - Actions
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductManagementCollectionViewCell = self.tabsCollectionView.dequeueReusableCellWithReuseIdentifier("ProductManagementIdentifier", forIndexPath: indexPath) as! ProductManagementCollectionViewCell
        
        cell.titleLabel.text = pageTitle[indexPath.row]
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = .whiteColor()
            cell.setTextColor(Constants.Colors.appTheme)
            cell.setImage(selectedImage[indexPath.row])
        } else {
            cell.setTextColor(UIColor.whiteColor())
            cell.backgroundColor = Constants.Colors.appTheme
            cell.setImage(deselectedImage[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if selectedIndex != indexPath.row {
            selectedIndex = indexPath.row
            self.tabsCollectionView.reloadData()
            setSelectedViewControllerWithIndex(indexPath.row, transition: UIViewAnimationOptions.TransitionNone)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width / 4, height: 60)
    }

}
