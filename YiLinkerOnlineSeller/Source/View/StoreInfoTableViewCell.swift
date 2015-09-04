//
//  StoreInfoTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol StoreInfoTableViewCellDelegate {
    func storeInfoVerify()
}

class StoreInfoTableViewCell: UITableViewCell {

    var delegate: StoreInfoTableViewCellDelegate?
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var storeNameTextField: UITextField!
    
    @IBOutlet weak var verifyButton: UIButton!
    
    @IBOutlet weak var coverPhotoView: UIView!
    @IBOutlet weak var profilePhotoView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.verifyButton.layer.cornerRadius = 5.0
        self.verifyButton.clipsToBounds = true
        
        self.profilePhotoView.layer.cornerRadius = self.profilePhotoView.frame.size.width / 2
        self.profilePhotoView.clipsToBounds = true
        
        self.coverPhotoView.layer.cornerRadius = 5.0
        self.coverPhotoView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func callVerification(sender: AnyObject){
        self.delegate?.storeInfoVerify()
    }
    
}
