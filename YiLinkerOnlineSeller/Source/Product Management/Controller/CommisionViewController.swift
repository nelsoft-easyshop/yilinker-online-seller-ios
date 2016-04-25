//
//  CommisionViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 4/21/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class CommisionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commissionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupNavigationBar()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.saveButton.layer.cornerRadius = 2.0
    }
    
    // MARK: - Functions
    
    func setupNavigationBar() {
        
        self.title = "Commision"
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, UIBarButtonItem(image: UIImage(named: "nav-back"), style: .Plain, target: self, action: "backAction")]
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Actions
    
    @IBAction func saveCommissionAction(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
