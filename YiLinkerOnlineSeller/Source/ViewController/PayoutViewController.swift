//
//  PayoutViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 1/29/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

struct PayoutStrings {
    // Tabs
    static let tabWithdraw = StringHelper.localizedStringWithKey("PAYOUT_TAB_WITHDRAW_KEY")
    static let tabRequest = StringHelper.localizedStringWithKey("PAYOUT_TAB_REQUESTS_KEY")
    static let tabRecord = StringHelper.localizedStringWithKey("PAYOUT_TAB_RECORD_KEY")
    static let tabEarning = StringHelper.localizedStringWithKey("PAYOUT_TAB_EARNINGS_KEY")
    
    // Controllers
    static let titleWithdrawal = StringHelper.localizedStringWithKey("PAYOUT_CONTROLLER_BALANCE_WITHDRAWAL_KEY")
    static let titleRequest = StringHelper.localizedStringWithKey("PAYOUT_CONTROLLER_WITHDRAWAL_REQUEST_KEY")
    static let titleRecord = StringHelper.localizedStringWithKey("PAYOUT_CONTROLLER_BALANCE_RECORD_KEY")
    static let titleEarnings = StringHelper.localizedStringWithKey("PAYOUT_CONTROLLER_EARNINGS_KEY")
    static let titlePayoutSummary = StringHelper.localizedStringWithKey("PAYOUT_CONTROLLER_SUMMARY_KEY")
    
    // Balance Withdrawal
    static let withdrawalAvailableBalance = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_AVAILABLE_BALANCE_KEY")
    static let withdrawalAmount = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_WITHDRAWAL_AMOUNT_KEY")
    static let withdrawalMethod = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_WITHDRAWAL_METHOD_KEY")
    static let withdrawalBankDeposit = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_BANK_DEPOSIT_KEY")
    static let withdrawalBankCheque = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_BANK_CHEQUE_KEY")
    static let withdrawalDepositTo = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_DEPOSIT_TO_KEY")
    static let withdrawalMobileNumber = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_MOBILE_NUMBER_KEY")
    static let withdrawalConfirmationCode = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_CONFIRMATION_CODE_KEY")
    static let withdrawalNoBankAccount = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_NO_BANK_ACCOUNT_MESSAGE_KEY")
    static let withdrawalGetCode = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_GET_CODE_BUTTON_KEY")
    static let withdrawalProceed = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_PROCEED_BUTTON_KEY")
    static let withdrawalLessThanMinimum = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_AMOUNT_LESS_THAN_MINIMUM_KEY")
    static let withdrawalAmountMinimum = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_AMOUNT_MINIMUM_KEY")
    static let withdrawalGreaterThanBalance = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_AMOUNT_GREATER_THAN_BALANCE_KEY")
    static let withdrawalAmountCharge = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_AMOUNT_CHARGE_KEY")
    static let withdrawalContactCSR = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_CONTACT_CSR_KEY")
    
    // Alert
    static let alertRequestSent = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_CODE_ALERT_REQUEST_SENT_KEY")
    static let alertRequestSuccessful = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_CODE_ALERT_REQUEST_SUCCESSFUL_KEY")
    static let alertRequestFailed = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_CODE_ALERT_REQUEST_FAILED_KEY")
    
