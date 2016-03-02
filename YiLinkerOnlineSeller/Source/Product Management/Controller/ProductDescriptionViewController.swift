//
//  ProductDescriptionViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ProductDescriptionViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var fullDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.loadHTMLString(fullDescription, baseURL: nil)
        
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeAction")
        
    }

    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
