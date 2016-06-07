//
//  TranslationShortDescriptionTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/26/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol TranslationInputTableViewCellDelegate {
    func translationInputTableViewCell(cell: TranslationInputTableViewCell, onTextChanged textView: UITextView, section: Int)
}

class TranslationInputTableViewCell: UITableViewCell {
    
    var delegate: TranslationInputTableViewCellDelegate?
    
    static let reuseIdetifier: String = "TranslationInputTableViewCell"
    
    var section = 0

    @IBOutlet weak var defaultLanguageLabel: UILabel!
    @IBOutlet weak var defaultLanguageTextView: UITextView!
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var translationTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeViews()
    }
    
    func initializeViews() {
        self.defaultLanguageLabel.text = StringHelper.localizedStringWithKey("TRANSLATION_DEFAULT_LANGUAGE")
        
        
        self.defaultLanguageTextView.delegate = self
        self.translationTextView.delegate = self
        
        self.defaultLanguageTextView.layer.cornerRadius = 5
        self.defaultLanguageTextView.layer.borderWidth = 1
        self.defaultLanguageTextView.layer.borderColor = Constants.Colors.borderColor.CGColor
        
        self.translationTextView.layer.cornerRadius = 5
        self.translationTextView.layer.borderWidth = 1
        self.translationTextView.layer.borderColor = Constants.Colors.borderColor.CGColor
    }
    
    func setLanguage(language: String) {
        let temp = StringHelper.localizedStringWithKey("TRANSLATION_YOUR_TRANSLATION")
        self.translationLabel.text = "\(temp) (\(language))"
        self.translationLabel.required()
    }
    
    func setDefaultLanguageValues(string: String) {
        self.defaultLanguageTextView.text = string
    }
    
    func setTranslationValues(string: String) {
        self.translationTextView.text = string
    }
}

extension TranslationInputTableViewCell: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        self.delegate?.translationInputTableViewCell(self, onTextChanged: textView, section: self.section)
    }
}
