//
//  TransactionTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var statusImageVIew: UIImageView!
    @IBOutlet weak var tidLabel: UILabel!
    @IBOutlet weak var productsDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        customizedViews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func customizedViews() {
        self.imageContainer.layer.cornerRadius = self.imageContainer.frame.size.height / 2
        self.priceLabel.layer.cornerRadius = self.priceLabel.frame.size.height / 2
    }
    
    func setStatus(status: Int) {
        if status == 1 {
            self.imageContainer.backgroundColor = Constants.Colors.transactionNew
            self.statusImageVIew.image = UIImage(named: "exclamation")
        } else if status == 6 || status == 11 || status == 7  {
            self.imageContainer.backgroundColor = Constants.Colors.transactionOngoing
            self.statusImageVIew.image = UIImage(named: "onGoing")
        } else if status == 3 {
            self.imageContainer.backgroundColor = Constants.Colors.transactionCompleted
            self.statusImageVIew.image = UIImage(named: "completed3")
        } else if status == 8 {
            self.imageContainer.backgroundColor = Constants.Colors.transactionCancelled
            self.statusImageVIew.image = UIImage(named: "cancelled2")
        }
    }
    
    func setTID(text: String) {
        self.tidLabel.text = text
    }
    
    func setProductDate(text: String) {
        self.productsDateLabel.text = text
    }
    
    func setPrice(text: String) {
        self.priceLabel.text = text
    }
}
