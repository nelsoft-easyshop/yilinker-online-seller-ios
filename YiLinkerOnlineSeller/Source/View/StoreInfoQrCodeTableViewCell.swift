//
//  StoreInfoQrCodeTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 10/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol StoreInfoQrCodeTableViewCellDelegate {
    func shareAction(postImage: UIImageView, title: String)
}


class StoreInfoQrCodeTableViewCell: UITableViewCell {

    
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var twitterButton: UIButton!
    @IBOutlet var googlePlusButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var qrCodeImageView: UIImageView!
    @IBOutlet var qrCodeLabel: UILabel!
    @IBOutlet var qrCodeDescriptionLabel: UILabel!
    @IBOutlet var shareWithFbLabel: UILabel!
    @IBOutlet var shareWithTwitterLabel: UILabel!
    @IBOutlet var shareWithGoogleLabel: UILabel!
    @IBOutlet var shareWithEmailLabel: UILabel!
    
    var qrCode: String = StringHelper.localizedStringWithKey("STORE_INFO_QR_LOCALIZE_KEY")
    var qrCodeDesc: String = StringHelper.localizedStringWithKey("STORE_INFO_SPREAD_LOCALIZE_KEY")
    var shareWith: String = StringHelper.localizedStringWithKey("STORE_INFO_SHARE_WITH_LOCALIZE_KEY")
    
    var delegate: StoreInfoQrCodeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.qrCodeLabel.text = qrCode
        self.qrCodeDescriptionLabel.text = qrCodeDesc
        self.shareWithEmailLabel.text = shareWith
        self.shareWithFbLabel.text = shareWith
        self.shareWithGoogleLabel.text = shareWith
        self.shareWithTwitterLabel.text = shareWith
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func socialShare(sender: AnyObject){
        self.delegate?.shareAction(self.qrCodeImageView, title: qrCode)
    }
    
}
