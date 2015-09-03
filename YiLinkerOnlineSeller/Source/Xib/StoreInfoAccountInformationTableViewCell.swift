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
    func changeEmailAddress()
}

class StoreInfoAccountInformationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var changeMobileButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
    
    var delegate: StoreInfoAccountInformationTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            self.saveButton.layer.cornerRadius = 5.0
            self.saveButton.clipsToBounds = true
        
            self.changeEmailButton.layer.cornerRadius = 5.0
            self.changeEmailButton.clipsToBounds = true
        
            self.changeMobileButton.layer.cornerRadius = 5.0
            self.changeMobileButton.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeEmailAddress(sender: AnyObject){
        println("Change Email address")
        self.delegate?.changeEmailAddress()
    }
    
    
    @IBAction func changePassword(sender: AnyObject){
        println("Change password")
        self.delegate?.changePassword()
    }
    
    
    @IBAction func saveAccountInfo(sender: AnyObject){
        println("Save Account Info")
        self.delegate?.saveAccountInfo()
    }
    
}
