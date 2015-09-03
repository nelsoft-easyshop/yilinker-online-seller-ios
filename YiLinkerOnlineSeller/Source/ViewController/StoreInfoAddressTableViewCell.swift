//
//  StoreInfoFooterTableViewCell.swift
//  
//
//  Created by Joriel Oller Fronda on 8/30/15.
//
//

import UIKit

protocol StoreInfoAddressTableViewCellDelagate{
    func changeToNewAddress()
}

class StoreInfoAddressTableViewCell: UITableViewCell {

    var delegate: StoreInfoAddressTableViewCellDelagate?
    
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //var tapAddressView = UITapGestureRecognizer(target: self, action: "changeMobileAddress")
        //self.addressView.addGestureRecognizer(<#gestureRecognizer: UIGestureRecognizer#>)(tapAddressView)
        var tapAddressView = UITapGestureRecognizer(target: self, action: "changeMobileAddress")
        addressView.addGestureRecognizer(tapAddressView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeMobileAddress(){
        println("tap")
        self.delegate?.changeToNewAddress()
    }
    
    
}
