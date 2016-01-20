//
//  StoreInfoFooterTableViewCell.swift
//  
//
//  Created by Joriel Oller Fronda on 8/30/15.
//
//

import UIKit

//MARK: Delegate
//StoreInfoAddressTableViewCell Delegate method
protocol StoreInfoAddressTableViewCellDelagate{
    func changeToNewAddress()
}

class StoreInfoAddressTableViewCell: UITableViewCell {

    var delegate: StoreInfoAddressTableViewCellDelagate?
    
    //Labels
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var newAddressLabel: UILabel!
    @IBOutlet weak var storeAddressTitleLabel: UILabel!
    
    //Views
    @IBOutlet weak var addressView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Add tap gesture recoginizer in addressView
        var tapAddressView = UITapGestureRecognizer(target: self, action: "changeMobileAddress")
        addressView.addGestureRecognizer(tapAddressView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: Provate method
    //Action method for addressView when tapped
    //Method to call ChangeAddressViewController
    func changeMobileAddress(){
        self.delegate?.changeToNewAddress()
    }
}
