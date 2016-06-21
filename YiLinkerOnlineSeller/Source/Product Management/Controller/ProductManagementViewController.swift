//
//  ProductManagementViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/25/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

private struct ManagementStrings {
    static let title = StringHelper.localizedStringWithKey("MANAGEMENT_TITLE_LOCALIZE_KEY")
    static let all = StringHelper.localizedStringWithKey("MANAGEMENT_ALL_LOCALIZE_KEY")
    static let active = StringHelper.localizedStringWithKey("MANAGEMENT_ACTIVE_LOCALIZE_KEY")
    static let inactive = StringHelper.localizedStringWithKey("MANAGEMENT_INACTIVE_LOCALIZE_KEY")
    static let drafts = StringHelper.localizedStringWithKey("MANAGEMENT_DRAFTS_LOCALIZE_KEY")
    static let deleted = StringHelper.localizedStringWithKey("MANAGEMENT_DELETED_LOCALIZE_KEY")
    static let underReview = StringHelper.localizedStringWithKey("MANAGEMENT_UNDER_REVIEW_LOCALIZE_KEY")
    static let rejected = StringHelper.localizedStringWithKey("MANAGEMENT_REJECTED_LOCALIZE_KEY")
    static let forCompletion = StringHelper.localizedStringWithKey("MANAGEMENT_COMPLETION_LOCALIZE_KEY")
    
    static let disableAll = StringHelper.localizedStringWithKey("MANAGEMENT_DISABLE_ALL_LOCALIZE_KEY")
    static let restoreAll = StringHelper.localizedStringWithKey("MANAGEMENT_RESTORE_ALL_LOCALIZE_KEY")
    static let deleteAll = StringHelper.localizedStringWithKey("MANAGEMENT_DELETE_ALL_LOCALIZE_KEY")
    
    static let moveActive = StringHelper.localizedStringWithKey("MANAGEMENT_MOVE_ACTIVE_LOCALIZE_KEY")
    static let moveInactive = StringHelper.localizedStringWithKey("MANAGEMENT_MOVE_INACTIVE_LOCALIZE_KEY")
    static let delete = StringHelper.localizedStringWithKey("MANAGEMENT_DELETE_LOCALIZE_KEY")
    static let restore = StringHelper.localizedStringWithKey("MANAGEMENT_RESTORE_LOCALIZE_KEY")
    
    static let modalTitle = StringHelper.localizedStringWithKey("MANAGEMENT_MODAL_TITLE_LOCALIZE_KEY")
    static let modalTitle2 = StringHelper.localizedStringWithKey("MANAGEMENT_MODAL_TITLE2_LOCALIZE_KEY")
    static let modalSubtitle = StringHelper.localizedStringWithKey("MANAGEMENT_MODAL_SUBTITLE_LOCALIZE_KEY")
    static let modalSubtitle2 = StringHelper.localizedStringWithKey("MANAGEMENT_MODAL_SUBTITLE2_LOCALIZE_KEY")
    
    static let stores = StringHelper.localizedStringWithKey("MANAGEMENT_STORES_LOCALIZE_KEY")
    static let language = StringHelper.localizedStringWithKey("MANAGEMENT_LANGUAGE_LOCALIZE_KEY")
}

struct Status {
    static let all = -1
    static let active = 2
    static let inactive = 6
    static let draft = 0
    static let deleted = 3
    static let review = 1
    static let rejected = 5
    static let fullyDeleted = 4
    static let forCompletion = 7
}

struct Draft {
    static var draft: Int = 0
}

class ProductManagementViewController: UIViewController, ProductManagementModelViewControllerDelegate, EmptyViewDelegate {
    
    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var loaderContainerView: UIView!
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var activeInactiveContainerView: UIView!
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var inactiveView: UIView!
    @IBOutlet weak var restoreView: UIView!
    @IBOutlet weak var activeInactiveDeleteContainerView: UIView!
    @IBOutlet weak var activeInactiveView: UIView!
    @IBOutlet weak var delete2View: UIView!
    @IBOutlet weak var activeInactiveLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var restoreLabel: UILabel!
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var dimView: UIView!
    
