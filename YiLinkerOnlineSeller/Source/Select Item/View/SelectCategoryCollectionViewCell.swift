//
//  SelectCategoryCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/18/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class SelectCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    //MARK: - 
    //MARK: - Nib Name And Identifier
    class func nibNameAndIdentifier() -> String {
        return "SelectCategoryCollectionViewCell"
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
