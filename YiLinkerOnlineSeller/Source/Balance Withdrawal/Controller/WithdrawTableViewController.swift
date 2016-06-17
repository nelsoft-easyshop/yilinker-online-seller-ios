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
    var contactCSRView: WithdrawContactCSR!
    
    var newFrame: CGRect!
    
    var balanceRecordModel: BalanceRecordModel!
    
    var dimView: UIView!
    
    var timer = NSTimer()
    var cooldown: Int = NSUserDefaults.standardUserDefaults().valueForKey("cooldownKey") as! Int
    
    var firstLoad: Bool = true
    var noBankAccount: Bool = false
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateLabel:", name: "UpdateTimerLabel", object: nil)
    }
    
    func setCooldownValue(value: Int) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: "cooldownKey")
    }
    
    func updateTimer() {
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateTimerLabel", object: nil)
    }
    
    func updateLabel(notification: NSNotificationCenter) {
        
        cooldown--

        if cooldown != 0 {
            if cooldown < 10 {
                self.confimationCodeView.getCodeButton.setTitle("00:0" + String(cooldown), forState: .Normal)
            } else {
                 self.confimationCodeView.getCodeButton.setTitle("00:" + String(cooldown), forState: .Normal)
            }
            
            self.confimationCodeView.getCodeButton.backgroundColor = UIColor.lightGrayColor()
            setCooldownValue(cooldown)
        } else {
            setCooldownValue(60)
            self.timer.invalidate()
            cooldown = 60

            self.confimationCodeView.getCodeButton.setTitle(PayoutStrings.withdrawalGetCode, forState: .Normal)

//            self.setStateForGetCodeButton()
//            
            var availableBalance: String = balanceRecordModel.availableBalance
            availableBalance = availableBalance.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range: nil)
            
            if count(amountView.amountTextField.text) == 0 || amountView.amountTextField.text.doubleValue < 100.0 || amountView.amountTextField.text.doubleValue > availableBalance.doubleValue {
                self.confimationCodeView.getCodeButton.backgroundColor = UIColor.lightGrayColor()
            } else {
                if self.confimationCodeView.getCodeButton.titleLabel!.text == PayoutStrings.withdrawalGetCode {
                    self.confimationCodeView.getCodeButton.backgroundColor = UIColor.darkGrayColor()
                }
                
                enableProceedButton()
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !firstLoad {
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.showHUD()
        }
        fireGetWithdrawalBalance()
        
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
    
    func getContactCSRView() -> WithdrawContactCSR {
        if self.contactCSRView == nil {
            self.contactCSRView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 7) as! WithdrawContactCSR
        }
        return self.contactCSRView
    }
    
    // MARK: - Functions
    
    func addViews() {
        self.getHeaderView().addSubview(self.getAvailableBalanceView())
        self.getHeaderView().addSubview(self.getAmountView())
        self.getHeaderView().addSubview(self.getMethodView())
        self.getHeaderView().addSubview(self.getDepositToView())
        self.getHeaderView().addSubview(self.getMobileNoView())
        self.getHeaderView().addSubview(self.getConfimationCodeView())
        if noBankAccount {
            self.getHeaderView().addSubview(self.getContactCSRView())
        }
        self.getHeaderView().addSubview(self.getProceedView())
        
        positionViews()
    }
    
    func positionViews() {
        self.setPosition(self.amountView, from: self.availableBalanceView)
        self.setPosition(self.methodView, from: self.amountView)
        self.setPosition(self.depositToView, from: self.methodView)
        self.setPosition(self.mobileNoView, from: self.depositToView)
        self.setPosition(self.confimationCodeView, from: self.mobileNoView)
        if noBankAccount {
            self.setPosition(self.contactCSRView, from: self.confimationCodeView)
            self.setPosition(self.proceedView, from: self.contactCSRView)
        } else {
            self.setPosition(self.proceedView, from: self.confimationCodeView)
        }
        
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
        // check available balance to disable textfield when balance is less than 100
        var availableBalance: String = balanceRecordModel.availableBalance
        self.availableBalanceView.setAvailableBalance(availableBalance)
        
        availableBalance = availableBalance.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range: nil)
        if availableBalance.doubleValue < 100 {
            self.amountView.amountTextField.userInteractionEnabled = false
            self.amountView.amountTextField.backgroundColor = UIColor.lightGrayColor()
            self.amountView.bottomLabel.text = PayoutStrings.withdrawalLessThanMinimum
            self.amountView.bottomLabel.textColor = UIColor.redColor()
            self.amountView.amountTextField.placeholder = ""
        }
        
        self.depositToView.nameLabel.text = self.balanceRecordModel.fullName
        self.depositToView.detailsLabel.text = self.balanceRecordModel.bankAccount
        self.depositToView.chequeLabel.text = self.balanceRecordModel.fullName
        
        // check bank account
        if hasBankAccount() {
            
//            self.depositToView.nameLabel.text = self.balanceRecordModel.fullName
//            self.depositToView.detailsLabel.text = self.balanceRecordModel.bankAccount
//            self.depositToView.chequeLabel.text = self.balanceRecordModel.fullName
            self.methodView.depositView.userInteractionEnabled = true
            noBankAccount = false
            
            for view in self.tableView.subviews {
                view.removeFromSuperview()
            }
            
            // add views, but this time with the error message for incomplete details
            addViews()
            
        } else {
            // if no bank account
            // remove views
            for view in self.tableView.subviews {
                view.removeFromSuperview()
            }
            
            noBankAccount = true
            
            // add views, but this time with the error message for incomplete details
            addViews()
            
            // disable amount text field
            self.amountView.amountTextField.userInteractionEnabled = false
            self.amountView.amountTextField.backgroundColor = UIColor.lightGrayColor()
            
            // disable method buttons
//            self.methodView.depositView.backgroundColor = UIColor.lightGrayColor()
            self.methodView.depositView.userInteractionEnabled = false
            
            // disable code text field
//            self.confimationCodeView.codeTextField.userInteractionEnabled = false
//            self.confimationCodeView.codeTextField.backgroundColor = UIColor.lightGrayColor()
            
//            self.depositToView.nameLabel.hidden = true
//            self.depositToView.detailsLabel.hidden = true
//            self.depositToView.chequeLabel.hidden = false
        }
        
        // mobile number
        self.mobileNoView.numberLabel.text = "  " + String(self.balanceRecordModel.contact_number)
    }
    
    func hasBankAccount() -> Bool {
        if self.balanceRecordModel.bankName == " - " || self.balanceRecordModel.accountName == " - " || self.balanceRecordModel.accountNumber == " - " {
            return false
        }
        
        return true
    }
    
    func startCooldown() {
        cooldown--
        if cooldown == 0 {
            timer.invalidate()
            cooldown = 60
            self.confimationCodeView.getCodeButton.setTitle(PayoutStrings.withdrawalGetCode, forState: .Normal)
            self.confimationCodeView.getCodeButton.backgroundColor = UIColor.darkGrayColor()
        } else {
            if cooldown >= 10 {
                self.confimationCodeView.getCodeButton.setTitle("00:" + String(cooldown), forState: .Normal)
            } else {
                self.confimationCodeView.getCodeButton.setTitle("00:0" + String(cooldown), forState: .Normal)
            }
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
        UIApplication.sharedApplication().keyWindow?.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func addEmptyView() {
        self.tableView.scrollEnabled = false
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView!.delegate = self
            self.emptyView!.frame = UIScreen.mainScreen().bounds
            self.emptyView?.center = self.view.center
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    func didTapReload() {
        if Reachability.isConnectedToNetwork() {
            self.tableView.scrollEnabled = true
            self.showHUD()
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
        } else {
            self.proceedView.proceedButton.backgroundColor = UIColor.lightGrayColor()
        }
    }
    
    func setStateForGetCodeButton() {
        
//        var availableBalance: String = balanceRecordModel.availableBalance
//        availableBalance = availableBalance.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range: nil)
//        
//        if count(amountView.amountTextField.text) == 0 {
//            self.amountView.bottomLabel.text = PayoutStrings.withdrawalAmountCharge
//            self.amountView.bottomLabel.textColor = UIColor.darkGrayColor()
//        } else if amountView.amountTextField.text.doubleValue < 100.0 {
//            self.amountView.bottomLabel.text = PayoutStrings.withdrawalAmountMinimum
//            self.amountView.bottomLabel.textColor = UIColor.redColor()
//            self.confimationCodeView.getCodeButton.backgroundColor = UIColor.lightGrayColor()
//        } else if amountView.amountTextField.text.doubleValue > availableBalance.doubleValue {
//            self.amountView.bottomLabel.text = PayoutStrings.withdrawalGreaterThanBalance
//            self.amountView.bottomLabel.textColor = UIColor.redColor()
//            self.confimationCodeView.getCodeButton.backgroundColor = UIColor.lightGrayColor()
//        } else {
//            if self.confimationCodeView.getCodeButton.titleLabel!.text == PayoutStrings.withdrawalGetCode {
//                
//                self.confimationCodeView.getCodeButton.backgroundColor = UIColor.darkGrayColor()
//                self.amountView.bottomLabel.text = PayoutStrings.withdrawalAmountCharge
//                self.amountView.bottomLabel.textColor = UIColor.darkGrayColor()
//            }
//            
//            enableProceedButton()
//        }
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
        self.timer.invalidate()
        setCooldownValue(60)
        cooldown = 60
        
        self.amountView.amountTextField.text = ""
        
        self.methodView.chequeCheckImageView.hidden = true
        self.methodView.depositCheckImageView.hidden = false
        if SessionManager.isSeller() {
            self.methodView.chequeView.backgroundColor = .lightGrayColor()
        }
        
        self.confimationCodeView.codeTextField.text = ""
        self.timer.invalidate()
        self.confimationCodeView.getCodeButton.setTitle(PayoutStrings.withdrawalGetCode, forState: .Normal)
        
        self.confimationCodeView.getCodeButton.backgroundColor = .lightGrayColor()
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
                        self.addEmptyView()
                    }
                    if requestErrorType == .ResponseError {
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        if errorModel.message != "" {
                            Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                        }
                    } else if requestErrorType == .AccessTokenExpired {
                        self.fireRefreshToken("details")
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
                self.addEmptyView()
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
            
            WebServiceManager.fireOTPAuthenticatedRequestWithUrl(APIAtlas.OTPAuth, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                self.hud?.hidden = true
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if successful {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: PayoutStrings.alertRequestSuccessful, title: PayoutStrings.alertRequestSent)
//                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("startCooldown"), userInfo: nil, repeats: true)
                    self.cooldown = 60
                    self.setCooldownValue(60)
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
                    
                } else {
                    if requestErrorType == .ResponseError {
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: PayoutStrings.alertRequestFailed)
                    } else if requestErrorType == .AccessTokenExpired {
                        self.fireRefreshToken("code")
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
                if self.dimView != nil {
                    self.dimView.removeFromSuperview()
                }
                
                if successful {
                    if responseObject["isSuccessful"] as! Bool {
                        self.clearInputData()
                        self.delegate?.withdrawToRequest(self)
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "", title: Constants.Localized.someThingWentWrong)
                    }
                } else {
                    if requestErrorType == .ResponseError {
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: PayoutStrings.alertRequestFailed)
                    } else if requestErrorType == .AccessTokenExpired {
                        self.fireRefreshToken("submit")
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
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: PayoutStrings.alertRequestFailed)
                    }
                }
            })
        } else {
            self.hud?.hidden = true
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.failed)
        }
    }
    
    func fireRefreshToken(type: String) {
        if Reachability.isConnectedToNetwork() {
            self.showHUD()
            WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.loginUrl, actionHandler: { (successful, responseObject, RequestErrorType) -> Void in
                self.hud?.hide(true)
                if successful {
                    self.showHUD()
                    
                    if type == "details" {
                        self.fireGetWithdrawalBalance()
                    } else if type == "code" {
                        self.fireGetCode()
                    } else if type == "submit" {
                        self.fireSubmitWithdrawal()
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
        } else {
            self.hud?.hide(true)
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.failed)
        }
        
    }
    
    // MARK: - Delegates
    
    // MARK: - Available Balance Delegate
    func gotoPayoutSummary(view: WithdrawAvailableBalanceView) {
        if canGotoPayoutSummary && balanceRecordModel != nil {
            canGotoPayoutSummary = false
            let payoutSummary = PayoutSummaryViewController(nibName: "PayoutSummaryViewController", bundle: nil)
            payoutSummary.prices = [String(balanceRecordModel.totalEarning), String(balanceRecordModel.tentativeEarning), String(balanceRecordModel.totalWithdrew), String(balanceRecordModel.availableBalance)]
            payoutSummary.inProcess = String(balanceRecordModel.totalWithdrewInProcess)
            self.navigationController?.pushViewController(payoutSummary, animated: true)
        }
    }
    
    // MARK: - Amount View Delegate 
    func amountDidChanged(view: WithdrawAmountView) {
        
        var availableBalance: String = balanceRecordModel.availableBalance
        availableBalance = availableBalance.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range: nil)
        
        println(amountView.amountTextField.text.doubleValue)
        if count(amountView.amountTextField.text) == 0 {
            self.amountView.bottomLabel.text = PayoutStrings.withdrawalAmountCharge
            self.amountView.bottomLabel.textColor = UIColor.darkGrayColor()
        } else if amountView.amountTextField.text.doubleValue < 100.0 {
            println("benga")
            self.amountView.bottomLabel.text = PayoutStrings.withdrawalAmountMinimum
            self.amountView.bottomLabel.textColor = UIColor.redColor()
            self.confimationCodeView.getCodeButton.backgroundColor = UIColor.lightGrayColor()
        } else if amountView.amountTextField.text.doubleValue > availableBalance.doubleValue {
            self.amountView.bottomLabel.text = PayoutStrings.withdrawalGreaterThanBalance
            self.amountView.bottomLabel.textColor = UIColor.redColor()
            self.confimationCodeView.getCodeButton.backgroundColor = UIColor.lightGrayColor()
        } else {
            
            self.amountView.bottomLabel.text = PayoutStrings.withdrawalAmountCharge
            self.amountView.bottomLabel.textColor = UIColor.darkGrayColor()
            
            if self.confimationCodeView.getCodeButton.titleLabel!.text == PayoutStrings.withdrawalGetCode {
                self.confimationCodeView.getCodeButton.backgroundColor = UIColor.darkGrayColor()
            }
            
            enableProceedButton()
        }
        
    }
    
    // MARK: - Method View Delegate
    func depositAction(view: WithdrawMethodView) {
        self.depositToView.nameLabel.hidden = false
        self.depositToView.detailsLabel.hidden = false
        
        self.depositToView.chequeLabel.hidden = true
    }
    
    func chequeAction(view: WithdrawMethodView) {
        self.depositToView.nameLabel.hidden = true
        self.depositToView.detailsLabel.hidden = true
        
        self.depositToView.chequeLabel.hidden = false
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
        
//        if self.dimView != nil {
//            self.dimView.removeFromSuperview()
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
}
