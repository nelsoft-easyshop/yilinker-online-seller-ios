//
//  TranslationImageCollectionViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 6/2/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol TranslationImageCollectionViewCellDelegate {
    func translationImageCollectionViewCell(cell: TranslationImageCollectionViewCell, didTapAtIndexPath indexPath: NSIndexPath)
}

class TranslationImageCollectionViewCell: UICollectionViewCell {

    static var reuseIdentifier = "TranslationImageCollectionViewCell"
    
    var delegate: TranslationImageCollectionViewCellDelegate?
    var indexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeViews()
    }
    
    func initializeViews() {
        self.checkButton.layer.cornerRadius = self.checkButton.frame.width / 2
    }

    @IBAction func buttonAction(sender: UIButton) {
        self.delegate?.translationImageCollectionViewCell(self, didTapAtIndexPath: self.indexPath)
    }
    
    func setCellImage(image: String) {
        self.cellImageView.sd_setImageWithURL(NSURL(string: image), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func setIsPrimary(isPrimary: Bool) {
        
        if isPrimary {
            self.starButton.setImage(UIImage(named: "ic_selected_as_primary"), forState: .Normal)
        } else {
            self.starButton.setImage(UIImage(named: "ic_unselected_as_primary"), forState: .Normal)
        }
    }
    
    func setIsSelected(selected: Bool) {
        self.checkButton.hidden = !selected
    }
}
