//
//  TransactionCancelOrderViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol TransactionCancelOrderViewControllerDelegate{
    func closeCancelOrderViewController()
    func yesCancelOrderAction()
    func noCancelOrderAction()
}

class TransactionCancelOrderViewController: UIViewController {
    
    var delegate: TransactionCancelOrderViewControllerDelegate?

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        mainView.layer.cornerRadius = 5
        closeView.layer.cornerRadius = closeView.frame.height / 2
        yesButton.layer.cornerRadius = 5
        noButton.layer.cornerRadius = 5
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if sender as! UIButton == closeButton {
            delegate?.closeCancelOrderViewController()
        } else if sender as! UIButton == yesButton {
            delegate?.yesCancelOrderAction()
        } else if sender as! UIButton == noButton {
            delegate?.noCancelOrderAction()
        }
    }
}
