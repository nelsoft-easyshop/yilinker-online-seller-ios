//
//  TransactionDetailsTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/4/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var totalUnitCostLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var paymentTypeTitleLabel: UILabel!
    @IBOutlet weak var dateCreatedTitleLabel: UILabel!
    @IBOutlet weak var totalQuantityTitleLabel: UILabel!
    @IBOutlet weak var totalUnitCostTitleLabel: UILabel!
    @IBOutlet weak var shippingCostTitleLabel: UILabel!
    @IBOutlet weak var totalCostTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializesViews()
        intializeLocalizedStrings()
    }

    func initializesViews() {
        statusLabel.layer.masksToBounds = true
        statusLabel.layer.cornerRadius = statusLabel.frame.height / 2
    }
    
    func intializeLocalizedStrings() {
        statusTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_STATUS_LOCALIZE_KEY")
        paymentTypeTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_PAYMENT_TYPE_LOCALIZE_KEY")
        dateCreatedLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_DATE_CREATED_LOCALIZE_KEY")
        totalQuantityTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_TOTAL_QUANTITY_LOCALIZE_KEY")
        totalUnitCostTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_TOTAL_UNIT_COST_LOCALIZE_KEY")
        shippingCostTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_SHIPPING_COST_LOCALIZE_KEY")
        totalCostTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_TOTAL_COST_LOCALIZE_KEY")
    }

}
