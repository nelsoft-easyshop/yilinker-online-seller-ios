//
//  ResellerViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/7/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ResellerViewController: UIViewController, UICollectionViewDataSource, ResellerCollectionReusableViewDelegate {

    let headerIdentifier: String = "ResellerCollectionReusableView"
    let headerNibName: String = "ResellerCollectionReusableView"
    
    let cellNibNameAndIdentifier: String = "ResellerItemCollectionViewCell"
    
    let headerHeight: CGFloat = 116
    var hud: MBProgressHUD?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var resellerUploadedItemModels: [ResellerItemModel] = []
    var cellCounter: Int = 0
    
    //MARK: - View Did Appear
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if self.resellerUploadedItemModels.count == 0 {
            self.navigationItem.rightBarButtonItems = []
        } else {
            self.checkButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.title = ResellerStrings.reseller
        self.backButton()
        self.layout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController!.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func layout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, self.headerHeight)
        self.collectionView.collectionViewLayout = layout
    }
    
    //MARK: Register Cells
    func registerCell() {
        let headerNib: UINib = UINib(nibName: self.headerNibName, bundle: nil)
        self.collectionView.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.headerIdentifier)
        
        let cellNib: UINib = UINib(nibName: cellNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: cellNibNameAndIdentifier)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ResellerItemCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(cellNibNameAndIdentifier, forIndexPath: indexPath) as! ResellerItemCollectionViewCell
        
        cell.setCellWithResellerItemModel(self.resellerUploadedItemModels[indexPath.row])
        
        return cell
    }
    
    //MARK: - Cell Size
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

            if IphoneType.isIphone6() {
                return CGSizeMake(111, 150)
            } else if IphoneType.isIphone4() {
                return CGSizeMake(145, 150)
            } else if IphoneType.isIphone5() {
                return CGSizeMake(145, 150)
            } else if IphoneType.isIphone6Plus() {
                return CGSizeMake(124, 150)
            } else {
                return CGSizeMake(110, 150)
            }

    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let resellerView: ResellerCollectionReusableView = self.collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: self.headerIdentifier, forIndexPath: indexPath) as! ResellerCollectionReusableView
        resellerView.delegate = self
        return resellerView
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return self.resellerUploadedItemModels.count
    }
    
    func backButton() {
        var customBackButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "back")
        customBackButton.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkButton() {
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 45, 45)
        checkButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer, customCheckButton]
    }
    
    func check() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        
        var productIds: [Int] = []
        
        for item in self.resellerUploadedItemModels {
            productIds.append(item.uid)
        }
        
        let parameters: NSDictionary = [
            "access_token": SessionManager.accessToken(),
            "productIds[]": productIds]
        
        manager.POST(APIAtlas.resellerUploadUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let message: String = responseObject["message"] as! String
            self.navigationController?.view.makeToast(message)
            self.hud?.hide(true)
            self.dismissViewControllerAnimated(true, completion: nil)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
    }
    
    //MARK: - Display Selected Item
    func animateSelectedItems() {
        /*let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            if self.collectionView != nil && self.cellCounter != self.resellerUploadedItemModels.count {
                var startOfIndexToAdd: Int = self.resellerUploadedItemModels.count - self.cellCounter
                
                startOfIndexToAdd = startOfIndexToAdd - 1
                
                var indexPaths: [NSIndexPath] = []
                
                for var x = startOfIndexToAdd; x < self.resellerUploadedItemModels.count; x++ {
                    let indexPath: NSIndexPath = NSIndexPath(forItem: x, inSection: 0)!
                    indexPaths.append(indexPath)
                }
                
                self.collectionView.performBatchUpdates({ () -> Void in
                    self.collectionView.insertItemsAtIndexPaths(indexPaths)
                    }, completion: nil)
            }
        }*/
        
        self.collectionView.reloadData()
    }
    
    //MARK: - Header Delegate
    func resellerCollectionReusableView(didClickAddItemButton resellerCollectionReusableView: ResellerCollectionReusableView) {
        let productUploadCategoryViewController: ProductUploadCategoryViewController = ProductUploadCategoryViewController(nibName: "ProductUploadCategoryViewController", bundle: nil)
        productUploadCategoryViewController.userType = UserType.Reseller
        productUploadCategoryViewController.pageTitle = "Select Category"
        self.cellCounter = self.resellerUploadedItemModels.count - 1
        self.navigationController?.pushViewController(productUploadCategoryViewController, animated: true)
    }
}
