//
//  StoreInfoQrCodeTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 10/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

//MARK: Delegate
//Delegate methods of StoreInfoQrCodeTableViewCell
protocol StoreInfoQrCodeTableViewCellDelegate {
    func shareFBAction(postImage: UIImageView, title: String)
    func shareTWAction(postImage: UIImageView, title: String)
    func shareEMAction(postImage: UIImageView, title: String)
    func shareGPAction(postImage: UIImageView, title: String)
}

class StoreInfoQrCodeTableViewCell: UITableViewCell {

    //Buttons
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var googlePlusButton: UIButton!
    @IBOutlet var twitterButton: UIButton!
    
    //Imageviews
    @IBOutlet var qrCodeImageView: UIImageView!
    
    //Labels
    @IBOutlet var qrCodeDescriptionLabel: UILabel!
    @IBOutlet var qrCodeLabel: UILabel!
    @IBOutlet var shareWithEmailLabel: UILabel!
    @IBOutlet var shareWithFbLabel: UILabel!
    @IBOutlet var shareWithGoogleLabel: UILabel!
    @IBOutlet var shareWithTwitterLabel: UILabel!
    
    //Global variables declarations
    //Variables that can only be accessed withis the class
    var qrCodeDesc: String = StringHelper.localizedStringWithKey("STORE_INFO_SPREAD_LOCALIZE_KEY")
    var qrCode: String = StringHelper.localizedStringWithKey("STORE_INFO_QR_LOCALIZE_KEY")
    var shareWith: String = StringHelper.localizedStringWithKey("STORE_INFO_SHARE_WITH_LOCALIZE_KEY")
    
    //Initialized StoreInfoQrCodeTableViewCellDelegate
    var delegate: StoreInfoQrCodeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Set text in labels
        self.qrCodeLabel.text = qrCode
        self.qrCodeDescriptionLabel.text = qrCodeDesc
        self.shareWithEmailLabel.text = shareWith
        self.shareWithFbLabel.text = shareWith
        self.shareWithGoogleLabel.text = shareWith
        self.shareWithTwitterLabel.text = shareWith
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Action methods for buttons
    @IBAction func socialEMShare(sender: AnyObject){
        self.delegate?.shareEMAction(self.qrCodeImageView, title: qrCode)
    }
    
    @IBAction func socialFBShare(sender: AnyObject){
        self.delegate?.shareFBAction(self.qrCodeImageView, title: qrCode)
    }
    
    @IBAction func socialGPShare(sender: AnyObject){
        self.delegate?.shareGPAction(self.qrCodeImageView, title: qrCode)
    }
    
    @IBAction func socialTWShare(sender: AnyObject){
        self.delegate?.shareTWAction(self.qrCodeImageView, title: qrCode)
    }
    
}
