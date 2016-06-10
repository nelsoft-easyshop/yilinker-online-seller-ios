//
//  ProductUploadButtonTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct ProductUploadButtonTableViewCellConstant {
    static let productUploadButtonTableViewCellNibAndIdentifier = "ProductUploadButtonTableViewCell"
}

class ProductUploadButtonTableViewCell: UITableViewCell {

    // Custom Buttons
    @IBOutlet weak var cellButton: DynamicRoundedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellButton.setTitle(ProductUploadStrings.addMore, forState: UIControlState.Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
