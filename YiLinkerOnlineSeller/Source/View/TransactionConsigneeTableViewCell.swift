//
//  TransactionConsigneeTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol TransactionConsigneeTableViewCellDelegate{
    func messageConsigneeAction()
    func smsConsigneeAction()
    func callConsigneeAction()
}

class TransactionConsigneeTableViewCell: UITableViewCell {
    
    var delegate: TransactionConsigneeTableViewCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var smsButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
    }

    func initializeViews() {
        messageButton.layer.cornerRadius = messageButton.frame.height / 2
        messageButton.layer.borderWidth = 2
        messageButton.layer.borderColor = Constants.Colors.productPrice.CGColor
    }
    
    @IBAction func messageAction(sender: AnyObject) {
        delegate?.messageConsigneeAction()
    }
    
    @IBAction func smsAction(sender: AnyObject) {
        delegate?.smsConsigneeAction()
    }
    @IBAction func callAction(sender: AnyObject) {
        delegate?.callConsigneeAction()
    }
}
