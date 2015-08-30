//
//  DashBoardHeaderCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/25/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class DashBoardHeaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var totalSalesLabel: UILabel!
    @IBOutlet weak var totalTransactionsLabel: UILabel!
    @IBOutlet weak var totalProductsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
    }
    
    func initializeViews() {
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.height / 2
        profilePhotoImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profilePhotoImageView.layer.borderWidth = 4
    }
    
    func setCoverPhoto(url: String) {
        coverPhotoImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func setProfilePhoto(url: String) {
        profilePhotoImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func setStoreName(text: String) {
        storeNameLabel.text = text
    }
    
    func setAddress(text: String) {
        storeAddressLabel.text = text
    }
    
    func setTotalSales(text: String) {
        totalSalesLabel.text = text
    }
    
    func setTotalTransactions(text: String) {
        totalTransactionsLabel.text = text
    }
    
    func setTotalProducts(text: String) {
        totalProductsLabel.text = text
    }
}
