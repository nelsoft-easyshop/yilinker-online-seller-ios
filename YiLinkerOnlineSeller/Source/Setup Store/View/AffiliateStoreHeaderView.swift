//
//  AffiliateStoreHeaderView.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class AffiliateStoreHeaderView: UIView {

    @IBOutlet weak var coverPhotoContainerView: UIView!
    @IBOutlet weak var profilePhotoContainerView: UIView!
    
    //MARK: - 
    //MARK: - Nib Name
    class func nibName() -> String {
        return "AffiliateStoreHeaderView"
    }
    
    //MARK: - 
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addCoverPhoto()
        self.addProfilePhoto()
    }
    
    //MARK: - 
    //MARK: - Add Cover Photo
    private func addCoverPhoto() {
        let coverPhotoCustomUploadView: CustomUploadView = XibHelper.puffViewWithNibName(CustomUploadView.nibName(), index: 0) as! CustomUploadView
        coverPhotoContainerView.layoutIfNeeded()
        coverPhotoCustomUploadView.frame = coverPhotoContainerView.frame
        self.coverPhotoContainerView.addSubview(coverPhotoCustomUploadView)
    }
    
    //MARK: -
    //MARK: - Add Cover Photo
    private func addProfilePhoto() {
        let profilePhotoCustomView: CustomUploadView = XibHelper.puffViewWithNibName(CustomUploadView.nibName(), index: 0) as! CustomUploadView
        profilePhotoContainerView.layoutIfNeeded()
        profilePhotoCustomView.frame = CGRectMake(0, 0, profilePhotoContainerView.frame.size.width, profilePhotoContainerView.frame.size.height)
        self.profilePhotoContainerView.addSubview(profilePhotoCustomView)
        
        self.profilePhotoContainerView.layer.borderColor = UIColor.whiteColor().CGColor
        self.profilePhotoContainerView.layer.borderWidth = 2
    }
    
}
