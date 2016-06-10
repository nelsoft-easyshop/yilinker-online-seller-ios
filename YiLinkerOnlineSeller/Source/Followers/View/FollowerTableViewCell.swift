//
//  FollowerTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol FollowerTableViewCellDelegate {
    func messageButtonAction(sender: AnyObject)
}

class FollowerTableViewCell: UITableViewCell {
    
    var delegate: FollowerTableViewCellDelegate?

    @IBOutlet weak var followerImageView: UIImageView!
    @IBOutlet weak var followerNameLabel: UILabel!
    @IBOutlet weak var followerEmailLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
    }

    @IBAction func messageAction(sender: AnyObject) {
        delegate?.messageButtonAction(self)
    }
    
    func initializeViews() {
        followerImageView.layer.cornerRadius = followerImageView.frame.height / 2
        
        if SessionManager.isReseller(){
            messageButton.hidden = true
            messageButton.userInteractionEnabled = false
        }
    }
    
    func setFollowerImage(url: NSURL) {
        followerImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func setFollowerName(text: String) {
        followerNameLabel.text = text
    }
    
    func setFollowerEmail(text: String) {
        followerEmailLabel.text = text
    }

}
