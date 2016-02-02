//
//  PayoutEarningsTransactionTypeTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

struct PayoutEarningsTransactionTypeStrings {
    static let kCompleted: String = StringHelper.localizedStringWithKey("PAYOUT_COMPLETED_LOCALIZE_KEY")
    static let kTentative: String = StringHelper.localizedStringWithKey("PAYOUT_TENTATIVE_LOCALIZE_KEY")
}

class PayoutEarningsTransactionTypeTableViewCell: UITableViewCell {

    // Labels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var transactionNoLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var boughtByLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // Private Strings
    private static let nibNameAndIdentifier: String = "PayoutEarningsTransactionTypeTableViewCell"
    
    // Views
    @IBOutlet weak var statusView: DynamicRoundedView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func transactionsNibNameAndIdentifier() -> String {
        return PayoutEarningsTransactionTypeTableViewCell.nibNameAndIdentifier
    }
}
