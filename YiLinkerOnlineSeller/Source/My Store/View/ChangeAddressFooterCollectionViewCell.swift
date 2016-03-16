//
//  ChangeAddressFooterCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

//MARK: Delegate
//ChangeAddressFooterCollectionViewCell Delegate Method
protocol ChangeAddressFooterCollectionViewCellDelegate {
    func changeAddressFooterCollectionViewCell(didSelecteAddAddress cell: ChangeAddressFooterCollectionViewCell)
}

class ChangeAddressFooterCollectionViewCell: UICollectionViewCell {

    //Custom Button
    @IBOutlet weak var newAddressButton: DynamicRoundedButton!
    
    //Initialized ChangeAddressFooterCollectionViewCellDelegate
    var delegate: ChangeAddressFooterCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: Action method of button
    @IBAction func newAddress(sender: AnyObject) {
        self.delegate?.changeAddressFooterCollectionViewCell(didSelecteAddAddress: self)
    }
}
