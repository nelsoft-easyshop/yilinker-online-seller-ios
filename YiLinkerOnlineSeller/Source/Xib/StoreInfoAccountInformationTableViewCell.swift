//
//  StoreInfoAccountInformationTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol StoreInfoAccountInformationTableViewCellDelegate {
    
}

class StoreInfoAccountInformationTableViewCell: UITableViewCell {

    var delegate: StoreInfoBankAccountTableViewCellDelegate!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var changeMobileButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
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
    
}
