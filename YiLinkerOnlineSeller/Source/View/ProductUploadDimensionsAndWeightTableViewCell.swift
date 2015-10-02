//
//  ProductUploadDimensionsAndWeightTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadDimensionsAndWeightTableViewCellDelegate {
    func productUploadDimensionsAndWeightTableViewCell(textFieldDidChange textField: UITextField, text: String, cell: ProductUploadDimensionsAndWeightTableViewCell)
}

class ProductUploadDimensionsAndWeightTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var messageOneLabel: UILabel!
    @IBOutlet weak var messageTwoLabel: UILabel!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
   
    @IBOutlet weak var lengthlabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    var delegate: ProductUploadDimensionsAndWeightTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTextFieldDelegate()
        
        self.lengthlabel.required()
        self.widthLabel.required()
        self.heightLabel.required()
        self.weightLabel.required()
        
        self.messageOneLabel.text = ProductUploadStrings.dimensionsAndWieghtMessageOne
        self.messageTwoLabel.text = ProductUploadStrings.dimensionsAndWieghtMessageTwo
        
        self.lengthlabel.text = ProductUploadStrings.length
        self.heightLabel.text = ProductUploadStrings.height
        self.widthLabel.text = ProductUploadStrings.width
        self.weightLabel.text = ProductUploadStrings.weight
    }
    
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
    
    func textFieldDidChange(sender: UITextField) {
        self.delegate!.productUploadDimensionsAndWeightTableViewCell(textFieldDidChange: sender, text: sender.text, cell: self)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
