//
//  ProductUploadConditionTextFieldTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Yhel on 6/28/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadConditionTextFieldTableViewCellDelegate {
    func productUploadConditionTextFieldTableViewCell(textFieldDidChange text: String, cell: ProductUploadConditionTextFieldTableViewCell)
}

class ProductUploadConditionTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Labels
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var cellTexField: UITextField!
    
    var values: [String] = []
    
    // Initialize ProductUploadTextFieldTableViewCellDelegate
    var delegate: ProductUploadConditionTextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTextFieldDelegate()
        self.cellTexField.delegate = self
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.cellTexField.inputView = pickerView
        self.cellTexField.text = self.values[0]
        self.cellTexField.addToolBarWithDoneTarget(self, done: "done")
    }
    
    // MARK: -
    // MARK: -Textfield's action methods
    
    func done() {
        self.cellTexField.endEditing(true)
        self.delegate!.productUploadConditionTextFieldTableViewCell(textFieldDidChange: self.cellTexField.text, cell: self)
    }
    
    func textFieldDidChange(sender: UITextField) {
        self.delegate!.productUploadConditionTextFieldTableViewCell(textFieldDidChange: sender.text, cell: self)
    }
    
    // MARK: -
    // MARK: - Textfield delegate methods
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
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