//
//  EmptyView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//


protocol EmptyViewDelegate {
    func didTapReload()
}

class EmptyView: UIView {
    
    var delegate: EmptyViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tapToReloadLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    @IBAction func tapToReload(sender: AnyObject) {
        self.delegate?.didTapReload()
    }
    
}
