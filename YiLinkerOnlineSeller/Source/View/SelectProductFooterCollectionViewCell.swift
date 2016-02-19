//
//  SelectProductFooterCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/17/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class SelectProductFooterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var noMoreItemsToLoadLabel: UILabel!
    
    class func nibNameAndIdentifier() -> String {
        return "SelectProductFooterCollectionViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
