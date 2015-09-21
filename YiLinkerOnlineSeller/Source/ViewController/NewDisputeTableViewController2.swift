//
//  NewDisputeTableViewController2.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class NewDisputeTableViewController2: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, DisputeTextFieldTableViewCellDelegate, AddProductHeaderViewDelegate, ResolutionCenterProductListViewControllereDelegate, SelectedProductTableViewCellDelegate, RemarksTableViewCellDelegate {
    
    let cellTextFieldIdentifier: String = "DisputeTextFieldTableViewCell"
    let cellTextFieldNibName: String = "DisputeTextFieldTableViewCell"
    
    let productCellIdentifier: String = "SelectedProductTableViewCell"
    let productCellNibName: String = "SelectedProductTableViewCell"
    
    let remarksCellNibName: String = "RemarksTableViewCell"
    let remarksIdentifier: String = "RemarksTableViewCell"
    
    let textFieldRowHeight: CGFloat = 72
    let remarksHeight: CGFloat = 194
    
    var hud: MBProgressHUD?
    var transactionsModel: TransactionsModel = TransactionsModel()
    var transactionDefaultIndex: Int = 0
    var disputeTypeDefaultIndex: Int = 0
    
    var currentTextField: UITextField = UITextField()
    let disputeType: [String] = ["Refund", "Replacement"]
    
    var disputePickerType: DisputePickerType = DisputePickerType.TransactionList
    
    var products: [TransactionOrderProductModel] = []
    
    var resolutiontitle: String = ""
    var remarks: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fireRegisterCell()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.fireGetTransactions()
        
        self.title = "Add Case"
        self.backButton()
    }
    
    
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
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    func checkButton() {
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 45, 45)
        checkButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer, customCheckButton]
    }
    
    func fireRegisterCell() {
        let textFieldCellNib: UINib = UINib(nibName: self.cellTextFieldNibName, bundle: nil)
        self.tableView.registerNib(textFieldCellNib, forCellReuseIdentifier: self.cellTextFieldIdentifier)
        
        let productCellNib: UINib = UINib(nibName: self.productCellNibName, bundle: nil)
        self.tableView.registerNib(productCellNib, forCellReuseIdentifier: self.productCellIdentifier)
        
        let remarksCellNib: UINib = UINib(nibName: self.remarksCellNibName, bundle: nil)
        self.tableView.registerNib(remarksCellNib, forCellReuseIdentifier: self.remarksIdentifier)
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
        } else if section == 1 {
            return self.products.count
        } else {
            return 1
        }
    }

    //10: refund
    //16: replacement
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: DisputeTextFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.cellTextFieldIdentifier) as! DisputeTextFieldTableViewCell
            if indexPath.row == 0 {
                cell.titleLabel.text = "Dispute Title."
                cell.titleLabel.required()
                cell.textField.text = self.resolutiontitle
                cell.addTracker()
            } else if indexPath.row == 1 {
                cell.titleLabel.text = "Transaction No."
                if self.transactionsModel.transactions.count != 0 {
                   cell.textField.text = self.transactionsModel.transactions[self.transactionDefaultIndex].invoice_number
                }
                cell.titleLabel.required()
            } else if indexPath.row == 2 {
                cell.textField.text = self.disputeType[self.disputeTypeDefaultIndex]
                cell.titleLabel.text = "Dispute Type."
                cell.titleLabel.required()
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 {
            let cell: SelectedProductTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.productCellIdentifier) as! SelectedProductTableViewCell
            cell.productName.text = self.products[indexPath.row].productName
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            return cell
        } else {
            let cell: RemarksTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.remarksIdentifier) as! RemarksTableViewCell
            cell.delegate = self
            cell.remarksLabel.required()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textView.addToolBarWithDoneTarget(self, done: "done")
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
            return UIView(frame: CGRectZero)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        if section == 1 {
            height = 66
        }
        
        return height
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.textFieldRowHeight
        } else if indexPath.section == 1 {
            return 41
        } else {
            return self.remarksHeight
        }
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
                    self.fireRefreshToken(DisputeRefreshType.Transaction)
                }
                
                self.hud?.hide(true)
        })

    }
    
    func fireRefreshToken(disputeRefreshType: DisputeRefreshType) {
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
            
            if disputeRefreshType == DisputeRefreshType.Transaction {
                self.fireGetTransactions()
            } else {
                self.fireAddCase(self.remarks)
            }

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
        
        if self.disputePickerType == DisputePickerType.TransactionList {
            self.currentTextField.text = self.transactionsModel.transactions[self.transactionDefaultIndex].invoice_number
        } else {
            self.currentTextField.text = self.disputeType[self.disputeTypeDefaultIndex]
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
            return self.transactionsModel.transactions[row].invoice_number
        } else {
            return self.disputeType[row]
        }

    }

    func disputeTextFieldTableViewCell(disputeTextFieldTableViewCell: DisputeTextFieldTableViewCell, editingAtTextField textField: UITextField) {
        self.resolutiontitle = textField.text
    }
    
    func disputeTextFieldTableViewCell(disputeTextFieldTableViewCell: DisputeTextFieldTableViewCell, didStartEditingAtTextField textField: UITextField) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(disputeTextFieldTableViewCell)!
        
        if indexPath.row == 1 && indexPath.section == 0 {
            self.currentTextField = disputeTextFieldTableViewCell.textField
            self.disputePickerType = DisputePickerType.TransactionList
            self.addPicker(disputeTextFieldTableViewCell.textField)
        } else if indexPath.row == 2 && indexPath.section == 0 {
            self.currentTextField = disputeTextFieldTableViewCell.textField
            self.disputePickerType = DisputePickerType.DisputeType
            self.addPicker(disputeTextFieldTableViewCell.textField)
        }
    }
    
    func addProductHeaderView(addProductHeaderView: AddProductHeaderView, didClickButtonAdd button: UIButton) {
        let resolutionCenterProductListViewController: ResolutionCenterProductListViewController = ResolutionCenterProductListViewController(nibName: "ResolutionCenterProductListViewController", bundle: nil)
        resolutionCenterProductListViewController.transactionId = self.transactionsModel.transactions[self.transactionDefaultIndex].invoice_number
        resolutionCenterProductListViewController.delegate = self
        self.navigationController?.pushViewController(resolutionCenterProductListViewController, animated: true)
    }
    
    func resolutionCenterProductListViewController(resolutionCenterProductListViewController: ResolutionCenterProductListViewController, didSelecteProducts products: [TransactionOrderProductModel]) {
        for (index, product) in enumerate(products) {
            for p in self.products {
                if p.productId == product.productId {
                    self.navigationController?.view.makeToast("Some Item/s has been selected twice.")
                } else {
                    self.products.append(product)
                }
            }
            
            if self.products.count == 0 {
                self.products.append(product)
            }
        }
        
        self.tableView.reloadData()
    }
    
    func selectedProductTableViewCell(selectedProductTableViewCell: SelectedProductTableViewCell, didTapDeleteButton button: UIButton) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(selectedProductTableViewCell)!
        self.products.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Left)
    }
    
    func remarksTableViewCellDelegate(remarksTableViewCell: RemarksTableViewCell, didTapSubmit button: UIButton) {
        if self.resolutiontitle == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Title is required.")
        } else if self.products.count == 0 {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Selecting a product is required.")
        } else if remarksTableViewCell.textView.text == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Remarks is required.")
        } else {
            self.fireAddCase(remarksTableViewCell.textView.text)
        }
    }
    
    func fireAddCase(remarks: String) {
        self.showHUD()
        self.remarks = remarks
        let manager = APIManager.sharedInstance
        
        var ids: [String] = []
        
        for product in self.products {
            ids.append(product.productId)
        }
        
        var status: Int = 0
        
        if self.disputeType[self.disputeTypeDefaultIndex] == "Refund" {
            status = 10
        } else {
            status = 16
        }
        
        
        let parameters: NSDictionary = [
            "access_token": SessionManager.accessToken(),
            "disputeTitle": self.resolutiontitle,
            "remarks": remarks,
            "orderProductStatus": "10",
            "orderProductIds": ids.description]
        
        println(parameters)
        
        manager.POST(APIAtlas.resolutionCenterAddCaseUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            self.navigationController?.popViewControllerAnimated(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken(DisputeRefreshType.AddCase)
                } else {
                    self.navigationController?.view.makeToast("Something went wrong.")
                }
                
                self.hud?.hide(true)
        })
        
    }
}
