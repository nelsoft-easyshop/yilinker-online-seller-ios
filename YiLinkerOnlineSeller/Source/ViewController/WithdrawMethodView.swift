//
//  WithdrawMethodView.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol WithdrawMethodViewDelegate {
    func chequeAction(view: WithdrawMethodView)
    func depositAction(view: WithdrawMethodView)
}

class WithdrawMethodView: UIView {

    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var chequeView: UIView!
    @IBOutlet weak var depositCheckImageView: UIImageView!
    @IBOutlet weak var chequeCheckImageView: UIImageView!
    @IBOutlet weak var withdrawalMethodTextLabel: UILabel!
    
    var delegate: WithdrawMethodViewDelegate?
    
    override func awakeFromNib() {
        self.frame.size.width = UIScreen.mainScreen().bounds.width
        self.depositView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "depositAction:"))
        
        if SessionManager.isSeller() {
            self.chequeView.backgroundColor = .lightGrayColor()
        } else {
            self.chequeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "chequeAction:"))
        }
        
        self.withdrawalMethodTextLabel.text = PayoutStrings.withdrawalMethod + ":"
    }
    
    
    // MARK: - Actions
    
    func depositAction(gesture: UIGestureRecognizer) {
        delegate?.depositAction(self)
        depositCheckImageView.hidden = false
        chequeCheckImageView.hidden = true
    }
    
    func chequeAction(gesture: UIGestureRecognizer) {
        delegate?.chequeAction(self)
        chequeCheckImageView.hidden = false
        depositCheckImageView.hidden = true
    }

}
