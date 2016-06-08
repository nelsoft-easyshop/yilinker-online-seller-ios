//
//  AddWarehouseViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Elbert Philip O. Yagaya on 4/19/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class AddWarehouseViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var warehouseNameLabel: UILabel!
    @IBOutlet weak var fullAddressLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var barangayLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    @IBOutlet weak var warehouseNameTextField: UITextField!
    @IBOutlet weak var fullAddressTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var barangayTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    override func viewDidLoad() {
        self.initializedNavigationBarItems()
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
    }
    
    func initializedNavigationBarItems() {
        self.title = StringHelper.localizedStringWithKey("Add Warehouse")
        
        self.warehouseNameLabel.required()
        self.fullAddressLabel.required()
        self.countryLabel.required()
        self.provinceLabel.required()
        self.cityLabel.required()
        self.barangayLabel.required()
        
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
        addButton.addTarget(self, action: "addWarehouse", forControlEvents: UIControlEvents.TouchUpInside)
        var customAddButton: UIBarButtonItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = customAddButton
        
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addWarehouse() {
        println("AddWarehouse, API CALL")
    }
    
}
