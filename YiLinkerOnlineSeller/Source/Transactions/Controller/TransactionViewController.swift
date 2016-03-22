//
//  TransactionViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noTransactionLabel: UILabel!
    
    var pageTitle: [String] = []
    var selectedImage: [String] = ["transactions2", "newUpdates2", "onGoing2", "completed2", "cancelled3"]
    var deSelectedImage: [String] = ["transaction", "newUpdates", "onGoing", "completed", "cancelled"]
    var selectedItems: [Bool] = []
    
    var types: [String] = ["", "newupdates", "ongoing", "completed", "cancelled"]
    
    var selectedIndex: Int = 0
    var tableViewSectionHeight: CGFloat = 0
    var tableViewSectionTitle: String = ""
    
    var tableData: [TransactionModel] = []
    
    var hud: MBProgressHUD?
    
    var page: Int = 1
    var isRefreshable: Bool = true
    var type: String = ""
    var status: [String] = []
    var paymentMethod: [Int] = []
    var tempPaymentMethod: [Int] = []
    var dateFrom: String = ""
    var dateTo: String = ""
    var tempDateFrom: String = ""
    var tempDateTo: String = ""
    var sortBy: String = ""
    var tempSortBy: String = ""
    
    var errorLocalizedString = ""
    
    var selectedDate: Int = 4
    var selectedStatus: Int = 0
    var selectedPayment: Int = 0
    
    var isFromFilter: Bool = false
    var isNewOrder: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noTransactionLabel.hidden = true
        // Do any additional setup after loading the view.
        registerNibs()
        customizedNavigationBar()
        customizedVies()
        fireGetTransaction()
        initializeLocalizedStrings()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Methods
    
    func registerNibs() {
        let tab = UINib(nibName: "TransactionCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(tab, forCellWithReuseIdentifier: "TransactionCollectionIdentifier")
        
        let list = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        self.tableView.registerNib(list, forCellReuseIdentifier: "TransactionTableIdentifier")
    }
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = StringHelper.localizedStringWithKey("TRANSACTIONS_TITLE_LOCALIZE_KEY")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "filter"), style: .Plain, target: self, action: "filterAction"), navigationSpacer]
    }
    
    func customizedVies() {
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: - Actions

    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func filterAction() {        
        let filterController = TransactionTableViewController(nibName: "TransactionTableViewController", bundle: nil)
        var navigation = UINavigationController(rootViewController: filterController)
        navigation.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        navigation.navigationBar.barTintColor = Constants.Colors.appTheme
        filterController.delegate = self
        filterController.selectedDate = selectedDate
        filterController.selectedPayment = selectedPayment
        filterController.selectedStatus = selectedStatus
        self.navigationController?.presentViewController(navigation, animated: true, completion: nil)
    }
    
    func initializeLocalizedStrings() {
        noTransactionLabel.text = StringHelper.localizedStringWithKey("TRANSACTIONS_NO_TRANSACTIONS_LOCALIZE_KEY")
        pageTitle.append(StringHelper.localizedStringWithKey("TRANSACTIONS_TRANSACTIONS_LOCALIZE_KEY"))
        pageTitle.append(StringHelper.localizedStringWithKey("TRANSACTIONS_NEW_UPDATE_LOCALIZE_KEY"))
        pageTitle.append(StringHelper.localizedStringWithKey("TRANSACTIONS_ONGOING_LOCALIZE_KEY"))
        pageTitle.append(StringHelper.localizedStringWithKey("TRANSACTIONS_COMPLETED_LOCALIZE_KEY"))
        pageTitle.append(StringHelper.localizedStringWithKey("TRANSACTIONS_CANCELLED_LOCALIZE_KEY"))
        errorLocalizedString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        
        collectionView.reloadData()
    }
}



extension TransactionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, TransactionTableViewControllerDelegate {
    

    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageTitle.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TransactionCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("TransactionCollectionIdentifier", forIndexPath: indexPath) as! TransactionCollectionViewCell
        
        cell.pageLabel.text = pageTitle[indexPath.row].uppercaseString
        
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
        selectedIndex = indexPath.row
        
        self.collectionView.reloadData()
        tableData.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        
        type = types[indexPath.row]
        page = 1
        isRefreshable = true
        if !isFromFilter {
            status.removeAll(keepCapacity: false)
            //paymentMethod.removeAll(keepCapacity: false)
            sortBy = ""
        }
        
        if indexPath.row == 1 {
            dateFrom = formatDateToString(NSDate())
            dateTo = formatDateToString(NSDate().addDays(1))
        } else {
            var currentDate: NSDate = NSDate()
            if selectedDate == 1 {
                dateFrom = formatDateToString(NSDate())
                dateTo = formatDateToString(NSDate().addDays(1))
                
            } else if selectedDate == 2 {
                var beginningOfWeek: NSDate = firstDateOfWeekWithDate(currentDate)
                
                dateFrom = formatDateToString(beginningOfWeek)
                dateTo = formatDateToString(beginningOfWeek.addDays(6))
                
            }  else if selectedDate == 3 {
                var beginningOfMonth: NSDate = firstDateOfMonthWithDate(currentDate)
                
                dateFrom = formatDateToString(beginningOfMonth)
                dateTo = formatDateToString(beginningOfMonth.addDays(30))
                
            } else {
                dateFrom = ""
                dateTo = ""
            }

        }
        

