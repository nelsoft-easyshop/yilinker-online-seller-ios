//
//  ProductManagementModelViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol ProductManagementModelViewControllerDelegate {
    func pmmvcPressClosed()
}

class ProductManagementModelViewController: UIViewController {

    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var modalView: UIView!
    
    @IBOutlet weak var closeButton: UIView!
    @IBOutlet weak var yesButton: UIView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var delegate: ProductManagementModelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeViews()
    }

    // MARK: - Methods
    
    func customizeViews() {
        modalView.layer.cornerRadius = 5
        yesButton.layer.cornerRadius = 3
        noButton.layer.cornerRadius = 3
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selfAction:"))
    }

    
    func closeView() {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.pmmvcPressClosed()
    }
    
    // MARK: - Actions
    
    func selfAction(gesture: UIGestureRecognizer) {

    }
    
    @IBAction func closeAction(sender: AnyObject) {
        closeView()
    }
    
    @IBAction func yesAction(sender: AnyObject) {
        closeView()
    }

    @IBAction func noAction(sender: AnyObject) {
        closeView()
    }
    
    
    
    
}
