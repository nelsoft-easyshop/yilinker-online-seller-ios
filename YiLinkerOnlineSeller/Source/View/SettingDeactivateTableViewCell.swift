//
//  SettingDeactivateTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol SettingDeactivateTableViewCellDelegate{
    func deactivateTapped(sender: AnyObject)
}

class SettingDeactivateTableViewCell: UITableViewCell {
    
    var delegate: SettingDeactivateTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initializeTapGesture()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeTapGesture() {
        let tapRec = UITapGestureRecognizer()
        tapRec.addTarget(self, action: "tappedView")
        
        self.addGestureRecognizer(tapRec)
    }
    
    func tappedView(){
       delegate?.deactivateTapped(self)
    }

}
