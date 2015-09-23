//
//  CreateNewBankAccountViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit
protocol CreateNewBankAccountViewControllerDelegate{
    func updateCollectionView()
    func dismissDimView()
}
class CreateNewBankAccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterByTableViewCellDelegate, UITextFieldDelegate {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var accountTitleTextField: UITextField!
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var bankNameTextField: UITextField!
    
    @IBOutlet weak var bankTableView: UITableView!
    
    @IBOutlet weak var bankAccountTitleLabel: UILabel!
    @IBOutlet weak var bankAccountDetailLabel: UILabel!
    @IBOutlet weak var accountTitleLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    
    var storeInfoModel: StoreInfoModel!
    var bankModel: BankModel!
    
    var delegate: CreateNewBankAccountViewControllerDelegate?
    
    var hud: MBProgressHUD?
    
    var autoCompleteArray: NSMutableArray?
    var autoCompleteFilterArray: NSArray?
    var autoCompleteFilterArrayId: NSArray?
    var bankDictionary = Dictionary<String, Int>()
    var bankId: Int = 0
    
    var edit: Bool = false
    var editBankId: Int = 0
    var accountTitle: String = ""
    var accountName: String = ""
    var accountNumber: String = ""
    var bankName: String = ""
    
    let editBankTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_EDIT_LOCALIZE_KEY")
    let addBankTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_ADD_LOCALIZE_KEY")
    let account: String = StringHelper.localizedStringWithKey("CHANGE_BANK_ACCOUNT_TITLE_LOCALIZE_KEY")
    let accountNameTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_ACCOUNT_NAME_LOCALIZE_KEY")
    let accountNumberTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_ACCOUNT_NUMBER_LOCALIZE_KEY")
    let bankNameTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_BANK_NAME_LOCALIZE_KEY")
    let submitTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_SUBMIT_LOCALIZE_KEY")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bankTableView.hidden = true
        self.bankNameTextField.delegate = self
        self.bankTableView.tableFooterView = UIView.new()
        self.bankTableView.layer.masksToBounds = false
        self.bankTableView.layer.shadowColor = UIColor.blackColor().CGColor
        self.bankTableView.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        self.bankTableView.layer.shadowOpacity = 0.3
        self.bankTableView.delegate = self
        self.bankTableView.dataSource = self
        self.bankTableView.separatorInset = UIEdgeInsetsZero
        self.bankTableView.layoutMargins = UIEdgeInsetsZero
        
        self.accountTitleLabel.text = self.account
        self.accountNameLabel.text = self.accountNameTitle
        self.accountNumberLabel.text = self.accountNumberTitle
        self.bankNameLabel.text = self.bankNameTitle
        
        self.createButton.setTitle(self.submitTitle, forState: UIControlState.Normal)
       
        var storeInfo = UINib(nibName: "FilterByTableViewCell", bundle: nil)
        self.bankTableView.registerNib(storeInfo, forCellReuseIdentifier: "FilterByTableViewCell")
    
        self.fireEnabledBanks()
        
        if self.edit {
            self.bankAccountTitleLabel.text = self.editBankTitle
            self.fillBankDetails(accountTitle, accountName: accountName, accountNumber: accountNumber, bankName: bankName, bankAccountId: editBankId)
        } else {
            self.bankAccountTitleLabel.text = self.addBankTitle
        }
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.delegate?.dismissDimView()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createBankAcount(sender: AnyObject) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        var bankId2: Int = 0
        var url: String = ""
        var accountNumber: String = self.accountNumberTextField.text
        
        if edit {
            bankId2 = self.bankDictionary[self.bankNameTextField.text]!
            url = APIAtlas.sellerEditBankAccount
            var parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "accountTitle" : self.accountTitleTextField.text, "accountNumber" : accountNumber, "accountName" : self.accountNameTextField.text, "bankId" : NSNumber(integer: bankId2), "bankAccountId" : self.editBankId]
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                println("edited bank account")
                //self.dismissViewControllerAnimated(true, completion: nil)
                
