//
//  StoreInfoPreferredCategoriesTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 10/22/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class StoreInfoPreferredCategoriesTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var checkView: DynamicRoundedView!
    @IBOutlet var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setChecked(isChecked: Bool) {
        if isChecked {
            //            if isDate {
            checkView.hidden = false
            checkImageView.hidden = false
            checkView.backgroundColor = UIColorFromRGB(0x44A491)
            checkView.borderWidth = 0
            checkImageView.image = UIImage(named: "checkBox.png")
            //            } else {
            //                checkView.hidden = false
            //                checkImageView.hidden = false
            //                checkView.backgroundColor = Constants.Colors.transactionGreen
            //                checkImageView.image = UIImage(named: "checkDateWhite")
            //            }
        } else {
            //            if isDate {
            checkView.hidden = false
            checkView.borderWidth = 1
            checkView.backgroundColor = UIColor.whiteColor()
            checkImageView.hidden = true
            //            } else {
            //                checkView.hidden = false
            //                checkImageView.hidden = true
            //                checkView.backgroundColor = Constants.Colors.transactionGrey
            //            }
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
