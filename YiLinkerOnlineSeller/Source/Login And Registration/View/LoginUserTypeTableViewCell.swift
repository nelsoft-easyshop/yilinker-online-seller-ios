//
//  LoginUserTypeTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 2/5/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol LoginUserTypeTableViewCellDelegate {
    func loginUserTypeTableViewCell(loginUserTypeTableViewCell: LoginUserTypeTableViewCell, didSellerTap sellerButton: UIButton)
    func loginUserTypeTableViewCell(loginUserTypeTableViewCell: LoginUserTypeTableViewCell, didAffiliateTap affiliateButton: UIButton)
}

class LoginUserTypeTableViewCell: UITableViewCell {

    var delegate: LoginUserTypeTableViewCellDelegate?
    
    @IBOutlet weak var loginAsLabel: UILabel!
    @IBOutlet weak var sellerButton: UIButton!
    @IBOutlet weak var affiliateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initializeViews()
    }
    
    func initializeViews() {
        self.sellerButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.affiliateButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.sellerButton.imageEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30)
        self.affiliateButton.imageEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30)
        
        self.sellerButton.layer.cornerRadius = 5
        self.affiliateButton.layer.cornerRadius = 5
        
        self.sellerButton.layer.borderColor = Constants.Colors.grayLine.CGColor
        self.affiliateButton.layer.borderColor = Constants.Colors.grayLine.CGColor
        
        self.sellerButton.layer.borderWidth = 1
        self.affiliateButton.layer.borderWidth = 1
        
        self.sellerButton.layer.borderWidth = 1
        self.affiliateButton.layer.borderWidth = 1
        
        self.loginAsLabel.text = StringHelper.localizedStringWithKey("LOGIN_AS_LOCALIZE_KEY")
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        if sender == self.sellerButton {
            self.delegate?.loginUserTypeTableViewCell(self, didSellerTap: sender)
        } else if sender == self.affiliateButton {
            self.delegate?.loginUserTypeTableViewCell(self, didAffiliateTap: sender)
        }
    }
}
