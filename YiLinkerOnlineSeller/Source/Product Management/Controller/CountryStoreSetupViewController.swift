//
//  CountryStoreSetupViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 4/21/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class CountryStoreSetupViewController: UIViewController, EmptyViewDelegate {

    // MARK: Delarations
    
    // MARK: Components
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var CountryDetailsLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryValueLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var domainValueLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageValueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyValueLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateValueLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeNameValueLabel: UILabel!
    
    @IBOutlet weak var productSummaryLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productCollectionViewController: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryValueLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandValueLabel: UILabel!
    @IBOutlet weak var packageDimensionLabel: UILabel!
    @IBOutlet weak var packageDimensionValueLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightValueLabel: UILabel!
    
    @IBOutlet weak var productCombinationLabel: UILabel!
    
    @IBOutlet weak var productLocationPrimaryLabel: UILabel!
    @IBOutlet weak var productLocationPrimaryValueLabel: UILabel!
    
    @IBOutlet weak var productLocationSecondaryLabel: UILabel!
    @IBOutlet weak var productLocationSecondaryValueLabel: UILabel!
    
    @IBOutlet weak var commisionTitleLabel: UILabel!
    @IBOutlet weak var commisionLabel: UILabel!
    @IBOutlet weak var commisionValueLabel: UILabel!
    
    // MARK: Variables
    
    var countryStoreSetupModel: CountrySetupModel!
    var countryStoreModel: CountryListModel!
    
    var hud: MBProgressHUD?
    var emptyView: EmptyView?
    
    var productId: String = ""
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupNavigationBar()
        populateCountryStoreBasicDetails()
        fireGetCountryStoreDetails()
        
        let nib = UINib(nibName: "ProductImagesCollectionViewCell", bundle: nil)
        self.productCollectionViewController.registerNib(nib, forCellWithReuseIdentifier: "ProductImagesIdentifier")
        
        
        self.scrollView.backgroundColor = Constants.Colors.lightBackgroundColor
        
    }
    
    // MARK: - Functions
    
    func setupNavigationBar() {
        self.title = "Country Store Setup"
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-back"), style: .Plain, target: self, action: "backAction")]
    }
    
    func populateCountryStoreBasicDetails() {
        
        if countryStoreModel != nil {
            self.countryValueLabel.text = self.countryStoreModel.name
            self.domainValueLabel.text = self.countryStoreModel.domain
            self.languageValueLabel.text = self.countryStoreModel.defaultLanguage.name
            self.currencyValueLabel.text = "\(self.countryStoreModel.currency.name) (\(self.countryStoreModel.currency.symbol))"
            self.rateValueLabel.text = "1USD = \(self.countryStoreModel.currency.rate) \(self.countryStoreModel.currency.symbol)"
        } else {
            println("Country Store Model is nil")
        }
        
    }
    
    func populateCountryStoreSetupDetails() {
        
        if countryStoreSetupModel != nil {
            self.storeNameValueLabel.text = self.countryStoreSetupModel.product.store
            
            self.productNameLabel.text = self.countryStoreSetupModel.product.title
            self.productDescriptionLabel.text = self.countryStoreSetupModel.product.shortDescription
            self.productCollectionViewController.reloadData()
            self.categoryValueLabel.text = self.countryStoreSetupModel.product.category
            self.brandValueLabel.text = self.countryStoreSetupModel.product.brand
            let dimension = "\(self.countryStoreSetupModel.defaultUnit.height)cm x \(self.countryStoreSetupModel.defaultUnit.width)cm x \(self.countryStoreSetupModel.defaultUnit.length)cm"
            self.packageDimensionValueLabel.text = dimension
            self.weightValueLabel.text = self.countryStoreSetupModel.defaultUnit.weight + "KG"
            
            self.productLocationPrimaryValueLabel.text = self.countryStoreSetupModel.primaryAddress
            self.productLocationSecondaryValueLabel.text = self.countryStoreSetupModel.secondaryAddress
            
            self.addActions()
        } else {
            println("Country Store Setup Model is nil")
        }
        
    }
    
    // MARK: - Actions
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addActions() {
        
        self.productCombinationLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "productCombinationAction:"))
        self.productLocationPrimaryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "primaryLocationAction:"))
        self.productLocationSecondaryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "secondaryLocationAction:"))
