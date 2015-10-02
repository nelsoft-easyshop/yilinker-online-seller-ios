//
//  ProductDetailsViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct myConstant {
    static let cellIdentifier = "ProductDetailsIdentifier"
    static let title = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_TITLE_LOCALIZE_KEY")
    static let description = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_DESCRIPTION_LOCALIZE_KEY")
    static let seeMore = StringHelper.localizedStringWithKey("PRODUCT_DETAILS_SEEMORE_LOCALIZE_KEY")
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
    
    var newFrame: CGRect!
    
    var productId: String = "1"
    
    let detailNames = ["Category", "Brand"]
    let priceNames = ["Retail Price", "Discounted Price"]
    let dimensionWeightNames = ["Length (CM)", "Width (CM)", "Weight (KG)", "Height (CM)"]
    
    var detailValues: [String] = []
    var priceValues: [String] = []
    var dimensionWeightValues: [String] = []
    
    var listNames: [String] = []
    var listValues: [String] = []
    
    var listDetails: NSDictionary = [:]
    var listPrice: NSDictionary = [:]
    var listDimensionsWeight: NSDictionary = [:]
    var listSections: [NSArray] = []
    var listSectionTitle = ["Detail", "Price", "Dimensions & Weight"]
    var names: [String] = []
    var values: [String] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        customizeNavigationBar()
        
        let nib = UINib(nibName: "ProductDetailsTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: myConstant.cellIdentifier)
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
            self.productDescriptionView.titleLabel.text = myConstant.title
            self.productDescriptionView.seeMoreLabel.text = myConstant.seeMore
        }
        return self.productDescriptionView
    }
    
    // MARK: - Methods
    
    func customizeNavigationBar() {
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = myConstant.title
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton = UIBarButtonItem(image: UIImage(named: "back-white"), style: .Plain, target: self, action: "backAction")
        var editButton = UIBarButtonItem(image: UIImage(named: "edit"), style: .Plain, target: self, action: "editAction")
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, backButton]
        if SessionManager.isSeller() {
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
        self.productDescriptionView.descriptionLabel.text = productModel.completeDescription
        
        let def: CombinationModel = productModel.validCombinations[0]
        self.detailValues = [productModel.category.name, productModel.brand.name]
//        self.detailValues.append(productModel.category.name)
//        self.detailValues.append(productModel.brand.name)
        
        self.priceValues = [def.retailPrice, def.discountedPrice]
//        self.priceValues.append(def.retailPrice)
//        self.priceValues.append(def.discountedPrice)
        
        self.dimensionWeightValues = [def.length, def.width, def.weight, def.height]
//        self.dimensionWeightValues.append(def.length)
//        self.dimensionWeightValues.append(def.width)
//        self.dimensionWeightValues.append(def.weight)
//        self.dimensionWeightValues.append(def.height)
        
        self.listNames = ["Category", "Brand", "Retail Price", "Discounted Price", "Length (CM)", "Width (CM)", "Weight (KG)", "Height (CM)"]
        self.listValues = [productModel.category.name, productModel.brand.name, "P " + def.retailPrice, "P " + def.discountedPrice,
            def.length + "cm", def.width + "cm", def.weight + "kg", def.height + "cm"]
        
//        self.listDetails = ["Category": productModel.category.name, "Brand": productModel.brand.name]
//        self.listPrice = ["Retail Price": def.retailPrice, "Discounted Price": def.discountedPrice]
//        self.listDimensionsWeight = ["Length (CM)": def.length, "Width (CM)": def.width, "Weight (KG)": def.weight, "Height (CM)": def.height]
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
                println(error)
                self.hud?.hide(true)
        })
    }
    
    // MARK: - Actions
    
    func backAction() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func editAction() {
        self.showHUD()
        if self.productModel.imageUrls.count != self.productModel.images.count {
            self.productModel.images = []
            for i in 0..<self.productModel.imageUrls.count {
                var imgURL: NSURL = NSURL(string: self.productModel.imageUrls[i])!
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(
                    request, queue: NSOperationQueue.mainQueue(),
                    completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                        if error == nil {
                            self.productModel.images.append(UIImage(data: data)!)
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
        let cell: ProductDetailsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(myConstant.cellIdentifier) as! ProductDetailsTableViewCell
        cell.selectionStyle = .None
        
        cell.itemNameLabel.text = self.listNames[indexPath.row + (indexPath.section * 2)]
        cell.itemValueLabel.text = self.listValues[indexPath.row + (indexPath.section * 2)]
        
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
        self.navigationController?.presentViewController(productDescription, animated: true, completion: nil)
    }
    
    func downloadImage(url: String) {
        
        var imgURL: NSURL = NSURL(string: url)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    self.imagesToEdit.append(UIImage(data: data)!)
                }
        })
        
    }
    
    // Dealloc
    
//    deinit {
//        self.tableView.delegate = nil
//        self.tableView.dataSource = nil
//    }
}
