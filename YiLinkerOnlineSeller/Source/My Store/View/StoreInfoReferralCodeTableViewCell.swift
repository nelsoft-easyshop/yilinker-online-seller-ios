//
//  StoreInfoReferralCodeTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 1/26/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol StoreInfoReferralCodeTableViewCellDelegate {
    func copyReferralCode(code: String)
    func saveReferralPerson(referralName: String)
}

class StoreInfoReferralCodeTableViewCell: UITableViewCell {

    // Buttons
    @IBOutlet weak var copyButton: DynamicRoundedButton!
    @IBOutlet weak var saveReferralPersonButton: DynamicRoundedButton!
    
    // Labels
    @IBOutlet weak var referralCodeLabel: UILabel!
    @IBOutlet weak var referralCodeInfoLabel: UILabel!
    @IBOutlet weak var referralPersonLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var referralCodeTextField: UITextField!
    @IBOutlet weak var referralPersonNameTextField: UITextField!
    
    // Initialize StoreInfoReferralCodeTableViewCellDelegate
    var delegate: StoreInfoReferralCodeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func copyReferralCode(sender: UIButton) {
        self.delegate?.copyReferralCode(self.referralCodeTextField.text!)
    }
    
    @IBAction func saveReferralPerson(sender: UIButton) {
        self.delegate?.saveReferralPerson(self.referralPersonNameTextField.text!)
    }
    
}
