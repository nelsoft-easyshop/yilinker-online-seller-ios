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
    
    static let downloadFailed = StringHelper.localizedStringWithKey("PRODUCT_DOWNLOAD_FAILED_LOCALIZE_KEY")
    static let tryAgain = StringHelper.localizedStringWithKey("PRODUCT_TRY_AGAIN_LOCALIZE_KEY")
}

struct ProductUploadEdit {
    static var edit: Bool = false
    static var isPreview: Bool = false
    static var combinedImagesDictionary: [NSMutableDictionary] = []
    static var uploadType: UploadType = UploadType.NewProduct
    static var url: String = ""
    static var parameters: NSMutableDictionary = NSMutableDictionary()
}

class ProductDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProductDescriptionViewDelegate, EmptyViewDelegate, SuccessUploadViewControllerDelegate {

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
    var uploadType: UploadType = UploadType.NewProduct
    var url: String = ""
    var parameters: NSMutableDictionary = NSMutableDictionary()
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ProductDetailsTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: DetailsString.cellIdentifier)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        customizeNavigationBar()
        loadloadViewsWithDetails()
        if Reachability.isConnectedToNetwork() {
            if ProductUploadEdit.isPreview {
                isEditable = true
                populateDetails()
            } else {
                ProductUploadEdit.combinedImagesDictionary.removeAll(keepCapacity: false)
                requestProductDetails()
            }
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.error)
        }
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
        var editButton: UIBarButtonItem?
        
        if ProductUploadEdit.isPreview {
            //editButton = UIBarButtonItem(image: UIImage(named: "check"), style: .Plain, target: self, action: "editAction")
            editButton = UIBarButtonItem(title: "Upload", style: .Plain, target: self, action: "editAction")
        } else {
            editButton = UIBarButtonItem(image: UIImage(named: "edit"), style: .Plain, target: self, action: "editAction")
        }

        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, backButton]
        if SessionManager.isSeller() {
            if isEditable {
                if ProductUploadEdit.edit {
                    
                } else {
                    self.navigationItem.rightBarButtonItem = editButton
                }
            } else if !isEditable && self.uploadType == UploadType.NewProduct && ProductUploadEdit.isPreview {
                self.navigationItem.rightBarButtonItem = editButton
            }
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
        self.uploadType = ProductUploadEdit.uploadType
        self.productImagesView.setDetails(productModel, uploadType: self.uploadType)
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
    
    func gotoEditProduct() {
        self.hud?.hide(true)
        let upload: ProductUploadTC = ProductUploadTC(nibName: "ProductUploadTC", bundle: nil)
        upload.uploadType = UploadType.EditProduct
        upload.productModel = self.productModel
        ProductUploadCombination.draft = true
        let navigationController: UINavigationController = UINavigationController(rootViewController: upload)
        navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
        self.tabBarController!.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func showAlertDownloadFail() {
        let alert = UIAlertController(title: AlertStrings.failed, message: DetailsString.downloadFailed, preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: AlertStrings.ok, style: UIAlertActionStyle.Cancel) { (alert) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alert.addAction(okButton)
//        let tryAgainButton = UIAlertAction(title: DetailsString.downloadFailed, style: UIAlertActionStyle.Default) { (alert) -> Void in
//            self.navigationController?.popViewControllerAnimated(true)
//        }
//        alert.addAction(tryAgainButton)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func downloadImage(url: [String]) {
        println("DOWNLOADING MAIN IMAGES = \(url.count)")
        var downloadedImage: Int = 0
        
        for i in 0..<url.count {
            self.productModel.editedImage.append(ServerUIImage())
            
            var imgURL: NSURL = NSURL(string: url[i])!
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(
                request, queue: NSOperationQueue.mainQueue(),
                completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if error == nil {
                        downloadedImage++
                        println("success downloading main image - \(i + 1)")
                        var convertedImage: ServerUIImage = ServerUIImage(data: data)!
                        convertedImage.uid = self.productModel.imageIds[i]
//                        self.productModel.editedImage.append(convertedImage)
                        self.productModel.editedImage[i] = convertedImage
                        
                        var productMainImagesModel: ProductMainImagesModel = ProductMainImagesModel(image: UIImage(data: data,scale:1.0)!, imageName: self.productModel.imageIds[i], imageStatus: true, imageFailed: false)
                        self.productModel.mainImagesName.append(self.productModel.imageIds[i])
                        if self.productModel.productMainImagesModel.count == 0 {
                            self.productModel.productMainImagesModel.append(productMainImagesModel)
                        } else {
                            self.productModel.productMainImagesModel.insert(productMainImagesModel, atIndex: self.productModel.productMainImagesModel.count)
                        }
                        
                        if downloadedImage == self.productModel.imageUrls.count {
                            self.downloadCombinationsImages()
                        }
                    } else {
                        self.showAlertDownloadFail()
                    }
            })
        }
    }
    
    func downloadCombinationsImages() {
        println("DOWNLOADING COMBINATION IMAGES")
        if self.productModel.validCombinations.count == 0 {
            self.gotoEditProduct()
        } else {
            var imageIndex: Int = 0
            var totalCombinationImages: Int = 0
            var downloadedImages: Int = 0
            
            for i in 0..<self.productModel.validCombinations.count {
                
                if self.productModel.validCombinations[i].imagesUrl.count != 0 && self.productModel.validCombinations[i].imagesUrl[0] != "" {
                    println("downloading images of combination -  \(i + 1)")
                    for j in 0..<self.productModel.validCombinations[i].imagesUrl.count {
                        totalCombinationImages++
                        var imgURL: NSURL = NSURL(string: self.productModel.validCombinations[i].imagesUrl[j])!
                        println("downloading images -  \(j + 1) >> image url == \(imgURL)")
                        // Adding dummy images to be replaced by inserting using index
                        self.productModel.oldEditedCombinationImages.append(ServerUIImage())
                        self.productModel.oldEditedCombinationImages.append(ServerUIImage())
                        self.productModel.validCombinations[i].editedImages.append(ServerUIImage())
                        self.productModel.validCombinations[i].editedImages.append(ServerUIImage())
                        
                        let request: NSURLRequest = NSURLRequest(URL: imgURL)
                        NSURLConnection.sendAsynchronousRequest(
                            request, queue: NSOperationQueue.mainQueue(),
                            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                                downloadedImages++
                                
                                if i == 0 {
                                    imageIndex = j
                                } else {
                                    imageIndex = self.productModel.validCombinations[i - 1].imagesUrl.count + j
                                }
                                
                                if error == nil {
                                    println("downloaded combination image - \(i + 1) of \(j + 1) - index >> \(imageIndex)")
                                    var convertedImage: ServerUIImage = ServerUIImage(data: data)!
                                    convertedImage.uid = self.productModel.validCombinations[i].imagesId[j]
                                    self.productModel.oldEditedCombinationImages[imageIndex] = convertedImage
                                    self.productModel.validCombinations[i].editedImages[j] = convertedImage
                                    
                                    self.productModel.oldEditedCombinationImages.removeLast()
                                    self.productModel.validCombinations[i].editedImages.removeLast()
                                    
                                    if totalCombinationImages == downloadedImages {
                                        self.gotoEditProduct()
                                    }
                                } else {
                                    println("failed downloading combination image - \(i + 1) of \(j + 1)")
                                    self.showAlertDownloadFail()
                                }
                        })
                        
                    }
                } else {
                    self.gotoEditProduct()
                    break
                }
            }
        }
    }
    
    // MARK: - Request
    
    func requestProductDetails() {
        self.showHUD()
        let id: String = "?access_token=" + SessionManager.accessToken() + "&productId=" + productId
        WebServiceManager.fireGetProductDetailsRequestWithUrl(APIAtlas.getProductDetails + id, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.productModel = ProductModel.parseDataWithDictionary(responseObject)
                self.populateDetails()
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    let alert = UIAlertController(title: AlertStrings.failed, message: errorModel.message, preferredStyle: UIAlertControllerStyle.Alert)
                    let okButton = UIAlertAction(title: AlertStrings.ok, style: UIAlertActionStyle.Cancel) { (alert) -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    alert.addAction(okButton)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken()
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        })
    }
    
    func requestRefreshToken() {
        
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.loginUrl, actionHandler: { (successful, responseObject, RequestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.requestProductDetails()
            } else {
                //Forcing user to logout.
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logout()
                    GPPSignIn.sharedInstance().signOut()
                    self.navigationController?.popToRootViewControllerAnimated(false)
                })
            }
        })
    }
    
    // MARK: - Actions
    
    func backAction() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func editAction() {
        if ProductUploadEdit.isPreview {
            self.showHUD()
            self.upload(ProductUploadEdit.uploadType)
        } else {
            if self.productModel != nil {
                self.showHUD()
                if self.productModel.imageUrls.count != self.productModel.editedImage.count {
                    self.productModel.editedImage = []
                    self.downloadImage(self.productModel.imageUrls)
                } else {
                    self.gotoEditProduct()
                }
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
    
    func upload(uploadType: UploadType) {
        self.showHUD()
        WebServiceManager.fireProductUploadRequestWithUrl(ProductUploadEdit.url+"?access_token=\(SessionManager.accessToken())", parameters: ProductUploadEdit.parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if let success = responseObject["isSuccessful"] as? Bool {
                    if success {
                        println(responseObject)
                        self.hud?.hide(true)
                        if uploadType == UploadType.Draft {
                            self.dismissViewControllerAnimated(true, completion: nil)
                            self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyDraft)
                        } else if uploadType == UploadType.EditProduct {
                            ProductUploadEdit.edit = false
                            self.dismissViewControllerAnimated(true, completion: nil)
                            self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyEdited)
                        } else {
                            self.success()
                        }

                        /*
                        if !self.productIsDraft {
                        self.success()
                        } else {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        }*/
                    } else {
                        self.showAlert(Constants.Localized.invalid, message: responseObject["message"] as! String)
                    }
                }
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken2()
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        })
        /*
        WebServiceManager.fireProductUploadImageRequestWithUrl(ProductUploadCombination.url, parameters: ProductUploadCombination.parameters!, data: ProductUploadCombination.datas, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.hud?.hide(true)
                let dictionary: NSDictionary = responseObject as! NSDictionary
                
                if dictionary["isSuccessful"] as! Bool == true {
                    if uploadType == UploadType.Draft {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyDraft)
                    } else if uploadType == UploadType.EditProduct {
                        ProductUploadEdit.edit = false
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyEdited)
                    } else {
                        self.success()
                    }
                } else {
                    self.showAlert(Constants.Localized.invalid, message: dictionary["message"] as! String)
                }

//                if uploadType == UploadType.Draft {
//                    ProductUploadEdit.edit = false
//                    self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyDraft)
//                } else if uploadType == UploadType.EditProduct {
//                    ProductUploadEdit.edit = false
//                    self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyEdited)
//                } else {
//                    self.success()
//                }
//                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken2()
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
                self.tableView.reloadData()
            }
        })*/
    }
    