    // Modal
    static let modalTitle = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_MODAL_TITLE_KEY")
    static let modalMessage = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_MODAL_MESSAGE_KEY")
    static let modalRequestedAmount = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_MODAL_REQUESTED_AMOUNT_KEY")
    static let modalBankCharge = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_MODAL_BANK_CHARGE_KEY")
    static let modalAmountToReceived = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_MODAL_AMOUNT_TO_RECEIVE_KEY")
    static let modalYes = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_MODAL_YES_KEY")
    static let modalNo = StringHelper.localizedStringWithKey("PAYOUT_BALANCE_WITHDRAWAL_MODAL_NO_KEY")
    
    
    // Payout Summary
    static let summaryTotalEarnings = StringHelper.localizedStringWithKey("PAYOUT_SUMMARY_TOTAL_EARNINGS_KEY")
    static let summaryTentative = StringHelper.localizedStringWithKey("PAYOUT_SUMMARY_TENTATIVE_RECEIVABLE_KEY")
    static let summaryTotalWithdrew = StringHelper.localizedStringWithKey("PAYOUT_SUMMARY_TOTAL_WITHDREW_KEY")
    static let summaryAvailableBalance = StringHelper.localizedStringWithKey("PAYOUT_SUMMARY_AVAILABLE_BALANCE_KEY")
    static let summaryInProcess = StringHelper.localizedStringWithKey("PAYOUT_SUMMARY_IN_PROCESS_KEY")
    
    // Balance Record
    static let recordNoData = StringHelper.localizedStringWithKey("PAYOUT_RECORD_NO_DATA_KEY")
    static let recordTotalEarnings = StringHelper.localizedStringWithKey("PAYOUT_RECORD_TOTAL_EARNINGS_KEY")
    static let recordActiveEarnings = StringHelper.localizedStringWithKey("PAYOUT_RECORD_ACTIVE_EARNINGS_KEY")
    static let recordTentativeEarnings = StringHelper.localizedStringWithKey("PAYOUT_RECORD_TENTATIVE_EARNINGS_KEY")
    static let recordTotalWithdrew = StringHelper.localizedStringWithKey("PAYOUT_RECORD_TOTAL_WITHDREW_KEY")
    
}

protocol PayoutViewControllerDelegate {
    func passStoreInfo(controller: PayoutViewController, storeInfo: StoreInfoModel)
}

class PayoutViewController: UIViewController, WithdrawTableViewControllerDelegate {

    // Xibs
    @IBOutlet weak var tabsCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    // Tabs
    var tabsName: [String] = [PayoutStrings.tabWithdraw, PayoutStrings.tabRequest, PayoutStrings.tabRecord, PayoutStrings.tabEarning]
    var selectedImage: [String] = ["withdraw", "request", "record", "earning"]
    var deselectedImage: [String] = ["withdraw2", "request2", "record2", "earning2"]
    var selectedIndex: Int = 0
    
    // Controllers
    var withdrawVC: WithdrawTableViewController?
    var requestVC: PayoutRequestListViewController?
    var recordVC: PayoutBalanceRecordViewController?
    var earningVC: PayoutEarningsViewController?
    // Arrays of view controllers
    var viewControllers = [UIViewController]()
    var controllersName: [String] = [PayoutStrings.titleWithdrawal, PayoutStrings.titleRequest, PayoutStrings.titleRecord, PayoutStrings.titleEarnings]
    // Current View Controller
    var currentChildViewController: UIViewController?
    // Child controllers frame
    var containerViewFrame: CGRect?
    
    var headerView: UIView!
    
    var storeInfo: StoreInfoModel!
    
    var delegate: PayoutViewControllerDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        initViewControllers()
        
