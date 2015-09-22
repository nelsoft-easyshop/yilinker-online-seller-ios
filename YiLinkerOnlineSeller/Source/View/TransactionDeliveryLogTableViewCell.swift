//
//  TransactionDeliveryLogTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionDeliveryLogTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var riderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeViews()
    }
    
    func initializeViews() {
        mainView.layer.cornerRadius = 8
    }

}
