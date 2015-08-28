//
//  SettingsItemTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol SettingsItemTableViewCellDelegate{
    func settingSwitchChanged(sender: AnyObject, isOn: Bool)
}

class SettingsItemTableViewCell: UITableViewCell {
    
    var delegate: SettingsItemTableViewCellDelegate?

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchAction(sender: AnyObject) {
        delegate?.settingSwitchChanged(self, isOn: (sender as! UISwitch).on)
    }
    
    func setTitleText(text: String) {
        titleTextLabel.text = text
    }
    
    func setSettingSwitchStatus(isOn: Bool){
        settingSwitch.on = isOn
    }

}
