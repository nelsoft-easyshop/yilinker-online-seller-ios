//
//  StoreInfoAccountInformationTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol StoreInfoAccountInformationTableViewCellDelegate {
    func saveMobile()
    func changeMobileNumber()
    func changeEmailAddress()
}

class StoreInfoAccountInformationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var saveButton: UIButton!
    
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
    
    @IBAction func changeMobile(sender: AnyObject){
        println("Change Mobile")
        self.delegate?.changeMobileNumber()
    }
    
    
    @IBAction func changeEmail(sender: AnyObject){
        println("Change Email")
        self.delegate?.changeEmailAddress()
    }
    
    
    @IBAction func submitMobile(sender: AnyObject){
        println("Submit Mobile")
        self.delegate?.saveMobile()
    }
    
}
