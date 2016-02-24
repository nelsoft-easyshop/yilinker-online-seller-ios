//
//  EditProfileChangeTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 2/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class EditProfileChangeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTitleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTitle(title: String) {
        self.titleLabel.text = title
    }
    
    func setValue(valueTitle: String, value: String) {
        self.valueTitleLabel.text = valueTitle
        self.valueLabel.text = value
    }
    
    func setValueChangeable(isChangeable: Bool) {
        if isChangeable {
            self.changeLabel.hidden = false
            self.arrowImageView.hidden = false
        } else {
            self.changeLabel.hidden = true
            self.arrowImageView.hidden = true
        }
    }
}
