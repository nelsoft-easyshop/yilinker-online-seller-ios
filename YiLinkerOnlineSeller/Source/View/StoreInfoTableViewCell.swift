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
    func callUzyPicker(imageType: String)
}

class StoreInfoTableViewCell: UITableViewCell {

    var delegate: StoreInfoTableViewCellDelegate?
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var storeNameTextField: UITextField!
    
    @IBOutlet weak var storeDescriptionTextView: UITextView!
    
    @IBOutlet weak var verifyButton: UIButton!
    
    @IBOutlet weak var coverPhotoView: UIView!
    @IBOutlet weak var profilePhotoView: UIView!
    
    @IBOutlet weak var profileCoverPhotoUploadView: UIView!
    @IBOutlet weak var coverPhotoUploadView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.verifyButton.layer.cornerRadius = 5.0
        self.verifyButton.clipsToBounds = true
        
        self.profilePhotoView.layer.cornerRadius = self.profilePhotoView.frame.size.width / 2
        self.profilePhotoView.clipsToBounds = true
        
        self.coverPhotoView.layer.cornerRadius = 5.0
        self.coverPhotoView.clipsToBounds = true
        
        self.storeDescriptionTextView.layer.cornerRadius = 5.0
        self.storeDescriptionTextView.layer.borderWidth = 1.0
        self.storeDescriptionTextView.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.storeDescriptionTextView.clipsToBounds = true
        
        self.mobilePhoneTextField.enabled = false
        
        var tapProfilePhoto = UITapGestureRecognizer(target: self, action: "callUzyPicker")
        self.profileCoverPhotoUploadView.addGestureRecognizer(tapProfilePhoto)
        
        var tapCoverPhoto = UITapGestureRecognizer(target: self, action: "callUzyPickerCover")
        self.coverPhotoUploadView.addGestureRecognizer(tapCoverPhoto)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func callVerification(sender: AnyObject){
        self.delegate?.storeInfoVerify()
    }
    
    func callUzyPicker(){
        self.delegate?.callUzyPicker("profile")
    }
    
    func callUzyPickerCover(){
        self.delegate?.callUzyPicker("cover")
    }
   
}
