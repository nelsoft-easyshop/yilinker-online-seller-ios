//
//  WithdrawTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WithdrawTableViewController: UITableViewController, AvailableBalanceDelegate, WithdrawAmountViewDelegate, WithdrawConfirmationCodeViewDelegate, WithdrawProceedViewDelegate {
    
    var headerView: UIView!
    var availableBalanceView: WithdrawAvailableBalanceView!
    var amountView: WithdrawAmountView!
    var methodView: WithdrawMethodView!
    var depositToView: WithdrawDepositToView!
    var mobileNoView: WithdrawMobileNoView!
    var confimationCodeView: WithdrawConfirmationCodeView!
    var proceedView: WithdrawProceedView!
    
    var newFrame: CGRect!
    
    var balanceRecordModel: BalanceRecordModel!
    
    var dimView: UIView!
    
    var timer = NSTimer()
    var cooldown: Int = 60
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        fireGetWithdrawalBalance()
        addViews()
    }
    
    // MARK: - Initialize Views
    
    func getHeaderView() -> UIView {
        if self.headerView == nil {
            self.headerView = UIView(frame: CGRectZero)
            self.headerView.autoresizesSubviews = false
        }
        return self.headerView
    }
    
    func getAvailableBalanceView() -> WithdrawAvailableBalanceView {
        if self.availableBalanceView == nil {
            self.availableBalanceView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 0) as! WithdrawAvailableBalanceView
            self.availableBalanceView.delegate = self
        }
        return self.availableBalanceView
    }
    
    func getAmountView() -> WithdrawAmountView {
        if self.amountView == nil {
            self.amountView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 1) as! WithdrawAmountView
            self.amountView.delegate = self
        }
        return self.amountView
    }
    
    func getMethodView() -> WithdrawMethodView {
        if self.methodView == nil {
            self.methodView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 2) as! WithdrawMethodView
        }
        return self.methodView
    }
    
    func getDepositToView() -> WithdrawDepositToView {
        if self.depositToView == nil {
            self.depositToView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 3) as! WithdrawDepositToView
        }
        return self.depositToView
    }
    
    func getMobileNoView() -> WithdrawMobileNoView {
        if self.mobileNoView == nil {
            self.mobileNoView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 4) as! WithdrawMobileNoView
        }
        return self.mobileNoView
    }
    
    func getConfimationCodeView() -> WithdrawConfirmationCodeView {
        if self.confimationCodeView == nil {
            self.confimationCodeView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 5) as! WithdrawConfirmationCodeView
            self.confimationCodeView.delegate = self
        }
        return self.confimationCodeView
    }
    
    func getProceedView() -> WithdrawProceedView {
        if self.proceedView == nil {
            self.proceedView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 6) as! WithdrawProceedView
            self.proceedView.delegate = self
        }
        return self.proceedView
    }
    
    // MARK: - Functions
    
    func addViews() {
        self.getHeaderView().addSubview(self.getAvailableBalanceView())
        self.getHeaderView().addSubview(self.getAmountView())
        self.getHeaderView().addSubview(self.getMethodView())
        self.getHeaderView().addSubview(self.getDepositToView())
        self.getHeaderView().addSubview(self.getMobileNoView())
        self.getHeaderView().addSubview(self.getConfimationCodeView())
        self.getHeaderView().addSubview(self.getProceedView())
        
        positionViews()
    }
    
    func positionViews() {
        self.setPosition(self.amountView, from: self.availableBalanceView)
        self.setPosition(self.methodView, from: self.amountView)
        self.setPosition(self.depositToView, from: self.methodView)
        self.setPosition(self.mobileNoView, from: self.depositToView)
        self.setPosition(self.confimationCodeView, from: self.mobileNoView)
        self.setPosition(self.proceedView, from: self.confimationCodeView)
        
        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.proceedView.frame)
        self.headerView.frame = newFrame
        
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame) + 20
        view.frame = newFrame
    }
    
    func populateData() {
        self.availableBalanceView.setAvailableBalance(balanceRecordModel.availableBalance)
    }
    
    func startCooldown() {
        cooldown--
        if cooldown == 0 {
            timer.invalidate()
            cooldown = 60
            self.confimationCodeView.getCodeButton.setTitle("GET CODE", forState: .Normal)
            self.confimationCodeView.getCodeButton.userInteractionEnabled = true
        } else {
            self.confimationCodeView.getCodeButton.setTitle("00:" + String(cooldown), forState: .Normal)
        }
        
    }
    
    // validate requirements
    
    func didMeetRequirements() -> Bool {
        
        if self.amountView.amountTextField.text == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Amount is required.", title: "Unable to Proceed")
            return false
        } else if (self.amountView.amountTextField.text as NSString).doubleValue < 100.0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Amount must be higher or equal than P100.0.", title: "Unable to Proceed")
            return false
        }
        
        return true
    }
    
    // show confirmation modal
    
    func showConfirmationModal() {
        var withdrawModal = WithdrawModalViewController(nibName: "WithdrawModalViewController", bundle: nil)
        //        withdrawModal.delegate = self
        withdrawModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        withdrawModal.providesPresentationContextTransitionStyle = true
        withdrawModal.definesPresentationContext = true
        withdrawModal.view.backgroundColor = UIColor.clearColor()
        self.tabBarController?.presentViewController(withdrawModal, animated: true, completion: nil)
        
        //        dimView = UIView(frame: self.view.bounds)
        //        dimView.backgroundColor = .blackColor()
        //        dimView.alpha = 0.0
        //        self.navigationController?.navigationBar.addSubview(dimView)
        //
        //        UIView.animateWithDuration(0.25, animations: {
        //            self.dimView.alpha = 0.60
        //        })
    }
    
    // MARK: - Requests
    
    func fireGetWithdrawalBalance() {
        let parameters: NSDictionary = ["access_token": /*SessionManager.accessToken()*/"YTBhM2RiYjczMzliYTk3ZGI4ZTBiZThlYzM1YmUxNDJkZGIwMzE4N2IxOTVjNTFlYTEwYmM0M2QyZGM4NjlhYw", "dateTo": "", "dateFrom": "", "page": 1, "perPage": 1]
        
        WebServiceManager.fireGetBalanceRecordRequestWithUrl(APIAtlas.getBalanceRecordDetails, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.balanceRecordModel = BalanceRecordModel.parseDataWithDictionary(responseObject as! NSDictionary)
                self.populateData()
            } else {
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .PageNotFound {
                    Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                } else {
                    println(responseObject)
                }
            }
        })
    }
    
    func fireGetCode() {
        
        let parameters: NSDictionary = ["access_token": /*SessionManager.accessToken()*/"ZTJkMjVmYmEyNjExODcyMDViZmZmMTkwZTVlM2QxODY2OThjYzNmOThkZGFlODQ1MjQwY2I0MGMzYjNmYzIyNA", "type": "withdrawal"]
        
        var url: String = APIAtlas.baseUrl
        url = url.stringByReplacingOccurrencesOfString("v1", withString: APIAtlas.OTPAuth, options: nil, range: nil)
        println(url)
        
        WebServiceManager.fireOTPAuthenticatedRequestWithUrl(url, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                println(responseObject)
                
                self.confimationCodeView.getCodeButton.userInteractionEnabled = false
                
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Confirmation code has been sent to your mobile number.", title: "Code Request Sent")
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("startCooldown"), userInfo: nil, repeats: true)
                
            } else {
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .PageNotFound {
                    Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                } else {
                    println(responseObject)
                }
            }
        })
    }
    
    func fireSubmitWithdrawal() {
        var method: String = "bank"
        
        if !self.methodView.chequeCheckImageView.hidden {
            method = "cheque"
        }
        
        let parameters: NSDictionary = ["access_token": "ZTJkMjVmYmEyNjExODcyMDViZmZmMTkwZTVlM2QxODY2OThjYzNmOThkZGFlODQ1MjQwY2I0MGMzYjNmYzIyNA",
            "withdrawalMethod": method,
            "otp": self.confimationCodeView.codeTextField.text,
            "amount": self.amountView.amountTextField.text]
        
        WebServiceManager.fireSubmitWithdrawalRequestWithUrl(APIAtlas.submitWithdrawalRequest, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                println(responseObject)
            } else {
                println(responseObject)
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .PageNotFound {
                    Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                } else {
                    println(responseObject)
                }
            }
        })
    }
    
    // MARK: - Delegates
    
    // MARK: - Available Balance Delegate
    func gotoPayoutSummary(view: WithdrawAvailableBalanceView) {
        let payoutSummary = PayoutSummaryViewController(nibName: "PayoutSummaryViewController", bundle: nil)
        payoutSummary.prices = [String(balanceRecordModel.totalEarning), String(balanceRecordModel.tentativeEarning), String(balanceRecordModel.totalWithdrew), String(balanceRecordModel.availableBalance)]
        payoutSummary.inProcess = String(balanceRecordModel.totalWithdrewInProcess)
        self.navigationController?.pushViewController(payoutSummary, animated: true)
    }
    
    // MARK: - Amount View Delegate 
    func amountDidChanged(view: WithdrawAmountView) {
        
        if count(amountView.amountTextField.text) > 2 { // digit is greater than 2
            
        }
        
        if (amountView.amountTextField.text as NSString).doubleValue >= 100.0 {
            self.amountView.bottomLabel.text = "Available balance should be P 100.0 or above to withdraw"
            self.amountView.bottomLabel.textColor = UIColor.redColor()
            self.confimationCodeView.getCodeButton.backgroundColor = UIColor.darkGrayColor()
        } else if /*Double(balanceRecordModel.availableBalance)*/0.0 < (amountView.amountTextField.text as NSString).doubleValue {
            self.amountView.bottomLabel.text = "Withdrawal amount should be less than available balance"
            self.amountView.bottomLabel.textColor = UIColor.redColor()
        } else {
            self.confimationCodeView.getCodeButton.backgroundColor = UIColor.lightGrayColor()
            self.amountView.bottomLabel.text = "P 50.00 bank charge for withdrawal below P 5,000.00"
            self.amountView.bottomLabel.textColor = UIColor.blackColor()
        }
    }
    
    // MARK: - Confimation Code View Delegate
    func getCodeAction(view: WithdrawConfirmationCodeView) {
        fireGetCode()
    }
    
    func codeDidChanged(view: WithdrawConfirmationCodeView) {
        if self.confimationCodeView.getCodeButton.backgroundColor == UIColor.darkGrayColor() && 
            count(self.confimationCodeView.codeTextField.text) == 6 {
            self.proceedView.proceedButton.backgroundColor = Constants.Colors.pmYesGreenColor
        } else {
            self.proceedView.proceedButton.backgroundColor = UIColor.lightGrayColor()
        }
    }
    
    // MARK: - Proceed View Delegate
    func proceedAction(view: WithdrawProceedView) {
        fireSubmitWithdrawal()
//        if didMeetRequirements() {
//            showConfirmationModal()
//        } else {
//            
//        }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}
