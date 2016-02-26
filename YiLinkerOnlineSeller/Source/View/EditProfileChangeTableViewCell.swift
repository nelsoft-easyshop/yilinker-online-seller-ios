//
//  EditProfileChangeTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 2/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol EditProfileChangeTableViewCellDelegate {
    func editProfileChangeCell(editProfileChangeCell: EditProfileChangeTableViewCell, didTapSendButton sendButton: UIButton)
}

class EditProfileChangeTableViewCell: UITableViewCell {

    var delegate: EditProfileChangeTableViewCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTitleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.changeButton.titleLabel?.lineBreakMode = .ByWordWrapping
        self.changeButton.titleLabel?.numberOfLines = 2
    }
    
    func setTitle(title: String) {
        self.titleLabel.text = title
    }
    
    func setChangeButtonTitle(title: String) {
        self.changeButton.setTitle(title, forState: .Normal)
    }
    
    func setValue(valueTitle: String, value: String) {
        self.valueTitleLabel.text = valueTitle
        self.valueLabel.text = value
    }
    
    func setValueChangeable(isChangeable: Bool) {
        if isChangeable {
            self.changeButton.hidden = false
            self.arrowImageView.hidden = false
        } else {
            self.changeButton.hidden = true
            self.arrowImageView.hidden = true
        }
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        self.delegate?.editProfileChangeCell(self, didTapSendButton: self.changeButton)
    }
}
