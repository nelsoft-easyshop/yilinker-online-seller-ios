//
//  DashBoardItemCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/25/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class DashBoardItemCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
    }
    
    func initializeViews() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
        //iconView.layer.cornerRadius = iconView.frame.height / 2
        
        iconView.layer.cornerRadius = ((screenWidth - 100) / 4) / 2
        
    }
    
    func setIconImage(image: UIImage) {
        iconImageView.image = image
    }
    
    func setText(text: String) {
        textLabel.text = text
        textLabel.sizeToFit()
    }
}
