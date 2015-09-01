//
//  CustomizedCategoryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CustomizedCategoryViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "CustomizedCategoryTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "CustomizedCategory")
        
        customizedNavigationBar()

    }

    // MARK: - Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Customized Category"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "addCategory"), style: .Plain, target: self, action: "addCategoryAction"), navigationSpacer]
    }

    // MARK: - Actions
    
    func backAction() {
        
    }
    
    func addCategoryAction() {
        let addCustomizedCategory = AddCustomizedCategoryViewController(nibName: "AddCustomizedCategoryViewController", bundle: nil)
        var rootViewController = UINavigationController(rootViewController: addCustomizedCategory)
        self.navigationController?.presentViewController(rootViewController, animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CustomizedCategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CustomizedCategory") as! CustomizedCategoryTableViewCell
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let addCustomizedCategory = AddCustomizedCategoryViewController(nibName: "AddCustomizedCategoryViewController", bundle: nil)
        addCustomizedCategory.subCategoriesItems = 4
        addCustomizedCategory.imageItems = 5
        addCustomizedCategory.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addCustomizedCategory, animated: true)
    }
    
    
}
