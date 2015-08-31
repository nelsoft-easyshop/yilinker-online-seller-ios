//
//  StoreInfoBankAccountTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol StoreInfoBankAccountTableViewCellDelegate{
    func newBankAccount()
}

class StoreInfoBankAccountTableViewCell: UITableViewCell {

    var delegate: StoreInfoBankAccountTableViewCellDelegate?
   
    @IBOutlet weak var changeBankAccountButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func bankAccount(sender: AnyObject) {
        println("New Bank Account")
        self.delegate?.newBankAccount()
    }
    
}
