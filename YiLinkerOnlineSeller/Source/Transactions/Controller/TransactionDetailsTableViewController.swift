//
//  TransactionDetailsTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/4/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionDetailsTableViewController: UITableViewController, TransactionDetailsFooterViewDelegate, TransactionConsigneeTableViewCellDelegate, TransactionCancelOrderViewControllerDelegate, TransactionCancelOrderSuccessViewControllerDelegate, TransactionCancelReasonOrderViewControllerDelegate, TransactionShipItemTableViewControllerDelegate {
    
    var detailsCellIdentifier: String = "TransactionDetailsTableViewCell"
    var productsCellIdentifier: String = "TransactionProductTableViewCell"
    var consigneeCellIdentifier: String = "TransactionConsigneeTableViewCell"
    
    var sectionHeader: [String] = []
    var productList: [String] = []
    
    var tableHeaderView: UIView!
    var tidLabel: UILabel!
    var counterLabel: UILabel!
    
    var tableFooterView: TransactionDetailsFooterView!
    
    var dimView: UIView?
    
    var invoiceNumber: String = ""
    
    var hud: MBProgressHUD?
    
    var transactionDetailsModel: TransactionDetailsModel!
    var transactionConsigneeModel: TransactionConsigneeModel!
    
    var date_modified: String = "2000-01-01 00:00:00.000000"
    var errorMessage: String = ""
    var errorLocalizedString = ""
    
    var transactioStatus: String = ""
    
    var contacts = [W_Contact()]
    var orderProductIds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionDetailsModel = TransactionDetailsModel(isSuccessful: false, message: "", transactionInvoice: "", transactionShippingFee: "", transactionDate: "2000-01-01 00:00:00.000000", transactionPrice: "", transactionQuantity: 0, transactionUnitPrice: "",  transactionStatusId: 0, transactionStatusName: "", transactionPayment: "", transactionItems: [], isCancellable: false, isShippable: false)
        
        transactionConsigneeModel = TransactionConsigneeModel(isSuccessful: false, message: "", deliveryAddress: "", consigneeName: "", consigneeContactNumber: "", buyerId: 0, email: "")
        
        initializeNavigationBar()
        initializeViews()
        registerNibs()
        fireGetTransactionDetails()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNibs() {
        var detailsNib = UINib(nibName: detailsCellIdentifier, bundle: nil)
        tableView.registerNib(detailsNib, forCellReuseIdentifier: detailsCellIdentifier)
        
        var productsNib = UINib(nibName: productsCellIdentifier, bundle: nil)
        tableView.registerNib(productsNib, forCellReuseIdentifier: productsCellIdentifier)
        
        var consigneeNib = UINib(nibName: consigneeCellIdentifier, bundle: nil)
        tableView.registerNib(consigneeNib, forCellReuseIdentifier: consigneeCellIdentifier)
    }
    
    func initializeTableView() {
        tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 80))
        tableHeaderView.backgroundColor = UIColor.whiteColor()
        
        tidLabel = UILabel(frame: CGRectMake(16, 20, (self.view.bounds.width - 32), 20))
        tidLabel.textColor = Constants.Colors.grayText
        tidLabel.font = UIFont(name: "Panton-Bold", size: CGFloat(14))
        tidLabel.text = ""
        tableHeaderView.addSubview(tidLabel)
        
        counterLabel = UILabel(frame: CGRectMake(16, 40, (self.view.bounds.width - 32), 20))
        counterLabel.textColor = Constants.Colors.grayText
        counterLabel.font = UIFont(name: "Panton-Regular", size: CGFloat(14))
        counterLabel.text = ""
        tableHeaderView.addSubview(counterLabel)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableFooterView = nil
        
        transactionDetailsModel.isCancellable = false       //Remove cancel Button
        
        
        if  (transactionDetailsModel.isShippable || transactionDetailsModel.isCancellable) && !SessionManager.isReseller(){
            if tableFooterView == nil {
                tableFooterView = XibHelper.puffViewWithNibName("TransactionDetailsFooterView", index: 0) as! TransactionDetailsFooterView
                tableFooterView.delegate = self
                tableFooterView.setStatus(transactionDetailsModel.isShippable, isCancellable: transactionDetailsModel.isCancellable)
                tableFooterView.frame.size.width = self.view.frame.size.width

                self.tableView.tableFooterView = tableFooterView
            }
        }
        
        
        self.tidLabel.text = "TID-\(self.transactionDetailsModel.transactionInvoice)"
        if self.transactionDetailsModel.transactionQuantity > 1 {
            let productString = StringHelper.localizedStringWithKey("TRANSACTIONS_DETAILS_PRODUCT_LOCALIZE_KEY")
            self.counterLabel.text = "\(self.transactionDetailsModel.transactionQuantity) \(productString)"
        } else {
            let productString = StringHelper.localizedStringWithKey("TRANSACTIONS_DETAILS_PRODUCTS_LOCALIZE_KEY")
            self.counterLabel.text = "\(self.transactionDetailsModel.transactionQuantity) \(productString)"
        }
        
        
        self.tableView.tableHeaderView = tableHeaderView
        
        self.tableView.reloadData()
    }
    
    func initializeNavigationBar() {
        self.title = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_TITLE_LOCALIZE_KEY")
        
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
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func initializeLocalizedStrings() {
        sectionHeader.append(StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_DETAILS_LOCALIZE_KEY"))
        sectionHeader.append(StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_PRODUCT_LIST_LOCALIZE_KEY"))
        
        if !SessionManager.isReseller(){
            sectionHeader.append(StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_CONSIGNEE_LOCALIZE_KEY"))
        }
        errorLocalizedString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        
        initializeTableView()
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return sectionHeader.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {           //Details
            return 1
        } else if section == 1 {    //Product List
            if transactionDetailsModel.transactionItems.count != 0 {
                return transactionDetailsModel.transactionItems[0].products.count
            } else {
                return 0
            }
        } else if section == 2 {    //Consignee
            return 1
        }  else if section == 3 {    //Delivery Status
            return 1
        } else {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: TransactionDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier(detailsCellIdentifier, forIndexPath: indexPath) as! TransactionDetailsTableViewCell
            cell.selectionStyle = .None;
            if transactioStatus == StringHelper.localizedStringWithKey("TRANSACTIONS_TRANSACTIONS_LOCALIZE_KEY") {
                cell.statusLabel.text = "   \(transactionDetailsModel.transactionStatusName)     "
            } else {
                cell.statusLabel.text = "   \(transactioStatus)     "
            }
            
            cell.paymentTypeLabel.text = transactionDetailsModel.transactionPayment
            cell.dateCreatedLabel.text = formatDateToString(formatStringToDate(transactionDetailsModel.transactionDate))
            cell.dateModifiedLabel.text = formatDateToString(formatStringToDate(date_modified))
            cell.totalQuantityLabel.text = "\(transactionDetailsModel.transactionQuantity)"
            cell.totalUnitCostLabel.text = calculateTotalUnitCost().formatToTwoDecimal().formatToPeso()
            cell.shippingCostLabel.text = transactionDetailsModel.transactionShippingFee.formatToPeso()
            cell.totalCostLabel.text = transactionDetailsModel.transactionPrice.formatToPeso()
            return cell
        } else if indexPath.section == 1 {
            let cell: TransactionProductTableViewCell = tableView.dequeueReusableCellWithIdentifier(productsCellIdentifier, forIndexPath: indexPath) as! TransactionProductTableViewCell
            if transactionDetailsModel.transactionItems.count != 0 {
                cell.productNameLabel.text = transactionDetailsModel.transactionItems[0].products[indexPath.row].productName
                cell.statusLabel.text = "   \(transactionDetailsModel.transactionItems[0].products[indexPath.row].orderProductStatusName)   "
            }
            return cell
        }  else if indexPath.section == 2 {
            let cell: TransactionConsigneeTableViewCell = tableView.dequeueReusableCellWithIdentifier(consigneeCellIdentifier, forIndexPath: indexPath) as! TransactionConsigneeTableViewCell
            cell.selectionStyle = .None;
            cell.nameLabel.text = transactionConsigneeModel.consigneeName
            cell.addressLabel.text = transactionConsigneeModel.deliveryAddress
            
            if transactionConsigneeModel.consigneeContactNumber.isEmpty {
                cell.contactNumberLabel.text = "-"
            } else {
                cell.contactNumberLabel.text = transactionConsigneeModel.consigneeContactNumber
            }
            
            cell.delegate = self
            return cell
        } else {
            let cell: TransactionDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier(detailsCellIdentifier, forIndexPath: indexPath) as! TransactionDetailsTableViewCell
            cell.selectionStyle = .None;
            // Configure the cell...
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 40))
        headerView.backgroundColor = Constants.Colors.selectedCellColor
        var headerTextLabel: UILabel = UILabel(frame: CGRectMake(16, 15, (self.view.bounds.width - 32), 20))
        headerTextLabel.textColor = Constants.Colors.grayText
        headerTextLabel.font = UIFont(name: "Panton-Regular", size: CGFloat(12))
        headerTextLabel.text = sectionHeader[section]
        headerView.addSubview(headerTextLabel)
        
        return headerView
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {           //Details
            return 264
        } else if indexPath.section == 1 {    //Product Lis
            return 55
        } else if indexPath.section == 2 {    //Consignee
            return 190
        }else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            var productDetailsController = TransactionProductTableViewController(nibName: "TransactionProductTableViewController", bundle: nil)
            productDetailsController.productModel = transactionDetailsModel.transactionItems[0].products[indexPath.row]
            productDetailsController.invoiceNumber = invoiceNumber
            self.navigationController?.pushViewController(productDetailsController, animated:true)
        }
    }
    
    func calculateTotalUnitCost() -> String {
        var tempUnitCost: Double = 0
        
        for unitCost in transactionDetailsModel.transactionItems[0].products {
            tempUnitCost += (unitCost.totalPrice.stringByReplacingOccurrencesOfString(",", withString: "") as NSString).doubleValue
        }
        
        return "\(tempUnitCost)"
    }
    
    func fireGetTransactionDetails(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "transactionId": invoiceNumber];
        
        manager.GET(APIAtlas.transactionDetails, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.transactionDetailsModel = TransactionDetailsModel.parseDataWithDictionary(responseObject)
            self.date_modified = self.transactionDetailsModel.transactionDate
            
            println(responseObject)
            
            if self.transactionDetailsModel.isSuccessful {
                if SessionManager.isReseller(){
                    self.hud?.hide(true)
                    self.initializeLocalizedStrings()
                } else {
                    self.fireGetConsigneeDetails()
                }
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.transactionDetailsModel.message, title: self.errorLocalizedString)
                self.navigationController!.popViewControllerAnimated(true)
                self.hud?.hide(true)
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
    
    func fireGetConsigneeDetails(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "transactionId": invoiceNumber];
        
        manager.GET(APIAtlas.transactionConsignee, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.transactionConsigneeModel = TransactionConsigneeModel.parseDataWithDictionary(responseObject)
            println(self.transactionConsigneeModel.consigneeName)
            println(responseObject)
            
            if self.transactionConsigneeModel.isSuccessful {
                self.initializeLocalizedStrings()
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.transactionDetailsModel.message, title: self.errorLocalizedString)
                self.navigationController!.popViewControllerAnimated(true)
            }
            
            self.hud?.hide(true)
            
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
            self.fireGetTransactionDetails()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }
    
    func getContactsFromEndpoint(keyword: String){
        //SVProgressHUD.show()
        if (Reachability.isConnectedToNetwork()) {
            self.showHUD()
            
            let manager: APIManager = APIManager.sharedInstance
            manager.requestSerializer = AFHTTPRequestSerializer()
            
            let parameters: NSDictionary = [
                "page"          : "1",
                "limit"         : "1",
                "keyword"       : keyword,
                "access_token"  : SessionManager.accessToken()
                ]   as Dictionary<String, String>
            
            let url = APIAtlas.baseUrl + APIAtlas.ACTION_GET_CONTACTS
            
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.contacts = W_Contact.parseContacts(responseObject as! NSDictionary)
                self.goToMessaging()
                //SVProgressHUD.dismiss()
                self.hud?.hide(true)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        if (SessionManager.isLoggedIn()){
                            self.fireRefreshToken()
                        }
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    }
                    
                    self.contacts = Array<W_Contact>()
                    
                    //SVProgressHUD.dismiss()
                    self.hud?.hide(true)
            })
        }
        
    }
    
    func goToMessaging() {
        var selectedContact : W_Contact?
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let messagingViewController: MessageThreadVC = (storyBoard.instantiateViewControllerWithIdentifier("MessageThreadVC") as? MessageThreadVC)!
        
        if contacts.count != 0 {
            selectedContact = contacts[0]
        }
        
        println("SELECTED CONTACT \(contacts[0].userId)")
        
        var isOnline = "-1"
        if (SessionManager.isLoggedIn()){
            isOnline = "1"
        } else {
            isOnline = "0"
        }
        messagingViewController.sender = W_Contact(fullName: SessionManager.userFullName() , userRegistrationIds: "", userIdleRegistrationIds: "", userId: SessionManager.accessToken(), profileImageUrl: SessionManager.profileImageStringUrl(), isOnline: isOnline)
        messagingViewController.recipient = selectedContact!
        
        self.navigationController?.pushViewController(messagingViewController, animated: true)
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
    
    // MARK: - TransactionDetailsFooterViewDelegate
    func shipItemAction() {
        var shipItemController = TransactionShipItemTableViewController(nibName: "TransactionShipItemTableViewController", bundle: nil)
        shipItemController.invoiceNumber = invoiceNumber
        shipItemController.delegate = self
        
        orderProductIds.removeAll(keepCapacity: false)
        for subValue in transactionDetailsModel.transactionItems[0].products {
            orderProductIds.append(subValue.orderProductId)
        }
        
        shipItemController.orderProductIds = orderProductIds
        self.navigationController?.pushViewController(shipItemController, animated:true)
    }
    
    func cancelOrderAction() {
        showDimView()
        
//        var cancelOrderController = TransactionCancelOrderViewController(nibName: "TransactionCancelOrderViewController", bundle: nil)
//        cancelOrderController.delegate = self
//        cancelOrderController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
//        cancelOrderController.providesPresentationContextTransitionStyle = true
//        cancelOrderController.definesPresentationContext = true
//        cancelOrderController.view.backgroundColor = UIColor.clearColor()
//        self.tabBarController?.presentViewController(cancelOrderController, animated: true, completion: nil)
        
        var reasonController = TransactionCancelReasonOrderViewController(nibName: "TransactionCancelReasonOrderViewController", bundle: nil)
        reasonController.delegate = self
        reasonController.invoiceNumber = invoiceNumber
        reasonController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        reasonController.providesPresentationContextTransitionStyle = true
        reasonController.definesPresentationContext = true
        reasonController.view.backgroundColor = UIColor.clearColor()
        self.tabBarController?.presentViewController(reasonController, animated: true, completion: nil)
    }
    
    // MARK: - TransactionCancelOrderViewControllerDelegate
    func closeCancelOrderViewController() {
        hideDimView()
    }
    
    func yesCancelOrderAction() {
        var reasonController = TransactionCancelReasonOrderViewController(nibName: "TransactionCancelReasonOrderViewController", bundle: nil)
        reasonController.delegate = self
        reasonController.invoiceNumber = invoiceNumber
        reasonController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        reasonController.providesPresentationContextTransitionStyle = true
        reasonController.definesPresentationContext = true
        reasonController.view.backgroundColor = UIColor.clearColor()
        self.tabBarController?.presentViewController(reasonController, animated: true, completion: nil)
    }
    
    func noCancelOrderAction() {
        hideDimView()
    }
    
    
    // MARK: - TransactionCancelOrderSuccessViewControllerDelegate
    func closeCancelOrderSuccessViewController() {
        hideDimView()
        sectionHeader.removeAll(keepCapacity: false)
        self.fireGetTransactionDetails()
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
    
    
    // MARK: - TransactionConsigneeTableViewCellDelegate
    func messageConsigneeAction() {
       println("Message")
        if transactionConsigneeModel.email.isNotEmpty() {
            self.getContactsFromEndpoint(transactionConsigneeModel.email)
        }
    }
    
    func smsConsigneeAction() {
        if !transactionConsigneeModel.consigneeContactNumber.isEmpty {
            UIApplication.sharedApplication().openURL(NSURL(string: "sms:\(transactionConsigneeModel.consigneeContactNumber)")!)
        }
    }
    
    func callConsigneeAction() {
        if !transactionConsigneeModel.consigneeContactNumber.isEmpty {
            UIApplication.sharedApplication().openURL(NSURL(string: "tel:\(transactionConsigneeModel.consigneeContactNumber)")!)
        }
    }
    
    // MARK: - TransactionShipItemTableViewControllerDelegate
    func cancelTransactionShipItem() {
        
    }
    
    func readyForPickupItemTransaction() {
        
        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: StringHelper.localizedStringWithKey("TRANSACTION_SHIP_SUCCESS_LOCALIZE_KEY"), title: StringHelper.localizedStringWithKey("TRANSACTION_SHIP_ITEM_LOCALIZE_KEY"))
        sectionHeader.removeAll(keepCapacity: false)
        self.fireGetTransactionDetails()
    }
    
    
    
    func formatDateToString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.stringFromDate(date)
    }
    
    func formatStringToDate(date: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        return dateFormatter.dateFromString(date)!
    }
}