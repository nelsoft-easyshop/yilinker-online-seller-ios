//
//  ResolutionCenterViewControllerV2.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 11/17/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// Strings
struct ResolutionStrings {
    static let title = StringHelper.localizedStringWithKey("RESOLUTION_TITLE_LOCALIZE_KEY")
    static let cases = StringHelper.localizedStringWithKey("RESOLUTION_CASES_LOCALIZE_KEY")
    static let open = StringHelper.localizedStringWithKey("RESOLUTION_OPEN_LOCALIZE_KEY")
    static let closed = StringHelper.localizedStringWithKey("RESOLUTION_CLOSED_LOCALIZE_KEY")
    static let file = StringHelper.localizedStringWithKey("RESOLUTION_FILE_LOCALIZE_KEY")
    static let emptyText = StringHelper.localizedStringWithKey("RESOLUTION_EMPTY_LOCALIZE_KEY")
}

class ResolutionCenterViewControllerV2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Buttons
    @IBOutlet weak var casesTab: UIButton!
    @IBOutlet weak var closedTab: UIButton!
    @IBOutlet weak var disputeButton: UIButton!
    @IBOutlet weak var openTab: UIButton!
    
    // Imageviews
    @IBOutlet weak var casesImageView: UIImageView!
    @IBOutlet weak var closedImageView: UIImageView!
    @IBOutlet weak var openImageView: UIImageView!
    
    // Labels
    @IBOutlet weak var casesLabel: UILabel!
    @IBOutlet weak var closedLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    
    // Tableview
    @IBOutlet weak var resolutionTableView: UITableView!
    
    // Views
    @IBOutlet weak var casesContainerView: UIView!
    @IBOutlet weak var closedContainerView: UIView!
    @IBOutlet weak var openContainerView: UIView!
    
    // Model
    var resolutionCenterModel: ResolutionCenterModel!
    
    var currentSelectedFilter = SelectedFilters(time:.Total,status:.Both)
    var tableData = [ResolutionCenterElement]()
    var tabSelector = ButtonToTabBehaviorizer()
    
    // Global Variables
    var hud: MBProgressHUD?
    var dimView: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize tab-behavior for buttons
        tabSelector.viewDidLoadInitialize(casesTab, second: openTab, third: closedTab)
        
        // UITableViewDataSource initialization
        resolutionTableView.dataSource = self
        resolutionTableView.delegate = self
        
        // Dispute button
        disputeButton.addTarget(self, action:"disputePressed", forControlEvents:.TouchUpInside)
        
        //Set text to labels
        self.casesLabel.text = ResolutionStrings.cases
        self.openLabel.text = ResolutionStrings.open
        self.closedLabel.text = ResolutionStrings.closed
        self.disputeButton.setTitle(ResolutionStrings.file, forState: .Normal)
        self.emptyLabel.text = ResolutionStrings.emptyText
        
        //Added tap gesture recognizer to views
        self.casesContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "casesAction:"))
        self.openContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "openAction:"))
        self.closedContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "closedAction:"))
        
        self.setSelectedTab(0)
        
        self.registerNib()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.emptyLabel.hidden = true
        fireGetCases()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let caseDetails = self.storyboard?.instantiateViewControllerWithIdentifier("CaseDetailsTableViewController")
            as! CaseDetailsTableViewController
        caseDetails.passData(tableData[indexPath.row])
        
        self.navigationController?.pushViewController(caseDetails, animated:true);
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = resolutionTableView.dequeueReusableCellWithIdentifier("RcCell") as! ResolutionCenterCell
        
        let currentDataId:(ResolutionCenterElement) = tableData[indexPath.item]
        cell.setData(currentDataId)
        
        return cell
    }
    
    // MARK: Buttons actions
    // MARK: Tab Selection Logic
    @IBAction func casesPressed(sender: AnyObject) {
        if self.tabSelector.didSelectTheSameTab(sender) {
            return
        }
        self.tabSelector.setSelection(.TabOne)
        self.currentSelectedFilter.status = .Both
        fireGetCases()
    }
    
    @IBAction func openPressed(sender: AnyObject) {
        if self.tabSelector.didSelectTheSameTab(sender) {
            return
        }
        self.tabSelector.setSelection(.TabTwo)
        self.currentSelectedFilter.status = .Open
        fireGetCases()
    }
    
    @IBAction func closedPressed(sender: AnyObject) {
        if self.tabSelector.didSelectTheSameTab(sender) {
            return
        }
        self.tabSelector.setSelection(.TabThree)
        self.currentSelectedFilter.status = .Closed
        fireGetCases()
    }
    
    // MARK: Navigation bar
    // Add navigation bar buttons
    func setupNavigationBar() {
        // Title text in Navigation Bar will now turn WHITE
        self.title = ResolutionStrings.title
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        
        // Back button
        let backButton = UIBarButtonItem(title:" ", style:.Plain, target: self, action:"goBackButton")
        backButton.image = UIImage(named: "back-white")
        backButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = backButton
        
        // Filter button
        let filterButton = UIBarButtonItem(title:" ", style:.Plain, target: self, action:"goFilterButton")
        filterButton.image = UIImage(named: "filter-resolution")
        filterButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    // Show loader
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
    
    // MARK: - Navigation Bar Buttons actions
    func goBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goFilterButton() {
        let filtrationNav =
        self.storyboard?.instantiateViewControllerWithIdentifier("FilterNavigationController")
            as! UINavigationController
        let filtrationView = filtrationNav.viewControllers[0] as! ResolutionFilterViewController
        filtrationView.delegate = self
        
        self.navigationController?.presentViewController(filtrationNav, animated: true, completion: nil)
    }
    
    func applyFilter() {
        switch self.currentSelectedFilter.status {
        case .Both:
            tabSelector.setSelection(.TabOne)
        case .Open:
            tabSelector.setSelection(.TabTwo)
        case .Closed:
            tabSelector.setSelection(.TabThree)
        default:
            tabSelector.setSelection(.TabOne)
        }
    }
    
    // MARK: - Tabs Actions
    func casesAction(gesture: UIGestureRecognizer) {
        setSelectedTab(0)
        self.currentSelectedFilter.status = .Both
        fireGetCases()
        self.emptyLabel.hidden = true
    }
    
    func openAction(gesture: UIGestureRecognizer) {
        setSelectedTab(1)
        self.currentSelectedFilter.status = .Open
        fireGetCases()
        self.emptyLabel.hidden = true
    }
    
    func closedAction(gesture: UIGestureRecognizer) {
        setSelectedTab(2)
        self.currentSelectedFilter.status = .Closed
        fireGetCases()
        self.emptyLabel.hidden = true
    }
    
    // MARK: Private methods
    // MARK: - New Dispute View Controller
    func disputePressed() {
        let newDisputeTableviewController: NewDisputeTableViewController2 = NewDisputeTableViewController2(nibName: "NewDisputeTableViewController2", bundle: nil)
        self.navigationController?.pushViewController(newDisputeTableviewController, animated:true)
    }
    
    // MARK: Use to format date in 'yyyy-MM-dd' format eg. 2016-01-23
    func formatDateToCompleteString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(date)
    }
    
    // Register nib files
    func registerNib() {
        // Load custom cell
        let nib = UINib(nibName:"ResolutionCenterCell", bundle:nil)
        resolutionTableView.registerNib(nib, forCellReuseIdentifier: "RcCell")
        resolutionTableView.rowHeight = 108
    }
    
    //MARK: Set selected tab
    func setSelectedTab(index: Int) {
        self.casesContainerView.backgroundColor = Constants.Colors.appTheme
        self.casesImageView.image = UIImage(named: "cases2-a")
        self.casesLabel.textColor = UIColor.whiteColor()
        
        self.openContainerView.backgroundColor = Constants.Colors.appTheme
        self.openImageView.image = UIImage(named: "open2-a")
        self.openLabel.textColor = UIColor.whiteColor()
        
        self.closedContainerView.backgroundColor = Constants.Colors.appTheme
        self.closedImageView.image = UIImage(named: "close4-a")
        self.closedLabel.textColor = UIColor.whiteColor()
        
        if index == 0 {
            self.casesContainerView.backgroundColor = UIColor.whiteColor()
            self.casesImageView.image = UIImage(named: "cases2-b")
            self.casesLabel.textColor = Constants.Colors.appTheme
        } else if index == 1 {
            self.openContainerView.backgroundColor = UIColor.whiteColor()
            self.openImageView.image = UIImage(named: "open2-b")
            self.openLabel.textColor = Constants.Colors.appTheme
        } else if index == 2 {
            self.closedContainerView.backgroundColor = UIColor.whiteColor()
            self.closedImageView.image = UIImage(named: "close4-b")
            self.closedLabel.textColor = Constants.Colors.appTheme
        }
    }
    
    // MARK: Alert view
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    // MARK: - Delegate methods
    func dissmissDisputeViewController(controller: DisputeViewController, type: String) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView?.alpha = 0
            self.dimView?.layer.zPosition = -1
        })
    }
    
    // MARK: -
    // MARK: - REST API request
    // MARK: POST METHOD - Get cases
    /*
    *
    * (Parameters) - access_token, disputeStatusType, dateFrom, dateTo
    *
    * Function to get all the field cases of seller
    *
    */
    func fireGetCases() {
        
        self.showHUD()
    
        var parameters: NSDictionary = NSDictionary()
        
        // add filters to parameter
        if self.currentSelectedFilter.isDefault() {
            parameters = ["access_token" : SessionManager.accessToken()]
        } else {
            let statusFilter = self.currentSelectedFilter.getStatusFilter()
            let timeFilter = self.currentSelectedFilter.getTimeFilter()
            
            var fullDate = timeFilter.componentsSeparatedByString("-")
            
            if timeFilter == ""  {
                parameters = [ "access_token" : SessionManager.accessToken(), "disputeStatusType" : statusFilter]
            } else if statusFilter == "0" {
                if self.currentSelectedFilter.getFilterType() == ResolutionTimeFilter.ThisMonth {
                    let date = NSDate()
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : self.formatDateToCompleteString(date.startOfMonth()!),
                        "dateTo": self.formatDateToCompleteString(date.endOfMonth()!)]
                    
                } else if self.currentSelectedFilter.getFilterType() == ResolutionTimeFilter.ThisWeek {
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : self.currentSelectedFilter.sundayDate(),
                        "dateTo": timeFilter]
                } else {
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : timeFilter]
                }
            } else {
                if self.currentSelectedFilter.getFilterType() == ResolutionTimeFilter.ThisMonth {
                    let date = NSDate()
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : self.formatDateToCompleteString(date.startOfMonth()!),
                        "dateTo": self.formatDateToCompleteString(date.endOfMonth()!),
                        "disputeStatusType" : statusFilter]
                    
                } else if self.currentSelectedFilter.getFilterType() == ResolutionTimeFilter.ThisWeek {
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : self.currentSelectedFilter.sundayDate(),
                        "dateTo": timeFilter,
                        "disputeStatusType" : statusFilter]
                } else {
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : timeFilter,
                        "disputeStatusType" : statusFilter]
                }
            }
        }
        
        WebServiceManager.fireGetResolutionCenterRequestWithUrl(APIAtlas.getResolutionCenterCases, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.resolutionCenterModel = ResolutionCenterModel.parseDataWithDictionary(responseObject)
                
                if self.resolutionCenterModel.isSuccessful {
                    if self.resolutionCenterModel.resolutionArray.count == 0 {
                        self.emptyLabel.hidden = false
                    } else {
                        self.tableData.removeAll(keepCapacity: false)
                        self.tableData = self.resolutionCenterModel.resolutionArray
                        self.resolutionTableView.reloadData()
                    }
                } else {
                    self.emptyLabel.hidden = false
                }
                
                self.hud?.hide(true)
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.showAlert(Constants.Localized.error, message: errorModel.message)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
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
                self.hud?.hide(true)
            }
        })
    }
    
    // MARK: POST METHOD - Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    * Function to refresh token to get another access token
    *
    */
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
            
            self.fireGetCases()
            
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
        })
        
    }
}
