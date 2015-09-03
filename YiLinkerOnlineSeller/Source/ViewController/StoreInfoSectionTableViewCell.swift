//
//  StoreInfoSectionTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol StoreInfoSectionTableViewCellDelegate {
    func generateQRCode()
}

class StoreInfoSectionTableViewCell: UITableViewCell {

    var delegate: StoreInfoSectionTableViewCellDelegate?
    
    @IBOutlet weak var generateQRCodeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func generateQRCode(){
        self.delegate?.generateQRCode()
    }
}
