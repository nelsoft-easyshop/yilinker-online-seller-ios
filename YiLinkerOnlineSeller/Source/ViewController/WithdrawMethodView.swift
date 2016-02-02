//
//  WithdrawMethodView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WithdrawMethodView: UIView {

    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var chequeView: UIView!
    @IBOutlet weak var depositCheckImageView: UIImageView!
    @IBOutlet weak var chequeCheckImageView: UIImageView!
    
    override func awakeFromNib() {
        self.frame.size.width = UIScreen.mainScreen().bounds.width
        self.depositView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "depositAction:"))
        
        if SessionManager.isSeller() {
            self.chequeView.backgroundColor = .lightGrayColor()
        } else {
            self.chequeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "chequeAction:"))
        }
    }
    
    
    // MARK: - Actions
    
    func depositAction(gesture: UIGestureRecognizer) {
        depositCheckImageView.hidden = false
        chequeCheckImageView.hidden = true
    }
    
    func chequeAction(gesture: UIGestureRecognizer) {
        chequeCheckImageView.hidden = false
        depositCheckImageView.hidden = true
    }

}
