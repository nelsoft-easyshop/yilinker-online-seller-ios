//
//  TransactionProductDescriptionViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionProductDescriptionViewController: UIViewController {
    
    var fullDescription: String = ""
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadHTMLString("<font face='Panton-Light'>\(fullDescription)", baseURL: nil)
        initializeNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeNavigationBar() {
        self.title = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DESCRIPTION_LOCALIZE_KEY")
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    

    
}
