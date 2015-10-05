//
//  TransactionProductTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionProductTableViewController: UITableViewController, TransactionProductDetailsFooterViewDelegate, TransactionCancelOrderViewControllerDelegate, TransactionCancelOrderSuccessViewControllerDelegate, TransactionCancelReasonOrderViewControllerDelegate, TransactionDeliveryTableViewCellDelegate, TransactionProductDescriptionTableViewCellDelegate {
    
    var purchaseCellIdentifier: String = "TransactionProductPurchaseTableViewCell"
    var productCellIdentifier: String = "TransactionProductDetailsTableViewCell"
    var descriptionCellIdentifier: String = "TransactionProductDescriptionTableViewCell"
    var deliveryCellIdentifier: String = "TransactionDeliveryTableViewCell"
    
    var sectionHeader: [String] = []
    var productAttributeData: [String] = []
    var productAttributeValueData: [String] = ["", "", "", "", ""]
    
    var tableHeaderView: TransactionProductDetailsHeaderView!
    var tableFooterView: TransactionProductDetailsFooterView!
    
    var productModel: TransactionOrderProductModel!
    var invoiceNumber: String = ""
    
    var dimView: UIView?
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productAttributeValueData[0] = productModel.sku
        productAttributeValueData[1] = productModel.width
        productAttributeValueData[2] = productModel.length
        productAttributeValueData[3] = productModel.weight
        productAttributeValueData[4] = productModel.height

        initializeNavigationBar()
        initializeTableView()
        registerNibs()
        initializeViews()
        initializeLocalizedStrings()
        initializeAttributes()
        fireGetProductDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNibs() {
        var purchaseNib = UINib(nibName: purchaseCellIdentifier, bundle: nil)
        tableView.registerNib(purchaseNib, forCellReuseIdentifier: purchaseCellIdentifier)
        
        var productNib = UINib(nibName: productCellIdentifier, bundle: nil)
        tableView.registerNib(productNib, forCellReuseIdentifier: productCellIdentifier)
        
        var descriptionNib = UINib(nibName: descriptionCellIdentifier, bundle: nil)
        tableView.registerNib(descriptionNib, forCellReuseIdentifier: descriptionCellIdentifier)
        
        var deliveryNib = UINib(nibName: deliveryCellIdentifier, bundle: nil)
        tableView.registerNib(deliveryNib, forCellReuseIdentifier: deliveryCellIdentifier)
    }
    
    func initializeTableView() {
        if tableHeaderView == nil {
            tableHeaderView = XibHelper.puffViewWithNibName("TransactionProductDetailsHeaderView", index: 0) as! TransactionProductDetailsHeaderView
            tableHeaderView.frame.size.width = self.view.frame.size.width
            tableHeaderView.productNameLabel.text = productModel.productName
            tableHeaderView.productDescriptionLabel.text = productModel.shortDescription
            tableHeaderView.images.append(productModel.productImage)
        }
        
        if productModel.isCancellable {
            if tableFooterView == nil {
                tableFooterView = XibHelper.puffViewWithNibName("TransactionProductDetailsFooterView", index: 0) as! TransactionProductDetailsFooterView
                tableFooterView.delegate = self
                tableFooterView.frame.size.width = self.view.frame.size.width
                tableFooterView.frame.size.height = 65
                
                
                self.tableView.tableFooterView = tableFooterView
            }
        } else {
            self.tableView.tableFooterView = UIView(frame: CGRectZero)
        }
        
        self.tableView.tableHeaderView = tableHeaderView
    }
    
    func initializeAttributes() {
        for subValue in productModel.attributes {
            productAttributeValueData.insert(subValue.attributeValue, atIndex: 0)
            productAttributeData.insert(subValue.attributeName, atIndex: 0)
        }
        
        self.tableView.reloadData()
    }
    
    func initializeNavigationBar() {
        self.title = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_LOCALIZE_KEY")
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func initializeViews(){
        dimView = UIView(frame: self.view.bounds)
        dimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController?.view.addSubview(dimView!)
        //self.view.addSubview(dimView!)
        dimView?.hidden = true
        dimView?.alpha = 0
    }
    
    func initializeLocalizedStrings() {
        sectionHeader.append(StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_PURCHASE_LOCALIZE_KEY"))
        sectionHeader.append(StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_LOCALIZE_KEY"))
        sectionHeader.append(StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DESCRIPTION_LOCALIZE_KEY"))
        sectionHeader.append(StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DELIVERY_LOCALIZE_KEY"))
        
        productAttributeData.append(StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_SKU_LOCALIZE_KEY"))
        productAttributeData.append(StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_WIDTH_LOCALIZE_KEY"))
        productAttributeData.append(StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_LENGTH_LOCALIZE_KEY"))
        productAttributeData.append(StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_WEIGHT_LOCALIZE_KEY"))
        productAttributeData.append(StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_HEIGHT_LOCALIZE_KEY"))
        
        tableView.reloadData()
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func fireGetProductDetails(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "orderProductId": productModel.orderProductId];
        
        manager.GET(APIAtlas.orderProductDetails, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            println(responseObject)
            self.hud?.hide(true)
            if responseObject != nil {
                if let tempVar = responseObject["isSuccessful"] as? Bool {
                    if tempVar {
                        if responseObject["data"] != nil {
                            if let tempValue: AnyObject? = responseObject["data"] {
                                self.productModel = TransactionOrderProductModel.parseDataWithDictionary(tempValue!)
                                self.initializeTableView()
                                self.initializeAttributes()
                            }
                        }
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: responseObject["message"] as! String, title: StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY"))
                        self.navigationController!.popViewControllerAnimated(true)
                        self.hud?.hide(true)
                    }
                }
            }
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                
                self.hud?.hide(true)
                
                if Reachability.isConnectedToNetwork() {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken()
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                        self.navigationController!.popViewControllerAnimated(true)
                    }
                } else {
                    UIAlertController.displayNoInternetConnectionError(self)
                    self.navigationController!.popViewControllerAnimated(true)
                }
                println(error)
        })
    }
    
    func fireRefreshToken() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.fireGetProductDetails()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeader.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return productAttributeData.count
        } else {
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 45))
        headerView.backgroundColor = Constants.Colors.selectedCellColor
        
        
        var headerSubView: UIView = UIView(frame: CGRectMake(0, 10, self.view.bounds.width, 35))
        headerSubView.backgroundColor = UIColor.whiteColor()
        
        var headerTextLabel: UILabel = UILabel(frame: CGRectMake(16, 8, (self.view.bounds.width - 32), 20))
        headerTextLabel.textColor = Constants.Colors.grayText
        headerTextLabel.font = UIFont(name: "Panton-Bold", size: CGFloat(14))
        headerTextLabel.text = sectionHeader[section]
        headerSubView.addSubview(headerTextLabel)
        
        headerView.addSubview(headerSubView)
        
        var line: UIView = UIView(frame: CGRectMake(0, 44, self.view.bounds.width, 1))
        line.backgroundColor = Constants.Colors.selectedCellColor
        
        headerView.addSubview(line)
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {           //Details
            return 100
        } else if indexPath.section == 1 {    //Product Lis
            return 35
        } else if indexPath.section == 2 {    //Consignee
            return 100
        } else if indexPath.section == 3 {    //Delivery Status
            return 155
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell: TransactionProductPurchaseTableViewCell = tableView.dequeueReusableCellWithIdentifier(purchaseCellIdentifier, forIndexPath: indexPath) as! TransactionProductPurchaseTableViewCell
            cell.quantityLabel.text = "\(productModel.quantity)x"
            cell.priceLabel.text = productModel.unitPrice.formatToTwoDecimal()
            cell.totalCostLabel.text = productModel.totalPrice.formatToTwoDecimal()
            return cell
        } else if indexPath.section == 1 {
            let cell: TransactionProductDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier(productCellIdentifier, forIndexPath: indexPath) as! TransactionProductDetailsTableViewCell
            
            cell.productAttributeLabel.text = productAttributeData[indexPath.row]
            if productAttributeValueData[indexPath.row].isEmpty {
                cell.productDeatilsLabel.text = "-"
            } else {
                cell.productDeatilsLabel.text = productAttributeValueData[indexPath.row]
            }
            
            return cell
        } else if indexPath.section == 2{
            let cell: TransactionProductDescriptionTableViewCell = tableView.dequeueReusableCellWithIdentifier(descriptionCellIdentifier, forIndexPath: indexPath) as! TransactionProductDescriptionTableViewCell
            cell.productDescriptionLabel.text = productModel.fullDescription
            cell.delegate = self
            return cell
        }  else if indexPath.section == 3 {
            let cell: TransactionDeliveryTableViewCell = tableView.dequeueReusableCellWithIdentifier(deliveryCellIdentifier, forIndexPath: indexPath) as! TransactionDeliveryTableViewCell
            cell.selectionStyle = .None;
            cell.delegate = self
            return cell
        } else {
            let cell: TransactionDeliveryTableViewCell = tableView.dequeueReusableCellWithIdentifier(deliveryCellIdentifier, forIndexPath: indexPath) as! TransactionDeliveryTableViewCell
            cell.selectionStyle = .None;
            cell.delegate = self
            return cell
        }
    }
    
    
   // MARK : TransactionProductDetailsFooterViewDelegate
    func cancelButtonOrderAction() {
        showDimView()
        
        var cancelOrderController = TransactionCancelOrderViewController(nibName: "TransactionCancelOrderViewController", bundle: nil)
        cancelOrderController.delegate = self
        cancelOrderController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        cancelOrderController.providesPresentationContextTransitionStyle = true
        cancelOrderController.definesPresentationContext = true
        cancelOrderController.view.backgroundColor = UIColor.clearColor()
        self.tabBarController?.presentViewController(cancelOrderController, animated: true, completion: nil)
    }
    
    // MARK : TransactionProductDescriptionTableViewCellDelegate
    func seeMoreAction() {
        var descriptionController = TransactionProductDescriptionViewController(nibName: "TransactionProductDescriptionViewController", bundle: nil)
        descriptionController.fullDescription = productModel.fullDescription
        self.navigationController?.pushViewController(descriptionController, animated:true)
    }

    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.navigationController?.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func showDimView() {
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    func hideDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 0
            }, completion: { finished in
                self.dimView!.hidden = true
        })
    }
    
    // MARK: - TransactionCancelOrderViewControllerDelegate
    func closeCancelOrderViewController() {
        hideDimView()
    }
    
    func yesCancelOrderAction() {
        var reasonController = TransactionCancelReasonOrderViewController(nibName: "TransactionCancelReasonOrderViewController", bundle: nil)
        reasonController.delegate = self
        reasonController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        reasonController.providesPresentationContextTransitionStyle = true
        reasonController.definesPresentationContext = true
        reasonController.view.backgroundColor = UIColor.clearColor()
        reasonController.orderProductId = productModel.orderProductId
        reasonController.invoiceNumber = invoiceNumber
        self.tabBarController?.presentViewController(reasonController, animated: true, completion: nil)
    }
    
    func noCancelOrderAction() {
        hideDimView()
    }
    
    
    // MARK: - TransactionCancelOrderSuccessViewControllerDelegate
    func closeCancelOrderSuccessViewController() {
        hideDimView()
        productModel.isCancellable = false
        initializeTableView()
    }
    
    func returnToDashboardAction() {
        hideDimView()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: TransactionCancelReasonOrderViewControllerDelegate
    func closeTransactionCancelReasonOrderViewController() {
        hideDimView()
    }
    
    func submitTransactionCancelReason() {
        var successController = TransactionCancelOrderSuccessViewController(nibName: "TransactionCancelOrderSuccessViewController", bundle: nil)
        successController.delegate = self
        successController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        successController.providesPresentationContextTransitionStyle = true
        successController.definesPresentationContext = true
        successController.view.backgroundColor = UIColor.clearColor()
        self.tabBarController?.presentViewController(successController, animated: true, completion: nil)
    }

    // MARK: - TransactionDeliveryTableViewCellDelegate {
    func smsPickupRiderAction() {
        
    }
    
    func callPickupRiderAction() {
        
    }
    
    func smsDeliveryRiderAction() {
        
    }
    
    func callDeliveryRiderAction() {
        
    }
    
    func lastCheckinAction() {
        var transactionDetailsController = TransactionDeliveryLogTableViewController(nibName: "TransactionDeliveryLogTableViewController", bundle: nil)
        transactionDetailsController.orderProductId = productModel.orderProductId
        self.navigationController?.pushViewController(transactionDetailsController, animated:true)
    }
    
}
