//
//  RemarksTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol RemarksTableViewCellDelegate {
    func remarksTableViewCellDelegate(remarksTableViewCell: RemarksTableViewCell, didTapSubmit button: UIButton)
}

class RemarksTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    var delegate: RemarksTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.submitButton.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func submit(sender: AnyObject) {
        self.delegate?.remarksTableViewCellDelegate(self, didTapSubmit: self.submitButton)
    }
}
