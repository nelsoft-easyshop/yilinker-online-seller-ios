//
//  StoreInfoSectionTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

//MARK: Delegate
//StoreInfoSectionTableViewCell Delegate method
protocol StoreInfoSectionTableViewCellDelegate {
    func generateQRCode()
}

class StoreInfoSectionTableViewCell: UITableViewCell {
    
    //Buttons
    @IBOutlet weak var generateQRCodeButton: UIButton!
    
    //Labels
    @IBOutlet weak var generateLabel: UILabel!
    @IBOutlet weak var qrCodeLabel: UILabel!
    
    //Initialized StoreInfoSectionTableViewCellDelegate
    var delegate: StoreInfoSectionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Action methods of buttons
    //Method to generate qr code
    @IBAction func generateQRCode(){
        self.delegate?.generateQRCode()
    }
}
