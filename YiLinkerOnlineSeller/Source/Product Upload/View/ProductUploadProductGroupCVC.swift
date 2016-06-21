//
//  ProductUploadProductGroupCVC.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 5/13/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol ProductUploadProductGroupCVCDelegate {
    func deleteProductGroup()
}

class ProductUploadProductGroupCVC: UICollectionViewCell {

    // Buttons
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: ProductUploadProductGroupCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deleteButton(sender: UIButton) {
        self.delegate?.deleteProductGroup()
    }
}
