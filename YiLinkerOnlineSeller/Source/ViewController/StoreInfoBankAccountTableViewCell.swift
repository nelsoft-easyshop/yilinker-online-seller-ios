//
//  StoreInfoBankAccountTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

//MARK- Delegate
//StoreInfoBankAccountTableViewCell Delegate method
protocol StoreInfoBankAccountTableViewCellDelegate{
    func newBankAccount()
}

class StoreInfoBankAccountTableViewCell: UITableViewCell {

    var delegate: StoreInfoBankAccountTableViewCellDelegate?
   
    @IBOutlet weak var bankAccountTitleLabel: UILabel!
    
    @IBOutlet weak var bankAccountDetailLabel: UILabel!
    
    @IBOutlet weak var bankAccountInfoLabel: UILabel!
    @IBOutlet weak var newAccountLabel: UILabel!
    @IBOutlet weak var bankAccountView: UIView!
    @IBOutlet weak var arrowButton: UIButton!

    var accountTitle: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var tapBankView = UITapGestureRecognizer(target: self, action: "tapBankAccount")
        arrowButton.addGestureRecognizer(tapBankView)
        
        newAccountLabel.addGestureRecognizer(tapBankView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tapBankAccount(){
        self.delegate?.newBankAccount()
        println("new bank account")
    }
}
