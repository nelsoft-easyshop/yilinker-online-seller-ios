//
//  ProductUploadTextViewTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: Delegate
// ProductUploadTextViewTableViewCell delegate method
protocol ProductUploadTextViewTableViewCellDelegate {
    func productUploadTextViewTableViewCell(textFieldDidChange text: String, cell: ProductUploadTextViewTableViewCell, textFieldType: ProductTextFieldType)
}

class ProductUploadTextViewTableViewCell: UITableViewCell, UITextViewDelegate {

    // Labels
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    // Textviews
    @IBOutlet weak var productUploadTextView: UITextView!
    
    // Global variables
    var textFieldType: ProductTextFieldType?
    
    // Initialize ProductUploadTextViewTableViewCellDelegate
    var delegate: ProductUploadTextViewTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.productUploadTextView.delegate = self
        self.productUploadTextView.layer.cornerRadius = 3.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Private methods
    func addTextFieldDelegate() {
        //self.productUploadTextView.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    // Textfield action methods
    func textViewDidChange(textView: UITextView) {
        self.delegate!.productUploadTextViewTableViewCell(textFieldDidChange: textView.text, cell: self, textFieldType: self.textFieldType!)
    }
    
    // MARK: Textview delegate method
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let prospectiveText = (textView.text! as NSString).stringByReplacingCharactersInRange(range, withString: text)
        return count(prospectiveText) <= 160 && prospectiveText.containsOnlyCharactersIn("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .'-&:!/?()@%*_{}[],;")
    }
}