        selectedStatus = indexPath.row
        isFromFilter = false
        fireGetTransaction()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return
            CGSize(width: self.view.frame.size.width / 5, height: 50)
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TransactionTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionTableIdentifier") as! TransactionTableViewCell
        cell.selectionStyle = .None
        
        let tempModel = tableData[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: NSDate = dateFormatter.dateFromString(tempModel.date_modified)!
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "MMMM dd, yyyy"
        let dateAdded = dateFormatter1.stringFromDate(date)
        
        cell.setStatus(tempModel.order_status_id.toInt()!)
        cell.setTID(tempModel.invoice_number)
        cell.setPrice(tempModel.total_price.formatToPeso())
            
        if tempModel.total_quantity.toInt() < 2 {
            let productString = StringHelper.localizedStringWithKey("TRANSACTIONS_PRODUCT_LOCALIZE_KEY")
            cell.setProductDate("\(tempModel.total_quantity) \(productString)\t\t\(dateAdded)")
        } else {
            let productString = StringHelper.localizedStringWithKey("TRANSACTIONS_PRODUCTS_LOCALIZE_KEY")
            cell.setProductDate("\(tempModel.total_quantity) \(productString)\t\t\(dateAdded)")
        }
            
        return cell
    }
    
    // MARK: Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !tableData[indexPath.row].invoice_number.isEmpty {
            var transactionDetailsController = TransactionDetailsTableViewController(nibName: "TransactionDetailsTableViewController", bundle: nil)
            transactionDetailsController.invoiceNumber = tableData[indexPath.row].invoice_number
            transactionDetailsController.date_modified = "\(tableData[indexPath.row].date_modified).000000"
            transactionDetailsController.transactioStatus = pageTitle[selectedIndex]
            self.navigationController?.pushViewController(transactionDetailsController, animated:true)
        } else {
            let noInvoiceString = StringHelper.localizedStringWithKey("TRANSACTIONS_NO_INVOCE_LOCALIZE_KEY")
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: noInvoiceString, title: errorLocalizedString)
        }

    }
    
    func scrollViewDidEndDragging(aScrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset: CGPoint = aScrollView.contentOffset
        var bounds: CGRect = aScrollView.bounds
        var size: CGSize = aScrollView.contentSize
        var inset: UIEdgeInsets = aScrollView.contentInset
        var y: CGFloat = offset.y + bounds.size.height - inset.bottom
        var h: CGFloat = size.height
        var reload_distance: CGFloat = 10
        var temp: CGFloat = h + reload_distance
        if y > temp {
            fireGetTransaction()
        }
    }
    
    func fireGetTransaction(){
        self.noTransactionLabel.hidden = true
        if isRefreshable {
            self.showHUD()
            let manager = APIManager.sharedInstance
//            let parameters: NSMutableDictionary = ["access_token" : SessionManager.accessToken(), "page" : page, "type" : type];
            
            var url: String = "\(APIAtlas.transactionList)?access_token=\(SessionManager.accessToken())&page=\(page)"
            
            if status.isEmpty {
                url = "\(url)&type=\(type)"
            } else {
                if status.count < 5 {
                    for subValue in status {
                        url = "\(url)&type=\(subValue)"
                    }
                }
            }
            
            if paymentMethod.count < 5 {
                for subValue in paymentMethod {
                    if subValue != 0 {
                        url = "\(url)&paymentMethod=\(subValue)"
                    }
                }
            }
            
            if !dateFrom.isEmpty {
                url = "\(url)&dateFrom=\(dateFrom)"
            }
            
            if !dateTo.isEmpty {
                url = "\(url)&dateTo=\(dateTo)"
            }
            
            if isNewOrder {
                url = "\(url)&sortBy=create&sortDirection=desc"
                isNewOrder = false
            }
            
            manager.GET(url, parameters: nil, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                let transactionModel: TransactionsModel = TransactionsModel.parseDataWithDictionary(responseObject)
                
                println(responseObject)
                
                if transactionModel.isSuccessful {
                    self.tableData += transactionModel.transactions
                    self.tableView.reloadData()
                    
                    self.page++
                    self.noTransactionLabel.hidden = true
                    if transactionModel.transactions.count == 0 {
                        if self.page == 2 {
                            self.noTransactionLabel.hidden = false
                        }
                        self.isRefreshable = false
                    }
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: transactionModel.message, title: self.errorLocalizedString)
                }
                
                
                self.hud?.hide(true)
                
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                    self.hud?.hide(true)
                    
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken()
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                    }
                    
                    println(error)
            })
        }
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
            self.fireGetTransaction()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
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
    
    // MARK : TransactionTableViewControllerDelegate
    func doneWithFilter(dates: String, statuses: [String], paymentMethods: [String], selectedDate: Int, selectedStatus: Int, selectedPayment: Int) {
        self.selectedDate = selectedDate
        self.selectedStatus = selectedStatus
        self.selectedPayment = selectedPayment
        
        if dates.isEmpty {
            dateFrom = ""
            dateTo = ""
        } else {
            var currentDate: NSDate = NSDate()
            
            if dates == StringHelper.localizedStringWithKey("TRANSACTIONS_TODAY_LOCALIZE_KEY") {
                dateFrom = formatDateToString(NSDate())
                dateTo = formatDateToString(NSDate().addDays(1))
                
            } else if dates == StringHelper.localizedStringWithKey("TRANSACTIONS_THIS_WEEK_LOCALIZE_KEY") {
                var beginningOfWeek: NSDate = firstDateOfWeekWithDate(currentDate)
                
                dateFrom = formatDateToString(beginningOfWeek)
                dateTo = formatDateToString(beginningOfWeek.addDays(6))
                
            }  else if dates == StringHelper.localizedStringWithKey("TRANSACTIONS_THIS_MONTH_LOCALIZE_KEY") {
                var beginningOfMonth: NSDate = firstDateOfMonthWithDate(currentDate)
                
                dateFrom = formatDateToString(beginningOfMonth)
                dateTo = formatDateToString(beginningOfMonth.addDays(30))
                
            } else {
                dateFrom = ""
                dateTo = ""
            }
        }
        
        status.removeAll(keepCapacity: false)
        for subValue in statuses {
            if subValue == StringHelper.localizedStringWithKey("TRANSACTIONS_NEW_ORDER_LOCALIZE_KEY") {
                status.append(types[1])
                isNewOrder = true
            } else if subValue == StringHelper.localizedStringWithKey("TRANSACTIONS_NEW_UPDATE_LOCALIZE_KEY") {
                status.append(types[1])
                isNewOrder = false
            } else if subValue == StringHelper.localizedStringWithKey("TRANSACTIONS_ONGOING_LOCALIZE_KEY") {
                status.append(types[2])
                isNewOrder = false
            } else if subValue == StringHelper.localizedStringWithKey("TRANSACTIONS_COMPLETED_LOCALIZE_KEY") {
                status.append(types[3])
                isNewOrder = false
            }  else if subValue == StringHelper.localizedStringWithKey("TRANSACTIONS_CANCELLED_LOCALIZE_KEY") {
                status.append(types[4])
                isNewOrder = false
            }
        }
        
        paymentMethod.removeAll(keepCapacity: false)
        for subValue in paymentMethods {
            if subValue == StringHelper.localizedStringWithKey("TRANSACTIONS_COD_LOCALIZE_KEY") {
                paymentMethod.append(3)
            } else if subValue == StringHelper.localizedStringWithKey("TRANSACTIONS_CREDIT_DEBIT_CARD_LOCALIZE_KEY") {
                paymentMethod.append(1)
            } else if subValue == StringHelper.localizedStringWithKey("TRANSACTIONS_DRAGONPAY_LOCALIZE_KEY") {
                paymentMethod.append(2)
            } else if subValue == StringHelper.localizedStringWithKey("TRANSACTIONS_PESOPAY_LOCALIZE_KEY") {
                paymentMethod.append(1)
            }  else if subValue == StringHelper.localizedStringWithKey("TRANSACTIONS_WALLET_LOCALIZE_KEY") {
                paymentMethod.append(0)
            }
        }
        tempPaymentMethod = paymentMethod
        tempDateFrom = dateFrom
        tempDateTo = dateTo
        isRefreshable = true
        tableData.removeAll(keepCapacity: false)
        page = 1
        isFromFilter = true
        self.collectionView(collectionView, didSelectItemAtIndexPath: NSIndexPath(forRow: selectedStatus, inSection: 0))
    }
    
    func formatStringToDate(date: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.dateFromString(date)!
    }
    
    func formatDateToString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(date)
    }
    
    func firstDateOfWeekWithDate(date: NSDate) -> NSDate {
        
        var beginningOfWeek: NSDate?
        var calendar: NSCalendar = NSCalendar.currentCalendar()
        calendar.rangeOfUnit(.CalendarUnitWeekOfYear, startDate: &beginningOfWeek, interval: nil, forDate: date)
        
        return beginningOfWeek!
        
    }
    
    func firstDateOfMonthWithDate(date: NSDate) -> NSDate {
        var calendar: NSCalendar = NSCalendar.currentCalendar()
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth, fromDate: date)
        components.day = 1
        return calendar.dateFromComponents(components)!
    }
}