    var pageTitle: [String] = [ManagementStrings.all, ManagementStrings.active, ManagementStrings.inactive, ManagementStrings.drafts, ManagementStrings.deleted, ManagementStrings.underReview, ManagementStrings.rejected]
    var selectedImage: [String] = ["all2", "active2", "inactive2", "drafts2", "deleted2", "review2", "review2"]
    var deSelectedImage: [String] = ["all", "active", "inactive", "drafts", "deleted", "review", "review"]
    var statusId: [Int] = [Status.all, Status.active, Status.inactive, Status.draft, Status.deleted, Status.review, Status.rejected]
    
    var selectedIndex: Int = 0
    var tableViewSectionHeight: CGFloat = 0
    var tableViewSectionTitle: String = ""
    
    var selectedItemsIndex: [Int] = []
    var selectedItems: [String] = []
    
    var hud: MBProgressHUD?
    var emptyView: EmptyView?
    
    var productModel: ProductManagementProductModel!
    var requestTask: NSURLSessionDataTask!
    
    let flags = ["http://images-mediawiki-sites.thefullwiki.org/04/3/7/0/95484361858573992.png",
        "http://wiki.erepublik.com/images/thumb/2/21/Flag-China.jpg/50px-Flag-China.jpg",
        "https://jeetkunedomalaysia.files.wordpress.com/2014/10/jeet-kune-do-jkd-malaysia-flag.gif",
        "http://www.thailanguagehut.com/wp-content/uploads/2010/04/Thai-Flag.gif",
        "http://flaglane.com/download/singaporean-flag/singaporean-flag-graphic.png",
        "http://flaglane.com/download/singaporean-flag/singaporean-flag-graphic.png",
        "http://flaglane.com/download/singaporean-flag/singaporean-flag-graphic.png"]
    let languages = ["EN", "EN", "CN", "EN", "FR", "08"]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//                SessionManager.setAccessToken("YjU4NTRhNzdmNDRmYjU1ODQ5MzVjZmIyN2E1ZjA4NWMxNTEwNDFhNmRlNTA2MDAyMzAxNWIzYWFjZTIxOTZiMA")
        self.showHUD()
        customizeNavigationBar()
        customizeViews()
        registerNibs()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        getProductList(statusId[selectedIndex], key: self.searchBarTextField.text)
    }
    
    // MARK: - Methods
    
    func registerNibs() {
        
        let nibATVC = UINib(nibName: "ProductManagementAllTableViewCell", bundle: nil)
        self.tableView.registerNib(nibATVC, forCellReuseIdentifier: "ProductManagementAllIdentifier")
        
        let nibTVC = UINib(nibName: "ProductManagementTableViewCell", bundle: nil)
        self.tableView.registerNib(nibTVC, forCellReuseIdentifier: "ProductManagementIdentifier")
        
        let nibCVC = UINib(nibName: "ProductManagementCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(nibCVC, forCellWithReuseIdentifier: "ProductManagementIdentifier")
    }
    
    func customizeViews() {
        self.collectionView.backgroundColor = Constants.Colors.appTheme
        self.searchBarContainerView.backgroundColor = Constants.Colors.appTheme
        self.searchBarTextField.addTarget(self, action: "searchBarTextDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        self.searchBarTextField.layer.cornerRadius = self.searchBarTextField.frame.size.height / 2
        let searchImageView: UIImageView = UIImageView(image: UIImage(named: "search2"))
        searchImageView.frame = CGRectMake(0.0, 0.0, searchImageView.image!.size.width + 10.0, searchImageView.image!.size.height)
        searchImageView.contentMode = UIViewContentMode.Center
        self.searchBarTextField.leftViewMode = UITextFieldViewMode.Always
        self.searchBarTextField.leftView = searchImageView
        
        self.deleteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "deleteAction:"))
        self.activeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "activeAction:"))
        self.inactiveView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "inactiveAction:"))
        self.activeInactiveView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "activeInactiveAction:"))
        self.delete2View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "delete2Action:"))
        self.restoreView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "restoreAction:"))
        self.restoreView.backgroundColor = Constants.Colors.appTheme
        
        self.dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dimAction"))
        self.deleteLabel.text = ManagementStrings.delete
        self.restoreLabel.text = ManagementStrings.restore
        self.emptyLabel.text = StringHelper.localizedStringWithKey("EMPTY_LABEL_NO_PRODUCTS_FOUND_LOCALIZE_KEY")
    }
    
    func customizeNavigationBar() {
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = ManagementStrings.title
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "search"), style: .Plain, target: self, action: "searchAction"), navigationSpacer]
        
        //        //extending navigation bar
        //
        //        self.navigationController?.navigationBar.translucent = false
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Pixel"), forBarMetrics: UIBarMetrics.Default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
        //
        //        //navigation bar shadow
        //        self.view.layer.shadowOffset = CGSizeMake(0, 1.0 / UIScreen.mainScreen().scale)
        //        self.view.layer.shadowRadius = 0
        //
        //        self.view.layer.shadowColor = Constants.Colors.appTheme.CGColor
        //        self.view.layer.shadowOpacity = 0.25
        
    }
    
    func sectionHeaderView() -> UIView {
        var sectionHeaderContainverView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        sectionHeaderContainverView.backgroundColor = UIColor.whiteColor()
        
        let buttonWidth: CGFloat = 80.0
        let lineThin: CGFloat = 0.5
        
        var tabLabel = UILabel(frame: CGRectZero)
        tabLabel.text = pageTitle[selectedIndex]
        tabLabel.textColor = UIColor.darkGrayColor()
        tabLabel.font = UIFont.systemFontOfSize(13.0)
        tabLabel.sizeToFit()
        tabLabel.center.y = sectionHeaderContainverView.center.y
        tabLabel.frame.origin.x = 10.0
        sectionHeaderContainverView.addSubview(tabLabel)
        
        var button1 = UIButton(frame: CGRectMake(self.view.frame.size.width - buttonWidth, 0, buttonWidth, sectionHeaderContainverView.frame.size.height))
        button1.titleLabel?.font = UIFont.systemFontOfSize(11.0)
        button1.setTitleColor(Constants.Colors.appTheme, forState: .Normal)
        button1.addTarget(self, action: "tabAction:", forControlEvents: .TouchUpInside)
        sectionHeaderContainverView.addSubview(button1)
        
        if selectedIndex == 1 {
            button1.setTitle(ManagementStrings.disableAll, forState: .Normal)
        } else if selectedIndex == 2 || selectedIndex == 3 || selectedIndex == 6 {
            button1.setTitle(ManagementStrings.deleteAll, forState: .Normal)
            
            if selectedIndex == 2 {
                var separatorLineView = UIView(frame: CGRectMake(button1.frame.origin.x - lineThin, 0, lineThin, sectionHeaderContainverView.frame.size.height - 10))
                separatorLineView.center.y = sectionHeaderContainverView.center.y
                separatorLineView.backgroundColor = UIColor.lightGrayColor()
                sectionHeaderContainverView.addSubview(separatorLineView)
                
                var restoreAllButton = UIButton(frame: CGRectMake(separatorLineView.frame.origin.x - buttonWidth, 0, buttonWidth, sectionHeaderContainverView.frame.size.height))
                restoreAllButton.setTitle(ManagementStrings.restoreAll, forState: .Normal)
                restoreAllButton.titleLabel?.font = UIFont.systemFontOfSize(11.0)
                restoreAllButton.setTitleColor(Constants.Colors.appTheme, forState: .Normal)
                restoreAllButton.addTarget(self, action: "tabAction:", forControlEvents: .TouchUpInside)
                sectionHeaderContainverView.addSubview(restoreAllButton)
            }
        } else if selectedIndex == 4 {
            button1.setTitle(ManagementStrings.restoreAll, forState: .Normal)
        }
        
        var underlineView = UIView(frame: CGRectMake(0, sectionHeaderContainverView.frame.size.height - lineThin, sectionHeaderContainverView.frame.size.width, lineThin))
        underlineView.backgroundColor = UIColor.lightGrayColor()
        sectionHeaderContainverView.addSubview(underlineView)
        
        return sectionHeaderContainverView
    }
    
    func showModal(#title: String, message: String, status: Int) {
        var productManagementModel = ProductManagementModelViewController(nibName: "ProductManagementModelViewController", bundle: nil)
        productManagementModel.delegate = self
        productManagementModel.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        productManagementModel.providesPresentationContextTransitionStyle = true
        productManagementModel.definesPresentationContext = true
        productManagementModel.view.backgroundColor = UIColor.clearColor()
        productManagementModel.titleLabel.text = title
        productManagementModel.subTitleLabel.text = message
        productManagementModel.status = status
        self.tabBarController?.presentViewController(productManagementModel, animated: true, completion: nil)
        
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0.60
            self.dimView.layer.zPosition = 2
        })
    }
    
    func dismissModal() {
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0
            self.dimView.layer.zPosition = 0
        })
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(frame: CGRectZero)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.loaderContainerView.addSubview(self.hud!)
        self.loaderContainerView.hidden = false
        self.hud?.show(true)
    }
    
    func getProductList(status: Int, key: String) {
        if Reachability.isConnectedToNetwork() {
            if self.requestTask != nil {
                self.requestTask.cancel()
                self.requestTask = nil
            }
            self.showHUD()
            
            var parameters: NSDictionary = [:]
            if status == Status.all {
                //                parameters = ["access_token": SessionManager.accessToken(),
                //                    "status": "all",
                //                    "keyword": key]
                self.requestGetProductList("all", key: key)
            } else {
                //                parameters = ["access_token": SessionManager.accessToken(),
                //                    "status": String(status),
                //                    "keyword": key]
                self.requestGetProductList(String(status), key: key)
            }
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.error)
        }
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
            self.getProductList(self.statusId[self.selectedIndex], key: self.searchBarTextField.text)
        } else {
            addEmptyView()
        }
    }
    
    // MARK: - Actions
    
    func dimAction() {
        dismissModal()
    }
    
    func backAction() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func searchAction() {
        if searchBarContainerView.hidden {
            self.searchBarTextField.becomeFirstResponder()
            self.searchBarContainerView.hidden = false
            self.collectionView.transform = CGAffineTransformMakeTranslation(0.0, 44.0)
            self.tableView.transform = CGAffineTransformMakeTranslation(0.0, 44.0)
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 44, 0)
            self.loaderContainerView.transform = CGAffineTransformMakeTranslation(0.0, 44.0)
            self.emptyLabel.transform = CGAffineTransformMakeTranslation(0.0, 44.0)
        } else {
            self.searchBarTextField.endEditing(true)
            self.searchBarContainerView.hidden = true
            self.collectionView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
            self.tableView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            self.loaderContainerView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
            self.emptyLabel.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
        }
        
    }
    
    func tabAction(sender: AnyObject) {
        if productModel != nil && productModel.products.count != 0 {
            var action: Int = 0
            
            if selectedIndex == 1 {
                action = Status.inactive
            } else if selectedIndex == 2 {
                if sender.titleLabel!!.text == ManagementStrings.deleteAll {
                    action = Status.deleted
                } else if sender.titleLabel!!.text == ManagementStrings.restoreAll {
                    action = Status.active
                }
            } else if selectedIndex == 3 || selectedIndex == 6 {
                action = Status.deleted
            } else if selectedIndex == 4 {
                action = Status.review
            }
            
            if sender.titleLabel!.text != nil {
                showModal(title: ManagementStrings.modalTitle + sender.titleLabel!!.text!.lowercaseString + ManagementStrings.modalTitle2,
                    message: ManagementStrings.modalSubtitle + sender.titleLabel!!.text!.lowercaseString + ManagementStrings.modalSubtitle2,
                    status: action)
            }
        }
    }
    
    func deleteAction(gesture: UIGestureRecognizer) {
        self.searchBarTextField.userInteractionEnabled = false
        if selectedIndex == 3 {
            requestUpdateProductStatus(Status.fullyDeleted)
        } else {
            requestUpdateProductStatus(Status.deleted)
        }
    }
    
    func activeAction(gesture: UIGestureRecognizer) {
        self.searchBarTextField.userInteractionEnabled = false
        requestUpdateProductStatus(Status.inactive)
    }
    
    func inactiveAction(gesture: UIGestureRecognizer) {
        self.searchBarTextField.userInteractionEnabled = false
        requestUpdateProductStatus(Status.active)
    }
    
    func activeInactiveAction(gesture: UIGestureRecognizer) {
        self.searchBarTextField.userInteractionEnabled = false
        if selectedIndex == 1 {
            requestUpdateProductStatus(Status.inactive)
        } else if selectedIndex == 2 {
            requestUpdateProductStatus(Status.active)
//            if SessionManager.isSeller() {
//                requestUpdateProductStatus(Status.active)
//            }
        }
    }
    
    func delete2Action(gesture: UIGestureRecognizer) {
        self.searchBarTextField.userInteractionEnabled = false
        requestUpdateProductStatus(Status.deleted)
    }
    
    func restoreAction(gesture: UIGestureRecognizer) {
        self.searchBarTextField.userInteractionEnabled = false
        requestUpdateProductStatus(Status.review)
    }
    
    // MARK: - Requests
    
    func requestGetProductList(status: String, key: String) {
        WebServiceManager.fireProductListRequestWithUrl(APIAtlas.managementGetProductList, status: String(status), keyword: key, actionHandler: { (successful, responseObject, requestErrorType) -> Void in

            if successful {
                    self.productModel = ProductManagementProductModel.parseDataWithDictionary(responseObject as! NSDictionary)
                    if self.productModel.products.count != 0 {
                        self.tableView.reloadData()
                        
                        if SessionManager.isReseller() {
                            var productStatuses: [Int] = []
                            for i in 0..<self.productModel.products.count {
                                productStatuses.append(self.productModel.products[i].status)
                            }
                            
                            if !(contains(productStatuses, Status.active) || contains(productStatuses, Status.inactive)) {
                                self.emptyLabel.hidden = false
                            }
                    }
                }
                
                self.loaderContainerView.hidden = true
                self.searchBarTextField.userInteractionEnabled = true
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                self.loaderContainerView.hidden = true
                self.searchBarTextField.userInteractionEnabled = true
                if requestErrorType == .ResponseError {
                    //Error in api requirements

                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    if errorModel.message == "No products found" {
                        self.emptyLabel.hidden = false
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "", title: errorModel.message)
                    }
                } else if requestErrorType == .AccessTokenExpired {
                    if status == "all" {
                        self.requestRefreshToken("get", status: Status.all)
                    } else {
                        self.requestRefreshToken("get", status: status.toInt()!)
                    }
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
    
    func requestUpdateProductStatus(status: Int) {
        if Reachability.isConnectedToNetwork() {
            self.showHUD()
            
            WebServiceManager.fireUpdateProductStatusRequestWithUrl(APIAtlas.managementUpdateProductStatus, productId: selectedItems.description, status: status, actionHandler: { (successful, responseObject, requestErrorType) -> Void in

                if successful {
                    self.selectedItems = []
                    self.updateSelectedItems(0, selected: false)
                    self.getProductList(self.statusId[self.selectedIndex], key: self.searchBarTextField.text)
                } else {
                    self.hud?.hide(true)
                    self.loaderContainerView.hidden = true
                    self.searchBarTextField.userInteractionEnabled = true
                    if requestErrorType == .ResponseError {
                        //Error in api requirements
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        
//                        let data: NSArray = (responseObject["data"] as? NSArray)!
//                        if data == NSArray() {
//                            self.emptyLabel.hidden = false
//                        } else {
                            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: responseObject["message"] as! String, title: AlertStrings.failed)
//                        }
                    } else if requestErrorType == .AccessTokenExpired {
                        self.requestRefreshToken("update", status: status)
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
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.error)
        }
    }
    
    func requestRefreshToken(type: String, status: Int) {
        
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.loginUrl, actionHandler: { (successful, responseObject, RequestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                if type == "get" {
                    self.getProductList(status, key: self.searchBarTextField.text)
                } else if type == "update" {
                    self.requestUpdateProductStatus(status)
                } else {
                    println("else in product view refresh token")
                }
            } else {
                //Forcing user to logout.
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logout()
                    GPPSignIn.sharedInstance().signOut()
                    self.navigationController?.popToRootViewControllerAnimated(false)
                })
            }
        })
        
//        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
//            "client_secret": Constants.Credentials.clientSecret,
//            "grant_type": Constants.Credentials.grantRefreshToken,
//            "refresh_token": SessionManager.refreshToken()]
//        
//        let manager = APIManager.sharedInstance
//        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
//            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
//            
//            self.hud?.hide(true)
//            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
//            if type == "get" {
//                self.getProductList(status, key: self.searchBarTextField.text)
//            } else if type == "update" {
//                self.requestUpdateProductStatus(status)
//            } else {
//                println("else in product view refresh token")
//            }
//            
//            }, failure: {
//                (task: NSURLSessionDataTask!, error: NSError!) in
//                self.hud?.hide(true)
//                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "", title: AlertStrings.wentWrong)
//        })
    }
    
} // ProductManagementViewController


extension ProductManagementViewController: UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ProductManagementTableViewCellDelegate, ProductManagementModelViewControllerDelegate {
    
    // MARK: - Search Bar Delegate
    
    func searchBarTextDidChanged(textField: UITextField) {
        if count(self.searchBarTextField.text) > 2 || self.searchBarTextField.text == "" {
            self.emptyLabel.hidden = true
            getProductList(statusId[selectedIndex], key: searchBarTextField.text)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.searchBarTextField.resignFirstResponder()
        
        return true
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productModel != nil {
            return productModel.products.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if selectedIndex == 0 || selectedIndex == 5 {
            let cell: ProductManagementAllTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("ProductManagementAllIdentifier") as! ProductManagementAllTableViewCell
            cell.selectionStyle = .None
            cell.tag = indexPath.row
            
            cell.setProductImage(self.productModel.products[indexPath.row].image)
            cell.titleLabel.text = self.productModel.products[indexPath.row].name
            cell.subTitleLabel.text = self.productModel.products[indexPath.row].category
            cell.setStatus(self.productModel.products[indexPath.row].status)
            
            if selectedIndex == 5 {
                cell.statusLabel.hidden = true
            } else { // adjust labels
//                if self.productModel.products[indexPath.row].status == Status.newUpload {
//                    cell.statusLabel.hidden = true
//                    cell.subTitleLabel.hidden = false
//                } else {
                    cell.statusLabel.hidden = false
                    cell.subTitleLabel.hidden = false
                    cell.adjustLabels()
                    cell.setCountriesAndLanguages(self.productModel.products[indexPath.row])
//                }
            }
            
            if SessionManager.isReseller() {
                if self.productModel.products[indexPath.row].status == Status.active || self.productModel.products[indexPath.row].status == Status.inactive {
                    cell.hidden = false
                } else {
                    cell.hidden = true
                }
            }
            
            return cell
        } else {
            let cell: ProductManagementTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("ProductManagementIdentifier") as! ProductManagementTableViewCell
            cell.selectionStyle = .None
            cell.tag = indexPath.row
            
            cell.delegate = self
            cell.index = selectedIndex
            cell.clearCheckImage()
            
            if contains(selectedItems, self.productModel.products[indexPath.row].id) {
                cell.selected()
            } else {
                cell.deselected()
            }
            
            cell.setProductImage(self.productModel.products[indexPath.row].image)
            cell.titleLabel.text = self.productModel.products[indexPath.row].name
            cell.subTitleLabel.text = self.productModel.products[indexPath.row].category
            cell.setCountriesAndLanguages(self.productModel.products[indexPath.row])
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if SessionManager.isReseller() && self.productModel.products[indexPath.row].status == 0 {
            return 0.0
        }
        
        if self.selectedIndex == 0 || self.selectedIndex == 5 {
            return 88.0
        }
        return 80.0
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewSectionHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if Reachability.isConnectedToNetwork() {
            
            let productManagementMenu = ProductManagementMenuTableViewController(nibName: "ProductManagementMenuTableViewController", bundle: nil)
            productManagementMenu.selectedIndex = self.selectedIndex
            productManagementMenu.productModel = self.productModel.products[indexPath.row]
            self.navigationController?.pushViewController(productManagementMenu, animated: true)
          
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.error)
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchBarTextField.resignFirstResponder()
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductManagementCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("ProductManagementIdentifier", forIndexPath: indexPath) as! ProductManagementCollectionViewCell
        
        cell.titleLabel.text = pageTitle[indexPath.row].uppercaseString
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = .whiteColor()
            cell.setTextColor(Constants.Colors.appTheme)
            cell.setImage(selectedImage[indexPath.row])
        } else {
            cell.setTextColor(UIColor.whiteColor())
            cell.backgroundColor = Constants.Colors.appTheme
            cell.setImage(deSelectedImage[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if selectedIndex != indexPath.row {
            self.emptyLabel.hidden = true
            self.selectedItems = []
            self.productModel = nil
            getProductList(statusId[indexPath.row], key: searchBarTextField.text)
            selectedIndex = indexPath.row
            Draft.draft = indexPath.row
            if selectedIndex == 0 {
                self.tableViewSectionHeight = 0.0
            } else {
                self.tableViewSectionHeight = 40.0
            }
            self.buttonsContainer.hidden = true
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.tableViewSectionHeight, 0, 0, 0)
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if SessionManager.isReseller() {
            if indexPath.row <= 2 {
                return CGSize(width: self.view.frame.size.width / 3, height: 60)
            } else {
                return CGSize(width: 0.0, height: 60.0)
            }
        }
        return CGSize(width: self.view.frame.size.width / 6, height: 60)
    }
    
    // MARK: - Product Management Table View Cell Delegate
    
    func updateSelectedItems(index: Int, selected: Bool) {
        
        if selected {
            self.selectedItems.append(self.productModel.products[index].id)
        } else {
            self.selectedItems = self.selectedItems.filter({$0 != self.productModel.products[index].id})
        }
        
        if selectedIndex == 1 || selectedIndex == 2 {
            self.activeInactiveView.backgroundColor = Constants.Colors.appTheme
            self.activeInactiveDeleteContainerView.hidden = false
            if selectedIndex == 1 {
                self.activeInactiveLabel.text = ManagementStrings.moveInactive
            } else {
                self.activeInactiveLabel.text = ManagementStrings.moveActive
            }
            
            self.deleteView.hidden = true
            self.activeInactiveContainerView.hidden = true
            
        } else if selectedIndex == 3 {
            self.deleteView.hidden = false
            
            self.activeInactiveContainerView.hidden = true
            self.activeInactiveDeleteContainerView.hidden = true
        } else if selectedIndex == 4 {
            self.activeInactiveContainerView.hidden = false

            self.deleteView.hidden = true
            self.activeInactiveDeleteContainerView.hidden = true
        } else if selectedIndex == 6 {
            self.deleteView.hidden = false
            
            self.activeInactiveDeleteContainerView.hidden = true
            self.activeInactiveContainerView.hidden = true
        } else {
            
        }
        
        if self.selectedItems.count != 0 {
            self.buttonsContainer.hidden = false
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        } else {
            self.buttonsContainer.hidden = true
            self.tableView.contentInset = UIEdgeInsetsZero
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
        }
    }
    
    // MARK: - Product Management Modal View Controller Delegate
    
    func pmmvcPressClose() {
        self.dismissModal()
    }
    
    func pmmvcPressNo() {
        self.dismissModal()
    }
    
    func pmmvcPressYes(status: Int) {
        
        selectedItems = []
        for i in 0..<productModel.products.count {
            selectedItems.append(productModel.products[i].id)
        }
        
        requestUpdateProductStatus(status)
        
        self.dismissModal()
    }
    
}
