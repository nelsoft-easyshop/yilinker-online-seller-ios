//
//  StoreInfoTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

//MARK: Struct
struct IMAGETYPE {
    static var imageType: String = ""
}

//MARK: Delegate
//Delegate methods of StoreInfoTableViewCell
protocol StoreInfoTableViewCellDelegate {
    func callUzyPicker(imageType: String)
    func storeInfoVerify(mobile: String)
    func storeInfoCopyToClipboard(link: String)
    func storeNameAndDescription(storeName: String, storeDescription: String)
    func textViewNextResponder(textView: UITextView)
    func textViewScrollUp(textView: UITextView)
}

class StoreInfoTableViewCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {

    //Buttons
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var storeLinkButton: UIButton!
    
    //Imageviews
    @IBOutlet weak var coverEditImageView: UIImageView!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var profileEditImageView: UIImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    //Labels
    @IBOutlet var tinLabel: UILabel!
    @IBOutlet weak var coverEditLabel: UILabel!
    @IBOutlet weak var mobilePhoneLabel: UILabel!
    @IBOutlet weak var profileEditLabel: UILabel!
    @IBOutlet weak var storeDescriptionLabel: UILabel!
    @IBOutlet weak var storeInfoLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeLinkTitleLabel: UILabel!
    @IBOutlet weak var storeLinkLabel: UILabel!
    
    //Textfields
    @IBOutlet var tinTextField: UITextField!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var storeNameTextField: UITextField!
    
    //Textviews
    @IBOutlet weak var storeDescriptionTextView: UITextView!
    
    //Views
    @IBOutlet weak var coverPhotoUploadView: UIView!
    @IBOutlet weak var coverPhotoView: UIView!
    @IBOutlet weak var profileCoverPhotoUploadView: UIView!
    @IBOutlet weak var profilePhotoView: UIView!
    
    //Initialized StoreInfoTableViewCellDelegate
    var delegate: StoreInfoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Set rounded edges for verifyButton
        self.verifyButton.layer.cornerRadius = 5.0
        self.verifyButton.clipsToBounds = true
        
        //Set circle for profilePhotoView
        self.profilePhotoView.layer.cornerRadius = self.profilePhotoView.frame.size.width / 2
        self.profilePhotoView.clipsToBounds = true
        
        //Set rounded edges for coverPhotoView
        self.coverPhotoView.layer.cornerRadius = 5.0
        self.coverPhotoView.clipsToBounds = true
        
        ////Set rounded edges and border color for storeDescriptionTextView
        self.storeDescriptionTextView.layer.cornerRadius = 5.0
        self.storeDescriptionTextView.layer.borderWidth = 1.0
        self.storeDescriptionTextView.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.storeDescriptionTextView.clipsToBounds = true
        
        //Disabled mobilePhoneTextField
        self.mobilePhoneTextField.enabled = false
        
        //Added tap gesture recognizer in profileCoverPhotoUploadView
        var tapProfilePhoto = UITapGestureRecognizer(target: self, action: "callUzyPicker")
        self.profileCoverPhotoUploadView.addGestureRecognizer(tapProfilePhoto)
        
        //Added tap gesture recognizer in coverPhotoUploadView
        var tapCoverPhoto = UITapGestureRecognizer(target: self, action: "callUzyPickerCover")
        self.coverPhotoUploadView.addGestureRecognizer(tapCoverPhoto)
        
        //Assigned storeNameTextField and storeDescriptionTextView delegate to itself
        self.storeNameTextField.delegate = self
        self.storeDescriptionTextView.delegate = self
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:  TextField Delegate Mehtods
    func textFieldDidBeginEditing(textField: UITextField) {
        println("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.delegate?.storeNameAndDescription(self.storeNameTextField.text, storeDescription: self.storeDescriptionTextView.text)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.textViewNextResponder(self.storeDescriptionTextView)
        return true
    }
    
    //MARK: TextView Delegate Methods
    func textViewDidBeginEditing(textField: UITextView) {
        self.delegate?.textViewScrollUp(textField)
    }
    
    func textViewDidEndEditing(textField: UITextView) {
        self.delegate?.storeNameAndDescription(self.storeNameTextField.text, storeDescription: self.storeDescriptionTextView.text)
    }
    
    //MARK: TextView Datasource Method
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let prospectiveText = (textView.text! as NSString).stringByReplacingCharactersInRange(range, withString: text)
        self.delegate?.storeNameAndDescription(self.storeNameTextField.text, storeDescription: prospectiveText)
        return textView.textInputMode != nil //&& prospectiveText.containsOnlyCharactersIn("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .'-&:!/")
    }
    
    //MARK: Action method for button
    //Method to call ChangeMobileNumberViewController
    @IBAction func callVerification(sender: AnyObject){
        self.delegate?.storeInfoVerify(self.mobilePhoneTextField.text)
    }
    
    //MARK: Action method for button
    //Method to call ChangeMobileNumberViewController
    @IBAction func copyToClipboard(sender: AnyObject){
        self.delegate?.storeInfoCopyToClipboard(self.storeLinkLabel!.text!)
    }
    
    //MARK: Private method
    //Action method for profileCoverPhotoUploadView and coverPhotoUploadView when tapped
    //Method to call ChangeBankAccountViewController
    func callUzyPicker(){
        self.delegate?.callUzyPicker("profile")
        IMAGETYPE.imageType = "profile"
    }
    
    func callUzyPickerCover(){
        self.delegate?.callUzyPicker("cover")
        IMAGETYPE.imageType = "cover"
    }
   
}