//    func upload(uploadType: UploadType) {
//        self.showHUD()
//        self.uploadType = uploadType
//        let manager = APIManager.sharedInstance
//        manager.POST(ProductUploadCombination.url, parameters: ProductUploadCombination.parameters, constructingBodyWithBlock: { (formData: AFMultipartFormData) -> Void in
//            for (index, data) in enumerate(ProductUploadCombination.datas) {
//                println("multipart index: \(index)")
//                formData.appendPartWithFileData(data, name: "images[]", fileName: "\(index)", mimeType: "image/jpeg")
//            }
//            
//            }, success: { (NSURLSessionDataTask, response: AnyObject) -> Void in
//                self.hud?.hide(true)
//                let dictionary: NSDictionary = response as! NSDictionary
//                
//                if dictionary["isSuccessful"] as! Bool == true {
//                    if uploadType == UploadType.Draft {
//                        self.dismissViewControllerAnimated(true, completion: nil)
//                        self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyDraft)
//                    } else if uploadType == UploadType.EditProduct {
//                        ProductUploadEdit.edit = false
//                        self.dismissViewControllerAnimated(true, completion: nil)
//                        //self.dismissViewControllerAnimated(true, completion: nil)
//                        self.dismissControllerWithToastMessage(ProductUploadStrings.successfullyEdited)
//                    } else {
//                        self.success()
//                    }
//                } else {
//                    self.showAlert(Constants.Localized.invalid, message: dictionary["message"] as! String)
//                }
//                println(response)
//            }) { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
//                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
//                let data = NSJSONSerialization.dataWithJSONObject(error.userInfo!, options: nil, error: nil)
//                let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                println("error response: \(string)")
//                if task.statusCode == 401 {
//                    self.fireRefreshToken2()
//                } else {
//                    if error.userInfo != nil {
//                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
//                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
//                        self.showAlert(Constants.Localized.error, message: errorModel.message)
//                    } else {
//                        self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
//                    }
//                    self.tableView.reloadData()
//                }
//                self.hud?.hide(true)
//        }
//    }
    
    //MARK: - Fire Refresh Token 2
    func fireRefreshToken2() {
        self.showHUD()
        
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.loginUrl, actionHandler: { (successful, responseObject, RequestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.upload(ProductUploadEdit.uploadType)
            } else {
                //Forcing user to logout.
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logout()
                    GPPSignIn.sharedInstance().signOut()
                    self.navigationController?.popToRootViewControllerAnimated(false)
                })
            }
        })

        /*
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.upload(ProductUploadEdit.uploadType)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else {
                    self.showAlert(Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                }
                self.hud?.hide(true)
        })*/
    }
    
    //MARK: - Dismiss Controller Toast Message
    func dismissControllerWithToastMessage(message: String) {
        self.tableView.endEditing(true)
        self.navigationController?.view.makeToast(message)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            let productManagement: ProductDetailsViewController = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
            let navigationController: UINavigationController = UINavigationController(rootViewController: productManagement)
            navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
            //self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.popViewControllerAnimated(true)
            //self.navigationController?.popToRootViewControllerAnimated(true)//(productManagement, animated: true)
        }
    }
    
    //MARK: - Success
    func success() {
        let successViewController: SuccessUploadViewController = SuccessUploadViewController(nibName: "SuccessUploadViewController", bundle: nil)
        successViewController.delegate = self
        self.presentViewController(successViewController, animated: true, completion: nil)
    }
    
    //MARK: - Success Upload View Controller
    func successUploadViewController(didTapDashBoard viewController: SuccessUploadViewController) {
        self.tableView.hidden = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Success Upload View Controller
    func successUploadViewController(didTapUploadAgain viewController: SuccessUploadViewController) {
        let productUploadTableViewController: ProductUploadTableViewController = ProductUploadTableViewController(nibName: "ProductUploadTableViewController", bundle: nil)
        let navigationController: UINavigationController = UINavigationController(rootViewController: productUploadTableViewController)
        navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
        self.navigationController?.pushViewController(productUploadTableViewController, animated: true)
        //self.dismissViewControllerAnimated(true, completion: nil)
        //self.presentViewController(productUploadTableViewController, animated: true, completion: nil)
        //self.tabBarController!.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    //MARK: Alert view
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    // Dealloc
    /*
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }*/
}

