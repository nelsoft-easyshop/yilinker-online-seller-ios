//
//  ProductManagementTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductManagementTableViewCell: UITableViewCell {

    @IBOutlet weak var checkContainerView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        costumizeVies()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // MARK: - Methods
    
    func costumizeVies() {
        checkContainerView.layer.cornerRadius = 4.0
        checkContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "checkAction:"))
    }
    
    func clearCheckImage() {
        checkImageView.hidden = true
        checkContainerView.backgroundColor = UIColor.lightGrayColor()
    }
    // MARK: - Actions
    
    func checkAction(gesture: UIGestureRecognizer) {
        if checkImageView.hidden {
            checkImageView.hidden = false
            if index == 4 {
                checkContainerView.backgroundColor = .redColor()//Constants.Colors.pmCheckRedColor
            } else {
                checkContainerView.backgroundColor = Constants.Colors.pmCheckGreenColor
            }
        } else {
            clearCheckImage()
        }
    }
}


