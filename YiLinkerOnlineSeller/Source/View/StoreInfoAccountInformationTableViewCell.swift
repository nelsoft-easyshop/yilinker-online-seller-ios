//
//  StoreInfoAccountInformationTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol StoreInfoAccountInformationTableViewCellDelegate {
    func saveAccountInfo()
    func changePassword()
}

class StoreInfoAccountInformationTableViewCell: UITableViewCell{
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var accountInfoLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var saveView: DynamicRoundedView!
    var delegate: StoreInfoAccountInformationTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            //self.saveButton.layer.cornerRadius = 5.0
            //self.saveButton.clipsToBounds = true
        
        self.changePasswordButton.layer.cornerRadius = 5.0
        self.changePasswordButton.clipsToBounds = true
        var tap = UITapGestureRecognizer(target: self, action: "save")
        saveView.addGestureRecognizer(tap)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func changePassword(sender: AnyObject){
        println("Change password")
        self.delegate?.changePassword()
    }
    
    
    @IBAction func saveAccountInfo(sender: AnyObject){
        println("Save Account Info")
        self.delegate?.saveAccountInfo()
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        
        self.passwordTextField.resignFirstResponder()
    }
    
    func save(){
        self.delegate?.saveAccountInfo()
    }
    
}
