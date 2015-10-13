//
//  FilterResultsRiderNameViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 10/2/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class FilterResultsRiderNameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, FilterViewControllerDelegate {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var searchFilterCollectionView: UICollectionView!
    
    var filterBySelected: String = ""
    
    var filterBy: [String] = []
    
    var dimView2: UIView!
    
    var hud: MBProgressHUD?

    var tableData: [TransactionModel] = []
    var riderName: String = ""
    var productName: String = ""
    var transactionId: String = ""
    var isPageEnd: Bool = false
    var page: Int = 0
    var isSuccessful: Bool = false
    var searchType: Int = 0
    
    let oldToNew: String = StringHelper.localizedStringWithKey("SEARCH_OLD_TO_NEW_LOCALIZE_KEY")
    let newToOld: String = StringHelper.localizedStringWithKey("SEARCH_NEW_TO_OLD_LOCALIZE_KEY")
    let aWeekAgo: String = StringHelper.localizedStringWithKey("SEARCH_A_WEEK_LOCALIZE_KEY")
    let aMonth: String = StringHelper.localizedStringWithKey("SEARCH_A_MONTH_LOCALIZE_KEY")
    var sortDirection: String = ""
    var dateFrom: String = ""
    var dateTo: String = ""
    var filterType: String = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filterBy = [oldToNew, newToOld]
        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        self.filterTableView.separatorInset = UIEdgeInsetsZero
        self.filterTableView.layoutMargins = UIEdgeInsetsZero
        
        self.edgesForExtendedLayout = .None
        dimView2 = UIView(frame: UIScreen.mainScreen().bounds)
        dimView2.backgroundColor=UIColor.blackColor()
        dimView2.alpha = 0.5
        self.navigationController?.view.addSubview(dimView2)
        dimView2.hidden = true
        
        self.dimView.hidden = true
        self.noResultsLabel.hidden = true
        // Do any additional setup after loading the view.
        var tapSort = UITapGestureRecognizer(target: self, action: "sort");
        self.sortView.addGestureRecognizer(tapSort)
        
        var tapFilter = UITapGestureRecognizer(target: self, action: "filter")
        self.filterView.addGestureRecognizer(tapFilter)
        
        var nibFilter = UINib(nibName: "FilterByTableViewCell", bundle: nil)
        self.filterTableView.registerNib(nibFilter, forCellReuseIdentifier: "FilterByTableViewCell")
        
        let collectionViewNib: UINib = UINib(nibName: "FilterResultsCollectionViewCellV2", bundle: nil)
        self.searchFilterCollectionView.registerNib(collectionViewNib, forCellWithReuseIdentifier: "FilterResultsCollectionViewCellV2")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        if IphoneType.isIphone4()  {
            layout.itemSize = CGSize(width: self.view.frame.size.width - 100, height: 79)
        } else if IphoneType.isIphone5() {
            layout.itemSize = CGSize(width: self.view.frame.size.width - 80, height: 79)
        } else {
            layout.itemSize = CGSize(width: self.view.frame.size.width - 20, height: 79)
        }
        
        layout.minimumLineSpacing = 20
        layout.footerReferenceSize = CGSizeMake(self.searchFilterCollectionView.frame.size.width, 38)
        searchFilterCollectionView.collectionViewLayout = layout
        searchFilterCollectionView.dataSource = self
        searchFilterCollectionView.delegate = self
        
        /*
        for var i = 0; i < self.searchModel!.invoiceNumber.count; i++ {
        self.allObjectArray.addObject(i)
        }
        self.elements.addObjectsFromArray(self.allObjectArray.subarrayWithRange(NSMakeRange(0, 20)))
        */
        
        //self.title = "\(self.searchModel!.invoiceNumber.count) Results"
        self.sortDirection = "ASC"
        if self.searchType == 1 {
            self.fireSearchRiderName(transactionId)
        } else if searchType == 2 {
            self.fireSearchRiderName(productName)
        } else {
            self.fireSearchRiderName(riderName)
        }
        
        self.backButton()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sort() {
        if dimView.hidden {
            UIView.animateWithDuration(0.3, animations: {
                self.dimView.hidden = false
                self.dimView.alpha = 1.0
            })
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.dimView.alpha = 0
                }, completion: { finished in
                    self.dimView.hidden = true
            })
        }
        
    }
    
    func filter(){
        self.showView()
        var filterViewController = FilterViewController(nibName: "FilterViewController", bundle: nil)
        filterViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        filterViewController.providesPresentationContextTransitionStyle = true
        filterViewController.definesPresentationContext = true
        filterViewController.delegate = self
        self.tabBarController?.presentViewController(filterViewController, animated: true, completion: nil)
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
        if self.searchType == 1 {
            if y > temp {
                self.fireSearchRiderName(self.transactionId)
            }
        } else if self.searchType == 2 {
            if y > temp {
                self.fireSearchRiderName(self.productName)
            }
        } else {
            if y > temp {
                self.fireSearchRiderName(self.riderName)
            }
        }
        
    }
    
    // Mark: - UITableViewDataSource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.filterTableView.dequeueReusableCellWithIdentifier("FilterByTableViewCell") as! FilterByTableViewCell
        cell.filterByLabel.text = filterBy[indexPath.row]
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
        
    }
    
    // Mark: - UITableViewDelegate methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.dimView.hidden = true
        let indexPath = tableView.indexPathForSelectedRow();
        filterBySelected = filterBy[indexPath!.row]
        if filterBySelected == "0" {
            self.sortDirection = "desc"
        } else {
            self.sortDirection = "asc"
        }
        
        self.tableData.removeAll(keepCapacity: false)
        page = 0
        isPageEnd = false
        
        if self.searchType == 1 {
            self.fireSearchRiderName(transactionId)
        } else if searchType == 2 {
            self.fireSearchRiderName(productName)
        } else {
            self.fireSearchRiderName(riderName)
        }

        
        //Add filto call filter collection view and reload
        println(filterBySelected)
        
    }
    
    //MARK: Collection view delegate methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !self.tableData.isEmpty {
            return self.tableData.count
        } else {
            return 0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : FilterResultsCollectionViewCellV2 = collectionView.dequeueReusableCellWithReuseIdentifier("FilterResultsCollectionViewCellV2", forIndexPath: indexPath) as! FilterResultsCollectionViewCellV2
        
        if !self.tableData.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date: NSDate = dateFormatter.dateFromString(self.tableData[indexPath.row].date_added)!
            
            let dateFormatter1 = NSDateFormatter()
            dateFormatter1.dateFormat = "MMMM dd, yyyy"
            let dateAdded = dateFormatter1.stringFromDate(date)
            cell.statusView.layer.cornerRadius = cell.statusView.frame.height/2
            cell.statusView.layer.cornerRadius = cell.statusView.frame.size.height / 2
            
            if self.tableData[indexPath.row].order_status_id == "1" {
                cell.statusView.backgroundColor = Constants.Colors.transactionNew
                cell.statusImageView.image = UIImage(named: "exclamation")
            } else if self.tableData[indexPath.row].order_status_id == "6" || self.tableData[indexPath.row].order_status_id == "7" || self.tableData[indexPath.row].order_status_id == "11" {
                cell.statusView.backgroundColor = Constants.Colors.transactionOngoing
                cell.statusImageView.image = UIImage(named: "onGoing")
            } else if self.tableData[indexPath.row].order_status_id == "3" {
                cell.statusView.backgroundColor = Constants.Colors.transactionCompleted
                cell.statusImageView.image = UIImage(named: "completed3")
            } else if self.tableData[indexPath.row].order_status_id == "8" {
                cell.statusView.backgroundColor = Constants.Colors.transactionCancelled
                cell.statusImageView.image = UIImage(named: "cancelled2")
            }
            
            //cell.transactionIdLabel.text = self.tableData[indexPath.row].invoice_number
            cell.dateLabel.text = dateAdded
           
            if self.tableData[indexPath.row].product_count.toInt() < 2 {
                let productString = StringHelper.localizedStringWithKey("TRANSACTIONS_PRODUCT_LOCALIZE_KEY")
                cell.numberOfProductsLabel.text = self.tableData[indexPath.row].product_count + " " + productString
            } else {
                let productString = StringHelper.localizedStringWithKey("TRANSACTIONS_PRODUCTS_LOCALIZE_KEY")
                 cell.numberOfProductsLabel.text = self.tableData[indexPath.row].product_count + " " + productString
            }
            
            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
            if self.searchType == 1 {
                let underlineAttributedString = NSAttributedString(string: self.tableData[indexPath.row].invoice_number, attributes: underlineAttribute)
                cell.riderNameLabel.text = "TID-Rider Name"
                cell.productNameLabel.text = self.tableData[indexPath.row].product_names
                cell.transactionIdLabel.textColor = Constants.Colors.appTheme
                cell.productNameLabel.textColor = Constants.Colors.grayText
                cell.riderNameLabel.textColor = Constants.Colors.grayText
                cell.transactionIdLabel.attributedText = underlineAttributedString
            } else if self.searchType == 2 {
                let underlineAttributedString = NSAttributedString(string: self.tableData[indexPath.row].product_names, attributes: underlineAttribute)
                cell.riderNameLabel.text = "PN-Rider Name"
                cell.transactionIdLabel.text = self.tableData[indexPath.row].invoice_number
                cell.productNameLabel.textColor = Constants.Colors.appTheme
                cell.riderNameLabel.textColor = Constants.Colors.grayText
                cell.transactionIdLabel.textColor = UIColor.blackColor()
                cell.productNameLabel.attributedText = underlineAttributedString
            } else {
                let underlineAttributedString = NSAttributedString(string: self.riderName, attributes: underlineAttribute)
                cell.transactionIdLabel.text = self.tableData[indexPath.row].invoice_number
                cell.productNameLabel.text = self.tableData[indexPath.row].product_names
                cell.riderNameLabel.textColor = Constants.Colors.appTheme
                cell.productNameLabel.textColor = Constants.Colors.grayText
                cell.transactionIdLabel.textColor = UIColor.blackColor()
                cell.riderNameLabel.attributedText = underlineAttributedString
            }
            cell.sellerNameLabel.textColor = Constants.Colors.grayText
            cell.dateLabel.textColor = Constants.Colors.grayText
            cell.numberOfProductsLabel.textColor = Constants.Colors.grayText
            //cell.productNameLabel.text = self.tableData[indexPath.row].product_names
            //cell.sellerNameLabel.text = self.tableData[indexPath.row].
            cell.priceLabel.text = "P " + ((self.tableData[indexPath.row].total_price as NSString).floatValue).stringToFormat(2)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //self.showView()
        var transactionDetails = TransactionDetailsTableViewController(nibName: "TransactionDetailsTableViewController", bundle: nil)
        transactionDetails.edgesForExtendedLayout = .None
        transactionDetails.invoiceNumber = self.tableData[indexPath.row].invoice_number
        self.navigationController?.pushViewController(transactionDetails, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSizeMake(collectionView.bounds.size.width, CGFloat(139.0))
    }
    
    /*
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    nextpage = elements.count - 5
    if indexPath.row == nextpage {
    currentPage++
    nextpage = elements.count  - 5
    elements.addObjectsFromArray(allObjectArray.subarrayWithRange(NSMakeRange(currentPage, 20)))
    self.searchFilterCollectionView.reloadData()
    }
    
    }
    */
    
    //MARK: Filter Rider Name
    func fireSearchRiderName(riderName: String) {
        if !isPageEnd {
            //self.clearModel()
            page++
            self.showHUD()
            let manager = APIManager.sharedInstance
            var params: String = ""
            
            if self.searchType == 1 {
                params = "transactionId=\(riderName)"
            } else if self.searchType == 2 {
                params = "productName=\(riderName)"
            } else {
                params = "riderName=\(riderName)"
            }
            
            var currentDate: NSDate = NSDate()
            if self.filterType == "Today" {
                dateFrom = formatDateToString(NSDate())
                dateTo = formatDateToString(NSDate())
                println("Today \(dateFrom)  to \(dateTo)")
            } else if self.filterType == "Day Ago" {
               let dayAgo = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: -1, toDate: NSDate(), options: nil)
                dateFrom = formatDateToString(dayAgo!)
                dateTo = formatDateToString(dayAgo!)
                 println("Day Ago \(dateFrom) to \(dateTo)")
            } else if self.filterType == "Week" {
                var beginningOfWeek: NSDate = firstDateOfWeekWithDate(currentDate)
                
                dateFrom = formatDateToString(beginningOfWeek)
                dateTo = formatDateToString(beginningOfWeek.addDays(6))
                println("Week \(dateFrom) to \(dateTo)")
            } else if self.filterType == "New" {
                
            }
            /*
            var beginningOfMonth: NSDate = firstDateOfMonthWithDate(currentDate)
            
            dateFrom = formatDateToString(beginningOfMonth)
            dateTo = formatDateToString(beginningOfMonth.addDays(30))
            println("Month \(dateFrom)-\(dateTo)")
            */
            var url: String = ""
            var urlEncoded: String = ""
            
            if self.filterType == "All" || self.filterType == "New" {
                url = APIAtlas.transactionLogs+"\(SessionManager.accessToken())&\(params)&sortDirection=\(self.sortDirection)&perPage=15&page=\(page)" as NSString as String
                urlEncoded = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            } else {
                url = APIAtlas.transactionLogs+"\(SessionManager.accessToken())&\(params)&sortDirection=\(self.sortDirection)&perPage=15&page=\(page)&dateFrom=\(dateFrom)&dateTo\(dateTo)" as NSString as String
                urlEncoded = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            }
   
            manager.GET(urlEncoded, parameters: nil, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                println(responseObject)
                let trans: TransactionsModel = TransactionsModel.parseDataWithDictionary(responseObject as! NSDictionary)
                self.isSuccessful = trans.isSuccessful
                
               
                if trans.transactions.count != 0 {
                    if trans.transactions.count < 15 {
                        self.isPageEnd = true
                        
                    }
                    if self.isSuccessful {
                        self.tableData += trans.transactions
                         self.title = "\(self.tableData.count) Results"
                    } else {
                        self.isPageEnd = true
                    }
                }
                
                self.searchFilterCollectionView.reloadData()
                self.dismissView()
                self.hud?.hide(true)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                     self.hud?.hide(true)
            })
        }
    }
    
    //MARK: Navigation bar
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func dismissView() {
        UIView.animateWithDuration(0.25, animations: {
            self.dimView2.alpha = 0
            }, completion: { finished in
                self.dimView2.hidden = true
        })
    }
    
    func filterAction(filter: String) {
        self.filterType = filter
        self.isPageEnd = false
        self.page = 0
        self.tableData.removeAll(keepCapacity: false)
        self.fireSearchRiderName(self.riderName)
    }
    
    func showView(){
        dimView2.hidden = false
        UIView.animateWithDuration(0.25, animations: {
            self.dimView2.alpha = 0.5
            }, completion: { finished in
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
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
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

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
//MARK: Number Formatter
extension Float {
    func stringToFormat(fractionDigits:Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return formatter.stringFromNumber(self) ?? "\(self)"
    }
}