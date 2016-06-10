//
//  ProductUploadDimensionsAndWeightTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// Constant
struct ProductUploadDimensionsAndWeightTableViewCellConstant {
    static let productUploadDimensionsAndWeightTableViewCellNibAndIdentifier = "ProductUploadDimensionsAndWeightTableViewCell"
}

// MARK: Delegate
// ProductUploadDimensionsAndWeightTableViewCell Delegate methods
protocol ProductUploadDimensionsAndWeightTableViewCellDelegate {
    func productUploadDimensionsAndWeightTableViewCell(textFieldDidChange textField: UITextField, text: String, cell: ProductUploadDimensionsAndWeightTableViewCell)
}

class ProductUploadDimensionsAndWeightTableViewCell: UITableViewCell, UITextFieldDelegate {

    // Labels
    @IBOutlet weak var messageOneLabel: UILabel!
    @IBOutlet weak var messageTwoLabel: UILabel!
    @IBOutlet weak var lengthlabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
   
    // Initialize ProductUploadDimensionsAndWeightTableViewCellDelegate
    var delegate: ProductUploadDimensionsAndWeightTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTextFieldDelegate()
        
        // Set label's texts
        self.messageOneLabel.text = ProductUploadStrings.dimensionsAndWieghtMessageOne
        self.messageTwoLabel.text = ProductUploadStrings.dimensionsAndWieghtMessageTwo
        self.lengthlabel.text = ProductUploadStrings.length
        self.heightLabel.text = ProductUploadStrings.height
        self.widthLabel.text = ProductUploadStrings.width
        self.weightLabel.text = ProductUploadStrings.weight
        
        // Append asterisk (*) in label's text
        self.lengthlabel.required()
        self.widthLabel.required()
        self.heightLabel.required()
        self.weightLabel.required()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: -
    // MARK: - Private methods
    // Add textfield delegate actions
  
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
        self.delegate!.productUploadDimensionsAndWeightTableViewCell(textFieldDidChange: sender, text: sender.text, cell: self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
