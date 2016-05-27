//
//  TranslationProductGroupTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 5/27/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol TranslationProductGroupTableViewCellDelegate  {
    func translationProductGroupTableViewCell(cell: TranslationProductGroupTableViewCell, onTextChanged textView: UITextView)
}

class TranslationProductGroupTableViewCell: UITableViewCell {

    var delegate: TranslationProductGroupTableViewCellDelegate?
    
    static let reuseIdentifier = "TranslationProductGroupTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TranslationProductGroupTableViewCell: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        self.delegate?.translationProductGroupTableViewCell(self, onTextChanged: textView)
    }
}
