//
//  ProductDetailsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

private struct DetailsString {
    static let cellIdentifier = "ProductDetailsIdentifier"
    static let title = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_TITLE_LOCALIZE_KEY")
    static let description = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_DESCRIPTION_LOCALIZE_KEY")
    static let seeMore = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_SEEMORE_LOCALIZE_KEY")

    static let titleDetails = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_TITLE_DETAILS_LOCALIZE_KEY")
    static let titlePrice = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_TITLE_PRICE_LOCALIZE_KEY")
    static let titleDimensionsWeight = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_TITLE_DIMENSIONSWEIGHT_LOCALIZE_KEY")
    
    static let category = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_CATEGORY_LOCALIZE_KEY")
    static let brand = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_BRAND_LOCALIZE_KEY")
    static let sku = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_SKU_LOCALIZE_KEY")
    static let quantity = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_QUANTITY_LOCALIZE_KEY")
    static let retail = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_RETAIL_LOCALIZE_KEY")
    static let discounted = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_DISCOUNTED_LOCALIZE_KEY")
    static let length = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_LENGTH_LOCALIZE_KEY")
    static let width = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_WIDTH_LOCALIZE_KEY")
    static let weight = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_WEIGHT_LOCALIZE_KEY")
    static let height = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_HEIGHT_LOCALIZE_KEY")
}

class ProductDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProductDescriptionViewDelegate, EmptyViewDelegate {

    // MARK: - Models
    var productDetailsModel: ProductDetailsModel!
    var productAttributesModel: [ProductAttributeModel]!
    var productUnitsModel: [ProductUnitsModel]!
    var productImagesModel: [ProductImagesModel]!
    // Upload Models
    var productModel: ProductModel!
    var imagesToEdit: [UIImage] = []
    var uploadAttributeModel: [AttributeModel] = []
    var uploadCombinationModel: [CombinationModel] = []
    
    // MARK: - Views
    @IBOutlet weak var tableView: UITableView!
    var headerView: UIView!
    var productImagesView: ProductImagesView!
    var productDescriptionView: ProductDescriptionView!
    var hud: MBProgressHUD?
    var emptyView: EmptyView?
    
    var isEditable: Bool = false
    
    var newFrame: CGRect!
    
    var productId: String = "1"
    var isDraft: Bool = false
    
    
    let detailNames = [DetailsString.category, DetailsString.brand, DetailsString.sku, DetailsString.quantity]
    let priceNames = [DetailsString.retail, DetailsString.discounted]
    let dimensionWeightNames = [DetailsString.length, DetailsString.width, DetailsString.weight, DetailsString.height]
    
    var detailValues: [String] = []
    var priceValues: [String] = []
    var dimensionWeightValues: [String] = []
    
    var listNames: [String] = []
    var listValues: [String] = []
    
    var listDetails: NSDictionary = [:]
    var listPrice: NSDictionary = [:]
    var listDimensionsWeight: NSDictionary = [:]
    var listSections: [NSArray] = []
    var listSectionTitle = [DetailsString.titleDetails, DetailsString.titlePrice, DetailsString.titleDimensionsWeight]
    var names: [String] = []
    var values: [String] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        customizeNavigationBar()
        
        let nib = UINib(nibName: "ProductDetailsTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: DetailsString.cellIdentifier)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork() {
            requestProductDetails()
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.error)
        }
        loadloadViewsWithDetails()
    }
    
    // MARK: - Init Views
    
    func getHeaderView() -> UIView {
        if self.headerView == nil {
            self.headerView = UIView(frame: CGRectZero)
            self.headerView.backgroundColor = Constants.Colors.backgroundGray
        }
        return self.headerView
    }
    
    func getProductImagesView() -> ProductImagesView {
        if self.productImagesView == nil {
            self.productImagesView = XibHelper.puffViewWithNibName("ProductDetailViews", index: 0) as! ProductImagesView
            self.productImagesView.frame.size.width = self.view.frame.size.width
        }
        return self.productImagesView
    }
    
    func getProductDescriptionView() -> ProductDescriptionView {
        if self.productDescriptionView == nil {
            self.productDescriptionView = XibHelper.puffViewWithNibName("ProductDetailViews", index: 1) as! ProductDescriptionView
            self.productDescriptionView.frame.size.width = self.view.frame.size.width
            self.productDescriptionView.delegate = self
            self.productDescriptionView.titleLabel.text = DetailsString.title
            self.productDescriptionView.seeMoreLabel.text = DetailsString.seeMore
        }
        return self.productDescriptionView
    }
    
    // MARK: - Methods
    
    func customizeNavigationBar() {
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = DetailsString.title
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton = UIBarButtonItem(image: UIImage(named: "back-white"), style: .Plain, target: self, action: "backAction")
        var editButton = UIBarButtonItem(image: UIImage(named: "edit"), style: .Plain, target: self, action: "editAction")
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, backButton]
        if isEditable {
            self.navigationItem.rightBarButtonItem = editButton
        }
    }
    
    func loadloadViewsWithDetails() {
        // Adding views
        self.getHeaderView().addSubview(self.getProductImagesView())
        self.getHeaderView().addSubview(self.getProductDescriptionView())
        
        // Positioning Views
        self.setPosition(self.productDescriptionView, from: self.productImagesView)
        
        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.productDescriptionView.frame) + 15.0
        self.headerView.frame = newFrame
        
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame) + 15.0
        view.frame = newFrame
    }
    
    func sectionHeaderView(index: Int) -> UIView {
        var sectionView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 45.0))
        sectionView.backgroundColor = UIColor.whiteColor()
        
        var titleLabel = UILabel(frame: CGRectMake(10.0, 0, self.view.frame.size.width - 10.0, sectionView.frame.size.height))
        titleLabel.text = self.listSectionTitle[index]
        titleLabel.font = UIFont(name: "Panton-SemoBold", size: 17.0)
        titleLabel.textColor = UIColor.darkGrayColor()
        sectionView.addSubview(titleLabel)
        
        var underlineView = UIView(frame: CGRectMake(0, sectionView.frame.size.height - 1, self.view.frame.size.width, 1))
        underlineView.backgroundColor = Constants.Colors.backgroundGray
