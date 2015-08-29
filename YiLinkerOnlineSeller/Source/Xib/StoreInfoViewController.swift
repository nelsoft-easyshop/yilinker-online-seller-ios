//
//  StoreInfoViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class StoreInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StoreInfoTableViewCellDelegate, StoreInfoSectionTableViewCellDelegate, StoreInfoAddressTableViewCellDelagate, StoreInfoBankAccountTableViewCellDelegate , StoreInfoAccountInformationTableViewCellDelegate{
    
    @IBOutlet weak var storeInfoTableView: UITableView!
    
    let storeInfoSectionTableViewCellIndentifier: String = "StoreInfoSectionTableViewCell"
    let storeInfoAddressTableViewCellIdentifier: String = "StoreInfoAddressTableViewCell"
    let storeInfoBankAccountTableViewCellIdentifier: String = "StoreInfoBankAccountTableViewCell"
    let storeInfoAccountInformationTableViewCellIdentifier: String = "StoreInfoAccountInformationTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storeInfoHeader: StoreInfoTableViewCell = XibHelper.puffViewWithNibName("StoreInfoTableViewCell", index: 0) as! StoreInfoTableViewCell
        storeInfoHeader.delegate = self
        
        self.storeInfoTableView.tableHeaderView = storeInfoHeader
        
        self.initializeViews()
        self.registerNibs()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.storeInfoTableView.tableFooterView = UIView(frame: CGRectZero)
        self.storeInfoTableView.delegate = self
        self.storeInfoTableView.dataSource = self
    }
    
    func registerNibs() {
        var storeInfo = UINib(nibName: storeInfoSectionTableViewCellIndentifier, bundle: nil)
        self.storeInfoTableView.registerNib(storeInfo, forCellReuseIdentifier: storeInfoSectionTableViewCellIndentifier)
        
        var storeInfoBankAccount = UINib(nibName: storeInfoBankAccountTableViewCellIdentifier, bundle: nil)
        storeInfoTableView.registerNib(storeInfoBankAccount, forCellReuseIdentifier: storeInfoBankAccountTableViewCellIdentifier)
        
        var storeInfoAddress = UINib(nibName: storeInfoAddressTableViewCellIdentifier, bundle: nil)
        storeInfoTableView.registerNib(storeInfoAddress, forCellReuseIdentifier: storeInfoAddressTableViewCellIdentifier)
        
        var storeInfoAccountInformation = UINib(nibName: storeInfoAccountInformationTableViewCellIdentifier, bundle: nil)
        storeInfoTableView.registerNib(storeInfoAccountInformation, forCellReuseIdentifier: storeInfoAccountInformationTableViewCellIdentifier)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(storeInfoSectionTableViewCellIndentifier, forIndexPath: indexPath) as! StoreInfoSectionTableViewCell
            cell.delegate = self
            
            return cell
       } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(storeInfoAddressTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoAddressTableViewCell
            cell.delegate = self
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier( storeInfoBankAccountTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoBankAccountTableViewCell
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier( storeInfoAccountInformationTableViewCellIdentifier, forIndexPath: indexPath) as! StoreInfoAccountInformationTableViewCell
            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 198
        } else if indexPath.section == 1 {
            return 163
        } else  if indexPath.section == 2 {
            return 132
        } else {
            return 299
        }
    }
    
    //Store Details Function
    func storeInfoVerify() {
        println("verify")
        /*
        var dimView = UIView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.layer.frame.width, self.view.layer.frame.height))
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        view.addSubview(dimView)

        var attributeModal = VerifyNumberViewController(nibName: "VerifyNumberViewController", bundle: nil)
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
        
        var activityViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        self.navigationController?.pushViewController(activityViewController, animated:true)
        */
        var attributeModal = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)

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
