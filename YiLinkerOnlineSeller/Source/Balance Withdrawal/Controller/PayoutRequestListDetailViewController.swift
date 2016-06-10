//
//  PayoutRequestListDetailViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

struct PayoutRequestListDetailStrings {
    static let kDate: String = StringHelper.localizedStringWithKey("PAYOUT_DATE_LOCALIZE_KEY")
    static let kMethod: String = StringHelper.localizedStringWithKey("PAYOUT_WITHDRAWAL_METHOD_LOCALIZE_KEY")
    static let kRequested: String = StringHelper.localizedStringWithKey("PAYOUT_REQUESTED_LOCALIZE_KEY")
    static let kBankCharge: String = StringHelper.localizedStringWithKey("PAYOUT_BANK_CHARGE_LOCALIZE_KEY")
    static let kAmount: String = StringHelper.localizedStringWithKey("PAYOUT_AMOUNT_LOCALIZE_KEY")
    static let kStatus: String = StringHelper.localizedStringWithKey("PAYOUT_STATUS_LOCALIZE_KEY")
    static let kBankAccountName: String = StringHelper.localizedStringWithKey("PAYOUT_BANK_ACCOUNT_NAME_LOCALIZE_KEY")
    static let kBankAccountNumber: String = StringHelper.localizedStringWithKey("PAYOUT_BANK_NUMBER_LOCALIZE_KEY")
    static let kBankName: String = StringHelper.localizedStringWithKey("PAYOUT_BANK_NAME_LOCALIZE_KEY")
}

struct PayoutRequestListDetailCellHeight {
    static let kRowHeight: CGFloat = 43
    static let kSectionHeight: CGFloat = 81
    static let kSectionHeightBank: CGFloat = 44
    static let kSectionCountOne: Int = 1
    static let kSectionCountTwo: Int = 2
}

class PayoutRequestListDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Tableview
    @IBOutlet weak var tableView: UITableView!
    
    // Models
    var payoutRequestModel: PayoutRequestListModel?
    
    // Global variables
    var payoutRequestDetails: [String] = [PayoutRequestListDetailStrings.kDate, PayoutRequestListDetailStrings.kMethod, PayoutRequestListDetailStrings.kRequested, PayoutRequestListDetailStrings.kBankCharge, PayoutRequestListDetailStrings.kAmount, PayoutRequestListDetailStrings.kStatus]
    var bankDetails: [String] = [PayoutRequestListDetailStrings.kBankAccountName, PayoutRequestListDetailStrings.kBankAccountNumber, PayoutRequestListDetailStrings.kBankName]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set navigation bar title
        self.title = PayoutStrings.titleRequestDetails
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.backButton()
        self.registerCell()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    // MARK: Navigation bar - Add Back Button in navigation bar
    
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
    
    // MARK: -
    // MARK: - Navigation bar back button action
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }

    // MARK: -
    // MARK: - Register Cell
    
    func registerCell() {
        let nibNameAndIdentifierListItem: UINib = UINib(nibName: PayoutRequestListItemTableViewCell.listItemNibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(nibNameAndIdentifierListItem, forCellReuseIdentifier: PayoutRequestListItemTableViewCell.listItemNibNameAndIdentifier())
        
        let nibNameAndIdentifierListHeader: UINib = UINib(nibName: PayoutRequestListDetailHeaderTableViewCell.listHeaderNibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(nibNameAndIdentifierListHeader, forCellReuseIdentifier: PayoutRequestListDetailHeaderTableViewCell.listHeaderNibNameAndIdentifier())
        
        let nibNameAndIdentifierListBankHeader: UINib = UINib(nibName: PayoutRequestListBankDetailHeaderTableViewCell.bankHeaderNibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(nibNameAndIdentifierListBankHeader, forCellReuseIdentifier: PayoutRequestListBankDetailHeaderTableViewCell.bankHeaderNibNameAndIdentifier())
    }
    
    // MARK: -
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if self.payoutRequestModel!.withdrawalMethod == "Bank Deposit" {
            return PayoutRequestListDetailCellHeight.kSectionCountTwo
        } else {
            return PayoutRequestListDetailCellHeight.kSectionCountOne
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return self.payoutRequestDetails.count
        } else {
            return self.bankDetails.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(PayoutRequestListItemTableViewCell.listItemNibNameAndIdentifier(), forIndexPath: indexPath) as! PayoutRequestListItemTableViewCell
    
        if indexPath.section == 0 {
            cell.itemLabel.text = self.payoutRequestDetails[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.itemDetailLabel.text = self.payoutRequestModel!.date
                break
            case 1:
                cell.itemDetailLabel.text = self.payoutRequestModel!.withdrawalMethod
                break
            case 2:
                cell.itemDetailLabel.text = self.payoutRequestModel!.currencyCode + " " + self.payoutRequestModel!.totalAmount
                break
            case 3:
                cell.itemDetailLabel.text = self.payoutRequestModel!.currencyCode + " " + self.payoutRequestModel!.charge
                break
            case 4:
                cell.itemDetailLabel.text = self.payoutRequestModel!.currencyCode + " " + self.payoutRequestModel!.netAmount
                break
            case 5:
                cell.itemDetailLabel.text = self.payoutRequestModel!.status.uppercaseString
                
                break
            default:
                
                break
            }
        } else {
            cell.itemLabel.text = self.bankDetails[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.itemDetailLabel.text = self.payoutRequestModel!.accountName
                break
            case 1:
                cell.itemDetailLabel.text = self.payoutRequestModel!.accountNumber
                break
            case 2:
                cell.itemDetailLabel.text = self.payoutRequestModel!.bankName
                break
            default:
                
                break
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PayoutRequestListDetailCellHeight.kRowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var payoutRequestListDetailViewController: PayoutRequestListDetailViewController = PayoutRequestListDetailViewController(nibName: "PayoutRequestListDetailViewController", bundle: nil)
        self.navigationController?.presentViewController(payoutRequestListDetailViewController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            var tableHeaderView = self.tableView.dequeueReusableCellWithIdentifier(PayoutRequestListDetailHeaderTableViewCell.listHeaderNibNameAndIdentifier()) as! PayoutRequestListDetailHeaderTableViewCell
           
            tableHeaderView.depositNameLabel.text = self.payoutRequestModel!.withdrawalMethod + ": " + self.payoutRequestModel!.payTo
            
            tableHeaderView.depositToLabel.text = PayoutRequestListDetailHeaderStrings.kDepositTo
            
            return tableHeaderView
        } else {
            var tableHeaderView = self.tableView.dequeueReusableCellWithIdentifier(PayoutRequestListBankDetailHeaderTableViewCell.bankHeaderNibNameAndIdentifier()) as! PayoutRequestListBankDetailHeaderTableViewCell
            tableHeaderView.bankDepositLabel.text = PayoutRequestListBankDetailHeaderStrings.kBankDepositDetails
            return tableHeaderView
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return PayoutRequestListDetailCellHeight.kSectionHeight
        } else {
            return PayoutRequestListDetailCellHeight.kSectionHeightBank
        }
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
