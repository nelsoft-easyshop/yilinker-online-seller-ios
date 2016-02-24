//
//  EditProfileAddressTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 2/17/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol EditProfileAddressTableViewCellDelegate {
    func editProfileAddressCell(editProfileAddressCell: EditProfileAddressTableViewCell, didTapChangeAddress view: UIView)
    func editProfileAddressCell(editProfileAddressCell: EditProfileAddressTableViewCell, didTapSave button: UIButton)
}

class EditProfileAddressTableViewCell: UITableViewCell {

    var delegate: EditProfileAddressTableViewCellDelegate?
    
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var changeAddressLabel: UILabel!
    
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeViews()
    }
    
    func initializeViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "changeAddressAction")
        self.addressView.addGestureRecognizer(tapGesture)
        
        //Set button to round rect
        self.saveButton.layer.cornerRadius = 5
    }
    
    func passValue(storeInfo: StoreInfoModel) {
        self.addressTitleLabel.text = storeInfo.title
        self.addressLabel.text = storeInfo.store_address
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        self.delegate?.editProfileAddressCell(self, didTapSave: sender)
    }
    
    func changeAddressAction() {
        self.delegate?.editProfileAddressCell(self, didTapChangeAddress: addressView)
    }
}
