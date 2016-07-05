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
    
    var footerView: SelectProductFooterCollectionViewCell = SelectProductFooterCollectionViewCell()
    
    var tempCollectionViewCount: Int = 16
    private var lastContentOffset: CGFloat = 0
    private var detectScroll: Bool = true
    
    var dimView: UIView?
    var firstHide: Bool = true
    private var affiliateProductModels: [AffiliateProductModel] = []
    
    private var categoryIds: [String] = []
    
    var sortBy: String = "latest"
    var status: String = "all"
    var limit: String = "6"
    var page: Int = 1
    var name: String = ""
    
    private var affiliateGetProductModel: AffiliateGetProductModel = AffiliateGetProductModel()
    
    var categories: [CategoryModel] = []
    
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
        
        self.localizedString()
        
        self.fireAffiliateGetProduct { (successful) -> Void in
            self.collectionView.reloadData()
        }
        
        self.fireGetCategories()
    }
    
    //MARK: - 
    //MARK: - Show Product Count
    func showProductCount() {
        self.selectYourProductLabel.text = "SELECT YOUR PRODUCT (\(self.affiliateGetProductModel.selectedProductCount)/\(self.affiliateGetProductModel.storeSpace))"
        self.doneButton.setTitle("DONE (\(self.affiliateGetProductModel.selectedProductCount)/\(self.affiliateGetProductModel.storeSpace))", forState: .Normal)
    }
    
    //MARK: - 
    //MARK: - Localized String
    func localizedString() {
        self.selectYourProductLabel.text = "\(Strings.selecttYourProduct) (00/00)"
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
        if count(searchText) >= 3 {
            self.name = searchText
            self.page = 1
            self.affiliateProductModels.removeAll(keepCapacity: false)
            self.collectionView.reloadData()
            
            self.fireAffiliateGetProduct({ (successful) -> Void in
                self.collectionView.reloadData()
            })
        } else {
            self.name = ""
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.search()
        self.affiliateProductModels.removeAll(keepCapacity: false)
        
        self.sortBy = "latest"
        self.status = "all"
        self.limit = "20"
        self.page = 1
        
        self.fireAffiliateGetProduct { (successful) -> Void in
            self.collectionView.reloadData()
        }
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
            filterModalViewController.categories = self.categories
            
            filterModalViewController.status = self.status
            filterModalViewController.sortBy = self.sortBy

            filterModalViewController.initButtons()
            self.navigationController!.presentViewController(filterModalViewController, animated: true, completion: nil)
            self.showDimView()
        }
    }
    
    //MARK: - 
    //MARK: - Done Action
    @IBAction func doneAction(sender: AnyObject) {
        var isLoading = false
        
        for product in self.affiliateProductModels {
            if product.isLoading {
                isLoading = true
                break
            }
        }
        
        if isLoading {
           Toast.displayToastBottomWithMessage("Some of your selected/unselected products is still loading.", duration: 2.0, view: self.navigationController!.view!)
        } else {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
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
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    //MARK: - 
    //MARK: - Back
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
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
        
        if indexPath.row < self.affiliateProductModels.count {
            let affiliateProductModel: AffiliateProductModel = self.affiliateProductModels[indexPath.row]
            
            cell.productNameLabel.text = affiliateProductModel.name
            
            if affiliateProductModel.isSelected {
                cell.checkBoxImageView.image = UIImage(named: "new-check")
            } else {
                cell.checkBoxImageView.image = UIImage(named: "old-check")
            }
            
            if affiliateProductModel.isLoading {
                cell.checkBoxImageView.hidden = true
                cell.activityIndicatorView.startAnimating()
            } else {
                cell.checkBoxImageView.hidden = false
                cell.activityIndicatorView.stopAnimating()
            }
            
            cell.productNameLabel.text = affiliateProductModel.name
            cell.originalPriceLabel.text = affiliateProductModel.originalPrice
            cell.originalPriceLabel.drawDiscountLine(false)
            cell.discountedPriceLabel.text = affiliateProductModel.discountedPrice
            
            cell.discountedPriceLabel.text = affiliateProductModel.discountedPrice
            
            cell.discountPercentageLabel.text = "\(affiliateProductModel.discount)% OFF"
            
            
            if affiliateProductModel.discountedPrice == affiliateProductModel.originalPrice {
                cell.originalPriceLabel.hidden = true
                cell.discountPercentageLabel.hidden = true
            } else {
                cell.originalPriceLabel.hidden = false
                cell.discountPercentageLabel.hidden = false
            }
            
            cell.imageView.sd_setImageWithURL(NSURL(string: affiliateProductModel.images[0])!, placeholderImage: UIImage(named: "logo-selection"))
            
            cell.earningLabel.text = affiliateProductModel.earning
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
        println("product count: \(self.affiliateGetProductModel.products.count)")
        return self.affiliateProductModels.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        self.footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: SelectProductFooterCollectionViewCell.nibNameAndIdentifier(), forIndexPath: indexPath) as! SelectProductFooterCollectionViewCell
        
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
                self.fireAffiliateGetProduct({ (successful) -> Void in
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
    
        if indexPath.row < self.affiliateProductModels.count {
            let affiliateProductModel: AffiliateProductModel = self.affiliateProductModels[indexPath.row]
            if affiliateProductModel.isSelected {
                cell.activityIndicatorView.startAnimating()
                affiliateProductModel.isLoading = true
                
                cell.checkBoxImageView.hidden = true
                affiliateProductModel.isSelected = false
                cell.checkBoxImageView.image = UIImage(named: "old-check")
                self.fireSaveAffiliateProductsWithProductId("", removeProductId: "\(affiliateProductModel.manufacturerProductId)", index: indexPath.row)
            } else {
                if self.affiliateGetProductModel.selectedProductCount < self.affiliateGetProductModel.storeSpace {
                    cell.activityIndicatorView.startAnimating()
                    affiliateProductModel.isSelected = true
                    cell.checkBoxImageView.image = UIImage(named: "new-check")
                    affiliateProductModel.isLoading = true
                    
                    cell.checkBoxImageView.hidden = true
                    self.fireSaveAffiliateProductsWithProductId("\(affiliateProductModel.manufacturerProductId)", removeProductId: "", index: indexPath.row)
                } else {
                    cell.activityIndicatorView.stopAnimating()
                    cell.activityIndicatorView.hidden = true
                    self.showLimitAlert()
                }
            }
        }
    }
    
    func showLimitAlert() {
        let alertController = UIAlertController(title: "You have reached the maximum(\(self.affiliateGetProductModel.storeSpace)) item.", message: nil, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: - 
    //MARK: - Filter Modal View Controller Delegate
    func filterModalViewController(filterModalViewController: FilterModalViewController, didTapButton button: UIButton) {
        if button == filterModalViewController.allButton {
            self.status = "all"
        } else if button == filterModalViewController.availableButton {
            self.status = "available"
        } else if button == filterModalViewController.selectedButton {
            self.status = "selected"
        }
        
        if button == filterModalViewController.latestButton {
            self.sortBy = "latest"
        } else if button == filterModalViewController.earningButton {
            self.sortBy = "earning"
        }
        
        if button == filterModalViewController.cancelButton {
            self.hideDimView()
            filterModalViewController.dismissViewControllerAnimated(true, completion: nil)
        } else if button == filterModalViewController.applyFilterButton {
            self.hideDimView()
            filterModalViewController.dismissViewControllerAnimated(true, completion: nil)
            
            self.affiliateProductModels.removeAll(keepCapacity: false)
            self.page = 1
            
            self.fireAffiliateGetProduct { (successful) -> Void in
                
                self.collectionView.reloadData()
                
                if self.affiliateProductModels.count <= 5 {
                    self.footerView.activityIndicatorView.stopAnimating()
                } else {
                    self.footerView.activityIndicatorView.startAnimating()
                }
            }
        }
    }
    
    //MARK: - 
    //MARK: - Fire Affiliate Get Product
    func fireAffiliateGetProduct(actionHandler: (successful: Bool) -> Void) {
        var categoryArray: [Int] = []
        
        for cat in self.categories {
            if cat.isSelected {
                categoryArray.append(cat.uid)
            }
        }
        
        println(StringHelper.convertArrayToJsonString(categoryArray as NSArray) as String)
        
        var categoryIdsString: String = StringHelper.convertArrayToJsonString(categoryArray as NSArray) as String
        
        if categoryIdsString == "[]" {
            categoryIdsString = ""
        }
        
        WebServiceManager.fireAffiliateGetSellerProductFromUrl(APIAtlas.affiliateGetProduct, categoryIds: categoryIdsString, sortby: self.sortBy, limit: self.limit, page: "\(self.page)", status: self.status, name: self.name) { (successful, responseObject, requestErrorType) -> Void in
            
            if successful {
                self.affiliateGetProductModel = AffiliateGetProductModel.parseDataFromDictionary(responseObject as! NSDictionary)
                self.showProductCount()
                
                println(responseObject as! NSDictionary)
                
                for product in self.affiliateGetProductModel.products {
                    self.affiliateProductModels.append(product)
                }
                
                self.page++
                
                if self.affiliateProductModels.count <= 5 {
                    self.footerView.activityIndicatorView.stopAnimating()
                } else {
                    self.footerView.activityIndicatorView.startAnimating()
                }
                
                self.collectionView.reloadData()
                actionHandler(successful: true)
            } else {
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .AccessTokenExpired {
                   self.fireRefreshTokenWithRefreshType(.GetProduct, params: [])
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
        }
    }
    
    //MARK: -
    //MARK: - Fire Save Affiliate Products
    func fireSaveAffiliateProductsWithProductId(addProductId: String, removeProductId: String, index: Int) {
        WebServiceManager.fireAffiliateSaveProductFromUrl(APIAtlas.affiliateSaveOrRemoveProductUrl, productIds: "[\(addProductId)]", removeManufacturerProductIds: "[\(removeProductId)]") {
            (successful, responseObject, requestErrorType) -> Void in
            println(responseObject)
            if successful {
                let indexPath: NSIndexPath = NSIndexPath(forItem: index, inSection: 0)
                
                if index < self.collectionView.numberOfItemsInSection(0) {
                    
                    let affiliateSaveProductResponseModel: AffiliateSaveProductResponseModel = AffiliateSaveProductResponseModel.parseDataFromDictionary(responseObject as! NSDictionary)
                    
                    if affiliateSaveProductResponseModel.save.count != 0 {
                        if index < self.affiliateProductModels.count {
                            self.affiliateProductModels[index].isSelected = true
                            self.affiliateGetProductModel.selectedProductCount++
                        }
                        
                    }
                    
                    if affiliateSaveProductResponseModel.remove.count != 0 {
                        if index < self.affiliateProductModels.count {
                            self.affiliateProductModels[index].isSelected = false
                            self.affiliateGetProductModel.selectedProductCount--
                        }
                    }
                    
                    self.showProductCount()
                    
                    var indexPaths: [NSIndexPath] = self.collectionView.indexPathsForVisibleItems() as! [NSIndexPath]
                    
                    var reloadCell: Bool = false
                    
                    for i in indexPaths {
                        if i == indexPath {
                            reloadCell = true
                            break
                        }
                    }
                    
                    if reloadCell {
                        self.affiliateProductModels[index].isLoading = false
                        self.collectionView.reloadItemsAtIndexPaths([indexPath])
                    }
                }
            } else {
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshTokenWithRefreshType(.Add, params: [addProductId, removeProductId, index])
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
        }
    }
    
    //MARK: - 
    //MARK: - Fire Get Categories
    func fireGetCategories() {
        WebServiceManager.fireAffiliateGetCategoriesFromUrl(APIAtlas.affiliateGetCategories, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            if successful {
                let mainDictioanry = responseObject as! NSDictionary
                let dictionaries = mainDictioanry["data"] as! [NSDictionary]
                
                for dictionary in dictionaries {
                   self.categories.append(CategoryModel.parseDataFromDictionary(dictionary))
                }
            } else {
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.navigationController!.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshTokenWithRefreshType(.GetCategory, params: [])
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
        })
    }
    
    //MARK: -
    //MARK: - Fire Refresh Token With Refresh Type
    func fireRefreshTokenWithRefreshType(affiliateSelectProductRefreshType: AffiliateSelectProductRefreshType, params: [AnyObject]) {
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                if affiliateSelectProductRefreshType == .GetProduct {
                    self.fireAffiliateGetProduct({ (successful) -> Void in
                        self.collectionView.reloadData()
                    })
                } else if affiliateSelectProductRefreshType == .GetCategory {
                    self.fireGetCategories()
                } else {
                    self.fireSaveAffiliateProductsWithProductId(params[0] as! String, removeProductId: params[1] as! String, index: params[2] as! Int)
                }
            } else {
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        })
    }
}
