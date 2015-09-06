//
//  ChangeBankAccountViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ChangeBankAccountViewControllerDelegate {
    func updateBankDetail(accountTitle: String, accountName: String, accountNumber: Int, bankName: String)
}

class ChangeBankAccountViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, ChangeAddressCollectionViewCellDelegate, ChangeAddressFooterCollectionViewCellDelegate, CreateNewBankAccountViewControllerDelegate {
    
    @IBOutlet weak var changeBankAccountCollectionView: UICollectionView!
    
    var bankAccountModel: BankAccountModel!
    var getAddressModel: GetAddressesModel!
    
    var cellCount: Int = 0
    var selectedIndex: Int = -1
    var defaultBank: Int = 0;
    var selectedBankId: Int = 0
    var delegate: ChangeBankAccountViewControllerDelegate?
    
    var hud: MBProgressHUD?
    var dimView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        self.edgesForExtendedLayout = .None
        self.titleView()
        self.backButton()
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
        self.regsiterNib()
        self.fireBankAccount()
    }
    
    func titleView() {
        self.title = "Change Bank Account"
    }
    
    // Show hud
    
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
    
    func fireBankAccount(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.POST(APIAtlas.sellerBankAccountList, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.bankAccountModel = BankAccountModel.parseBankAccountDataFromDictionary(responseObject as! NSDictionary)
            //self.populateData()

            self.cellCount = self.bankAccountModel.account_name.count
            for var num  = 0; num < self.bankAccountModel.account_name.count; num++ {
                if self.bankAccountModel.is_default[num]{
                    //self.selectedIndex = num
                    self.defaultBank = num
                }
                
            }
            self.changeBankAccountCollectionView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error)
        })
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
        
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check-white"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func done() {
        fireSetDefaultBankAccount()
    }
    
    func fireSetDefaultBankAccount(){
        self.showHUD()
        let manager = APIManager.sharedInstance
        println("\(self.bankAccountModel.bank_account_id.count)")
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "bankAccountId" : self.selectedBankId]
        
        manager.POST(APIAtlas.sellerSetDefaultBankAccount, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
          
            self.delegate?.updateBankDetail(self.bankAccountModel.account_title[self.defaultBank], accountName: self.bankAccountModel.account_name[self.defaultBank], accountNumber: self.bankAccountModel.account_number[self.defaultBank], bankName: self.bankAccountModel.bank_name[self.defaultBank])

            //self.changeBankAccountCollectionView.reloadData()
            
            self.navigationController!.popViewControllerAnimated(true)
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
               self.hud?.hide(true)
                println(error)
        })
    }

    func regsiterNib() {
        let changeAddressNib: UINib = UINib(nibName: Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.changeBankAccountCollectionView.registerNib(changeAddressNib, forCellWithReuseIdentifier: Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier)
        
        let collectionViewFooterNib: UINib = UINib(nibName: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.changeBankAccountCollectionView.registerNib(collectionViewFooterNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.cellCount == 0){
            return 0
        } else {
            return self.cellCount
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : ChangeAddressCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ChangeAddressCollectionViewCell
        
        println(self.bankAccountModel!.account_title[indexPath.row])
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
        println("selected bank for edit \(indexPath.row)")
        self.showView()
        var attributeModal = CreateNewBankAccountViewController(nibName: "CreateNewBankAccountViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.edit = true
        attributeModal.accountTitle = self.bankAccountModel.account_title[indexPath.row]
        attributeModal.accountName = self.bankAccountModel.account_name[indexPath.row]
        attributeModal.accountNumber = self.bankAccountModel.account_number[indexPath.row]
        attributeModal.bankName = self.bankAccountModel.bank_name[indexPath.row]
        attributeModal.editBankId = self.bankAccountModel.bank_account_id[indexPath.row]
        println("bank account id \(self.bankAccountModel.bank_account_id[indexPath.row])")
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
        self.navigationController?.presentViewController(attributeModal, animated: true, completion: nil)
    }

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeAddressCollectionViewCell(deleteAddressWithCell cell: ChangeAddressCollectionViewCell) {
        let indexPath: NSIndexPath = self.changeBankAccountCollectionView.indexPathForCell(cell)!
        fireDeleteBankAccount(cell.titleLabel.tag, indexPath: indexPath)
        println("deleted bank account \(cell.titleLabel.tag)")
    }
    
    func checkAddressCollectionViewCell(checkAdressWithCell cell: ChangeAddressCollectionViewCell){
         println("check bank account \(cell.titleLabel.text)")
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
    
    func fireDeleteBankAccount(bankAccountId: Int, indexPath: NSIndexPath){
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "bankAccountId" : NSNumber(integer: bankAccountId)];
        
        manager.POST(APIAtlas.sellerDeleteBankAccount, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.deleteCellInIndexPath(indexPath)
            self.changeBankAccountCollectionView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error)
        })
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let footerView: ChangeAddressFooterCollectionViewCell = self.changeBankAccountCollectionView?.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ChangeAddressFooterCollectionViewCell
        
        footerView.delegate = self
        
        return footerView
    }
    
    
    func changeAddressFooterCollectionViewCell(didSelecteAddAddress cell: ChangeAddressFooterCollectionViewCell) {
        /*let indexPath: NSIndexPath = NSIndexPath(forItem: self.cellCount, inSection: 0)
        self.addCellInIndexPath(indexPath)*/
        /*
        let addAddressTableViewController: AddAddressTableViewController = AddAddressTableViewController(nibName: "AddAddressTableViewController", bundle: nil)
        addAddressTableViewController.delegate = self
        self.navigationController!.presentViewController(addAddressTableViewController, animated: true, completion: nil)
        */
        self.showView()
        var attributeModal = CreateNewBankAccountViewController(nibName: "CreateNewBankAccountViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.edit = false
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
        self.navigationController?.presentViewController(attributeModal, animated: true, completion: nil)
    
        println("footer")
    }
    
    
    func updateCollectionView() {
        fireBankAccount()
        self.changeBankAccountCollectionView.reloadData()
    }
    
    func dismissDimView() {
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0
            }, completion: { finished in
                self.dimView.hidden = true
        })
    }
    
    func showView(){
        dimView.hidden = false
        UIView.animateWithDuration(0.25, animations: {
            self.dimView.alpha = 0.5
            }, completion: { finished in
        })
    }
}

