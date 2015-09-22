//
//  SelectedProductTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol SelectedProductTableViewCellDelegate {
    func selectedProductTableViewCell(selectedProductTableViewCell :SelectedProductTableViewCell, didTapDeleteButton button: UIButton)
}

class SelectedProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    var delegate: SelectedProductTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func close(sender: AnyObject) {
        self.delegate?.selectedProductTableViewCell(self, didTapDeleteButton: self.closeButton)
    }
}
