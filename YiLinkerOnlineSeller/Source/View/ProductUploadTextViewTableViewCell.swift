//
//  ProductUploadTextViewTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadTextViewTableViewCellDelegate {
    func productUploadTextViewTableViewCell(textFieldDidChange text: String, cell: ProductUploadTextViewTableViewCell, textFieldType: ProductTextFieldType)
}

class ProductUploadTextViewTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var productUploadTextView: UITextView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    var delegate: ProductUploadTextViewTableViewCellDelegate?
    var textFieldType: ProductTextFieldType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.productUploadTextView.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addTextFieldDelegate() {
        //self.productUploadTextView.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)

    }
    
    func textViewDidChange(textView: UITextView) {
        self.delegate!.productUploadTextViewTableViewCell(textFieldDidChange: textView.text, cell: self, textFieldType: self.textFieldType!)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let prospectiveText = (textView.text! as NSString).stringByReplacingCharactersInRange(range, withString: text)
        return count(prospectiveText) <= 160 && prospectiveText.containsOnlyCharactersIn("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .'-&:!/?()@%*_{}[],")
    }
}
