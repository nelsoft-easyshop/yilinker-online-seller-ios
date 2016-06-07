//
//  LanguageVariantsHeaderCollectionReusableView.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/31/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol LanguageVariantsHeaderCollectionReusableViewDelegate {
    func languageVariantsHeaderCollectionReusableView(cell: LanguageVariantsHeaderCollectionReusableView, onTextChanged textField: UITextField, indexPath: NSIndexPath)
}

class LanguageVariantsHeaderCollectionReusableView: UICollectionReusableView {

    static let reuseIdentifier = "LanguageVariantsHeaderCollectionReusableView"
    
    var indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    var delegate: LanguageVariantsHeaderCollectionReusableViewDelegate?
    
    @IBOutlet weak var variantTitleLabel: UILabel!
    @IBOutlet weak var variantNameLabel: UILabel!
    @IBOutlet weak var variantValuesLabel: UILabel!
    @IBOutlet weak var variantNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeViews()
    }
    
    func initializeViews() {
        self.variantNameLabel.text = StringHelper.localizedStringWithKey("TRANSLATION_VARIANT_NAME")
        self.variantValuesLabel.text = StringHelper.localizedStringWithKey("TRANSLATION_VARIANT_VALUES")
        
        self.variantNameLabel.required()
        self.variantValuesLabel.required()
    }
    
    func setVariant(variantNumber: Int, variantName: String, variantNamePlaceholder: String) {
        let temp = StringHelper.localizedStringWithKey("TRANSLATION_VARIANT")
        self.variantTitleLabel.text = "\(temp) \(variantNumber + 1)"
        self.variantNameTextField.text = variantName
        self.variantNameTextField.placeholder = variantNamePlaceholder
    }
    
    @IBAction func textFieldAction(sender: UITextField) {
        self.delegate?.languageVariantsHeaderCollectionReusableView(self, onTextChanged: sender, indexPath: self.indexPath)
    }
}
