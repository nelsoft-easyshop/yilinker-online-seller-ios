//
//  AffiliateSelectProductViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/17/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

private struct Strings {
    static let selectProduct = StringHelper.localizedStringWithKey("SELECT_PRODUCT_LOCALIZE_KEY")
    static let filter = StringHelper.localizedStringWithKey("TRANSACTIONS_FILTER_TITLE_LOCALIZE_KEY")
    static let selecttYourProduct = StringHelper.localizedStringWithKey("SELECT_YOUR_PRODUCT_LOCALIZE_KEY")
}

class AffiliateSelectProductViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, FilterModalViewControllerDelegate {
    
    @IBOutlet weak var selectYourProductLabel: UILabel!
    @IBOutlet weak var mainContainerVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tempCollectionViewCount: Int = 16
    private var lastContentOffset: CGFloat = 0
    private var detectScroll: Bool = true
    
    var dimView: UIView?
    var firstHide: Bool = true
    private var affiliateProductModels: [AffiliateProductModel] = []
    
    //MARK: - 
    //MARK: - Nib Name
    class func nibName() -> String {
        return "AffiliateSelectProductViewController"
    }
    
    //MARK: - 
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBarHeightConstraint.constant = 0
        self.initDimView()
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.title = Strings.selectProduct
        self.addSearchButton()
        self.initSearchBar()
        self.initFilter()
        self.initDoneButton()
        self.initMainContainerView()
        self.addBackButton()
        self.layout()
        self.registerCell()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 30, 0)
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, -30, 0)
        
        self.dummyFunction()
        self.localizedString()
    }
    
    //MARK: - 
    //MARK: - Localized String
    func localizedString() {
        self.selectYourProductLabel.text = "\(Strings.selecttYourProduct) (48/150)"
        self.doneButton.setTitle(Constants.Localized.done, forState: .Normal)
        self.filterButton.setTitle(Strings.filter, forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -
    //MARK: - Dim View
    func initDimView() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        dimView = UIView(frame: screenSize)
        dimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController!.view.addSubview(dimView!)
        //self.view.addSubview(dimView!)
        dimView?.hidden = true
        dimView?.alpha = 0
    }
    
    //MARK: -
    //MARK: - Hide Dim View
    func hideDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 0
            self.view.transform = CGAffineTransformMakeScale(1.00, 1.00)
            self.navigationController!.navigationBar.alpha = 1
            self.navigationController!.setNavigationBarHidden(false, animated: true)
            }, completion: { finished in
                
        })
    }
    
    //MARK: - 
    //MARK: - Show Dim View
    func showDimView() {
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            self.navigationController!.navigationBar.alpha = 0
            self.view.transform = CGAffineTransformMakeScale(0.90, 0.90)
            }, completion: { finished in
        })
    }
    
    //MARK: - 
    //MARK: - Init Search Bar
    func initSearchBar() {
        self.searchBar.delegate = self
        
        var cancelButton: UIButton = UIButton()
        
        let topView: UIView = self.searchBar.subviews[0] as! UIView
        
        for subView in topView.subviews {
            if subView.isKindOfClass(NSClassFromString("UINavigationButton")) {
                cancelButton = subView as! UIButton
                break
            }
        }
        
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    //MARK: - 
    //MARK: - Init Filter
    func initFilter() {
        let filterImage: UIImage = UIImage(named: "filter")!
        self.filterButton.setImage(filterImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        self.filterButton.tintColor = UIColor.darkGrayColor()
    }
    
    //MARK: - 
    //MARK: - Add Search Button
    func addSearchButton() {
        var searchButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        searchButton.frame = CGRectMake(0, 0, 40, 40)
        searchButton.addTarget(self, action: "search", forControlEvents: UIControlEvents.TouchUpInside)
        let image: UIImage = UIImage(named: "search")!
        let tintedImage = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        searchButton.setImage(tintedImage, forState: UIControlState.Normal)
        searchButton.tintColor = UIColor.whiteColor()
        
        var customSearchButton:UIBarButtonItem = UIBarButtonItem(customView: searchButton)
        customSearchButton.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer, customSearchButton]
    }
    
    
    //MARK: - 
    //MARK: - Search
    func search() {
        let defaultSearBarHeight: CGFloat = 44.0
        
        if self.isSearchBarVisible() {
            self.searchBarHeightConstraint.constant = 0
            self.mainContainerVerticalConstraint.constant = 49
            self.searchBar.endEditing(true)
        } else {
            self.mainContainerVerticalConstraint.constant = 0
            self.searchBarHeightConstraint.constant = defaultSearBarHeight
            self.searchBar.becomeFirstResponder()
        }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: -
    //MARK: - Is Search Bar Visible
    func isSearchBarVisible() -> Bool {
        if self.searchBarHeightConstraint.constant != 0 {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - 
    //MARK: - Search Bar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.search()
    }
    
    //MARK: - 
    //MARK: - Filter Action
    @IBAction func filterAction(sender: AnyObject) {
        if self.mainContainerVerticalConstraint.constant != 0 {
            var filterModalViewController = FilterModalViewController(nibName: FilterModalViewController.nibName(), bundle: nil)
            filterModalViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            filterModalViewController.providesPresentationContextTransitionStyle = true
            filterModalViewController.definesPresentationContext = true
            filterModalViewController.view.backgroundColor = UIColor.clearColor()
            filterModalViewController.delegate = self
            self.navigationController!.presentViewController(filterModalViewController, animated: true, completion: nil)
            self.showDimView()
        }
    }
    
    //MARK: - 
    //MARK: - Done Action
    @IBAction func doneAction(sender: AnyObject) {
        
    }
    
    //MARK: - 
    //MARK: - Init Done Button
    func initDoneButton() {
        self.doneButton.layer.cornerRadius = 5
    }
    
    //MARK: - 
    //MARK: - Init Main Container View
    func initMainContainerView() {
        self.mainContainerView.layer.zPosition = 100
    }
    
    //MARK: -
    //MARK: - Add Back Button
    func addBackButton() {
        var customBackButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "back")
        customBackButton.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    //MARK: - 
    //MARK: - Back
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - 
    //MARK: - Layout
    func layout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        self.collectionView.collectionViewLayout = layout
    }
    
    //MARK: -
    //MARK: Register Cells
    func registerCell() {
        let cellNib: UINib = UINib(nibName: SelectProductCollectionViewCell.nibNameAndIdentifier(), bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: SelectProductCollectionViewCell.nibNameAndIdentifier())
        
        let footerNib: UINib = UINib(nibName: SelectProductFooterCollectionViewCell.nibNameAndIdentifier(), bundle: nil)
        self.collectionView.registerNib(footerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: SelectProductFooterCollectionViewCell.nibNameAndIdentifier())
    }
    
    //MARK: -
    //MARK: - Collection View Data Source
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: SelectProductCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(SelectProductCollectionViewCell.nibNameAndIdentifier(), forIndexPath: indexPath) as! SelectProductCollectionViewCell
        
        let affiliateProductModel: AffiliateProductModel = self.affiliateProductModels[indexPath.row]
        
        cell.productNameLabel.text = affiliateProductModel.productName
        
        if affiliateProductModel.isSelected {
            cell.checkBoxImageView.image = UIImage(named: "new-check")
        } else {
            cell.checkBoxImageView.image = UIImage(named: "old-check")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let width: CGFloat = ((self.view.frame.size.width - 30) / 2)
            return CGSizeMake(width, 220)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.affiliateProductModels.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let footerView: SelectProductFooterCollectionViewCell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: SelectProductFooterCollectionViewCell.nibNameAndIdentifier(), forIndexPath: indexPath) as! SelectProductFooterCollectionViewCell
        return footerView
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
         return CGSizeMake(self.view.frame.size.width, 30)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if ((self.collectionView.contentOffset.y + 100) >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height)) {
            self.mainContainerVerticalConstraint.constant = 0
            self.detectScroll = false
            
            Delay.delayWithDuration(2.0, completionHandler: { (success) -> Void in
                self.detectScroll = true
            })
        }
        
        if self.detectScroll && self.searchBarHeightConstraint.constant == 0 {
            if self.lastContentOffset > scrollView.contentOffset.y {
                if self.mainContainerVerticalConstraint.constant == 0 {
                    self.mainContainerVerticalConstraint.constant = 49
                    
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.view.layoutIfNeeded()
                    })
                }
            } else if (self.lastContentOffset < scrollView.contentOffset.y) {
                if self.mainContainerVerticalConstraint.constant == 49 {
                    
                    if scrollView.contentOffset.y > 100 {
                        self.mainContainerVerticalConstraint.constant = 0
                    }
                    
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        
                        if self.collectionView.contentOffset.y > 100 {
                            self.view.layoutIfNeeded()
                        }
                    })
                }
            }
        }
    
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((self.collectionView.contentOffset.y - 10) >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height)) {
            Delay.delayWithDuration(0.5, completionHandler: { (success) -> Void in
                self.detectScroll = false
                self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
                self.collectionView.setContentOffset(CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.frame.size.height), animated: true)
                Delay.delayWithDuration(2.0, completionHandler: { (success) -> Void in
                    self.dummyFunction()
                    self.collectionView.reloadData()
                    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, -30, 0)
                    self.detectScroll = true
                })
            })
        }
    }
    
    //MARK: - 
    //MARK: - Collection View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var sprintAnimation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        sprintAnimation.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        sprintAnimation.velocity = NSValue(CGPoint: CGPointMake(2.0, 2.0))
        sprintAnimation.springBounciness = 10.0
        let cell: SelectProductCollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! SelectProductCollectionViewCell
        cell.pop_addAnimation(sprintAnimation, forKey: "springAnimation")
        
        
        let affiliateProductModel: AffiliateProductModel = self.affiliateProductModels[indexPath.row]
        
        if affiliateProductModel.isSelected {
            affiliateProductModel.isSelected = false
            cell.checkBoxImageView.image = UIImage(named: "old-check")
        } else {
            affiliateProductModel.isSelected = true
            cell.checkBoxImageView.image = UIImage(named: "new-check")
        }
    }
    
    //MARK: - 
    //MARK: - Filter Modal View Controller Delegate
    func filterModalViewController(filterModalViewController: FilterModalViewController, didTapButton button: UIButton) {
        if button == filterModalViewController.cancelButton {
            self.hideDimView()
            filterModalViewController.dismissViewControllerAnimated(true, completion: nil)
        } else if button == filterModalViewController.applyFilterButton {
            self.hideDimView()
            filterModalViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //MARK: - 
    //MARK: - Dummy Function
    func dummyFunction() {
        for i in 0..<16 {
            let affiliateProductModel: AffiliateProductModel = AffiliateProductModel()
            affiliateProductModel.productName = "Product \(i + 1)"
            affiliateProductModel.uid = i
            self.affiliateProductModels.append(affiliateProductModel)
        }
    }
}
