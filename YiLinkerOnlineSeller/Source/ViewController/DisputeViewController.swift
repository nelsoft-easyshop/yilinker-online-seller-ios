//
//  DisputeViewController.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class DisputeViewController: UIViewController {
    @IBOutlet weak var disputeTitle: UITextField!
    @IBOutlet weak var transactionNumber: UITextField!
    @IBOutlet weak var remarks: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var titleView: UIView!
    weak var delegate: ResolutionCenterViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        roundCornerRadius(self.disputeTitle.layer)
        roundCornerRadius(self.transactionNumber.layer)
        roundCornerRadius(self.remarks.layer)
        roundCornerRadius(self.submitButton.layer)
        roundCornerRadius(self.modalView.layer)
        roundCornerRadius(self.titleView.layer)
        
        addPadding(self.disputeTitle)
        addPadding(self.transactionNumber)
        
        setUpTextFields()
    }
    
    func roundCornerRadius(currentLayer: CALayer) {
        currentLayer.cornerRadius = 5
    }
    
    func addPadding(aTextField: UITextField!) {
        aTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        aTextField.leftViewMode = .Always
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTextFields() {
//        self.emailAddressTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
//        self.emailAddressTextField.delegate = self
//        self.passwordTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
//        self.passwordTextField.delegate = self
    }
    

    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.dissmissDisputeViewController(self, type: "none")
    }
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.dissmissDisputeViewController(self, type: "none")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
