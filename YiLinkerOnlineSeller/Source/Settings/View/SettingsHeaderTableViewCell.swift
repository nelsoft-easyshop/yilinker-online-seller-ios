//
//  SettingsHeaderTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class SettingsHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notificationLabel.text = StringHelper.localizedStringWithKey("NOTIFICATIONS_LOCALIZED_KEY")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
