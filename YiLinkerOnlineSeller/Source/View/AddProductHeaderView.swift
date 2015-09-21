//
//  AddProductHeaderView.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class AddProductHeaderView: UIView {

    @IBOutlet weak var addButton: UIButton!
   
    override func awakeFromNib() {
        self.addButton.layer.cornerRadius = 5
    }

}
