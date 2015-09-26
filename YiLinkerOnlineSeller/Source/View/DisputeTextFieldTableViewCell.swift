//
//  DisputeTextFieldTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol DisputeTextFieldTableViewCellDelegate {
    func disputeTextFieldTableViewCell(disputeTextFieldTableViewCell: DisputeTextFieldTableViewCell, didStartEditingAtTextField textField: UITextField)
    func disputeTextFieldTableViewCell(disputeTextFieldTableViewCell: DisputeTextFieldTableViewCell, editingAtTextField textField: UITextField)
}

class DisputeTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: DisputeTextFieldTableViewCellDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.delegate = self
    }
    
    func addTracker() {
        self.textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func textFieldDidChange(sender: UITextField) {
        self.delegate?.disputeTextFieldTableViewCell(self, editingAtTextField: self.textField)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate?.disputeTextFieldTableViewCell(self, didStartEditingAtTextField: self.textField)
    }
    
}
