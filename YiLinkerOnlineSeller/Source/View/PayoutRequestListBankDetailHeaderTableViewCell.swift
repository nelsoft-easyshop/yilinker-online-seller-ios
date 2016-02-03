//
//  PayoutRequestListBankDetailHeaderTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

struct PayoutRequestListBankDetailHeaderStrings {
    static let kBankDepositDetails: String = StringHelper.localizedStringWithKey("PAYOUT_BANK_DEPOSIT_DETAILS_LOCALIZE_KEY")
}
class PayoutRequestListBankDetailHeaderTableViewCell: UITableViewCell {

    // Labels
    @IBOutlet weak var bankDepositLabel: UILabel!
    
    // Private Strings
    private static let nibNameAndIdentifier: String = "PayoutRequestListBankDetailHeaderTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func bankHeaderNibNameAndIdentifier() -> String {
        return PayoutRequestListBankDetailHeaderTableViewCell.nibNameAndIdentifier
    }
}
