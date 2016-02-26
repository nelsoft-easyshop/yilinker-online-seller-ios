//
//  AffiliateStoreHeaderTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol AffiliateStoreHeaderTableViewCellDelegate {
    func affiliateStoreHeaderTableViewCell(affiliateStoreHeaderTableViewCell: AffiliateStoreHeaderTableViewCell, didTapView customView: UIView)
}

class AffiliateStoreHeaderTableViewCell: UITableViewCell, CustomUploadViewDelegate {

    @IBOutlet weak var coverPhotoContainerView: UIView!
    @IBOutlet weak var profilePhotoContainerView: UIView!
    
    var coverPhotoCustomUploadView: CustomUploadView = CustomUploadView()
    var profilePhotoCustomView: CustomUploadView = CustomUploadView()
    
    var delegate: AffiliateStoreHeaderTableViewCellDelegate?
    
    //MARK: -
    //MARK: - Nib Name
    class func nibNameAndIdentifier() -> String {
        return "AffiliateStoreHeaderTableViewCell"
    }
    
    //MARK: -
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.addCoverPhoto()
        self.addProfilePhoto()
    }
    
    //MARK: -
    //MARK: - Add Cover Photo
    private func addCoverPhoto() {
        self.coverPhotoCustomUploadView = XibHelper.puffViewWithNibName(CustomUploadView.nibName(), index: 0) as! CustomUploadView
        self.coverPhotoCustomUploadView.tag = 1
        coverPhotoContainerView.layoutIfNeeded()
        self.coverPhotoCustomUploadView.delegate = self
        self.coverPhotoCustomUploadView.frame = coverPhotoContainerView.frame
        self.coverPhotoContainerView.addSubview(self.coverPhotoCustomUploadView)
    }
    
    //MARK: -
    //MARK: - Add Cover Photo
    private func addProfilePhoto() {
        self.profilePhotoCustomView = XibHelper.puffViewWithNibName(CustomUploadView.nibName(), index: 0) as! CustomUploadView
        profilePhotoContainerView.layoutIfNeeded()
        
        self.profilePhotoCustomView.tag = 2
        self.profilePhotoCustomView.delegate = self
        self.profilePhotoCustomView.frame = CGRectMake(0, 0, profilePhotoContainerView.frame.size.width, profilePhotoContainerView.frame.size.height)
        self.profilePhotoContainerView.addSubview(self.profilePhotoCustomView)
        
        self.profilePhotoCustomView.layer.borderColor = UIColor.whiteColor().CGColor
        self.profilePhotoCustomView.layer.borderWidth = 2
    }
    
    //MARK: - 
    //MARK: - Custom Upload View Delegate
    func customUploadViewDidTap(customUploadView: CustomUploadView) {
        if customUploadView.tag == 1 {
            self.delegate?.affiliateStoreHeaderTableViewCell(self, didTapView: self.coverPhotoCustomUploadView)
        } else {
            self.delegate?.affiliateStoreHeaderTableViewCell(self, didTapView: self.profilePhotoCustomView)
        }
    }
}
