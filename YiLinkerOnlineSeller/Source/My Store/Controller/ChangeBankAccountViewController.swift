//
//  ChangeBankAccountViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

//MARK: Delegate
//ChangeBankAccountViewController Delegate Method
protocol ChangeBankAccountViewControllerDelegate {
    func updateBankDetail(accountTitle: String, accountName: String, accountNumber: String, bankName: String)
}

class ChangeBankAccountViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, ChangeAddressCollectionViewCellDelegate, ChangeAddressFooterCollectionViewCellDelegate, CreateNewBankAccountViewControllerDelegate {
    
    //Collection View
    @IBOutlet weak var changeBankAccountCollectionView: UICollectionView!
    
    //Strings
    let changeBankTitle: String = StringHelper.localizedStringWithKey("CHANGE_BANK_TITLE_LOCALIZE_KEY")
    let newAccount: String = StringHelper.localizedStringWithKey("CHANGE_BANK_NEW_ACCOUNT_LOCALIZE_KEY")
    let error: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_ERROR_LOCALIZE_KEY")
    let ok: String = StringHelper.localizedStringWithKey("CHANGE_MOBILE_OK_LOCALIZE_KEY")
    let somethingWentWrong: String = StringHelper.localizedStringWithKey("ERROR_SOMETHING_WENT_WRONG_LOCALIZE_KEY")
    
    //Models
    var bankAccountModel: BankAccountModel!
    var getAddressModel: GetAddressesModel!
    
    //Global variables declaration
    var cellCount: Int = 0
    var defaultBank: Int = 0
    var selectedIndex: Int = -1
    var selectedBankId: Int = 0
    var indexPath: NSIndexPath?
    var bankAccountId: Int = 0
    
    var dimView: UIView = UIView()
    var hud: MBProgressHUD?
    
    //Initialized ChangeBankAccountViewControllerDelegate
    var delegate: ChangeBankAccountViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton()
        self.initializeCollectionView()
        self.initializeDimView()
        self.regsiterNib()
        self.titleView()
        
        self.fireBankAccount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private Methods
    //Initialize collection view
    func initializeCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        if IphoneType.isIphone4()  {
            layout.itemSize = CGSize(width: self.view.frame.size.width - 100, height: 79)
        } else if IphoneType.isIphone5() {
            layout.itemSize = CGSize(width: self.view.frame.size.width - 80, height: 79)
        } else {
            layout.itemSize = CGSize(width: self.view.frame.size.width - 20, height: 79)
        }
        
