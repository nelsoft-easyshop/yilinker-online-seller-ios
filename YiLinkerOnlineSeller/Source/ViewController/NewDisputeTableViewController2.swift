//
//  NewDisputeTableViewController2.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class NewDisputeTableViewController2: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, DisputeTextFieldTableViewCellDelegate, AddProductHeaderViewDelegate {
    
    let cellTextFieldIdentifier: String = "DisputeTextFieldTableViewCell"
    let cellTextFieldNibName: String = "DisputeTextFieldTableViewCell"
    
    let textFieldRowHeight: CGFloat = 72
    var hud: MBProgressHUD?
    
    var transactionsModel: TransactionsModel = TransactionsModel()
    var transactionDefaultIndex: Int = 0
    var disputeTypeDefaultIndex: Int = 0
    
    var currentTextField: UITextField = UITextField()
    let disputeType: [String] = ["Refund", "Replacement"]
    
    var disputePickerType: DisputePickerType = DisputePickerType.TransactionList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fireRegisterCell()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.fireGetTransactions()
    }

    func fireRegisterCell() {
        let textFieldCellNib: UINib = UINib(nibName: self.cellTextFieldNibName, bundle: nil)
        self.tableView.registerNib(textFieldCellNib, forCellReuseIdentifier: self.cellTextFieldIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 3
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: DisputeTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.cellTextFieldIdentifier) as! DisputeTextFieldTableViewCell
            if indexPath.row == 0 {
                cell.titleLabel.text = "Dispute Title."
                cell.titleLabel.required()
            } else if indexPath.row == 1 {
                cell.titleLabel.text = "Transaction No."
                cell.titleLabel.required()
            } else if indexPath.row == 2 {
                cell.titleLabel.text = "Dispute Type."
                cell.titleLabel.required()
            }
            cell.delegate = self
            return cell
        } else {
            let cell: DisputeTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.cellTextFieldIdentifier) as! DisputeTextFieldTableViewCell
            cell.titleLabel.text = "Dispute Title."
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: CGRectZero)
        } else if section == 1 {
            let headerView: AddProductHeaderView = XibHelper.puffViewWithNibName("AddProductHeaderView", index: 0) as! AddProductHeaderView
            headerView.delegate = self
            return headerView
        } else {
            let headerView: RemarksTableViewCell = XibHelper.puffViewWithNibName("RemarksTableViewCell", index: 0) as! RemarksTableViewCell
            return headerView
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        if section == 1 {
            height = 66
        } else if section == 2 {
            height = 194
        }
        
        return height
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.textFieldRowHeight
    }
    
    func fireGetTransactions() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [
            "access_token": SessionManager.accessToken()]
        
        manager.GET(APIAtlas.transactionList, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            self.transactionsModel = TransactionsModel.parseDataWithDictionary(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                }
                
                self.hud?.hide(true)
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
            self.fireGetTransactions()
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    
    func addPicker(textField: UITextField) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if self.disputePickerType == DisputePickerType.TransactionList {
            pickerView.selectRow(self.transactionDefaultIndex, inComponent: 0, animated: false)
        } else {
            pickerView.selectRow(self.disputeTypeDefaultIndex, inComponent: 0, animated: false)
        }
        
        textField.inputView = pickerView
        textField.addToolBarWithDoneTarget(self, done: "done")
    }
    
    func done() {
        self.tableView.endEditing(true)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.disputePickerType == DisputePickerType.TransactionList {
            self.transactionDefaultIndex = row
            self.currentTextField.text = self.transactionsModel.transactions[row].invoice_number
        } else {
            self.disputeTypeDefaultIndex = row
            self.currentTextField.text = self.disputeType[row]
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.disputePickerType == DisputePickerType.TransactionList {
           return self.transactionsModel.transactions.count
        } else {
           return self.disputeType.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if self.disputePickerType == DisputePickerType.TransactionList {
            println(self.transactionsModel.transactions[row].invoice_number)
            return self.transactionsModel.transactions[row].invoice_number
        } else {
            return self.disputeType[row]
        }

    }

    func disputeTextFieldTableViewCell(disputeTextFieldTableViewCell: DisputeTextFieldTableViewCell, didStartEditingAtTextField textField: UITextField) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(disputeTextFieldTableViewCell)!
        
        if indexPath.row == 1 {
            self.currentTextField = disputeTextFieldTableViewCell.textField
            self.disputePickerType = DisputePickerType.TransactionList
            self.addPicker(disputeTextFieldTableViewCell.textField)
        } else if indexPath.row == 2 {
            self.currentTextField = disputeTextFieldTableViewCell.textField
            self.disputePickerType = DisputePickerType.DisputeType
            self.addPicker(disputeTextFieldTableViewCell.textField)
        }
    }
    
    func addProductHeaderView(addProductHeaderView: AddProductHeaderView, didClickButtonAdd button: UIButton) {
        let resolutionCenterProductListViewController: ResolutionCenterProductListViewController = ResolutionCenterProductListViewController(nibName: "ResolutionCenterProductListViewController", bundle: nil)
        self.navigationController?.pushViewController(resolutionCenterProductListViewController, animated: true)
    }
}
