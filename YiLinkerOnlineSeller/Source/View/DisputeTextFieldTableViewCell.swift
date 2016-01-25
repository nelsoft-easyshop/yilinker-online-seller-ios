//
//  DisputeTextFieldTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: - Delegate
// DisputeTextFieldTableViewCell Delegate methods
protocol DisputeTextFieldTableViewCellDelegate {
    func disputeTextFieldTableViewCell(disputeTextFieldTableViewCell: DisputeTextFieldTableViewCell, didStartEditingAtTextField textField: UITextField)
    func disputeTextFieldTableViewCell(disputeTextFieldTableViewCell: DisputeTextFieldTableViewCell, editingAtTextField textField: UITextField)
}

class DisputeTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    //Labels
    @IBOutlet weak var titleLabel: UILabel!
    
    //Textfield
    @IBOutlet weak var textField: UITextField!

    // Initialized DisputeTextFieldTableViewCellDelegate
    var delegate: DisputeTextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.delegate = self
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addTracker() {
        self.textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    // Textfield action
    func textFieldDidChange(sender: UITextField) {
        self.delegate?.disputeTextFieldTableViewCell(self, editingAtTextField: self.textField)
    }
    
    // MARK: - Textfield delegate method
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate?.disputeTextFieldTableViewCell(self, didStartEditingAtTextField: self.textField)
    }
}
