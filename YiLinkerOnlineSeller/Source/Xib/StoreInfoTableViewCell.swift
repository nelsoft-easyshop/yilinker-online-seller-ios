//
//  StoreInfoTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol StoreInfoTableViewCellDelegate {
    
}

class StoreInfoTableViewCell: UITableViewCell {

    var delegate: StoreInfoTableViewCellDelegate?
    
    @IBOutlet weak var verifyButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.verifyButton.layer.cornerRadius = 5.0
        self.verifyButton.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
