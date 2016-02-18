//
//  EditProfileTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 2/17/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController {
    
    let personalCellIdentifier: String = "EditProfilePersonalTableViewCell"
    let addressCellIdentifier: String = "EditProfileAddressTableViewCell"
    
    var storeInfo: StoreInfoModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
        self.registerNibs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initializations
    func initializeViews() {
        self.view.backgroundColor = Constants.Colors.lightBackgroundColor
        
        //Add Back Button
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        //Set title
        self.title = "Edit Profile"
        
        //Add tap getsure to close keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func registerNibs() {
        let personalNib = UINib(nibName: self.personalCellIdentifier, bundle: nil)
        self.tableView.registerNib(personalNib, forCellReuseIdentifier: self.personalCellIdentifier)
        
        let addressNib = UINib(nibName: self.addressCellIdentifier, bundle: nil)
        self.tableView.registerNib(addressNib, forCellReuseIdentifier: self.addressCellIdentifier)
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Functions
    func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: EditProfilePersonalTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.personalCellIdentifier, forIndexPath: indexPath) as! EditProfilePersonalTableViewCell
            cell.passValue(self.storeInfo!)
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell: EditProfileAddressTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.addressCellIdentifier, forIndexPath: indexPath) as! EditProfileAddressTableViewCell
            cell.passValue(self.storeInfo!)
            cell.delegate = self
            return cell
        } else {
            let cell: EditProfilePersonalTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.personalCellIdentifier, forIndexPath: indexPath) as! EditProfilePersonalTableViewCell
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 405
        } else if indexPath.row == 1 {
            return 155
        } else {
            return 155
        }
    }
}

// MARK: - Delegates
// MARK: - Edit Profile Personal TableViewCell Delegate
extension EditProfileTableViewController: EditProfilePersonalTableViewCellDelegate {
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, textFieldShouldReturn textField: UITextField) {
        if textField == editProfilePersonalCell.mobilePhoneTextField {
            editProfilePersonalCell.firstNameTextField.becomeFirstResponder()
        } else if textField == editProfilePersonalCell.firstNameTextField {
            editProfilePersonalCell.lastNameTextField.becomeFirstResponder()
        } else if textField == editProfilePersonalCell.lastNameTextField {
            editProfilePersonalCell.emailLabel.becomeFirstResponder()
        } else if textField == editProfilePersonalCell.emailTextField {
            editProfilePersonalCell.tinTextField.becomeFirstResponder()
        } else if textField == editProfilePersonalCell.tinTextField {
            self.closeKeyboard()
        } else {
            self.closeKeyboard()
        }
    }
    
    func editProfilePersonalCell(editProfilePersonalCell: EditProfilePersonalTableViewCell, didTapSendVerification button: UIButton) {
        
    }
}

// MARK: - Edit Profile Address TableViewCell Delegate
extension EditProfileTableViewController: EditProfileAddressTableViewCellDelegate {
    func editProfileAddressCell(editProfileAddressCell: EditProfileAddressTableViewCell, didTapChangeAddress view: UIView) {
        var changeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        changeAddressViewController.delegate = self
        self.navigationController?.pushViewController(changeAddressViewController, animated:true)
    }
    
    func editProfileAddressCell(editProfileAddressCell: EditProfileAddressTableViewCell, didTapSave button: UIButton) {
        
    }
}

// MARK: - Change Address ViewController Delegate
extension EditProfileTableViewController: ChangeAddressViewControllerDelegate {
    func updateStoreAddressDetail(title: String, storeAddress: String) {
        self.storeInfo?.title = title
        self.storeInfo?.store_address = storeAddress
        self.tableView.reloadData()
    }
    
    func dismissView() {
        
    }
}
