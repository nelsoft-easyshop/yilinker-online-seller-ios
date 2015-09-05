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
        
        if status == 0 {
            statusLabel.text = "Draft"
            statusLabel.textColor = UIColor.darkGrayColor()
        } else if status == 1 {
            statusLabel.text = "Under Review"
            statusLabel.textColor = UIColor.darkGrayColor()
        } else if status == 2 {
            statusLabel.text = "Active"
            statusLabel.textColor = UIColor.greenColor()
        } else if status == 3 {
            statusLabel.text = "Inactive"
            statusLabel.textColor = UIColor.redColor()
        } else if status == 4 {
            statusLabel.text = "Deleted"
            statusLabel.textColor = UIColor.darkGrayColor()
            setDeleted()
        }
    }
    
    func setDeleted() {
        self.productImageView.alpha = 0.50
        self.titleLabel.alpha = 0.75
        self.subTitleLabel.alpha = 0.75
        self.statusLabel.alpha = 0.75
    }
    
}
