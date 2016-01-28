//
//  ProductManagementAllTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductManagementAllTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setProductImage(image: String) {
        productImageView.sd_setImageWithURL(NSURL(string: image), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func setStatus(status: Int) {
        
        if status == Status.draft {
            statusLabel.text = "Draft"
            statusLabel.textColor = UIColor.darkGrayColor()
            increaseAlpha()
        } else if status == Status.review {
            statusLabel.text = "Under Review"
            statusLabel.textColor = UIColor.darkGrayColor()
            increaseAlpha()
        } else if status == Status.active {
            statusLabel.text = "Active"
            statusLabel.textColor = Constants.Colors.pmCheckGreenColor
            increaseAlpha()
        } else if status == Status.deleted {
            statusLabel.text = "Deleted"
            statusLabel.textColor = UIColor.darkGrayColor()
            setDeleted()
        } else if status == Status.fullyDeleted {
            statusLabel.text = "Fully Deleted"
            statusLabel.textColor = UIColor.darkGrayColor()
            increaseAlpha()
        } else if status == Status.rejected {
            statusLabel.text = "Rejected"
            statusLabel.textColor = UIColor.redColor()
            increaseAlpha()
        } else if status == Status.inactive {
            statusLabel.text = "Inactive"
            statusLabel.textColor = UIColor.redColor()
            increaseAlpha()
        }

    }
    
    func setDeleted() {
        self.productImageView.alpha = 0.50
        self.titleLabel.alpha = 0.75
        self.subTitleLabel.alpha = 0.75
        self.statusLabel.alpha = 0.75
    }
    
    func increaseAlpha() {
        self.productImageView.alpha = 1.0
        self.titleLabel.alpha = 1.0
        self.subTitleLabel.alpha = 1.0
        self.statusLabel.alpha = 1.0
    }
    
}
