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
    
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var contactNumberTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
        initializeLocalizedStrings()
    }

    func initializeViews() {
        messageButton.layer.cornerRadius = messageButton.frame.height / 2
        messageButton.layer.borderWidth = 2
        messageButton.layer.borderColor = Constants.Colors.productPrice.CGColor
    }
    
    func initializeLocalizedStrings() {
        messageButton.setTitle(StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_MESSAGE_LOCALIZE_KEY"), forState: UIControlState.Normal)
        nameTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_NAME_LOCALIZE_KEY")
        addressTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_ADDRESS_LOCALIZE_KEY")
        contactNumberTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_CONTACT_LOCALIZE_KEY")
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
