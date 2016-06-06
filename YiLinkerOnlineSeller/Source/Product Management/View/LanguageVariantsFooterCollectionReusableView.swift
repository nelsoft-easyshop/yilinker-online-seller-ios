//
//  LanguageVariantsFooterCollectionReusableView.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/31/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol LanguageVariantsFooterCollectionReusableViewDelegate {
    func languageVariantsFooterCollectionReusableView(cell: LanguageVariantsFooterCollectionReusableView, onSaveButtonTap button: UIButton)
    func languageVariantsFooterCollectionReusableView(cell: LanguageVariantsFooterCollectionReusableView, onCombinarionButtonTap button: UIButton)
}

class LanguageVariantsFooterCollectionReusableView: UICollectionReusableView {

    static let reuseIdentifier = "LanguageVariantsFooterCollectionReusableView"
    
    var delegate: LanguageVariantsFooterCollectionReusableViewDelegate?
    
    @IBOutlet weak var combinationButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeViews()
    }
    
    func initializeViews() {
        self.combinationButton.layer.cornerRadius = 5
        self.saveButton.layer.cornerRadius = 5
        
        self.combinationButton.setTitle(StringHelper.localizedStringWithKey("TRANSLATION_VARIANT_VIEW_COMBINATION"), forState: .Normal)
        self.saveButton.setTitle(StringHelper.localizedStringWithKey("TRANSLATION_VARIANT_SAVE_TRANSLATION"), forState: .Normal)
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        if sender == self.combinationButton {
            delegate?.languageVariantsFooterCollectionReusableView(self, onCombinarionButtonTap: sender)
        } else {
            delegate?.languageVariantsFooterCollectionReusableView(self, onSaveButtonTap: sender)
        }
    }
}
