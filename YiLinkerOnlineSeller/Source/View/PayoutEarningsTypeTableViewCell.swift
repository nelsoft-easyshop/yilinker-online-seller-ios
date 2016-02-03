//
//  PayoutEarningsTypeTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

struct PayoutEarningsTypeStrings {
    static let kCompleted: String = StringHelper.localizedStringWithKey("PAYOUT_COMPLETED_LOCALIZE_KEY")
    static let kTentative: String = StringHelper.localizedStringWithKey("PAYOUT_TENTATIVE_LOCALIZE_KEY")
}

class PayoutEarningsTypeTableViewCell: UITableViewCell {

    // Labels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    //Views
    @IBOutlet weak var statusView: DynamicRoundedView!
    
    // Private Strings 
    private static let nibNameAndIdentifier: String = "PayoutEarningsTypeTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func earningsTypeNibNameAndIdentifier() -> String {
        return PayoutEarningsTypeTableViewCell.nibNameAndIdentifier
    }
}
