//
//  PayoutRequestListDetailViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutRequestListDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Tableview
    @IBOutlet weak var tableView: UITableView!
    
    // Models
    var payoutRequestModel: PayoutRequestListModel = PayoutRequestListModel(date: [""], withdrawalMethod: [""], totalAmount: [""], charge: [""], netAmount: [""], currencyCode: [""], status: [""], payTo: [""], bankName: [""], accountNumber: [""], accountName: [""])
    
    // Global varialbles
    var payoutRequestDetails: [String] = ["Date", "Method", "Requested", "Bank Charge", "Amount", "Status"]
    var bankDetails: [String] = ["Bank Account Name", "Bank Number", "Bank Name"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerCell()
        
        // Sample data for payout request details
        self.payoutRequestModel.date[0] = "02/01/2016"
        self.payoutRequestModel.withdrawalMethod[0] = "bank"
        self.payoutRequestModel.totalAmount[0] = "10000.0000".formatToTwoDecimal().formatToPeso()
        self.payoutRequestModel.charge[0] = "50.0000".formatToTwoDecimal().formatToPeso()
        self.payoutRequestModel.netAmount[0] = "10000.0000".formatToTwoDecimal().formatToPeso()
        self.payoutRequestModel.status[0] = "IN PROCESS"
        self.payoutRequestModel.accountName[0] = "Nelson Liao"
        self.payoutRequestModel.accountNumber[0] = "00551458614562"
        self.payoutRequestModel.bankName[0] = "China Bank"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Regiter nib files
    func registerCell() {
        let nib: UINib = UINib(nibName: "PayoutRequestListItemTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PayoutRequestListItemTableViewCell")
        
        let nib2: UINib = UINib(nibName: "PayoutRequestListDetailHeaderTableViewCell", bundle: nil)
        self.tableView.registerNib(nib2, forCellReuseIdentifier: "PayoutRequestListDetailHeaderTableViewCell")
        
        let nib3: UINib = UINib(nibName: "PayoutRequestListBankDetailHeaderTableViewCell", bundle: nil)
        self.tableView.registerNib(nib3, forCellReuseIdentifier: "PayoutRequestListBankDetailHeaderTableViewCell")
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if self.payoutRequestModel.withdrawalMethod[0] == "bank" {
            return 2
        } else {
            return 1
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
          let cell = self.tableView.dequeueReusableCellWithIdentifier("PayoutRequestListItemTableViewCell", forIndexPath: indexPath) as! PayoutRequestListItemTableViewCell
        
        if indexPath.section == 0 {
            cell.itemLabel.text = self.payoutRequestDetails[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.itemDetailLabel.text = self.payoutRequestModel.date[0]
                break
            case 1:
                if self.payoutRequestModel.withdrawalMethod[0] == "bank" {
                    cell.itemDetailLabel.text = "Bank Deposit"
                } else {
                    cell.itemDetailLabel.text = "Bank Cheque"
                }
                
                break
            case 2:
                cell.itemDetailLabel.text = self.payoutRequestModel.totalAmount[0]
                break
            case 3:
                cell.itemDetailLabel.text = self.payoutRequestModel.charge[0]
                break
            case 4:
                cell.itemDetailLabel.text = self.payoutRequestModel.netAmount[0]
                break
            case 5:
                cell.itemDetailLabel.text = self.payoutRequestModel.status[0]
                break
                
            default:
                
                break
            }
        } else {
            cell.itemLabel.text = self.bankDetails[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.itemDetailLabel.text = self.payoutRequestModel.accountName[0]
                break
            case 1:
                cell.itemDetailLabel.text = self.payoutRequestModel.accountNumber[0]
                break
            case 2:
                cell.itemDetailLabel.text = self.payoutRequestModel.bankName[0]
                break
                
            default:
                
                break
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 43
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var payoutRequestListDetailViewController = PayoutRequestListDetailViewController(nibName: "PayoutRequestListDetailViewController", bundle: nil)
        self.navigationController?.presentViewController(payoutRequestListDetailViewController, animated: true, completion: nil)
        //self.navigationController?.pushViewController(payoutRequestListDetailViewController, animated:true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            var tableHeaderView = self.tableView.dequeueReusableCellWithIdentifier("PayoutRequestListDetailHeaderTableViewCell") as! PayoutRequestListDetailHeaderTableViewCell
            return tableHeaderView
        } else {
            var tableHeaderView = self.tableView.dequeueReusableCellWithIdentifier("PayoutRequestListBankDetailHeaderTableViewCell") as! PayoutRequestListBankDetailHeaderTableViewCell
            return tableHeaderView
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 81
        } else {
            return 44
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
