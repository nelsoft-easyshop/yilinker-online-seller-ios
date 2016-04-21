//
//  ProductUploadCombinationFooterTVC.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 4/21/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadCombinationFooterTVCDelegate {
    func productUploadSkuDimensionsAndWeightTableViewCell(textFieldDidChange textField: UITextField, text: String, cell:
        ProductUploadCombinationFooterTVC)
}

class ProductUploadCombinationFooterTVC: UITableViewCell, UITextFieldDelegate {

    // Labels
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var skuTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    // Switch
    @IBOutlet weak var availableSwitch: UISwitch!
    
    // Variables 
    var delegate: ProductUploadCombinationFooterTVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addTextFieldDelegate()
        
        // Set labels texts
        self.lengthLabel.text = ProductUploadStrings.length
        self.heightLabel.text = ProductUploadStrings.height
        self.widthLabel.text = ProductUploadStrings.width
        self.weightLabel.text = ProductUploadStrings.weight
        
        // Append asterisk (*) in label's text
        // self.lengthLabel.required()
        // self.widthLabel.required()
        // self.heightLabel.required()
        // self.weightLabel.required()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: -
    // MARK: - Local methods
    // MARK: - Add textfield delegate actions
    
    func addTextFieldDelegate() {
        self.heightTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.heightTextField.delegate = self
        self.widthTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.widthTextField.delegate = self
        self.weightTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.weightTextField.delegate = self
        self.lengthTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.lengthTextField.delegate = self
    }
    
    // MARK: -
    // MARK: - Textfield data source methods
    
    func textFieldDidChange(sender: UITextField) {
        self.delegate!.productUploadSkuDimensionsAndWeightTableViewCell(textFieldDidChange: sender, text: sender.text, cell: self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
