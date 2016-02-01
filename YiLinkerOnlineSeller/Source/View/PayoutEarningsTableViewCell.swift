//
//  PayoutEarningsTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutEarningsTableViewCell: UITableViewCell {

    // Imageviews
    @IBOutlet weak var earningTypeImageView: UIImageView!
    
    // Labels
    @IBOutlet weak var earningTypeLabel: UILabel!
    @IBOutlet weak var earningTypeAmountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
