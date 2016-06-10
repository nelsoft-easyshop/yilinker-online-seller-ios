//
//  LanguageCombinationCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/31/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class LanguageCombinationCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "LanguageCombinationCollectionViewCell"
    
    @IBOutlet weak var variantNameLabel: UILabel!
    @IBOutlet weak var variantValueTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setVariant(variantName: String, variantValue: String) {
        self.variantNameLabel.text = variantName
        self.variantValueTextField.text = variantValue
        
        self.variantNameLabel.required()
    }
}
