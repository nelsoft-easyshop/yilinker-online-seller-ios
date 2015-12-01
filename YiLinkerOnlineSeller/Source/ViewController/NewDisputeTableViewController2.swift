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
    var reasonDefaultIndex: Int = 0
    
    var currentTextField: UITextField = UITextField()
    let disputeType: [String] = ["Refund", "Replacement"]
    
    var disputePickerType: DisputePickerType = DisputePickerType.TransactionList
    
    var products: [TransactionOrderProductModel] = []
    var reason: ResolutionCenterDisputeReasonModel?
    var reasonTableData: [ResolutionCenterDisputeReasonModel] = []
    var reasons: [ResolutionCenterDisputeReasonsModel] = []
    var reas: ResolutionCenterDisputeReasonsModel!
    var transactionIds: [String] = []
    var resolutiontitle: String = ""
    var resolutionTransactionId: String = ""
    var resolutionDisputeType: String = ""
    var resolutionReason: String = ""
    var remarks: String = ""
    var isValid: Bool = false
    
    //Localize strings
    let newDispute: String = StringHelper.localizedStringWithKey("RESOLUTION_CASES_LOCALIZE_KEY")
    let disputeTitle: String = StringHelper.localizedStringWithKey("DISPUTE_TITLE_LOCALIZE_KEY")
    let transactionNoTitle: String = StringHelper.localizedStringWithKey("DISPUTE_TRANSACTION_NO_LOCALIZE_KEY")
    let disputeTypeTitle: String = StringHelper.localizedStringWithKey("DISPUTE_DISPUTE_TYPE_LOCALIZE_KEY")
    let reasonTitle: String = StringHelper.localizedStringWithKey("DISPUTE_REASON_LOCALIZE_KEY")
    let reasonPlaceholderTitle: String = StringHelper.localizedStringWithKey("DISPUTE_REASON_PLACEHOLDER_LOCALIZE_KEY")
    let productsTitle: String = StringHelper.localizedStringWithKey("DISPUTE_PRODUCTS_LOCALIZE_KEY")
    let addTitle: String = StringHelper.localizedStringWithKey("DISPUTE_ADD_LOCALIZE_KEY")
    let transactionTitle: String = StringHelper.localizedStringWithKey("DISPUTE_TRANSACTION_NUMBER_LOCALIZE_KEY")
    let enterTransactionTitle: String = StringHelper.localizedStringWithKey("DISPUTE_TRANSACTION_NUMBER_PLACEHOLDER_LOCALIZE_KEY")
    let remarksTitle: String = StringHelper.localizedStringWithKey("DISPUTE_REMARKS_LOCALIZE_KEY")
    let submitTitle: String = StringHelper.localizedStringWithKey("DISPUTE_SUBMIT_CASE_LOCALIZE_KEY")
    let addCaseTitle: String = StringHelper.localizedStringWithKey("DISPUTE_ADD_CASE_LOCALIZE_KEY")
    let addProductTitle: String = StringHelper.localizedStringWithKey("DISPUTE_ADD_LOCALIZE_KEY")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fireRegisterCell()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.fireGetTransactions()
        self.fireGetReasons()
        self.title = addCaseTitle
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
            return 4
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
                cell.titleLabel.text = disputeTitle
                cell.titleLabel.required()
                cell.textField.text = self.resolutiontitle
                cell.addTracker()
            } else if indexPath.row == 1 {
                cell.titleLabel.text = transactionNoTitle
                cell.titleLabel.required()
                cell.addTracker()
            } else if indexPath.row == 2 {
                //cell.textField.text = self.disputeType[self.disputeTypeDefaultIndex]
                cell.titleLabel.text = disputeTypeTitle
                cell.titleLabel.required()
                cell.addTracker()
            } else {
                cell.textField.placeholder = reasonPlaceholderTitle
                cell.titleLabel.text = reasonTitle
                cell.titleLabel.required()
                cell.addTracker()
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
            cell.remarksLabel.text = remarksTitle
            cell.submitButton.setTitle(submitTitle, forState: UIControlState.Normal)
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
            headerView.productsLabel.text = productsTitle
            headerView.addButton.setTitle(addProductTitle, forState: UIControlState.Normal)
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
            "access_token": SessionManager.accessToken(), "type" : "for-resolution"]
        
        manager.GET(APIAtlas.transactionList, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            self.transactionsModel = TransactionsModel.parseDataWithDictionary(responseObject as! NSDictionary)
            print(responseObject)
            for i in 0..<self.transactionsModel.transactions.count {
                //if self.transactionsModel.transactions[i].order_status_id == "3" || self.transactionsModel.transactions[i].order_status_id == "6" {
                    self.transactionIds.append(self.transactionsModel.transactions[i].invoice_number)
                //}
            }
            self.tableView.reloadData()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.fireRefreshToken(DisputeRefreshType.Transaction)
                }
                
                self.hud?.hide(true)
        })

    }
    
    func fireGetReasons() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [
            "access_token": SessionManager.accessToken()]
        
        manager.GET(APIAtlas.resolutionCenterReasons+"\(SessionManager.accessToken())", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            self.reason = ResolutionCenterDisputeReasonModel.parseDataFromDictionary(responseObject as! NSDictionary)
            
            for var i: Int = 0; i < self.reason?.key.count; i++ {
                var arr = [ResolutionCenterDisputeReasonsModel]()
                for var j: Int = 0; j < self.reason?.reason.count; j++ {
                    if self.reason!.key[i] == self.reason!.allkey[j] {
                        self.reas = ResolutionCenterDisputeReasonsModel(id: self.reason!.id[j], reason: self.reason!.reason[j])
                        arr.append(self.reas)
                        println("id \(self.reason!.id[j])")
                    }
                }
                self.reasonTableData.append(ResolutionCenterDisputeReasonModel(key2: self.reason!.key[i], resolutionReasons2: arr))
            }
           
            //self.tableView.reloadData()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.fireRefreshToken(DisputeRefreshType.Reason)
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
            } else if disputeRefreshType == DisputeRefreshType.AddCase{
                self.fireAddCase(self.remarks)
            } else {
                self.fireGetReasons()
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
        } else if self.disputePickerType == DisputePickerType.DisputeType {
            pickerView.selectRow(self.disputeTypeDefaultIndex, inComponent: 0, animated: false)
        } else {
            pickerView.selectRow(self.reasonDefaultIndex, inComponent: 0, animated: false)
        }
        
        if self.disputePickerType == DisputePickerType.TransactionList {
            self.isValid = true
            if self.transactionsModel.transactions.count != 0 {
                self.currentTextField.text = self.transactionsModel.transactions[self.transactionDefaultIndex].invoice_number//self.transactionIds[self.transactionDefaultIndex]
                self.resolutionTransactionId = self.transactionsModel.transactions[self.transactionDefaultIndex].invoice_number
            } else {
                //self.showAlert(title: Constants.Localized.no, message: StringHelper.localizedStringWithKey("TRANSACTIONS_NO_TRANSACTIONS_AVAIL_LOCALIZE_KEY"))
            }
        } else if self.disputePickerType == DisputePickerType.DisputeType {
            self.currentTextField.text = self.reasonTableData[self.disputeTypeDefaultIndex].key2
            self.resolutionDisputeType = self.reasonTableData[self.disputeTypeDefaultIndex].key2
        } else {
            self.currentTextField.text = self.reasonTableData[self.disputeTypeDefaultIndex].resolutionReasons2[self.reasonDefaultIndex].reason
            self.resolutionReason = self.reasonTableData[self.disputeTypeDefaultIndex].resolutionReasons2[self.reasonDefaultIndex].reason
        }
        
       
        textField.inputView = pickerView
        
        
        textField.addToolBarWithDoneTarget(self, done: "done")
    }
    
    func done() {
        self.tableView.endEditing(true)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.disputePickerType == DisputePickerType.TransactionList {
            if self.transactionsModel.transactions.count != 0 {
                self.transactionDefaultIndex = row
                self.currentTextField.text = self.transactionsModel.transactions[self.transactionDefaultIndex].invoice_number
            }
        } else if self.disputePickerType == DisputePickerType.DisputeType {
            self.disputeTypeDefaultIndex = row
            self.reasonDefaultIndex = 0
            self.currentTextField.text = self.reason!.key[row]
        } else {
            self.reasonDefaultIndex = row
            self.currentTextField.text = self.reasonTableData[self.disputeTypeDefaultIndex].resolutionReasons2[row].reason
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.disputePickerType == DisputePickerType.TransactionList {
           return self.transactionsModel.transactions.count
        } else if self.disputePickerType == DisputePickerType.DisputeType {
           return self.reason!.key.count
        } else {
            return self.reasonTableData[self.disputeTypeDefaultIndex].resolutionReasons2.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if self.disputePickerType == DisputePickerType.TransactionList {
            return self.transactionsModel.transactions[row].invoice_number
        } else if self.disputePickerType == DisputePickerType.DisputeType{
            return self.reason!.key[row]
        } else {
            return self.reasonTableData[self.disputeTypeDefaultIndex].resolutionReasons2[row].reason
        }

    }

    func disputeTextFieldTableViewCell(disputeTextFieldTableViewCell: DisputeTextFieldTableViewCell, editingAtTextField textField: UITextField) {
        self.resolutiontitle = textField.text
    }
    
    func disputeTextFieldTableViewCell(disputeTextFieldTableViewCell: DisputeTextFieldTableViewCell, didStartEditingAtTextField textField: UITextField) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(disputeTextFieldTableViewCell)!
        if indexPath.row == 0 && indexPath.section == 0 {
            
        } else if indexPath.row == 1 && indexPath.section == 0 {
            self.currentTextField = disputeTextFieldTableViewCell.textField
            self.disputePickerType = DisputePickerType.TransactionList
            self.addPicker(disputeTextFieldTableViewCell.textField)
        } else if indexPath.row == 2 && indexPath.section == 0 {
            self.currentTextField = disputeTextFieldTableViewCell.textField
            self.disputePickerType = DisputePickerType.DisputeType
            self.addPicker(disputeTextFieldTableViewCell.textField)
        }  else if indexPath.row == 3 && indexPath.section == 0 {
            self.currentTextField = disputeTextFieldTableViewCell.textField
            self.disputePickerType = DisputePickerType.ReasonType
            self.addPicker(disputeTextFieldTableViewCell.textField)
        }

    }
    
    func addProductHeaderView(addProductHeaderView: AddProductHeaderView, didClickButtonAdd button: UIButton) {
        if self.isValid {
            let resolutionCenterProductListViewController: ResolutionCenterProductListViewController = ResolutionCenterProductListViewController(nibName: "ResolutionCenterProductListViewController", bundle: nil)
            if self.transactionsModel.transactions.count != 0 {
                resolutionCenterProductListViewController.transactionId = self.transactionsModel.transactions[self.transactionDefaultIndex].invoice_number
                resolutionCenterProductListViewController.delegate = self
                self.products.removeAll(keepCapacity: false)
                self.navigationController?.pushViewController(resolutionCenterProductListViewController, animated: true)
            }
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Please select transaction number.", title: "Incomplete product details")
        }
    }
    
    func resolutionCenterProductListViewController(resolutionCenterProductListViewController: ResolutionCenterProductListViewController, didSelecteProducts products: [TransactionOrderProductModel]) {
        for (index, product) in enumerate(products) {
            for p in self.products {
                /*if p.productId == product.productId {
                    self.navigationController?.view.makeToast("Some Item/s has been selected twice.")
                } else {
                    self.products.append(product)
                }*/
                //self.products.append(product)
            }
            self.products.append(product)
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
        } else if self.resolutionTransactionId == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Transaction id is required.")
        } else if self.resolutionDisputeType == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Dispute type is required.")
        } else if self.resolutionReason == "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Reason is required.")
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
            ids.append(product.orderProductId)
        }
        
        var status: Int = 0
        
        if self.reasonTableData[self.disputeTypeDefaultIndex].key2 == "Refund"{
            status = 10
        } else {
            status = 16
        }
        
        println("\(self.reasonTableData[self.disputeTypeDefaultIndex].resolutionReasons2[self.reasonDefaultIndex].id) \(self.reasonTableData[self.disputeTypeDefaultIndex].resolutionReasons2[self.reasonDefaultIndex].reason)")
        let parameters: NSDictionary = [
            "access_token": SessionManager.accessToken(),
            "disputeTitle": self.resolutiontitle,
            "remarks": remarks,
            "orderProductStatus": "\(status)",
            "reasonId": self.reasonTableData[self.disputeTypeDefaultIndex].resolutionReasons2[self.reasonDefaultIndex].id,
            "orderProductIds": ids.description]
        //[153, 486]
        println(ids.description)
        
        manager.POST(APIAtlas.resolutionCenterAddCaseUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject)
            self.hud?.hide(true)
            self.navigationController?.popViewControllerAnimated(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken(DisputeRefreshType.AddCase)
                } else {
                    self.navigationController?.view.makeToast(Constants.Localized.someThingWentWrong)
                }
                
                self.hud?.hide(true)
        })
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
