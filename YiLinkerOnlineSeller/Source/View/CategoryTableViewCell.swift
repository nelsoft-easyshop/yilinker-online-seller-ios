//
//  CategoryTableViewCell.swift
//  SearchESMobile
//
//  Created by Joriel Oller Fronda on 8/26/15.
//  Copyright (c) 2015 Joriel Oller Fronda. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet var shopItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Beats Studio Type Headphones", attributes: underlineAttribute)
        shopItemLabel.attributedText = underlineAttributedString
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
