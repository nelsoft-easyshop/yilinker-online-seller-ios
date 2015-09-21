//
//  DisputeTextFieldTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class DisputeTextFieldTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
