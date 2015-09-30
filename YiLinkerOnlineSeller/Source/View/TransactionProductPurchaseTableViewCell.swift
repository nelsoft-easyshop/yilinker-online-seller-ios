//
//  TransactionProductPurchaseTableViewCellTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionProductPurchaseTableViewCell: UITableViewCell {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var quantityTitleLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var totalCosttitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        intializeLocalizedStrings()
    }

    func intializeLocalizedStrings() {
        quantityTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_QUANTITY_LOCALIZE_KEY")
        priceTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_PRICE_LOCALIZE_KEY")
        totalCosttitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_TOTAL_COST_LOCALIZE_KEY")
    }

}
