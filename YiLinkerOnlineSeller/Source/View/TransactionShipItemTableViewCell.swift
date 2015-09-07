//
//  TransactionShipItemTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionShipItemTableViewCell: UITableViewCell {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pickupButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeViews() {
        cancelButton.layer.cornerRadius = 5
        pickupButton.layer.cornerRadius = 5
    }

}
