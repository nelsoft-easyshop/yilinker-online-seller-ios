//
//  TransactionDeliveryTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionDeliveryTableViewCell: UITableViewCell {

    @IBOutlet weak var lastCheckinLabel: UILabel!
    @IBOutlet weak var pickupRiderLabel: UILabel!
    @IBOutlet weak var deliveryRiderLabel: UILabel!
    
    @IBOutlet weak var pickupRiderSMSButton: UIButton!
    @IBOutlet weak var pickupRiderCallButton: UIButton!
    @IBOutlet weak var deliveryRiderSMSButton: UIButton!
    @IBOutlet weak var deliveryRiderCallButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
