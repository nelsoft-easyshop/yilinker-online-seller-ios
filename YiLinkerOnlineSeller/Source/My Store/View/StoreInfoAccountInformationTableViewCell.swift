//
//  StoreInfoAccountInformationTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

//MARK: Delegate
//StoreInfoAccountInformationTableViewCell Delegate methods
protocol StoreInfoAccountInformationTableViewCellDelegate {
    func saveAccountInfo()
    func changePassword()
}

class StoreInfoAccountInformationTableViewCell: UITableViewCell{
    
    //Custom Views
    @IBOutlet weak var saveView: DynamicRoundedView!
    
    //Buttons
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    //Labels
    @IBOutlet weak var accountInfoLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    
    //Textfields
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Initilized StoreInfoAccountInformationTableViewCellDelegate
    var delegate: StoreInfoAccountInformationTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Set rounded edge of the button
        self.changePasswordButton.layer.cornerRadius = 5.0
        self.changePasswordButton.clipsToBounds = true
        
        //Add tap gesture recognizer in saveView
        var tap = UITapGestureRecognizer(target: self, action: "save")
        saveView.addGestureRecognizer(tap)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Action methods of buttons
    //Method for change password button
    @IBAction func changePassword(sender: AnyObject){
        self.delegate?.changePassword()
    }
    
    //Method to dismiss keyboard
    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.passwordTextField.resignFirstResponder()
    }
    
    //Method for save button
    @IBAction func saveAccountInfo(sender: AnyObject){
        println("Save Account Info")
        self.delegate?.saveAccountInfo()
    }
    
    //MARK: Private method
    //Action method for saveView when tapped
    //Method for saving changes in account info
    func save(){
        self.delegate?.saveAccountInfo()
    }
}
