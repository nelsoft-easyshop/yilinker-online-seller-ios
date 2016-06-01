//
//  ProductUploadTextFieldTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct ProductUploadTextFieldTableViewCellConstant {
    static let productUploadTextFieldTableViewCellNibAndIdentifier = "ProductUploadTextFieldTableViewCell"
}

// MARK: Delegate
// ProductUploadTextFieldTableViewCell Delegate method
protocol ProductUploadTextFieldTableViewCellDelegate {
    func productUploadTextFieldTableViewCell(textFieldDidChange text: String, cell: ProductUploadTextFieldTableViewCell, textFieldType: ProductTextFieldType)
}

class ProductUploadTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // Labels
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var cellTexField: UITextField!
    
    // Global variables
    var textFieldType: ProductTextFieldType?
    var values: [String] = []
    
    // Initialize ProductUploadTextFieldTableViewCellDelegate
    var delegate: ProductUploadTextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTextFieldDelegate()
        self.cellTexField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.cellTexField.delegate = self
    }
    
    // MARK: -
    // MARK: - Private methods
    // MARK: - Add textfield action
    
    func addTextFieldDelegate() {
        self.cellTexField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    // MARK: -
    // MARK: - Add arrow in textfield
    
    func addArrow() {
        self.cellTexField.enabled = false
        self.cellTexField.rightViewMode = UITextFieldViewMode.Always
    }
    
    // MARK: -
    // MARK: - Add Picker view - Show picker view when textfield is on focus
    
    func addPicker() {
        if self.textFieldType == ProductTextFieldType.Condition {
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            
            let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
            pickerView.delegate = self
            pickerView.dataSource = self
            
            self.cellTexField.inputView = pickerView
            self.cellTexField.text = self.values[0]
            self.cellTexField.addToolBarWithDoneTarget(self, done: "done")
        }
    }
    
    // MARK: -
    // MARK: -Textfield's action methods
    
    func done() {
        self.cellTexField.endEditing(true)
        self.delegate!.productUploadTextFieldTableViewCell(textFieldDidChange: self.cellTexField.text, cell: self, textFieldType: self.textFieldType!)
    }
    
    func textFieldDidChange(sender: UITextField) {
        self.delegate!.productUploadTextFieldTableViewCell(textFieldDidChange: sender.text, cell: self, textFieldType: self.textFieldType!)
    }
    
    // MARK: -
    // MARK: - Textfield delegate methods
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if self.textFieldType == ProductTextFieldType.Brand || self.textFieldType == ProductTextFieldType.Category || self.textFieldType == ProductTextFieldType.ShippingCategory {
            self.delegate!.productUploadTextFieldTableViewCell(textFieldDidChange: "", cell: self, textFieldType: self.textFieldType!)
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.cellTexField.endEditing(true)
        return true
    }
    
    // MARK: -
    // MARK: - Picker view delegate methods
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.cellTexField.text = self.values[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.values[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
}
