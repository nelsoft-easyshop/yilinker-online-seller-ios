//
//  RecentProductsTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class RecentProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var modeOfPaymentLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
    }

    func initializeViews() {
        statusLabel.layer.cornerRadius = statusLabel.frame.height / 2
        statusLabel.layer.borderColor = Constants.Colors.grayText.CGColor
        statusLabel.layer.borderWidth = 1
    }
    
    func setProductName(text: String) {
        productNameLabel.text = text
    }
    
    func setModeOfPayment(text: String) {
        modeOfPaymentLabel.text = text
    }
    
    func setPrice(text: String) {
        priceLabel.text = text
    }
    
    func setStatus(text: String) {
        statusLabel.text = text
    }
}
