//
//  ChangeAddressCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

//MARK: Delegate
//ChangeAddressCollectionViewCell Delegate Methods
protocol ChangeAddressCollectionViewCellDelegate {
    func changeAddressCollectionViewCell(deleteAddressWithCell cell: ChangeAddressCollectionViewCell)
    func checkAddressCollectionViewCell(checkAdressWithCell cell: ChangeAddressCollectionViewCell)
}

class ChangeAddressCollectionViewCell: UICollectionViewCell {

    //Custom Button
    @IBOutlet weak var checkBoxButton: SemiRoundedButton!
    
    //Buttons
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteBigButton: UIButton!
    
    //Labels
    @IBOutlet weak var checkBoxBigButton: UIButton!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
   
    //Initialized ChangeAddressCollectionViewCellDelegate
    var delegate: ChangeAddressCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: Action methods of buttons
    @IBAction func deleteIndexPath(sender: AnyObject) {
        self.delegate?.changeAddressCollectionViewCell(deleteAddressWithCell: self)
    }
    
    @IBAction func selectAddress(sender: AnyObject) {
        self.delegate?.checkAddressCollectionViewCell(checkAdressWithCell: self)
    }
}
