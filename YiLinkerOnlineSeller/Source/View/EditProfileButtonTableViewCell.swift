//
//  EditProfileButtonTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 2/22/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol EditProfileButtonTableViewCellDelegate {
    func editProfileButtonCell(editProfileButtonCell: EditProfileButtonTableViewCell, didTapButton button: UIButton)
}

class EditProfileButtonTableViewCell: UITableViewCell {

    var delegate: EditProfileButtonTableViewCellDelegate?
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setButtonTitle(title: String) {
        self.saveButton.setTitle(title, forState: .Normal)
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        self.delegate?.editProfileButtonCell(self, didTapButton: sender)
    }
    
}