//        sectionView.addSubview(underlineView)
        
        return sectionView
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
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func populateDetails() {
        self.productImagesView.setDetails(productModel)
//        self.productDescriptionView.descriptionLabel.text = productModel.shortDescription
        self.productDescriptionView.setDescription(productModel.shortDescription)
        if productModel.validCombinations.count != 0 {
            let def: CombinationModel = productModel.validCombinations[0]
            self.detailValues = [productModel.category.name, productModel.brand.name, def.sku, def.quantity]
            self.priceValues = ["₱ " + def.retailPrice, "₱ " + def.discountedPrice]
            self.dimensionWeightValues = [def.length + "cm", def.width + "cm", def.weight + "kg", def.height + "cm"]

//            self.listValues = [productModel.category.name, productModel.brand.name, def.sku, def.quantity,
//                "₱" + def.retailPrice.floatValue.string(2), "₱" + def.discountedPrice.floatValue.string(2),
//                def.length + "cm", def.width + "cm", def.weight + "kg", def.height + "cm"]
        } else {
            self.detailValues = [productModel.category.name, productModel.brand.name, productModel.sku, String(productModel.quantity)]
            self.priceValues = ["₱ " + productModel.retailPrice, "₱ " + productModel.discoutedPrice]
            self.dimensionWeightValues = [productModel.length + "cm", productModel.width + "cm", productModel.weigth + "kg", productModel.height + "cm"]
            
//            self.listValues = [productModel.category.name, productModel.brand.name, productModel.sku, String(productModel.quantity),
//                "₱" + productModel.retailPrice.floatValue.string(2), "₱" + productModel.discoutedPrice.floatValue.string(2),
//                productModel.length + "cm", productModel.width + "cm", productModel.weigth + "kg", productModel.height + "cm"]
        }
        
        self.listNames = [DetailsString.category, DetailsString.brand, DetailsString.sku, DetailsString.quantity,
            DetailsString.retail, DetailsString.discounted,
            DetailsString.length, DetailsString.width, DetailsString.weight, DetailsString.height]
        self.listSections = [detailValues, priceValues, dimensionWeightValues]
        self.tableView.reloadData()
    }
    
    func localJson() {
        if let path = NSBundle.mainBundle().pathForResource("productDetailsItemsJson", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil) {
                if let jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                    if let data : NSDictionary = jsonResult["data"] as? NSDictionary {
                        if let items : NSArray = data["items"] as? NSArray {
                            for item in items as NSArray {
                                if let tempVar = item["items"] as? NSDictionary {
                                    println(tempVar)
//                                    for tempVar2 in tempVar as NSArray {
//                                        
//                                    }
                                }
//
//                                if let tempVar = category["fullName"] as? String {
//                                    fullName.append(tempVar)
//                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addEmptyView() {
        self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
        self.emptyView!.delegate = self
        self.emptyView!.frame = self.view.bounds
        self.view.addSubview(self.emptyView!)
    }
    
    // MARK: - Request
    
    func requestProductDetails() {
        self.showHUD()
        let id: String = "?access_token=" + SessionManager.accessToken() + "&productId=" + productId
        
        let manager = APIManager.sharedInstance
        manager.GET(APIAtlas.getProductDetails + id, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject)
            if responseObject["isSuccessful"] as! Bool {
                self.productModel = ProductModel.parseDataWithDictionary(responseObject)
//                self.productDetailsModel = ProductDetailsModel.parseDataWithDictionary(responseObject)
//                self.productAttributesModel = self.productDetailsModel.attributes
//                self.productUnitsModel = self.productDetailsModel.productUnits
//                self.productImagesModel = self.productDetailsModel.images
//                
                self.populateDetails()
            } else {
                self.showAlert(title: "Error", message: responseObject["message"] as! String)
                
            }
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error.userInfo)
                let alert = UIAlertController(title: AlertStrings.wentWrong, message: "", preferredStyle: UIAlertControllerStyle.Alert)
                let okButton = UIAlertAction(title: AlertStrings.ok, style: UIAlertActionStyle.Cancel) { (alert) -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                }
                alert.addAction(okButton)
                self.presentViewController(alert, animated: true, completion: nil)
                
        })
    }
    
    // MARK: - Actions
    
    func backAction() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func editAction() {
        if self.productModel != nil {
            self.showHUD()
            if self.productModel.imageUrls.count != self.productModel.editedImage.count {
                self.productModel.editedImage = []
                for i in 0..<self.productModel.imageUrls.count {
                    var imgURL: NSURL = NSURL(string: self.productModel.imageUrls[i])!
                    let request: NSURLRequest = NSURLRequest(URL: imgURL)
                    NSURLConnection.sendAsynchronousRequest(
                        request, queue: NSOperationQueue.mainQueue(),
                        completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                            if error == nil {
                                var convertedImage: ServerUIImage = ServerUIImage(data: data)!
                                convertedImage.uid = self.productModel.imageIds[i]
                                self.productModel.editedImage.append(convertedImage)
                                if self.productModel.editedImage.count == self.productModel.imageUrls.count {
                                    self.hud?.hide(true)
                                    let upload = ProductUploadTableViewController(nibName: "ProductUploadTableViewController", bundle: nil)
                                    upload.uploadType = UploadType.EditProduct
                                    upload.productModel = self.productModel
                                    let navigationController: UINavigationController = UINavigationController(rootViewController: upload)
                                    navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
                                    self.tabBarController!.presentViewController(navigationController, animated: true, completion: nil)
                                }
                            } else {
                                var convertedImage = ServerUIImage()
                                convertedImage.uid = self.productModel.imageIds[i]
                                self.productModel.images.append(convertedImage)
                                if self.productModel.images.count == self.productModel.imageUrls.count {
                                    self.hud?.hide(true)
                                    let upload = ProductUploadTableViewController(nibName: "ProductUploadTableViewController", bundle: nil)
                                    upload.uploadType = UploadType.EditProduct
                                    upload.productModel = self.productModel
                                    let navigationController: UINavigationController = UINavigationController(rootViewController: upload)
                                    navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
                                    self.tabBarController!.presentViewController(navigationController, animated: true, completion: nil)
                                }
                            }
                    })
                }
            } else {
                let upload = ProductUploadTableViewController(nibName: "ProductUploadTableViewController", bundle: nil)
                upload.uploadType = UploadType.EditProduct
                upload.productModel = self.productModel
                let navigationController: UINavigationController = UINavigationController(rootViewController: upload)
                navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
                self.tabBarController!.presentViewController(navigationController, animated: true, completion: nil)
            }
        }
    }

    func didTapReload() {
        if Reachability.isConnectedToNetwork() {
            requestProductDetails()
        } else {
            addEmptyView()
        }
        self.emptyView?.removeFromSuperview()
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.listSections.count != 0 {
            return self.listSections[section].count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProductDetailsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(DetailsString.cellIdentifier) as! ProductDetailsTableViewCell
        cell.selectionStyle = .None
        
        if indexPath.section == 0 {
            println(self.detailNames[indexPath.row])
            cell.itemNameLabel.text = self.detailNames[indexPath.row]
            if self.detailValues[indexPath.row] == "" {
                cell.itemValueLabel.text = "-"
            } else {
                cell.itemValueLabel.text = self.detailValues[indexPath.row]
            }
        } else if indexPath.section == 1 {
            cell.itemNameLabel.text = self.priceNames[indexPath.row]
            cell.itemValueLabel.text = self.priceValues[indexPath.row]
            if indexPath.row == 1 {
                cell.itemValueLabel.textColor = Constants.Colors.productPrice
            }
        } else if indexPath.section == 2 {
            cell.itemNameLabel.text = self.dimensionWeightNames[indexPath.row]
            if count(self.dimensionWeightValues[indexPath.row]) == 2 {
                cell.itemValueLabel.text = "-"
            } else {
                cell.itemValueLabel.text = self.dimensionWeightValues[indexPath.row]
            }
        }
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView(section)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 10.0))
        footerView.backgroundColor = Constants.Colors.backgroundGray
        
        return footerView
    }

    // MARK: - Product Description Delegate
    
    func gotoDescriptionViewController(view: ProductDescriptionView) {
        let productDescription = ProductDescriptionViewController(nibName: "ProductDescriptionViewController", bundle: nil)
        productDescription.fullDescription = self.productModel.completeDescription
        productDescription.title = "Description"
        let root = UINavigationController(rootViewController: productDescription)
        self.navigationController?.presentViewController(root, animated: true, completion: nil)
    }
    
    // Dealloc
    
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
}

