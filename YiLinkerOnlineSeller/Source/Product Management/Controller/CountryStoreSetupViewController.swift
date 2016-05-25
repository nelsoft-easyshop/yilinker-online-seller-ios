//
//  CountryStoreSetupViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 4/21/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class CountryStoreSetupViewController: UIViewController {

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
    
    let flags = ["http://wiki.erepublik.com/images/thumb/2/21/Flag-China.jpg/50px-Flag-China.jpg",
        "http://media.worldflags101.com/i/flags/cambodia.gif",
        "http://www.utazaselott.hu/userfiles/image/indonesian%20flag.jpg",
        "https://jeetkunedomalaysia.files.wordpress.com/2014/10/jeet-kune-do-jkd-malaysia-flag.gif",
        "http://images-mediawiki-sites.thefullwiki.org/04/3/7/0/95484361858573992.png",
        "http://www.thailanguagehut.com/wp-content/uploads/2010/04/Thai-Flag.gif",
        "http://www.therecycler.com/wp-content/uploads/2013/03/Vietnam-flag.jpg"]
    
    var tempAccessToken: String = ""
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fireGetCountryStoreDetails()
        setupNavigationBar()
        self.addActions()
        let nib = UINib(nibName: "ProductImagesCollectionViewCell", bundle: nil)
        self.productCollectionViewController.registerNib(nib, forCellWithReuseIdentifier: "ProductImagesIdentifier")
        
        populateCountryStoreBasicDetails()
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
            println(countryStoreSetupModel.product.id)
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
        productCombinations.combinationModel = self.countryStoreSetupModel.product.productUnits
        self.navigationController!.pushViewController(productCombinations, animated: true)
    }
    
    func primaryLocationAction(gesture: UIGestureRecognizer) {
        let inventoryLocation: InventoryLocationViewController = InventoryLocationViewController(nibName: "InventoryLocationViewController", bundle: nil)
        println(self.countryStoreSetupModel.product)
        inventoryLocation.productDetails = self.countryStoreSetupModel.product
        inventoryLocation.code = self.countryStoreModel.code
        inventoryLocation.warehousesModel = self.countryStoreSetupModel.productWarehouses
        inventoryLocation.logisticsModel = self.countryStoreSetupModel.logistics
        self.navigationController!.pushViewController(inventoryLocation, animated: true)
    }
    
    func secondaryLocationAction(gesture: UIGestureRecognizer) {
        let inventoryLocation: InventoryLocationViewController = InventoryLocationViewController(nibName: "InventoryLocationViewController", bundle: nil)
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
        
//        println(APIAtlas.getCountrySetupDetails)
//        println(SessionManager.accessToken())
        
        let url = "http://dev.seller.online.api.easydeal.ph/api/v3/PH/EN/auth/country-setup?access_token=" + SessionManager.accessToken()
        // APIAtlas.getCountrySetupDetails + SessionManager.accessToken()
        
        WebServiceManager.fireGetCountrySetupDetails(url, productId: "30571", code: self.countryStoreModel.code, actionHandler: { (successful, responseObject, requestErrorType) -> Void in

            println(responseObject)
            
            if successful {
                self.countryStoreSetupModel = CountrySetupModel.parseDataWithDictionary(responseObject as! NSDictionary)
                self.populateCountryStoreSetupDetails()
            } else {
                println("Failed")
            }
        
        })
        
    }
    
}

extension CountryStoreSetupViewController: UICollectionViewDataSource {
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.countryStoreSetupModel != nil {
            return self.countryStoreSetupModel.product.images.count
        }
        return flags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: ProductImagesCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductImagesIdentifier", forIndexPath: indexPath) as! ProductImagesCollectionViewCell

        if self.countryStoreSetupModel != nil {
            cell.setItemImage(self.countryStoreSetupModel.product.images[indexPath.row].imageLocation)
        } else {
            cell.setItemImage(flags[indexPath.row])
        }
        
        cell.layer.cornerRadius = 3.0
        
        return cell
    }
}

