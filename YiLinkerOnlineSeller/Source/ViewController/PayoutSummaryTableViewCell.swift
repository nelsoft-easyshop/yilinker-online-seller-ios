//
//  PayoutSummaryTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/2/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var inProcessLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
