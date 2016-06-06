//
//  LanguageVariantsCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/31/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol LanguageVariantsCollectionViewCellDelegate {
    func languageVariantsCollectionViewCell(cell: LanguageVariantsCollectionViewCell, onTextChanged textField: UITextField, indexPath: NSIndexPath)
}

class LanguageVariantsCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "LanguageVariantsCollectionViewCell"
    
    var indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    var delegate: LanguageVariantsCollectionViewCellDelegate?
    
    @IBOutlet weak var inputTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setVariant(variant: String, variantPlaceholder: String) {
        self.inputTextField.placeholder = variantPlaceholder
        self.inputTextField.text = variant
    }

    @IBAction func textFieldAction(sender: UITextField) {
        self.delegate?.languageVariantsCollectionViewCell(self, onTextChanged: sender, indexPath: self.indexPath)
    }

}
