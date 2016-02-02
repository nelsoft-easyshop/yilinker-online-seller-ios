//
//  WithdrawModalViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/2/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WithdrawModalViewController: UIViewController {

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
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0.5
        })
        
    }

    @IBAction func yesAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func noAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
