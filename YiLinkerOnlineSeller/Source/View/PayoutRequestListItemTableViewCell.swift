//
//  PayoutRequestListItemTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

struct PayoutRequestListItemStrings {
    static let kDeposit: String = StringHelper.localizedStringWithKey("PAYOUT_DEPOSIT_LOCALIZE_KEY")
    static let kCheque: String = StringHelper.localizedStringWithKey("PAYOUT_CHEQUE_LOCALIZE_KEY")
}

class PayoutRequestListItemTableViewCell: UITableViewCell {

    // Labels
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemDetailLabel: UILabel!
    
    // Private Strings
    private static let nibNameAndIdentifier: String = "PayoutRequestListItemTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func listItemNibNameAndIdentifier() -> String {
        return PayoutRequestListItemTableViewCell.nibNameAndIdentifier
    }
    
}
