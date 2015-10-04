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
    
    let headerHeight: CGFloat = 148
    var hud: MBProgressHUD?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.title = ResellerStrings.reseller
        self.backButton()
        self.checkButton()
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
    
    func registerCell() {
        let headerNib: UINib = UINib(nibName: self.headerNibName, bundle: nil)
        self.collectionView.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.headerIdentifier)
        
        let cellNib: UINib = UINib(nibName: ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductUploadImageCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(ProductUploadUploadImageTableViewCellConstant.productUploadImageCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ProductUploadImageCollectionViewCell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let resellerView: ResellerCollectionReusableView = self.collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: self.headerIdentifier, forIndexPath: indexPath) as! ResellerCollectionReusableView
        resellerView.delegate = self
        return resellerView
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 0
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
        
    }
    
    //Header Delegate
    func resellerCollectionReusableView(didClickAddItemButton resellerCollectionReusableView: ResellerCollectionReusableView) {
        let productUploadCategoryViewController: ProductUploadCategoryViewController = ProductUploadCategoryViewController(nibName: "ProductUploadCategoryViewController", bundle: nil)
        productUploadCategoryViewController.userType = UserType.Reseller
        productUploadCategoryViewController.pageTitle = "Select Category"
        self.navigationController?.pushViewController(productUploadCategoryViewController, animated: true)
    }
}
