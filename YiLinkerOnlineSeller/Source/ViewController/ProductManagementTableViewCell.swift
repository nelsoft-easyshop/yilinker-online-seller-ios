//
//  ProductManagementTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductManagementTableViewCellDelegate {
    func updateSelectedItems(index: Int, selected: Bool)
}

class ProductManagementTableViewCell: UITableViewCell {

    @IBOutlet weak var checkTapView: UIView!
    @IBOutlet weak var checkContainerView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var delegate: ProductManagementTableViewCellDelegate?
    
    var index: Int = 0
    var checkedItems: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // MARK: - Methods
    
    func setProductImage(image: String) {
        productImageView.sd_setImageWithURL(NSURL(string: image), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func setupViews() {
        checkContainerView.layer.cornerRadius = 4.0
        checkTapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "checkAction:"))
    }
    
    func clearCheckImage() {
        checkImageView.hidden = true
        checkContainerView.backgroundColor = UIColor.lightGrayColor()
    }
    
    func decreaseAlpha() {
        self.titleLabel.alpha = 0.75
        self.subTitleLabel.alpha = 0.75
        self.arrowImageView.alpha = 0.50
    }
    
    func increaseAlpha() {
        self.titleLabel.alpha = 1
        self.subTitleLabel.alpha = 1
        self.arrowImageView.alpha = 1
    }
    
    func selected() {
        checkImageView.hidden = false
        if index == 4 {
            checkContainerView.backgroundColor = Constants.Colors.pmCheckGreenColor
            self.productImageView.alpha = 1
            increaseAlpha()
        } else {
            checkContainerView.backgroundColor = .redColor()
            decreaseAlpha()
        }
    }
    
    func deselected() {
        clearCheckImage()
        
        if index == 4 {
            self.productImageView.alpha = 0.75
            decreaseAlpha()
        } else {
            self.productImageView.alpha = 1
            increaseAlpha()
        }
    }
    
    func isSelected(selected: Bool) {
        if selected {
            self.selected()
        }
    }
    
    // MARK: - Actions
    
    func checkAction(gesture: UIGestureRecognizer) {

        if checkImageView.hidden {
            checkedItems++
            selected()
        } else {
            checkedItems--
            deselected()
        }
     
        if checkedItems == 0 {
            delegate?.updateSelectedItems(self.tag, selected: false)
        } else {
            delegate?.updateSelectedItems(self.tag, selected: true)
        }
    }

}


