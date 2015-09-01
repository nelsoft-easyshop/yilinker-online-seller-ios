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
    func newAddress()
}

class StoreInfoAddressTableViewCell: UITableViewCell {

    var delegate: StoreInfoAddressTableViewCellDelagate?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var tapAddressView = UIGestureRecognizer(target: self, action: "changeAddress")
        self.addressView.addGestureRecognizer(tapAddressView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tapAddress(){
        self.delegate?.changeAddress()
        println("tap address")
    }
    
    
    func changeAddress(){
        self.delegate?.newAddress()
    }
    
    
}
