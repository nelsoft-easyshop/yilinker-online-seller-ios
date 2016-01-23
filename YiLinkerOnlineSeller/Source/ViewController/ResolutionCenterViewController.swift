//
//  ResolutionCenterViewController.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ResolutionCenterViewController
: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Buttons
    @IBOutlet weak var casesTab: UIButton!
    @IBOutlet weak var closedTab: UIButton!
    @IBOutlet weak var disputeButton: UIButton!
    @IBOutlet weak var openTab: UIButton!
    
    //Labels
    @IBOutlet weak var casesLabel: UILabel!
    @IBOutlet weak var closedLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    
    //Imageviews
    @IBOutlet weak var caseImageView: UIImageView!
    @IBOutlet weak var closedImageView: UIImageView!
    @IBOutlet weak var openImageView: UIImageView!
    
    //Tabkeview
    @IBOutlet weak var resolutionTableView: UITableView!
    
    //Views
    @IBOutlet weak var closedView: UIView!
    @IBOutlet weak var casesView: UIView!
    @IBOutlet weak var openVIew: UIView!
    
    //Localize strings
    let caseTitle: String = StringHelper.localizedStringWithKey("RESOLUTION_CASES_LOCALIZE_KEY")
    let openTitle: String = StringHelper.localizedStringWithKey("RESOLUTION_OPEN_LOCALIZE_KEY")
    let closedTitle: String = StringHelper.localizedStringWithKey("RESOLUTION_CLOSED_LOCALIZE_KEY")
    let resolutionTitle: String = StringHelper.localizedStringWithKey("RESOLUTION_TITLE_LOCALIZE_KEY")
    let fileDisputeTitle: String = StringHelper.localizedStringWithKey("RESOLUTION_FILE_LOCALIZE_KEY")
    let resTitle: String = StringHelper.localizedStringWithKey("RESOLUTION_TITLE_LOCALIZE_KEY")
    
    //Models
    var resolutionCenterModel: ResolutionCenterModel = ResolutionCenterModel()
    
    var currentSelectedFilter = SelectedFilters(time:.Total, status:.Both)
    var tableData = [ResolutionCenterElement]()
    var tabSelector = ButtonToTabBehaviorizer()
    
    //Global variables declaration
    var dimView: UIView? = nil
    var hud: MBProgressHUD?
    
    /// Don't Call fireGetCases() everytime this screen is shown
    /// Call it intentionally from inside the completion: from screens
    //override func viewDidAppear(animated: Bool) {
    //    super.viewDidAppear(animated)
    //    fireGetCases()
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set localized string to buttons
        //casesTab.setTitle(caseTitle, forState: UIControlState.Normal)
        casesLabel.text = caseTitle
        openLabel.text = openTitle
        closedLabel.text = closedTitle
        
        //openTab.setTitle(openTitle, forState: UIControlState.Normal)
        //closedTab.setTitle(closedTitle, forState: UIControlState.Normal)
        disputeButton.setTitle(fileDisputeTitle, forState: UIControlState.Normal)
        
        // Initialize tab-behavior for buttons
        //tabSelector.viewDidLoadInitialize(casesTab, second: openTab, third: closedTab)
        self.title = resTitle
        
        // UITableViewDataSource initialization
        resolutionTableView.dataSource = self
        resolutionTableView.delegate = self
        
        // Load custom cell
        let nib = UINib(nibName:"ResolutionCenterCell", bundle:nil)
        resolutionTableView.registerNib(nib, forCellReuseIdentifier: "RcCell")
        resolutionTableView.rowHeight = 108
        
        setupNavigationBar()
        
        // Dispute button
        disputeButton.addTarget(self, action:"disputePressed", forControlEvents:.TouchUpInside)
        
        caseImageView.image = UIImage(named: "cases2-b")
        closedImageView.image = UIImage(named: "close4-a")
        openImageView.image = UIImage(named: "open2-a")
        casesView.backgroundColor = UIColor.whiteColor()
        closedView.backgroundColor = Constants.Colors.appTheme
        openVIew.backgroundColor = Constants.Colors.appTheme
        casesLabel.textColor = Constants.Colors.appTheme
        closedLabel.textColor = UIColor.whiteColor()
        openLabel.textColor = UIColor.whiteColor()
        
        // Initial data load
        fireGetCases()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableData.removeAll(keepCapacity: false)
        self.fireGetCases()
    }
    // MARK: initialization functions
    func setupNavigationBar() {
        // Title text in Navigation Bar will now turn WHITE
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
    
    // MARK: Tab Selection Logic
    @IBAction func casesPressed(sender: AnyObject) {
        //if self.tabSelector.didSelectTheSameTab(sender) {
        //    return
       // }
        //self.tabSelector.setSelection(.TabOne)
        caseImageView.image = UIImage(named: "cases2-b")
        closedImageView.image = UIImage(named: "close4-a")
        openImageView.image = UIImage(named: "open2-a")
        casesView.backgroundColor = UIColor.whiteColor()
        closedView.backgroundColor = Constants.Colors.appTheme
        openVIew.backgroundColor = Constants.Colors.appTheme
        casesLabel.textColor = Constants.Colors.appTheme
        closedLabel.textColor = UIColor.whiteColor()
        openLabel.textColor = UIColor.whiteColor()
        
        self.currentSelectedFilter.status = .Both
        fireGetCases()
    }

    @IBAction func openPressed(sender: AnyObject) {
       // if self.tabSelector.didSelectTheSameTab(sender) {
        //    return
        //}
        //self.tabSelector.setSelection(.TabTwo)
        caseImageView.image = UIImage(named: "cases2-a")
        closedImageView.image = UIImage(named: "close4-a")
        openImageView.image = UIImage(named: "open2-b")
        casesView.backgroundColor = Constants.Colors.appTheme
        closedView.backgroundColor = Constants.Colors.appTheme
        openVIew.backgroundColor = UIColor.whiteColor()
        casesLabel.textColor = UIColor.whiteColor()
        closedLabel.textColor = UIColor.whiteColor()
        openLabel.textColor = Constants.Colors.appTheme
        self.currentSelectedFilter.status = .Open
        fireGetCases()
    }
    
    @IBAction func closedPressed(sender: AnyObject) {
        //if self.tabSelector.didSelectTheSameTab(sender) {
        //    return
        //}
        //self.tabSelector.setSelection(.TabThree)
        caseImageView.image = UIImage(named: "cases2-a")
        closedImageView.image = UIImage(named: "close4-b")
        openImageView.image = UIImage(named: "open2-a")
        casesView.backgroundColor = Constants.Colors.appTheme
        closedView.backgroundColor = UIColor.whiteColor()
        openVIew.backgroundColor = Constants.Colors.appTheme
        casesLabel.textColor = UIColor.whiteColor()
        closedLabel.textColor = Constants.Colors.appTheme
        openLabel.textColor = UIColor.whiteColor()
        self.currentSelectedFilter.status = .Closed
        fireGetCases()
    }
    
    // Mark: - New Dispute View Controller
    func disputePressed() {
        let newDisputeTableviewController: NewDisputeTableViewController2 = NewDisputeTableViewController2(nibName: "NewDisputeTableViewController2", bundle: nil)
        self.navigationController?.pushViewController(newDisputeTableviewController, animated:true)
    }
    
    // Mark: - OLD VERSION FOR MODAL File a Dispute
    private func disputeOldPressed() {
        var attributeModal = DisputeViewController(nibName: "DisputeViewController", bundle: nil)
        //attributeModal.delegate = self
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.backgroundColor = UIColor.clearColor()
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
      
        //UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(attributeModal, animated: true, completion: nil)
        self.navigationController?.presentViewController(attributeModal, animated: true, completion: nil)

        if self.dimView == nil {
            let dimView = UIView(frame: self.view.frame)
            dimView.tag = 1337;
            dimView.backgroundColor = UIColor.blackColor();
            dimView.alpha = 0.7;
            self.dimView = dimView
        }
        self.view.addSubview(self.dimView!);
        
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView?.alpha = 0.5
            self.dimView?.layer.zPosition = 2
            //self.view.transform = CGAffineTransformMakeScale(0.92, 0.95)
            //self.navigationController?.navigationBar.alpha = 0.0
        })
    }
    
    func dissmissDisputeViewController(controller: DisputeViewController, type: String) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView?.alpha = 0
            self.dimView?.layer.zPosition = -1
            //self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            //self.navigationController?.navigationBar.alpha = CGFl oat(self.visibility)
        })
    }

    
    
    // MARK: - Navigation Bar Buttons
    func goBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goFilterButton() {
        let filtrationNav =
            self.storyboard?.instantiateViewControllerWithIdentifier("FilterNavigationController")
                as! UINavigationController
        let filtrationView = filtrationNav.viewControllers[0] as! ResolutionFilterViewController
        //filtrationView.delegate = self

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
        fireGetCases()
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
    
    func fireGetCases() {
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        var parameters: NSDictionary = NSDictionary();
        var urlString: String = APIAtlas.getResolutionCenterCases
        
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
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : "\(fullDate[0])-1-\(fullDate[2])",
                        "dateTo": timeFilter]
                    
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
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : "\(fullDate[0])-1-\(fullDate[2])",
                        "dateTo": timeFilter,
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
        println(parameters)
        
        manager.GET(urlString, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.resolutionCenterModel = ResolutionCenterModel.parseDataWithDictionary(responseObject as! NSDictionary)
            
            //            var fullDate = self.resolutionCenterModel.resolutionArray[0].date.componentsSeparatedByString(" ")
            //            println(fullDate[0])
            //
            //            let dateFormatter = NSDateFormatter()
            //            dateFormatter.dateFormat = "MM/dd/yyyy"
            //            let date = dateFormatter.dateFromString(fullDate[0])
            //            println(date)
            
            if self.resolutionCenterModel.isSuccessful {
                self.tableData.removeAll(keepCapacity: false)
                self.tableData = self.resolutionCenterModel.resolutionArray
                self.resolutionTableView.reloadData()
            } else {
                println(responseObject["message"])
                //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Error while reading Resolution Center table", title: "Data Loading Error")
                self.tableData.removeAll(keepCapacity: false)
                self.tableData = self.resolutionCenterModel.resolutionArray
                self.resolutionTableView.reloadData()
            }
            
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Error Refreshing Token", title: "Refresh Token Error")
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
            self.fireGetCases()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }
}
