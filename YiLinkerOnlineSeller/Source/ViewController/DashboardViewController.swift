//
//  ViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by @EasyShop.ph on 8/24/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController!.tabBar.tintColor = Constants.Colors.appTheme

        let productUploadTableViewController: ProductUploadTableViewController = ProductUploadTableViewController(nibName: "ProductUploadTableViewController", bundle: nil)
        let navigationController: UINavigationController = UINavigationController(rootViewController: productUploadTableViewController)
        navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
        self.tabBarController!.presentViewController(navigationController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

