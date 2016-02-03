//
//  PayoutRequestListDetailHeaderTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

struct PayoutRequestListDetailHeaderStrings {
    static let kDepositTo: String = StringHelper.localizedStringWithKey("PAYOUT_DEPOSIT_TO_LOCALIZE_KEY")
    static let kBankDepositTo: String = StringHelper.localizedStringWithKey("PAYOUT_BANK_DEPOSIT_LOCALIZE_KEY")
    static let kBankChequeTo: String = StringHelper.localizedStringWithKey("PAYOUT_CHEQUE_LOCALIZE_KEY")
}

class PayoutRequestListDetailHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var depositToLabel: UILabel!
    @IBOutlet weak var depositNameLabel: UILabel!
    
    // Private Strings
    private static let nibNameAndIdentifier: String = "PayoutRequestListDetailHeaderTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func listHeaderNibNameAndIdentifier() -> String {
        return PayoutRequestListDetailHeaderTableViewCell.nibNameAndIdentifier
    }
}
