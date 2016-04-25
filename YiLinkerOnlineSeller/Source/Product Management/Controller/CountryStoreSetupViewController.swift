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
    
    let flags = ["http://wiki.erepublik.com/images/thumb/2/21/Flag-China.jpg/50px-Flag-China.jpg",
        "http://media.worldflags101.com/i/flags/cambodia.gif",
        "http://www.utazaselott.hu/userfiles/image/indonesian%20flag.jpg",
        "https://jeetkunedomalaysia.files.wordpress.com/2014/10/jeet-kune-do-jkd-malaysia-flag.gif",
        "http://images-mediawiki-sites.thefullwiki.org/04/3/7/0/95484361858573992.png",
        "http://www.thailanguagehut.com/wp-content/uploads/2010/04/Thai-Flag.gif",
        "http://www.therecycler.com/wp-content/uploads/2013/03/Vietnam-flag.jpg"]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupNavigationBar()
        self.addActions()
        let nib = UINib(nibName: "ProductImagesCollectionViewCell", bundle: nil)
        self.productCollectionViewController.registerNib(nib, forCellWithReuseIdentifier: "ProductImagesIdentifier")
    }
    
    // MARK: - Functions
    
    func setupNavigationBar() {
        
        self.title = "Country Store Setup"
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-back"), style: .Plain, target: self, action: "backAction")]
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addActions() {
        
        self.productCombinationLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "productCombinationAction:"))
        self.productLocationPrimaryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "primaryLocationAction:"))
        self.productLocationSecondaryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "secondaryLocationAction:"))
        self.commisionTitleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "commisionAction:"))
    }
    
    // MARK: - Requests
    
    // MARK: - Actions
    
    func productCombinationAction(gesture: UIGestureRecognizer) {
        let productCombinations: ProductCombinationViewController = ProductCombinationViewController(nibName: "ProductCombinationViewController", bundle: nil)
        self.navigationController!.pushViewController(productCombinations, animated: true)
    }
    
    func primaryLocationAction(gesture: UIGestureRecognizer) {
        let inventoryLocation: InventoryLocationViewController = InventoryLocationViewController(nibName: "InventoryLocationViewController", bundle: nil)
        self.navigationController!.pushViewController(inventoryLocation, animated: true)
    }
    
    func secondaryLocationAction(gesture: UIGestureRecognizer) {
        let inventoryLocation: InventoryLocationViewController = InventoryLocationViewController(nibName: "InventoryLocationViewController", bundle: nil)
        inventoryLocation.isPrimary = false
        self.navigationController!.pushViewController(inventoryLocation, animated: true)
    }
    
    func commisionAction(gesture: UIGestureRecognizer) {
        let commision: CommisionViewController = CommisionViewController(nibName: "CommisionViewController", bundle: nil)
        self.navigationController!.pushViewController(commision, animated: true)
    }

}

extension CountryStoreSetupViewController: UICollectionViewDataSource {
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: ProductImagesCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductImagesIdentifier", forIndexPath: indexPath) as! ProductImagesCollectionViewCell

        cell.setItemImage(flags[indexPath.row])
        cell.layer.cornerRadius = 3.0
        
        return cell
    }
}