        // called this to resize the buttons
        self.tabsCollectionView.reloadData()
        
    } // view did load
    
    override func viewDidLayoutSubviews() {
        self.containerViewFrame = containerView.bounds
    }
    
    // MARK: - Functions
    
    // MARK: - Setup Views
    func setupViews() {
        
        // Collection View
        self.tabsCollectionView.backgroundColor = Constants.Colors.appTheme
        
        // Collection View Cell
        let nibCVC = UINib(nibName: "ProductManagementCollectionViewCell", bundle: nil)
        self.tabsCollectionView.registerNib(nibCVC, forCellWithReuseIdentifier: "ProductManagementIdentifier")
        
        // Navigation Bar
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = PayoutStrings.titleWithdrawal
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        self.tabsCollectionView.reloadData()
    }
    
    // MARK: - Init View Controllers
    func initViewControllers() {
        withdrawVC = WithdrawTableViewController(nibName: "WithdrawTableViewController", bundle: nil)
        requestVC = PayoutRequestListViewController(nibName: "PayoutRequestListViewController", bundle: nil)
        recordVC = PayoutBalanceRecordViewController(nibName: "PayoutBalanceRecordViewController", bundle: nil)
        earningVC = PayoutEarningsViewController(nibName: "PayoutEarningsViewController", bundle: nil)
        
        withdrawVC!.delegate = self
        
        self.viewControllers.append(withdrawVC!)
        self.viewControllers.append(requestVC!)
        self.viewControllers.append(recordVC!)
        self.viewControllers.append(earningVC!)
        
        // set withdraw view controller as default view
        setSelectedViewControllerWithIndex(0, transition: UIViewAnimationOptions.TransitionNone)
        delegate?.passStoreInfo(self, storeInfo: self.storeInfo)
    }
    
    //MARK: - Set Selected View Controller With Index
    // This function is for executing child view logic code
    func setSelectedViewControllerWithIndex(index: Int, transition: UIViewAnimationOptions) {
        let viewController: UIViewController = viewControllers[index]
        setSelectedViewController(viewController, transition: transition)
    }
    
    //MARK: - Set Selected View Controller
    func setSelectedViewController(viewController: UIViewController, transition: UIViewAnimationOptions) {
        self.view.layoutIfNeeded()
        self.addChildViewController(viewController)
        self.view.layoutIfNeeded()
        self.addChildViewController(viewController)
        viewController.view.frame = self.containerViewFrame!
        
        self.containerView.addSubview(viewController.view)
        
        if let controller = viewController as? WithdrawTableViewController {
            controller.storeInfo = self.storeInfo
//            delegate?.passStoreInfo(self, storeInfo: self.storeInfo)
        }
        
        if self.currentChildViewController != nil {
            println("before transition")
            self.transitionFromViewController(self.currentChildViewController!, toViewController: viewController, duration: 0, options: transition, animations: nil) { (Bool) -> Void in
                println("after transition")
                
                viewController.didMoveToParentViewController(self)
                if !(self.currentChildViewController == viewController) {
                    if self.isViewLoaded() {
                        self.currentChildViewController?.willMoveToParentViewController(self)
                        self.currentChildViewController?.view.removeFromSuperview()
                        self.currentChildViewController?.removeFromParentViewController()
                    }
                }
                
                self.currentChildViewController = viewController
            }
        } else {
            viewController.didMoveToParentViewController(self)
            self.currentChildViewController = viewController
        }
    }
    
    // MARK: - Actions
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Withdraw Table View Controller Delegate
    
    func withdrawToRequest(controller: WithdrawTableViewController) {
        selectedIndex = 1
        self.tabsCollectionView.reloadData()
        setSelectedViewControllerWithIndex(1, transition: UIViewAnimationOptions.TransitionNone)
    }
    
    func passAmount(controller: WithdrawTableViewController, amount: Double) {
        
    }
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductManagementCollectionViewCell = self.tabsCollectionView.dequeueReusableCellWithReuseIdentifier("ProductManagementIdentifier", forIndexPath: indexPath) as! ProductManagementCollectionViewCell
        
        cell.titleLabel.text = tabsName[indexPath.row]
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = .whiteColor()
            cell.setTextColor(Constants.Colors.appTheme)
            cell.setImage(selectedImage[indexPath.row])
        } else {
            cell.setTextColor(UIColor.whiteColor())
            cell.backgroundColor = Constants.Colors.appTheme
            cell.setImage(deselectedImage[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if selectedIndex != indexPath.row {
            selectedIndex = indexPath.row
            self.tabsCollectionView.reloadData()
            self.title = controllersName[indexPath.row]
            setSelectedViewControllerWithIndex(indexPath.row, transition: UIViewAnimationOptions.TransitionNone)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width / 4, height: 60)
    }

}
