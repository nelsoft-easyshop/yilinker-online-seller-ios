//
//  TransactionDeliveryTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol TransactionDeliveryTableViewCellDelegate {
    func smsPickupRiderAction()
    func callPickupRiderAction()
    func smsDeliveryRiderAction()
    func callDeliveryRiderAction()
    func lastCheckinAction()
}

class TransactionDeliveryTableViewCell: UITableViewCell {
    
    var delegate: TransactionDeliveryTableViewCellDelegate?

    @IBOutlet weak var lastCheckinLabel: UILabel!
    @IBOutlet weak var pickupRiderLabel: UILabel!
    @IBOutlet weak var deliveryRiderLabel: UILabel!
    
    @IBOutlet weak var pickupRiderSMSButton: UIButton!
    @IBOutlet weak var pickupRiderCallButton: UIButton!
    @IBOutlet weak var deliveryRiderSMSButton: UIButton!
    @IBOutlet weak var deliveryRiderCallButton: UIButton!
    
    @IBOutlet weak var lastCheckinButton: UIButton!
    
    @IBOutlet weak var lastCheckinTitleLabel: UILabel!
    @IBOutlet weak var pickupRiderTitleLabel: UILabel!
    @IBOutlet weak var deliveryRiderTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeLocalizedStrings()
    }

    func initializeLocalizedStrings() {
        lastCheckinTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_LAST_CHECKIN_LOCALIZE_KEY")
        pickupRiderTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_PICKUP_RIDER_LOCALIZE_KEY")
        deliveryRiderTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DELIVERY_RIDER_LOCALIZE_KEY")
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == lastCheckinButton {
            delegate?.lastCheckinAction()
        } else if sender as! UIButton == pickupRiderSMSButton {
            delegate?.smsPickupRiderAction()
        } else if sender as! UIButton == pickupRiderCallButton {
            delegate?.callPickupRiderAction()
        } else if sender as! UIButton == deliveryRiderSMSButton {
            delegate?.smsDeliveryRiderAction()
        } else if sender as! UIButton == deliveryRiderCallButton {
            delegate?.callDeliveryRiderAction()
        }
    }

}
