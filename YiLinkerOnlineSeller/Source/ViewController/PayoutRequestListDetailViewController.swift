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
    var payoutRequestModel: PayoutRequestListModel = PayoutRequestListModel(date: "", withdrawalMethod: "", totalAmount: "", charge: "", netAmount: "", currencyCode: "", status: "", payTo: "", bankName: "", accountNumber: "", accountName: "")
    
    // Global varialbles
    var payoutRequestDetails: [String] = [PayoutRequestListDetailStrings.kDate, PayoutRequestListDetailStrings.kMethod, PayoutRequestListDetailStrings.kRequested, PayoutRequestListDetailStrings.kBankCharge, PayoutRequestListDetailStrings.kAmount, PayoutRequestListDetailStrings.kStatus]
    var bankDetails: [String] = [PayoutRequestListDetailStrings.kBankAccountName, PayoutRequestListDetailStrings.kBankAccountNumber, PayoutRequestListDetailStrings.kBankName]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Request Detail"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.backButton()
        self.registerCell()
        
        // Sample data for payout request details
        self.payoutRequestModel.date = "02/01/2016"
        self.payoutRequestModel.withdrawalMethod = "bank"
        self.payoutRequestModel.totalAmount = "10000.0000".formatToTwoDecimal().formatToPeso()
        self.payoutRequestModel.charge = "50.0000".formatToTwoDecimal().formatToPeso()
        self.payoutRequestModel.netAmount = "10000.0000".formatToTwoDecimal().formatToPeso()
        self.payoutRequestModel.status = "IN PROCESS".uppercaseString
        self.payoutRequestModel.accountName = "Nelson Liao"
        self.payoutRequestModel.accountNumber = "00551458614562"
        self.payoutRequestModel.bankName = "China Bank"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation bar
    // MARK: - Add Back Button in navigation bar
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
    
    //MARK: - Navigation bar back button action
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }

    // MARK: - Regiter nib files
    func registerCell() {
        let nibNameAndIdentifierListItem: UINib = UINib(nibName: PayoutRequestListItemTableViewCell.listItemNibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(nibNameAndIdentifierListItem, forCellReuseIdentifier: PayoutRequestListItemTableViewCell.listItemNibNameAndIdentifier())
        
        let nibNameAndIdentifierListHeader: UINib = UINib(nibName: PayoutRequestListDetailHeaderTableViewCell.listHeaderNibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(nibNameAndIdentifierListHeader, forCellReuseIdentifier: PayoutRequestListDetailHeaderTableViewCell.listHeaderNibNameAndIdentifier())
        
        let nibNameAndIdentifierListBankHeader: UINib = UINib(nibName: PayoutRequestListBankDetailHeaderTableViewCell.bankHeaderNibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(nibNameAndIdentifierListBankHeader, forCellReuseIdentifier: PayoutRequestListBankDetailHeaderTableViewCell.bankHeaderNibNameAndIdentifier())
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if self.payoutRequestModel.withdrawalMethod == "bank" {
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
                cell.itemDetailLabel.text = self.payoutRequestModel.date
                break
            case 1:
                if self.payoutRequestModel.withdrawalMethod == "bank" {
                    cell.itemDetailLabel.text = PayoutRequestListItemStrings.kDeposit
                } else {
                    cell.itemDetailLabel.text = PayoutRequestListItemStrings.kCheque
                }
                break
            case 2:
                cell.itemDetailLabel.text = self.payoutRequestModel.totalAmount
                break
            case 3:
                cell.itemDetailLabel.text = self.payoutRequestModel.charge
                break
            case 4:
                cell.itemDetailLabel.text = self.payoutRequestModel.netAmount
                break
            case 5:
                cell.itemDetailLabel.text = self.payoutRequestModel.status
                break
            default:
                
                break
            }
        } else {
            cell.itemLabel.text = self.bankDetails[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.itemDetailLabel.text = self.payoutRequestModel.accountName
                break
            case 1:
                cell.itemDetailLabel.text = self.payoutRequestModel.accountNumber
                break
            case 2:
                cell.itemDetailLabel.text = self.payoutRequestModel.bankName
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
            return tableHeaderView
        } else {
            var tableHeaderView = self.tableView.dequeueReusableCellWithIdentifier(PayoutRequestListBankDetailHeaderTableViewCell.bankHeaderNibNameAndIdentifier()) as! PayoutRequestListBankDetailHeaderTableViewCell
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
