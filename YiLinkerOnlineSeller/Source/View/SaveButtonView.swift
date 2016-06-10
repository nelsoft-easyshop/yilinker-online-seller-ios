//
//  SaveButtonView.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol SaveButtonViewDelegate {
    func saveButtonView(didClickButtonWithView view: SaveButtonView)
}

class SaveButtonView: UIView {
    
    @IBOutlet weak var saveButton: UIButton!
    var delegate: SaveButtonViewDelegate?
    
    override func awakeFromNib() {
        self.saveButton.layer.cornerRadius = 5
    }
    
    @IBAction func save(sender: AnyObject) {
        self.delegate!.saveButtonView(didClickButtonWithView: self)
    }
}
