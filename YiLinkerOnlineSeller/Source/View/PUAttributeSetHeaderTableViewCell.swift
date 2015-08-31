//
//  PUAttributeSetHeaderTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol PUAttributeSetHeaderTableViewCellDelegate {
    func pUAttributeSetHeaderTableViewCell(didClickEdit cell: PUAttributeSetHeaderTableViewCell)
    func pUAttributeSetHeaderTableViewCell(didClickDelete cell: PUAttributeSetHeaderTableViewCell)
}

class PUAttributeSetHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var attributeDefinitionLabel: UILabel!
    var delegate: PUAttributeSetHeaderTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func edit(sender: AnyObject) {
        self.delegate!.pUAttributeSetHeaderTableViewCell(didClickEdit: self)
    }
    
    @IBAction func deleteCell(sender: AnyObject) {
        self.delegate!.pUAttributeSetHeaderTableViewCell(didClickDelete: self)
    }
}
