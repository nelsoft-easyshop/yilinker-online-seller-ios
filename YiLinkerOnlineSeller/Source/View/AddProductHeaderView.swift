//
//  AddProductHeaderView.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol AddProductHeaderViewDelegate {
    func addProductHeaderView(addProductHeaderView: AddProductHeaderView, didClickButtonAdd button: UIButton)
}

class AddProductHeaderView: UIView {

    var delegate: AddProductHeaderViewDelegate?
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var productsLabel: UILabel!
   
    override func awakeFromNib() {
        self.addButton.layer.cornerRadius = 5
    }

    @IBAction func addItem(sender: AnyObject) {
        self.delegate?.addProductHeaderView(self, didClickButtonAdd: self.addButton)
    }
}
