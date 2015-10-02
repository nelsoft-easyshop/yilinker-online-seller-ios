//
//  FilterResultsCollectionViewCellV2.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 10/2/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class FilterResultsCollectionViewCellV2: UICollectionViewCell {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusImageView: UIView!
    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var numberOfProductsLabel: UILabel!
    @IBOutlet weak var riderNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
