//
//  ProductUploadAttributeValluesCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductUploadAttributeValuesCollectionViewCell: UICollectionViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    // Labels
    @IBOutlet weak var attributeDefinitionLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var attributeTextField: UITextField!
    
    // GLobal variables
    var values: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Private Methods
    func addPicker() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let index: Int = find(self.values, self.attributeTextField.text)!
        pickerView.selectRow(index, inComponent: 0, animated: false)
        self.attributeTextField.inputView = pickerView
        self.attributeTextField.addToolBarWithDoneTarget(self, done: "done")
    }
    
    func done() {
        self.attributeTextField.endEditing(true)
    }
    
    // MARK: Pickerview data source methods
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.attributeTextField.text = self.values[row]
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
