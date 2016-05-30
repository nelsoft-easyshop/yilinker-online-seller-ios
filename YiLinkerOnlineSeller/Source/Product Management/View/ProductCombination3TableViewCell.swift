//
//  ProductCombination3TableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 4/21/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol ProductCombination3TableViewCellDelegate {
    func getSwitchValue(view: ProductCombination3TableViewCell, section: Int, value: Int)
}

class ProductCombination3TableViewCell: UITableViewCell {

    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var availableSwitch: UISwitch!
    
    var delegate: ProductCombination3TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func availableAction(sender: UISwitch) {
        
        if sender.on {
            delegate?.getSwitchValue(self, section: self.tag, value: 1)
        } else {
            delegate?.getSwitchValue(self, section: self.tag, value: 0)
        }
        
    }

    
    
}