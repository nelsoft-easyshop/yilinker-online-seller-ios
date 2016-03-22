//
//  CreateNewBankAccountViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

//MARK: Delegate
//CreateNewBankAccountViewController Delegate methods
protocol CreateNewBankAccountViewControllerDelegate{
    func updateCollectionView()
    func dismissDimView()
}

class CreateNewBankAccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterByTableViewCellDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //Constraints
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    //Buttons
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    //Labels
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var accountTitleLabel: UILabel!
    @IBOutlet weak var bankAccountDetailLabel: UILabel!
    @IBOutlet weak var bankAccountTitleLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    
    //Tableview
    @IBOutlet weak var bankTableView: UITableView!
    
    //Texfields
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var accountTitleTextField: UITextField!
    @IBOutlet weak var bankNameTextField: UITextField!
    
    //Strings
    let editBankTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_EDIT_LOCALIZE_KEY")
    let addBankTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_ADD_LOCALIZE_KEY")
    let account: String = StringHelper.localizedStringWithKey("CHANGE_BANK_ACCOUNT_TITLE_LOCALIZE_KEY")
    let accountNameTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_ACCOUNT_NAME_LOCALIZE_KEY")
    let accountNumberTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_ACCOUNT_NUMBER_LOCALIZE_KEY")
    let bankNameTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_BANK_NAME_LOCALIZE_KEY")
    let submitTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_SUBMIT_LOCALIZE_KEY")
    
    //Models
    var storeInfoModel: StoreInfoModel!
    var bankModel: BankModel!
    
    //Global variable declarations
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
    
    //Initialized CreateNewBankAccountViewControllerDelegate
    var delegate: CreateNewBankAccountViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialized tableview
        self.bankTableView.hidden = true
        self.bankTableView.tableFooterView = UIView.new()
        self.bankTableView.layer.masksToBounds = false
        self.bankTableView.layer.shadowColor = UIColor.blackColor().CGColor
        self.bankTableView.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        self.bankTableView.layer.shadowOpacity = 0.3
        self.bankTableView.delegate = self
        self.bankTableView.dataSource = self
        self.bankTableView.separatorInset = UIEdgeInsetsZero
        self.bankTableView.layoutMargins = UIEdgeInsetsZero
        
        //Set Textfield delegate
        self.accountTitleTextField.delegate = self
        self.accountNumberTextField.delegate = self
        self.accountNameTextField.delegate = self
        self.bankNameTextField.delegate = self
        
        //Set labels and button text
        self.accountTitleLabel.text = self.account
        self.accountNameLabel.text = self.accountNameTitle
        self.accountNumberLabel.text = self.accountNumberTitle
        self.bankNameLabel.text = self.bankNameTitle
        self.createButton.setTitle(self.submitTitle, forState: UIControlState.Normal)
       
        self.registerNibs()
    
        self.addPicker()
        
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
    
    //MARK: Private Methods
    //Add picker view in bankNameTextField
    func addPicker() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
        self.bankNameTextField.inputView = pickerView
    }
    
    //Fill bank details
    func fillBankDetails(accountTitle: String, accountName: String,  accountNumber: String, bankName: String, bankAccountId: Int){
        if(!accountTitle.isEmpty) {
            self.accountTitleTextField.text = accountTitle
            self.accountNameTextField.text = accountName
            self.accountNumberTextField.text = accountNumber
            self.bankNameTextField.text = "\(bankName)"
        }
        
    }
    
    //Register nib files
    func registerNibs() {
        var storeInfo = UINib(nibName: "FilterByTableViewCell", bundle: nil)
        self.bankTableView.registerNib(storeInfo, forCellReuseIdentifier: "FilterByTableViewCell")
    }
    
    //Show loader
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
    
    //MARK: Button actions
    @IBAction func closeAction(sender: AnyObject) {
        self.delegate?.dismissDimView()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createBankAcount(sender: AnyObject) {
        let manager = APIManager.sharedInstance
        var bankId2: Int = 0
        var url: String = ""
        var accountNumber: String = self.accountNumberTextField.text
        
        if self.edit {
            if !self.bankNameTextField.text.isEmpty && !self.accountNameTextField.text.isEmpty && !self.accountTitleTextField.text.isEmpty && !self.accountNumberTextField.text.isEmpty{
                self.showHUD()
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
                    self.delegate?.dismissDimView()
                    }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.hud?.hide(true)
                        println(error)
                })
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "All fields are required.", title: "Error")
            }
        } else {
            if !self.bankNameTextField.text.isEmpty && !self.accountNameTextField.text.isEmpty && !self.accountTitleTextField.text.isEmpty && !self.accountNumberTextField.text.isEmpty{
                self.showHUD()
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
                    self.delegate?.dismissDimView()
                    }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.hud?.hide(true)
                        println(error)
                })
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "All fields are required.", title: "Error")
            }
        }
   
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
    
    //Tableview delegate methods
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
        
        let cell: FilterByTableViewCell = self.bankTableView.dequeueReusableCellWithIdentifier("FilterByTableViewCell") as! FilterByTableViewCell
        cell.delegate = self
        
        if(self.bankModel != nil){
            if(autoCompleteFilterArray != nil){
                cell.filterByLabel?.text = autoCompleteFilterArray!.objectAtIndex(indexPath.row) as? String
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
    
    //MARK : UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.bankModel.bankName.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.bankModel.bankName[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bankNameTextField.text = self.bankModel.bankName[row]
        bankId = self.bankModel.bankId[row]
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = self.bankModel.bankName[row]
        pickerLabel.numberOfLines = 0
        pickerLabel.font = UIFont(name: "Panton-Regular", size: 12)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    //MARK: Textfield Delegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    //MARK: -
    //MARK: - REST API request
    //MARK: POST METHOD - Get all available banks
    /*
    *
    * (Parameters) - access_token
    *
    * Function to get all available bank
    *
    */
    func fireEnabledBanks (){
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        
        //Add parameter of POST method
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()]
        
        manager.POST(APIAtlas.sellerBank, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.bankModel = BankModel.parseEnablebankData(responseObject as! NSDictionary)
            
            if responseObject["isSuccessful"] as! Bool {
                self.autoCompleteArray = NSMutableArray(array: self.bankModel.bankName as NSArray)
                self.autoCompleteFilterArray = NSArray(array: self.bankModel.bankName) as NSArray
                self.autoCompleteFilterArrayId = NSArray(array: self.bankModel.bankId) as NSArray
                for i in 0..<self.bankModel.bankName.count {
                    self.bankDictionary[self.bankModel.bankName[i]] = self.bankModel.bankId[i]
                }
            }
            
            self.bankTableView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
        })
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