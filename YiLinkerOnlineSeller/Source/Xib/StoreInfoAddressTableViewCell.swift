//
//  StoreInfoFooterTableViewCell.swift
//  
//
//  Created by Joriel Oller Fronda on 8/30/15.
//
//

import UIKit

protocol StoreInfoAddressTableViewCellDelagate{
        func changeAddress()
}

class StoreInfoAddressTableViewCell: UITableViewCell {

    var delegate: StoreInfoAddressTableViewCellDelagate?
    
    @IBOutlet weak var changeAddressButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var storeAddressLabel: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeAddress(sender: AnyObject){
        self.delegate?.changeAddress()
    }
    
    
    
}
