//
//  CaseDetailsTableViewController.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 9/2/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CaseDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var caseIDTitleLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var otherPartyLabel: UILabel!
    @IBOutlet weak var complaintLabel: UILabel!
    @IBOutlet weak var csrLabel: UIView!
    
    @IBOutlet weak var transactionIdTitleLabel: UILabel!
    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var caseID: UILabel!
    @IBOutlet weak var statusCase: UILabel!
    @IBOutlet weak var dateOpen: UILabel!
    @IBOutlet weak var otherParty: UILabel!
    @IBOutlet weak var complainantRemarks: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    //@IBOutlet weak var complainRemarksView: UIView!
    //@IBOutlet weak var complainRemarksCell: UITableViewCell!
    //@IBOutlet weak var csrRemarks: UILabel!
    
    var tableData = [String]()
    
    private var disputeId: String = ""

    var hud: MBProgressHUD?

    //Localize strings
    let caseIdTitle: String = StringHelper.localizedStringWithKey("CASE_ID_LOCALIZE_KEY")
    let detailsTitle: String = StringHelper.localizedStringWithKey("CASE_DETAILS_LOCALIZE_KEY")
    let statusTitle: String = StringHelper.localizedStringWithKey("CASE_STATUS_LOCALIZE_KEY")
    let dateTitle: String = StringHelper.localizedStringWithKey("RESOLUTION_DATE_OPENED_LOCALIZE_KEY")
    let otherPartyTitle: String = StringHelper.localizedStringWithKey("CASE_OTHER_PARTY_LOCALIZE_KEY")
    let complaintTitle: String = StringHelper.localizedStringWithKey("CASE_COMPLAINT_LOCALIZE_KEY")
    let csrTitle: String = StringHelper.localizedStringWithKey("CASE_CSR_LOCALIZE_KEY")
    let caseTitle: String = StringHelper.localizedStringWithKey("CASE_TITLE_LOCALIZE_KEY")
    let items: String = StringHelper.localizedStringWithKey("CASE_ITEMS_LOCALIZE_KEY")
    let transaction: String = StringHelper.localizedStringWithKey("DISPUTE_TRANSACTION_NO_LOCALIZE_KEY")
    override func viewDidLoad() {
        super.viewDidLoad()
        //Localized strings 
        caseIDTitleLabel.text =  caseIdTitle
        detailTitleLabel.text = detailsTitle
        statusTitleLabel.text = statusTitle
        dateTitleLabel.text = dateTitle
        otherPartyLabel.text = otherPartyTitle
        complaintLabel.text = complaintTitle
        transactionIdTitleLabel.text = transaction
        //csrRemarks.text = csrTitle
        itemLabel.text = items
        
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        setupNavigationBar()
        setupClearFields()
        setupControlShape()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fireGetCases()
    }
    
    private func setupControlShape() {
        // rounded label highlight
        statusCase.clipsToBounds = true
        statusCase.layer.cornerRadius = 13
    }
    
    private func setupClearFields()
    {
        caseID.text = ""
        statusCase.text = ""
        dateOpen.text = ""
        otherParty.text = ""
        complainantRemarks.text = ""
        transactionIdLabel.text = ""
        //csrRemarks.text = ""
    }
    
    private func setupNavigationBar() {
        if self.navigationController != nil {
            // white Title on Navigation Bar
            self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
            self.navigationItem.title = caseTitle
            
            // white back button, no text
            let backButton = UIBarButtonItem(title: "Back", style:.Plain, target: self, action:"goBackButton")
            backButton.image = UIImage(named: "back-white")
            backButton.tintColor = UIColor.whiteColor()
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation Bar buttons
    func goBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func passData(data: ResolutionCenterElement) {
        self.disputeId = data.resolutionId
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
        var parameters: NSDictionary =
            ["access_token" : SessionManager.accessToken()
                ,"disputeId": self.disputeId];
        let data2 = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        let string2 = NSString(data: data2!, encoding: NSUTF8StringEncoding)
        println(string2)
        manager.GET(APIAtlas.getResolutionCenterCaseDetails, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let caseDetailsModel: CaseDetailsModel = CaseDetailsModel.parseDataWithDictionary(responseObject)
            
            println(responseObject)
            let data2 = NSJSONSerialization.dataWithJSONObject(responseObject, options: nil, error: nil)
            let string2 = NSString(data: data2!, encoding: NSUTF8StringEncoding)
            println(string2)
            if caseDetailsModel.isSuccessful {
                let caseDetails = caseDetailsModel.caseData
                
                self.caseID.text = caseDetails.ticket
                self.statusCase.text = caseDetails.statusType
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date: NSDate = dateFormatter.dateFromString(caseDetails.dateAdded)!
                
                let dateFormatter1 = NSDateFormatter()
                dateFormatter1.dateFormat = "MMMM dd, yyyy"
                let dateAdded = dateFormatter1.stringFromDate(date)
                self.dateOpen.text = dateAdded
                self.transactionIdLabel.text = caseDetails.transactionId
                // In Seller other is Disputer, In Buyer other is Disputee
                self.otherParty.text = caseDetails.disputerName
                for remarkElement in caseDetails.remarks {
                    if( remarkElement.isAdmin ) {
                        //self.csrRemarks.text = remarkElement.message
                    }
                    else {
                        self.complainantRemarks.text = remarkElement.message
                    }
                }
                self.tableData = caseDetails.products
                self.tableView.reloadData()
            } else {
               self.showAlert(title: Constants.Localized.error, message: responseObject["message"] as! String)
            }
            self.hud?.hide(true)
            
        }, failure: {
            (task: NSURLSessionDataTask!, error: NSError!) in
            self.hud?.hide(true)
            
            let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
            println("error \(task.statusCode)")
            if task.statusCode == 401 {
                self.fireRefreshToken()
            } else {
              self.showAlert(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
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
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: UITableViewController
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ProductCell") as! UITableViewCell
        cell.textLabel!.font = UIFont(name: "Panton-Regular", size: 15.0)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.textLabel!.text = self.tableData[indexPath.row]
        return cell
    }

}
