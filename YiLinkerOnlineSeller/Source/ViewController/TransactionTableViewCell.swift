//
//  TransactionTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var statusImageVIew: UIImageView!
    @IBOutlet weak var tidLabel: UILabel!
    @IBOutlet weak var productsDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        customizedViews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func customizedViews() {
        self.imageContainer.layer.cornerRadius = self.imageContainer.frame.size.height / 2
        self.priceLabel.layer.cornerRadius = self.priceLabel.frame.size.height / 2
    }
}
