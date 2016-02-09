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
    func modalNoAction(controller: WithdrawModalViewController)
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
    
    var balanceWithdrawal: WithdrawTableViewController!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.containerView.layer.cornerRadius = 3.0
        self.yesButton.layer.cornerRadius = 5.0
        self.noButton.layer.cornerRadius = 5.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        balanceWithdrawal = WithdrawTableViewController()
        balanceWithdrawal.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.requestedAmountLabel.text = "Requested Amount: P " + String(stringInterpolationSegment: amountToWithdraw)
        if amountToWithdraw < 5000.0 {
            self.bankChargeLabel.text = "Bank Charge: P 50.00"
            self.amountToBeReceivedLabel.text = "Amount to be Received: P " + String(stringInterpolationSegment: amountToWithdraw - 50.0)
        } else {
            self.bankChargeLabel.text = "Bank Charge: P 0.00"
            self.amountToBeReceivedLabel.text = "Amount to be Received: P " + String(stringInterpolationSegment: amountToWithdraw)
        }
        
    }

    @IBAction func yesAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { finished in
            delegate?.modalYesAction(self)
        })
    }
    
    @IBAction func noAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.modalNoAction(self)
    }
    
    func passAmount(controller: WithdrawTableViewController, amount: Double) {
        amountToWithdraw = amount
        
//        self.requestedAmountLabel.text = "Requested Amount: P " + String(stringInterpolationSegment: amountToWithdraw)
//        if amountToWithdraw < 5000.0 {
//            self.bankChargeLabel.text = "Bank Charge: P 50.00"
//        } else {
//            self.bankChargeLabel.text = "Bank Charge: P 0.00"
//        }
//        self.amountToBeReceivedLabel.text = "Amount to be Received: P " + String(stringInterpolationSegment: amountToWithdraw - 50.0)
    }
    
    func withdrawToRequest(controller: WithdrawTableViewController) {
        
    }
}
