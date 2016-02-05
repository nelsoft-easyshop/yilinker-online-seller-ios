//
//  WithdrawTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol WithdrawTableViewControllerDelegate {
    func withdrawToRequest(controller: WithdrawTableViewController)
    func passAmount(controller: WithdrawTableViewController, amount: Double)
}

class WithdrawTableViewController: UITableViewController, EmptyViewDelegate, AvailableBalanceDelegate, WithdrawAmountViewDelegate, WithdrawConfirmationCodeViewDelegate, WithdrawProceedViewDelegate, WithdrawModalViewControllerDelegate, WithdrawMethodViewDelegate {
    
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
    
    var firstLoad: Bool = true
    
    var storeInfo: StoreInfoModel!
    
    var delegate: WithdrawTableViewControllerDelegate?
    
    // loader
    var hud: MBProgressHUD?
    
    // 
    var emptyView: EmptyView?
    //
    var canGotoPayoutSummary: Bool = true
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.showHUD()
//        NSNotificationCenter.defaultCenter().postNotificationName("showLoaderInPayoutScreen", object: nil)
//        fireGetWithdrawalBalance()
        addViews()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !firstLoad {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
        fireGetWithdrawalBalance()
        
        if self.storeInfo != nil {
            if self.storeInfo.name == "" {
                self.amountView.amountTextField.userInteractionEnabled = false
                self.amountView.amountTextField.backgroundColor = UIColor.lightGrayColor()
            } else {
                self.depositToView.nameLabel.text = self.storeInfo.name
                self.depositToView.detailsLabel.text = self.storeInfo.bankName + " | " + self.storeInfo.accountName + " | " + self.storeInfo.accountNumber
            }
            self.mobileNoView.numberLabel.text = "  " + String(self.storeInfo.contact_number)
        }

        
        canGotoPayoutSummary = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        firstLoad = false
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
            self.methodView.delegate = self
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
        var availableBalance: String = balanceRecordModel.availableBalance
        
        self.availableBalanceView.setAvailableBalance(availableBalance)
        
        availableBalance = availableBalance.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range: nil)
        if availableBalance.doubleValue < 100 {
            self.amountView.amountTextField.userInteractionEnabled = false
            self.amountView.amountTextField.backgroundColor = UIColor.lightGrayColor()
            self.amountView.bottomLabel.text = "Available Balance is less than P100.00"
            self.amountView.bottomLabel.textColor = UIColor.redColor()
            self.amountView.amountTextField.placeholder = ""
        }
    }
    
    func startCooldown() {
        cooldown--
        if cooldown == 0 {
            timer.invalidate()
            cooldown = 60
            self.confimationCodeView.getCodeButton.setTitle("GET CODE", forState: .Normal)
            self.confimationCodeView.getCodeButton.userInteractionEnabled = true
            self.confimationCodeView.getCodeButton.backgroundColor = UIColor.darkGrayColor()
        } else {
            self.confimationCodeView.getCodeButton.setTitle("00:" + String(cooldown), forState: .Normal)
        }
        
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(frame: CGRectZero)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func addEmptyView() {
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView!.delegate = self
            self.emptyView!.frame = UIScreen.mainScreen().bounds
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    func didTapReload() {
        if Reachability.isConnectedToNetwork() {
            self.emptyView?.hidden = true
            fireGetWithdrawalBalance()
        }
    }
    
    func enableProceedButton() {
        let withdrawalAmount: Double = self.amountView.amountTextField.text.doubleValue
        var availableBalance: String = balanceRecordModel.availableBalance
        availableBalance = availableBalance.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range: nil)
        
        if self.confimationCodeView.codeTextField.text != "" && withdrawalAmount >= 100.0 && withdrawalAmount <= availableBalance.doubleValue {
            self.proceedView.proceedButton.backgroundColor = Constants.Colors.pmYesGreenColor
            self.proceedView.proceedButton.userInteractionEnabled = true
        } else {
            self.proceedView.proceedButton.backgroundColor = UIColor.lightGrayColor()
            self.proceedView.proceedButton.userInteractionEnabled = false
        }
    }
    
    // validate requirements
    
    func didMeetRequirements() -> Bool {
        
        if self.amountView.amountTextField.text == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Amount is required.", title: "Unable to Proceed")
            return false
        } else if self.amountView.amountTextField.text.doubleValue < 100.0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Amount must be higher or equal than P100.0.", title: "Unable to Proceed")
            return false
        }
        
        return true
    }
    
    // show confirmation modal
    
    func showConfirmationModal() {
        var withdrawModal = WithdrawModalViewController(nibName: "WithdrawModalViewController", bundle: nil)
        withdrawModal.delegate = self
        withdrawModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        withdrawModal.providesPresentationContextTransitionStyle = true
        withdrawModal.definesPresentationContext = true
        withdrawModal.view.backgroundColor = UIColor.clearColor()
        withdrawModal.amountToWithdraw = self.amountView.amountTextField.text.doubleValue
        self.delegate?.passAmount(self, amount: self.amountView.amountTextField.text.doubleValue)
        self.tabBarController?.presentViewController(withdrawModal, animated: true, completion: nil)
        
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor = .blackColor()
        dimView.alpha = 0.0
        self.navigationController?.view.addSubview(dimView)

        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0.60
        })
    }
    
    func clearInputData() {
        self.amountView.amountTextField.text = ""
        
        self.methodView.chequeCheckImageView.hidden = true
        self.methodView.depositCheckImageView.hidden = false
        if SessionManager.isSeller() {
            self.methodView.chequeView.backgroundColor = .lightGrayColor()
        }
        
        self.confimationCodeView.codeTextField.text = ""
        self.timer.invalidate()
        self.confimationCodeView.getCodeButton.setTitle("GET CODE", forState: .Normal)
        
        self.proceedView.proceedButton.userInteractionEnabled = false
        self.proceedView.proceedButton.backgroundColor = .lightGrayColor()
        
        self.tableView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    // MARK: - Requests
    
    func fireGetWithdrawalBalance() {
        if Reachability.isConnectedToNetwork() {
            let parameters: NSDictionary = ["access_token": SessionManager.accessToken(), "dateTo": "", "dateFrom": "", "page": "", "perPage": ""]
            
            WebServiceManager.fireGetBalanceRecordRequestWithUrl(APIAtlas.getBalanceRecordDetails, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                self.hud?.hidden = true
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if successful {
                    self.balanceRecordModel = BalanceRecordModel.parseDataWithDictionary(responseObject as! NSDictionary)
                    self.populateData()
                } else {
                    if self.balanceRecordModel == nil {
//                        self.addEmptyView()
                    }
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
        } else {
            if self.balanceRecordModel == nil {
//                self.addEmptyView()
            }
            self.hud?.hidden = true
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.failed)
        }
    }
    
    func fireGetCode() {
        if Reachability.isConnectedToNetwork() {
            self.showHUD()
            let parameters: NSDictionary = ["access_token": SessionManager.accessToken(), "type": "withdrawal"]
            
            var url: String = APIAtlas.baseUrl
            url = url.stringByReplacingOccurrencesOfString("v1", withString: APIAtlas.OTPAuth, options: nil, range: nil)
            
            WebServiceManager.fireOTPAuthenticatedRequestWithUrl(url, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                self.hud?.hidden = true
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if successful {
                    self.confimationCodeView.getCodeButton.userInteractionEnabled = false
                    self.confimationCodeView.getCodeButton.backgroundColor = UIColor.lightGrayColor()
                    
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Confirmation code has been sent to your mobile number.", title: "Request Sent")
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("startCooldown"), userInfo: nil, repeats: true)
                    
                } else {
                    if requestErrorType == .ResponseError {
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
//                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: "Request Failed")
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
        } else {
            self.hud?.hidden = true
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.failed)
        }
    }
    
    func fireSubmitWithdrawal() {
        if Reachability.isConnectedToNetwork() {
            self.showHUD()
            var method: String = "bank"
            if !self.methodView.chequeCheckImageView.hidden {
                method = "cheque"
            }
            
            let parameters: NSDictionary = ["access_token": SessionManager.accessToken(),
                "withdrawalMethod": method,
                "otp": self.confimationCodeView.codeTextField.text,
                "amount": self.amountView.amountTextField.text]
            println(parameters)
            WebServiceManager.fireSubmitWithdrawalRequestWithUrl(APIAtlas.submitWithdrawalRequest, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                self.hud?.hidden = true
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if responseObject["isSuccessful"] as! Bool {
                    self.clearInputData()
                    self.delegate?.withdrawToRequest(self)
                } else {
                    if requestErrorType == .ResponseError {
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
//                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: "Request Failed")
                    } else if requestErrorType == .PageNotFound {
                        Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                    } else if requestErrorType == .NoInternetConnection {
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    } else if requestErrorType == .RequestTimeOut {
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    } else if requestErrorType == .UnRecognizeError {
                        Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                    } else {
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: "Request Failed")
                    }
                }
                
//                if successful {
//                    self.clearInputData()
//                    self.delegate?.withdrawToRequest(self)
//                } else {
//                    if requestErrorType == .ResponseError {
//                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
//                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
//                    } else if requestErrorType == .PageNotFound {
//                        Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
//                    } else if requestErrorType == .NoInternetConnection {
//                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
//                    } else if requestErrorType == .RequestTimeOut {
//                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
//                    } else if requestErrorType == .UnRecognizeError {
//                        Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
//                    } else {
//                        println(responseObject)
//                    }
//                }
            })
        } else {
            self.hud?.hidden = true
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.failed)
        }
    }
    
    func fireRefreshToken() {
        if Reachability.isConnectedToNetwork() {
            self.showHUD()
            WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.loginUrl, actionHandler: { (successful, responseObject, RequestErrorType) -> Void in
                self.hud?.hide(true)
                if successful {
                    
                } else {
                    //Forcing user to logout.
                    UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                        SessionManager.logout()
                        GPPSignIn.sharedInstance().signOut()
                        self.navigationController?.popToRootViewControllerAnimated(false)
                    })
                }
            })
        } else {
            self.hud?.hide(true)
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.failed)
        }
        
    }
    
    // MARK: - Delegates
    
    // MARK: - Available Balance Delegate
    func gotoPayoutSummary(view: WithdrawAvailableBalanceView) {
        if canGotoPayoutSummary {
            canGotoPayoutSummary = false
            let payoutSummary = PayoutSummaryViewController(nibName: "PayoutSummaryViewController", bundle: nil)
            payoutSummary.prices = [String(balanceRecordModel.totalEarning), String(balanceRecordModel.tentativeEarning), String(balanceRecordModel.totalWithdrew), String(balanceRecordModel.availableBalance)]
            payoutSummary.inProcess = String(balanceRecordModel.totalWithdrewInProcess)
            self.navigationController?.pushViewController(payoutSummary, animated: true)
        }
    }
    
    // MARK: - Amount View Delegate 
    func amountDidChanged(view: WithdrawAmountView) {
        
        // check if amount is greater than available balance
        // check if amount is less than 100
        
        if count(amountView.amountTextField.text) > 2 {
            var availableBalance: String = balanceRecordModel.availableBalance
            availableBalance = availableBalance.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range: nil)

            if amountView.amountTextField.text.doubleValue < 100.0 {
                self.amountView.bottomLabel.text = "Minimum withdrawal amount is P100.00"
                self.amountView.bottomLabel.textColor = UIColor.redColor()
                self.confimationCodeView.getCodeButton.backgroundColor = UIColor.lightGrayColor()
            } else if amountView.amountTextField.text.doubleValue > availableBalance.doubleValue {
                self.amountView.bottomLabel.text = "Withdrawal amount is greater than available balance"
                self.amountView.bottomLabel.textColor = UIColor.redColor()
                self.confimationCodeView.getCodeButton.backgroundColor = UIColor.lightGrayColor()
            } else {
                self.confimationCodeView.getCodeButton.backgroundColor = UIColor.darkGrayColor()
                self.amountView.bottomLabel.text = "P 50.00 bank charge for withdrawal below P 5,000.00"
                self.amountView.bottomLabel.textColor = UIColor.darkGrayColor()
                
                enableProceedButton()
            }
        } else {
            self.confimationCodeView.getCodeButton.backgroundColor = UIColor.darkGrayColor()
            self.amountView.bottomLabel.text = "P 50.00 bank charge for withdrawal below P 5,000.00"
            self.amountView.bottomLabel.textColor = UIColor.darkGrayColor()
            self.confimationCodeView.getCodeButton.backgroundColor = UIColor.lightGrayColor()
            
            enableProceedButton()
        }
    }
    
    // MARK: - Method View Delegate
    func depositAction(view: WithdrawMethodView) {
        self.depositToView.detailsLabel.hidden = false
//        self.depositToView.nameLabel.font = UIFont.systemFontOfSize(13.0)
//        self.depositToView.frame.origin.y = 4.0
    }
    
    func chequeAction(view: WithdrawMethodView) {
        self.depositToView.detailsLabel.hidden = true
//        self.depositToView.nameLabel.center.y = self.depositToView.center.y
//        self.depositToView.nameLabel.font = UIFont.systemFontOfSize(15.0)
    }
    
    // MARK: - Confimation Code View Delegate
    func getCodeAction(view: WithdrawConfirmationCodeView) {
        if self.confimationCodeView.getCodeButton.backgroundColor == UIColor.darkGrayColor() {
            fireGetCode()
        }
    }
    
    func codeDidChanged(view: WithdrawConfirmationCodeView) {
        enableProceedButton()
    }
    
    // MARK: - Proceed View Delegate
    func proceedAction(view: WithdrawProceedView) {
        if self.proceedView.proceedButton.backgroundColor == Constants.Colors.pmYesGreenColor  {
            showConfirmationModal()
        }
    }
    
    // MARK: - Withdraw Modal View Controller Delegate
    
    func modalYesAction(controller: WithdrawModalViewController) {
        self.showHUD()
        fireSubmitWithdrawal()
    }
    
    func modalNoAction(controller: WithdrawModalViewController) {
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0.0
        })
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
