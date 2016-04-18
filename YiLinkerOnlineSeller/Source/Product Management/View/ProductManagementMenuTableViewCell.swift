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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellText(text: String) {
        self.cellTextLabel.text = text
    }
    
}
