//
//  EditSubCategoriesRemovedTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/3/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol EditSubCategoriesRemovedTableViewCellDelegate {
    func addThisItemToBeRemove(index: Int)
    func removeThisItemToBeRemove(index: Int)
}

class EditSubCategoriesRemovedTableViewCell: UITableViewCell {

    var delegate: EditSubCategoriesRemovedTableViewCellDelegate?
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var subCategoryLabel: UILabel!
    
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
        self.imageContainerView.layer.cornerRadius = 4.0
        self.imageContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "checkAction:"))
        
        imageContainerView.backgroundColor = Constants.Colors.backgroundGray
    }
    
    func selected() {
        delegate?.addThisItemToBeRemove(self.tag)
        self.subCategoryLabel.alpha = 0.50
        checkImageView.hidden = false
        imageContainerView.backgroundColor = .redColor()
    }
    
    func deselected() {
        delegate?.removeThisItemToBeRemove(self.tag)
        self.subCategoryLabel.alpha = 1
        checkImageView.hidden = true
        imageContainerView.backgroundColor = Constants.Colors.backgroundGray
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
        } else {
            deselected()
        }
    }
    
}