        layout.minimumLineSpacing = 20
        layout.footerReferenceSize = CGSizeMake(self.changeBankAccountCollectionView.frame.size.width, 41)
        changeBankAccountCollectionView.collectionViewLayout = layout
        changeBankAccountCollectionView.dataSource = self
        changeBankAccountCollectionView.delegate = self
    }
    
    //Initialize dim view
    func initializeDimView() {
        self.edgesForExtendedLayout = .None
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
    }
    
    //MARK: Register nib files
    func regsiterNib() {
        let changeAddressNib: UINib = UINib(nibName: Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.changeBankAccountCollectionView.registerNib(changeAddressNib, forCellWithReuseIdentifier: Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier)
        
        let collectionViewFooterNib: UINib = UINib(nibName: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.changeBankAccountCollectionView.registerNib(collectionViewFooterNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier)
    }
    
    //MARK: Alert view
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: self.ok, style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    //Show hud
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
    
    //Show Dim View
    func showView(){
        dimView.hidden = false
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0.5
            }, completion: { finished in
        })
    }
    
    //Set title of Navigation Bar
    func titleView() {
        self.title =  self.changeBankTitle
    }
    
    //Reload collection view
    func updateCollectionView() {
        fireBankAccount()
        self.changeBankAccountCollectionView.reloadData()
    }
    
    //MARK: Navigation Bar
    //Set buttons in Navigation bar
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check-white"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    //Navigation bar button methods
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func done() {
        fireSetDefaultBankAccount()
    }
    
    //MARK: Delegate Methods
    func addCellInIndexPath(indexPath: NSIndexPath) {
        self.cellCount++
        self.changeBankAccountCollectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)])
    }
    
    func deleteCellInIndexPath(indexPath: NSIndexPath) {
        if cellCount != 0 {
            self.cellCount = self.cellCount - 1
        }
        
        self.changeBankAccountCollectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)])
    }
    
    //MARK: ChangeAddressCollectionViewCell Delegate Methods
    func changeAddressCollectionViewCell(deleteAddressWithCell cell: ChangeAddressCollectionViewCell) {
        let indexPath: NSIndexPath = self.changeBankAccountCollectionView.indexPathForCell(cell)!
        fireDeleteBankAccount(cell.titleLabel.tag, indexPath: indexPath)
    }
    
    func checkAddressCollectionViewCell(checkAdressWithCell cell: ChangeAddressCollectionViewCell){
        let indexPath: NSIndexPath = self.changeBankAccountCollectionView.indexPathForCell(cell)!
    
        cell.layer.borderWidth = 1
        cell.layer.borderColor = Constants.Colors.selectedGreenColor.CGColor
        cell.checkBoxButton.setImage(UIImage(named: "checkBox"), forState: UIControlState.Normal)
        cell.checkBoxButton.backgroundColor = Constants.Colors.selectedGreenColor
        
        self.selectedBankId = cell.titleLabel.tag
        self.defaultBank = indexPath.row
        
        cell.layer.cornerRadius = 5
        cell.delegate = self
        self.changeBankAccountCollectionView.reloadData()
        self.selectedIndex = indexPath.row
    }
    
    //MARK: ChangeAddressFooterCollectionViewCell Delegate Method
    func changeAddressFooterCollectionViewCell(didSelecteAddAddress cell: ChangeAddressFooterCollectionViewCell) {
        self.showView()
        var attributeModal = CreateNewBankAccountViewController(nibName: "CreateNewBankAccountViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.edit = false
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
        self.navigationController?.presentViewController(attributeModal, animated: true, completion: nil)
    }

    //MARK: ChangeBankAccountViewController Delegate Method
    func dismissDimView() {
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0
            }, completion: { finished in
                self.dimView.hidden = true
        })
    }
    
    //MARK: Collection View Delegate Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.cellCount == 0){
            return 0
        } else {
            return self.cellCount
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : ChangeAddressCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ChangeAddressCollectionViewCell
        
        if self.bankAccountModel != nil {
            cell.titleLabel.text = self.bankAccountModel!.account_title[indexPath.row]
            cell.subTitleLabel.text = "\(self.bankAccountModel!.account_number[indexPath.row])"+"\n"+self.bankAccountModel!.account_name[indexPath.row]+"\n"+self.bankAccountModel!.bank_name[indexPath.row]
            cell.titleLabel.tag = self.bankAccountModel!.bank_account_id[indexPath.row]
            self.selectedIndex = indexPath.row
            if self.defaultBank == indexPath.row {
                cell.layer.borderWidth = 1
                cell.layer.borderColor = Constants.Colors.selectedGreenColor.CGColor
                cell.checkBoxButton.setImage(UIImage(named: "checkBox"), forState: UIControlState.Normal)
                cell.checkBoxButton.backgroundColor = Constants.Colors.selectedGreenColor
            } else {
                cell.checkBoxButton.setImage(nil, forState: UIControlState.Normal)
                cell.checkBoxButton.layer.borderWidth = 1
                cell.checkBoxButton.layer.borderColor = UIColor.lightGrayColor().CGColor
                cell.checkBoxButton.backgroundColor = UIColor.clearColor()
                
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            }
            
            cell.layer.cornerRadius = 5
            cell.delegate = self
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.showView()
        
        var attributeModal = CreateNewBankAccountViewController(nibName: "CreateNewBankAccountViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.edit = true
        attributeModal.accountTitle = self.bankAccountModel.account_title[indexPath.row]
        attributeModal.accountName = self.bankAccountModel.account_name[indexPath.row]
        attributeModal.accountNumber = self.bankAccountModel.account_number[indexPath.row]
        attributeModal.bankName = self.bankAccountModel.bank_name[indexPath.row]
        attributeModal.editBankId = self.bankAccountModel.bank_account_id[indexPath.row]
        
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
        self.navigationController?.presentViewController(attributeModal, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let footerView: ChangeAddressFooterCollectionViewCell = self.changeBankAccountCollectionView?.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ChangeAddressFooterCollectionViewCell
        footerView.newAddressButton.setTitle(self.newAccount, forState: UIControlState.Normal)
        
        footerView.delegate = self
        
        return footerView
    }
    
    //MARK: -
    //MARK: - Rest API Request
    //MARK: - POST METHOD - Get Bank Accounts
    /*
    *
    * (Parameters) - access_token
    *
    * Function to get bank account list
    */
    func fireBankAccount(){
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        
        //Set parameter of POST Method
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.POST(APIAtlas.sellerBankAccountList, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if responseObject["isSuccessful"] as! Bool {
                //If isSuccessful is true, parse responseObject
                self.bankAccountModel = BankAccountModel.parseBankAccountDataFromDictionary(responseObject as! NSDictionary)
                
                self.cellCount = self.bankAccountModel.account_name.count
                
                
                for i in 0..<self.bankAccountModel.account_name.count {
                    if self.bankAccountModel.account_name.count == 1 {
                        self.selectedBankId = self.bankAccountModel.bank_account_id[i]
                    }
                    
                    if self.bankAccountModel.is_default[i] {
                        self.defaultBank = i
                        self.selectedBankId = self.bankAccountModel.bank_account_id[i]
                    }
                }
            } else {
                self.showAlert(Constants.Localized.error, message: self.somethingWentWrong)
            }
            
            self.changeBankAccountCollectionView.reloadData()
            self.hud?.hide(true)
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                //Catch unsuccessful return from the API
                if task.statusCode == 401 {
                    //Call method 'fireRefreshToken' if the token is expired
                    self.fireRefreshToken(ChangeBankAccountType.GetBankAccount)
                } else {
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        //Parsed error message return from the API
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        self.showAlert(self.error, message: errorModel.message)
                    } else {
                        self.showAlert(self.error, message: self.somethingWentWrong)
                    }
                }

        })
    }
    
    //MARK: - POST METHOD - Delete Bank Account
    /*
    *
    * (Parameters) - access_token, bankAccountId
    *
    * Function to delete bank account
    */
    func fireDeleteBankAccount(bankAccountId: Int, indexPath: NSIndexPath){
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        
        self.bankAccountId = bankAccountId
        self.indexPath = indexPath
        
        //Set parameters of POST Method
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "bankAccountId" : NSNumber(integer: bankAccountId)];
        
        manager.POST(APIAtlas.sellerDeleteBankAccount, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if responseObject["isSuccessful"] as! Bool {
                //If isSuccessful is true, delete item in collection view at specified indexPath
                self.deleteCellInIndexPath(indexPath)
            } else {
               self.showAlert(Constants.Localized.error, message: self.somethingWentWrong)
            }
            
            self.changeBankAccountCollectionView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                //Catch unsuccessful return from the API
                if task.statusCode == 401 {
                    //Call method 'fireRefreshToken' if the token is expired
                    self.fireRefreshToken(ChangeBankAccountType.DeleteBankAccount)
                } else {
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        //Parsed error message from API return
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        self.showAlert(self.error, message: errorModel.message)
                    } else {
                        self.showAlert(Constants.Localized.error, message: self.somethingWentWrong)
                    }
                }
                
                self.hud?.hide(true)
        })
    }

    //MARK: POST METHOD - Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    *Function to refresh token to get another access token
    *
    */
    func fireRefreshToken(bankAccountType: ChangeBankAccountType) {
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        
        //Set parameter of POST method
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            //Parsed 'responseObject' json object
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            
            if bankAccountType == ChangeBankAccountType.GetBankAccount {
                self.fireBankAccount()
            } else if bankAccountType == ChangeBankAccountType.SetBankAccount {
                self.fireSetDefaultBankAccount()
            } else {
                self.fireDeleteBankAccount(self.bankAccountId, indexPath: self.indexPath!)
            }
            
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                //Catch unsuccessful return from the API
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    //Parsed error message from API return
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    self.showAlert(self.error, message: errorModel.message)
                } else {
                    self.showAlert(Constants.Localized.error, message: self.somethingWentWrong)
                }
                
                self.hud?.hide(true)
        })
        
    }
    
    //MARK: - POST METHOD - Set Default Bank Account
    /*
    *
    * (Parameters) - access_token, bankAccountId
    *
    * Function to set the default bank account
    */
    func fireSetDefaultBankAccount(){
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        
        //Set parameters of POST Method
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "bankAccountId" : self.selectedBankId]
        
        manager.POST(APIAtlas.sellerSetDefaultBankAccount, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if responseObject["isSuccessful"] as! Bool {
                 self.delegate?.updateBankDetail(self.bankAccountModel.account_title[self.defaultBank], accountName: self.bankAccountModel.account_name[self.defaultBank], accountNumber: self.bankAccountModel.account_number[self.defaultBank], bankName: self.bankAccountModel.bank_name[self.defaultBank])
            } else {
                self.showAlert(Constants.Localized.error, message: self.somethingWentWrong)
            }
            
            self.navigationController!.popViewControllerAnimated(true)
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                //Catch unsuccessful return from the API
                if task.statusCode == 401 {
                    //Call method 'fireRefreshToken' if the token is expired
                    self.fireRefreshToken(ChangeBankAccountType.SetBankAccount)
                } else {
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        //Parsed error message from API return
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        self.showAlert(self.error, message: errorModel.message)
                    } else {
                        self.showAlert(Constants.Localized.error, message: self.somethingWentWrong)
                    }
                }
                
                self.hud?.hide(true)
        })
    }
}

