//
//  WarehouseProductDetailViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Elbert Philip O. Yagaya on 4/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class WarehouseProductDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        self.title = "Warehouse Product Detail"
        self.initializedNavigationBarItems()
    }
    
    
    func initializedNavigationBarItems() {
        self.title = StringHelper.localizedStringWithKey("Add Warehouse")
        
        var backButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 20, 20)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "close-1"), forState: UIControlState.Normal)
        var customBackButton: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = 0
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        var addButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        addButton.frame = CGRectMake(0, 0, 20, 20)
        addButton.setImage(UIImage(named: "check-1"), forState: UIControlState.Normal)
        addButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        var customAddButton: UIBarButtonItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = customAddButton
        
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        println("save product edit, API CALL")
    }


}

