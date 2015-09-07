//
//  ResellerItemTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/7/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ResellerItemTableViewCell: UITableViewCell {

    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var cellSellerLabel: UILabel!
    @IBOutlet weak var cellTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addImage() {
        self.statusImageView.image = UIImage(named: "addItem")
    }
    
    func checkImage() {
        self.statusImageView.image = UIImage(named: "checkCategory")
    }
    
}
