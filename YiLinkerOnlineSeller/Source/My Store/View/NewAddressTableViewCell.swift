//
//  NewAddressTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

//MARK: Delegate
//NewAddressTableViewCell Delegate Methods
protocol NewAddressTableViewCellDelegate {
    func newAddressTableViewCell(didClickNext newAddressTableViewCell: NewAddressTableViewCell)
    func newAddressTableViewCell(didClickPrevious newAddressTableViewCell: NewAddressTableViewCell)
    func newAddressTableViewCell(didBeginEditing newAddressTableViewCell: NewAddressTableViewCell, index: Int)
    func newAddressTableViewCell(didSelectRow row: Int, cell: NewAddressTableViewCell)
}

class NewAddressTableViewCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Labels
    @IBOutlet weak var rowTitleLabel: UILabel!
    
    //Textfields
    @IBOutlet weak var rowTextField: UITextField!
    
    //Global variable declarations
    var titles: [String] = []
    
    //Initialized NewAddressTableViewCellDelegate
    var delegate: NewAddressTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rowTextField.delegate = self
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: Private Methods
    func addPicker(selectedIndex: Int) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        self.rowTextField.inputView = pickerView
    }
    
    //MARK: Textfield delegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.newAddressTableViewCell(didBeginEditing: self, index: self.tag)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let prospectiveText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        return textField.textInputMode != nil && prospectiveText.containsOnlyCharactersIn("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .'-&")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.newAddressTableViewCell(didClickNext: self)
        return true
    }

    //MARK: Pickerview delegate methods
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.titles[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.newAddressTableViewCell(didSelectRow: row, cell: self)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
}
