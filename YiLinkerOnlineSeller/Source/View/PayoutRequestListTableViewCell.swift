//
//  PayoutRequestListTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 1/29/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

struct PayoutRequestListStrings {
    static let kBank: String = StringHelper.localizedStringWithKey("PAYOUT_DEPOSIT_LOCALIZE_KEY")
    static let kCheque: String = StringHelper.localizedStringWithKey("PAYOUT_CHEQUE_LOCALIZE_KEY")
    static let kBankCharge: String = StringHelper.localizedStringWithKey("PAYOUT_BANK_CHARGE_LOCALIZE_KEY")
    static let kCompleted: String = StringHelper.localizedStringWithKey("PAYOUT_COMPLETED_LOCALIZE_KEY")
    static let kTentative: String = StringHelper.localizedStringWithKey("PAYOUT_TENTATIVE_LOCALIZE_KEY")
    static let kInProgress: String = StringHelper.localizedStringWithKey("PAYOUT_IN_PROGRESS_LOCALIZE_KEY")
}

class PayoutRequestListTableViewCell: UITableViewCell {

    // Custom Views
    @IBOutlet weak var statusView: DynamicRoundedView!
    
    // Labels
    @IBOutlet weak var bankChargeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var requestDetailLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // Private Strings
    private static let nibNameAndIdentifier: String = "PayoutRequestListTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func listNibNameAndIdentifier() -> String {
        return PayoutRequestListTableViewCell.nibNameAndIdentifier
    }
}