                self.hud?.hide(true)
                self.delegate?.updateCollectionView()
                self.dismissViewControllerAnimated(true, completion: nil)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.hud?.hide(true)
                    println(error)
            })
        } else {
            bankId2 = self.bankId
            url = APIAtlas.sellerAddBankAccount
            var parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "accountTitle" : self.accountTitleTextField.text, "accountNumber" : accountNumber, "accountName" : self.accountNameTextField.text, "bankId" : NSNumber(integer: bankId2)]
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                println("created bank account")
                //self.dismissViewControllerAnimated(true, completion: nil)
                
                self.hud?.hide(true)
                self.delegate?.updateCollectionView()
                self.dismissViewControllerAnimated(true, completion: nil)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.hud?.hide(true)
                    println(error)
            })
        }
        
        self.delegate?.dismissDimView()
        
        
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if autoCompleteFilterArray != nil {
        return autoCompleteFilterArray!.count
        } else {
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //UITableViewCell *ell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:nil];
        let cell: FilterByTableViewCell = self.bankTableView.dequeueReusableCellWithIdentifier("FilterByTableViewCell") as! FilterByTableViewCell
        cell.delegate = self
        println(self.bankModel)
        if(self.bankModel != nil){
            //autoCompleteArray?.addObject(self.bankModel.bankName[indexPath.row])
            //autoCompleteArray = NSMutableArray(array: self.bankModel.bankName as NSArray)
            if(autoCompleteFilterArray != nil){
                cell.filterByLabel?.text = autoCompleteFilterArray!.objectAtIndex(indexPath.row) as? String
                
                println("complete array 1 \(autoCompleteArray)")
            }
        }
       
        cell.contentView.backgroundColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.clearColor()

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: FilterByTableViewCell = self.bankTableView.cellForRowAtIndexPath(indexPath) as! FilterByTableViewCell
        self.bankNameTextField.text = cell.filterByLabel.text
        self.bankId = self.bankDictionary[cell.filterByLabel.text!]!
        self.bankTableView.hidden = true
    }
    
    @IBAction func updateTopContraint(sender: AnyObject) {
        if IphoneType.isIphone4() {
            self.topConstraint.constant = -150
        } else if IphoneType.isIphone5() {
            topConstraint.constant = -60
        } else {
            topConstraint.constant = 60
        }
    }

    func fireEnabledBanks (){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()]
        
        manager.POST(APIAtlas.sellerBank, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
           
            self.bankModel = BankModel.parseEnablebankData(responseObject as! NSDictionary)
            //self.dismissViewControllerAnimated(true, completion: nil)
            self.autoCompleteArray = NSMutableArray(array: self.bankModel.bankName as NSArray)
            self.autoCompleteFilterArray = NSArray(array: self.bankModel.bankName) as NSArray
            self.autoCompleteFilterArrayId = NSArray(array: self.bankModel.bankId) as NSArray
            for var num = 0 ; num < self.bankModel.bankName.count; num++ {
                self.bankDictionary[self.bankModel.bankName[num]] = self.bankModel.bankId[num]
            }
            println("autocompletearray \(self.autoCompleteArray)")
            self.hud?.hide(true)
            self.bankTableView.reloadData()
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error)
        })
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var passcode = (self.bankNameTextField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)

        var predicate = NSPredicate(format: "SELF CONTAINS %@", passcode.uppercaseString)
        println(passcode)
        
        autoCompleteFilterArray = (autoCompleteArray!).filteredArrayUsingPredicate(predicate)
        if autoCompleteFilterArray?.count != 0 {
            self.bankTableView.hidden = false
        } else {
            self.bankTableView.hidden = true
        }
        
        self.bankTableView.reloadData()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.bankTableView.hidden = true
    }
    
    func fillBankDetails(accountTitle: String, accountName: String,  accountNumber: String, bankName: String, bankAccountId: Int){
        if(!accountTitle.isEmpty) {
            self.accountTitleTextField.text = accountTitle
            self.accountNameTextField.text = accountName
            self.accountNumberTextField.text = accountNumber
            self.bankNameTextField.text = "\(bankName)"
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
