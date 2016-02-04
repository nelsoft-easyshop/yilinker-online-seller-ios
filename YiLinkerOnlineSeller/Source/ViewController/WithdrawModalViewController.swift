//
//  WithdrawModalViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/2/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

protocol WithdrawModalViewControllerDelegate {
    func modalYesAction(controller: WithdrawModalViewController)
}

class WithdrawModalViewController: UIViewController, WithdrawTableViewControllerDelegate {

    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var requestedAmountLabel: UILabel!
    @IBOutlet weak var bankChargeLabel: UILabel!
    @IBOutlet weak var amountToBeReceivedLabel: UILabel!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var amountToWithdraw: Double = 0.0
    
    var delegate: WithdrawModalViewControllerDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.containerView.layer.cornerRadius = 3.0
        self.yesButton.layer.cornerRadius = 5.0
        self.noButton.layer.cornerRadius = 5.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.requestedAmountLabel.text = "Requested Amount: P " + String(stringInterpolationSegment: amountToWithdraw)
        if amountToWithdraw < 5000.0 {
            self.bankChargeLabel.text = "Bank Charge: P 50.00"
        } else {
            self.bankChargeLabel.text = "Bank Charge: P 0.00"
        }
        self.amountToBeReceivedLabel.text = "Amount to be Received: P " + String(stringInterpolationSegment: amountToWithdraw - 50.0)
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0.5
        })
        
    }

    @IBAction func yesAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.modalYesAction(self)
    }
    
    @IBAction func noAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func passAmount(controller: WithdrawTableViewController, amount: Double) {
        amountToWithdraw = amount
        
        self.requestedAmountLabel.text = "Requested Amount: P " + String(stringInterpolationSegment: amountToWithdraw)
        if amountToWithdraw < 5000.0 {
            self.bankChargeLabel.text = "Bank Charge: P 50.00"
        } else {
            self.bankChargeLabel.text = "Bank Charge: P 0.00"
        }
        self.amountToBeReceivedLabel.text = "Amount to be Received: P " + String(stringInterpolationSegment: amountToWithdraw - 50.0)
    }
    
    func withdrawToRequest(controller: WithdrawTableViewController) {
        
    }
}
