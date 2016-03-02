//
//  RemovedItemTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol RemovedItemTableViewCellDelegate {
    func addSelectedItems(index: Int)
    func removeSelectedItems(index: Int)
}

class RemovedItemTableViewCell: UITableViewCell {

    var delegate: RemovedItemTableViewCellDelegate?
    
    @IBOutlet weak var checkContainerView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeVies()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    
    func customizeVies() {
        self.checkContainerView.layer.cornerRadius = 4.0
        self.checkContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "checkAction:"))
        
        checkContainerView.backgroundColor = Constants.Colors.backgroundGray
    }
    
    func setProductImage(image: String) {
        self.itemImageView.sd_setImageWithURL(NSURL(string: image), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func selected() {
//        delegate?.updateCategoryItems(self.tag)
        self.itemLabel.alpha = 0.50
        self.vendorLabel.alpha = 0.50
        checkImageView.hidden = false
        checkContainerView.backgroundColor = .redColor()
    }
    
    func deselected() {
        self.itemLabel.alpha = 1
        self.vendorLabel.alpha = 1
        checkImageView.hidden = true
        checkContainerView.backgroundColor = Constants.Colors.backgroundGray
    }
    
    func isSelected(selected: Bool) {
        if selected {
            self.selected()
        }
    }
    
    // MARK: - Actions
    
    func checkAction(gesture: UIGestureRecognizer) {
        
        if checkImageView.hidden {
            selected()
            delegate?.addSelectedItems(self.tag)
        } else {
            deselected()
            delegate?.removeSelectedItems(self.tag)
        }
    }
    
}
