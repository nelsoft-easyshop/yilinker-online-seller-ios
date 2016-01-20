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
protocol StoreInfoBankAccountTableViewCellDelegate {
    func newBankAccount()
}

class StoreInfoBankAccountTableViewCell: UITableViewCell {

    //Buttons
    @IBOutlet weak var arrowButton: UIButton!
    
    //Labels
    @IBOutlet weak var bankAccountDetailLabel: UILabel!
    @IBOutlet weak var bankAccountInfoLabel: UILabel!
    @IBOutlet weak var bankAccountTitleLabel: UILabel!
    @IBOutlet weak var newAccountLabel: UILabel!
    
    //Views
    @IBOutlet weak var bankAccountView: UIView!
    
    //Initialized StoreInfoBankAccountTableViewCellDelegate
    var delegate: StoreInfoBankAccountTableViewCellDelegate?
    
    //Global variable declarations
    //Variables that can only be accessed in this class
    var accountTitle: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Added tap gesture recognizer in arrowButton and newAccountLabel
        var tapBankView = UITapGestureRecognizer(target: self, action: "goToBankAccount")
        arrowButton.addGestureRecognizer(tapBankView)
        newAccountLabel.addGestureRecognizer(tapBankView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Private method
    //Action method for newAccountLabel and arrowButton when tapped
    //Method to call ChangeBankAccountViewController
    func goToBankAccount(){
        self.delegate?.newBankAccount()
    }
}
