//
//  ProductManagementMenuTableViewCell.swift
//  
//
//  Created by John Paul Chan on 13/04/2016.
//
//

import UIKit

class ProductManagementMenuTableViewCell: UITableViewCell {
    
    static let reuseIdentidifier: String = "ProductManagementMenuTableViewCell"
    
    @IBOutlet weak var cellTextLabel: UILabel!
    @IBOutlet weak var typeTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.typeTextLabel.text = ""
    }

    func setCellText(text: String) {
        self.cellTextLabel.text = text
    }
    
    func setCellTypeTextLabel(text: String) {
        self.typeTextLabel.text = text
    }
    
}