//        self.commisionTitleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "commisionAction:"))
    }
    
    func productCombinationAction(gesture: UIGestureRecognizer) {
        let productCombinations: ProductCombinationViewController = ProductCombinationViewController(nibName: "ProductCombinationViewController", bundle: nil)
        productCombinations.delegate = self
        productCombinations.combinationModel = self.countryStoreSetupModel.product.productUnits
        productCombinations.countryStoreModel = self.countryStoreModel
        productCombinations.productDetails = self.countryStoreSetupModel.product
        self.navigationController!.pushViewController(productCombinations, animated: true)
    }
    
    func primaryLocationAction(gesture: UIGestureRecognizer) {
        let inventoryLocation: InventoryLocationViewController = InventoryLocationViewController(nibName: "InventoryLocationViewController", bundle: nil)
        inventoryLocation.delegate = self
        inventoryLocation.productDetails = self.countryStoreSetupModel.product
        inventoryLocation.code = self.countryStoreModel.code
        inventoryLocation.warehousesModel = self.countryStoreSetupModel.productWarehouses
        inventoryLocation.logisticsModel = self.countryStoreSetupModel.logistics
        self.navigationController!.pushViewController(inventoryLocation, animated: true)
    }
    
    func secondaryLocationAction(gesture: UIGestureRecognizer) {
        let inventoryLocation: InventoryLocationViewController = InventoryLocationViewController(nibName: "InventoryLocationViewController", bundle: nil)
        inventoryLocation.delegate = self
        inventoryLocation.productDetails = self.countryStoreSetupModel.product
        inventoryLocation.code = self.countryStoreModel.code
        inventoryLocation.warehousesModel = self.countryStoreSetupModel.productWarehouses
        inventoryLocation.logisticsModel = self.countryStoreSetupModel.logistics
        inventoryLocation.isPrimary = false
        self.navigationController!.pushViewController(inventoryLocation, animated: true)
    }
    
    func commisionAction(gesture: UIGestureRecognizer) {
        let commision: CommisionViewController = CommisionViewController(nibName: "CommisionViewController", bundle: nil)
        self.navigationController!.pushViewController(commision, animated: true)
    }

    // MARK: - Requests
    
    func fireGetCountryStoreDetails() {
        
        self.showHUD()

        WebServiceManager.fireGetCountrySetupDetails(APIAtlas.getCountrySetupDetails + SessionManager.accessToken(), productId: productId, code: self.countryStoreModel.code, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            self.hud?.hide(true)
            
            if successful {
                self.countryStoreSetupModel = nil
                self.countryStoreSetupModel = CountrySetupModel.parseDataWithDictionary(responseObject as! NSDictionary)
                self.populateCountryStoreSetupDetails()
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
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
    
    func fireRefreshToken() {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireGetCountryStoreDetails()
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                })
            }
        })
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    // MARK: - Empty View
    
    func addEmptyView() {
        self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
        self.emptyView?.frame = self.view.frame
        self.emptyView!.delegate = self
        self.view.addSubview(self.emptyView!)
    }
    
    func didTapReload() {
        self.emptyView?.removeFromSuperview()
        if Reachability.isConnectedToNetwork() {
            
        } else {
            addEmptyView()
        }
    }
    
}

extension CountryStoreSetupViewController: UICollectionViewDataSource, InventoryLocationViewControllerDelegate, ProductCombinationViewControllerDelegate {
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if countryStoreSetupModel != nil {
            return self.countryStoreSetupModel.product.images.count
        }
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: ProductImagesCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductImagesIdentifier", forIndexPath: indexPath) as! ProductImagesCollectionViewCell

        if countryStoreSetupModel != nil {
            cell.setItemImage(self.countryStoreSetupModel.product.images[indexPath.row].imageLocation)
        } else {
            cell.setDefaultImage()
        }
        
        cell.layer.cornerRadius = 3.0
        
        return cell
    }
    
    // MARK: Inventory Location View Controller Delegate
    
    func reloadDetailsFromInventoryLocation(controller: InventoryLocationViewController) {
        self.fireGetCountryStoreDetails()
    }
    
    // MARK: Product Combination View Controller Delegate
    
    func reloadDetailsFromProductCombination(controller: ProductCombinationViewController) {
        self.fireGetCountryStoreDetails()
    }
    
}

