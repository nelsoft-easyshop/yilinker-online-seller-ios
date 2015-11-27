//
//  StoreInfoTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct IMAGETYPE {
    static var imageType: String = ""
}
protocol StoreInfoTableViewCellDelegate {
    func storeInfoVerify(mobile: String)
    func storeNameAndDescription(storeName: String, storeDescription: String)
    func callUzyPicker(imageType: String)
    func textViewNextResponder(textView: UITextView)
}

class StoreInfoTableViewCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {

    var delegate: StoreInfoTableViewCellDelegate?
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet var tinTextField: UITextField!
    
    @IBOutlet weak var storeDescriptionTextView: UITextView!
    
    @IBOutlet weak var verifyButton: UIButton!
    
    @IBOutlet weak var coverPhotoView: UIView!
    @IBOutlet weak var profilePhotoView: UIView!
    
    @IBOutlet weak var profileCoverPhotoUploadView: UIView!
    @IBOutlet weak var coverPhotoUploadView: UIView!
    @IBOutlet weak var profileEditImageView: UIImageView!
    @IBOutlet weak var coverEditImageView: UIImageView!
    @IBOutlet weak var profileEditLabel: UILabel!
    @IBOutlet var tinLabel: UILabel!
    @IBOutlet weak var coverEditLabel: UILabel!
    @IBOutlet weak var storeInfoLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeDescriptionLabel: UILabel!
    @IBOutlet weak var mobilePhoneLabel: UILabel!
    
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
        self.storeNameTextField.delegate = self
        self.storeDescriptionTextView.delegate = self
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        println("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.delegate?.storeNameAndDescription(self.storeNameTextField.text, storeDescription: self.storeDescriptionTextView.text)
        println("TextField did end editing method called \(self.storeNameTextField.text)")
    }
    
    // UITextField Delegates
    func textViewDidBeginEditing(textField: UITextView) {
        println("TextField did begin editing method called")
    }
    
    func textViewDidEndEditing(textField: UITextView) {
        self.delegate?.storeNameAndDescription(self.storeNameTextField.text, storeDescription: self.storeDescriptionTextView.text)
       
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.textViewNextResponder(self.storeDescriptionTextView)
        return true
    }
    
    @IBAction func callVerification(sender: AnyObject){
        self.delegate?.storeInfoVerify(self.mobilePhoneTextField.text)
    }
    
    func callUzyPicker(){
        self.delegate?.callUzyPicker("profile")
        IMAGETYPE.imageType = "profile"
    }
    
    func callUzyPickerCover(){
        self.delegate?.callUzyPicker("cover")
        IMAGETYPE.imageType = "cover"
    }
   
}
