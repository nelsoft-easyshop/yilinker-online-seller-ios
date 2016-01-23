//
//  AddProductHeaderView.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: - Delegate
// AddProductHeaderView Delegate method
protocol AddProductHeaderViewDelegate {
    func addProductHeaderView(addProductHeaderView: AddProductHeaderView, didClickButtonAdd button: UIButton)
}

class AddProductHeaderView: UIView {
    
    // Buttons
    @IBOutlet weak var addButton: UIButton!
    
    // Labels
    @IBOutlet weak var productsLabel: UILabel!
   
    // Initialized AddProductHeaderViewDelegate
    var delegate: AddProductHeaderViewDelegate?
    
    override func awakeFromNib() {
        self.addButton.layer.cornerRadius = 5
    }

    // MARK: - Button action
    @IBAction func addItem(sender: AnyObject) {
        self.delegate?.addProductHeaderView(self, didClickButtonAdd: self.addButton)
    }
}
