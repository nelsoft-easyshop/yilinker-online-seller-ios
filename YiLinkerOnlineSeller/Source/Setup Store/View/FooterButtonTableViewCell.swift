//
//  FooterButtonTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 2/22/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol FooterButtonTableViewCellDelegate {
    func footerButtonTableViewCell(footerButtonTableViewCell: FooterButtonTableViewCell, didTapButton button: UIButton)
}

class FooterButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var delegate: FooterButtonTableViewCellDelegate?
    
    class func nibNameAndIdentifer() -> String {
        return "FooterButtonTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        button.layer.cornerRadius = 5
    }
    
    //MARK: -
    //MARK: Action methods for buttons
    @IBAction func action(sender: UIButton) {
        self.activityIndicatorView.startAnimating()
        self.delegate?.footerButtonTableViewCell(self, didTapButton: sender)
    }
    
    
    //MARK: - 
    //MARK: - Stop Activity Indicator View From Animating
    func stopActivityIndicatorViewFromAnimating() {
        self.activityIndicatorView.stopAnimating()
    }
}
