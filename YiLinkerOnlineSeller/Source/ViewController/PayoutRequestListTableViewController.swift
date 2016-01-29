//
//  PayoutRequestListTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 1/29/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutRequestListTableViewController: UITableViewController {
    
    
    // Local Strings
    let cellIdentifier: String = "PayoutRequestListTableViewCell"
    let cellNibName: String = "PayoutRequestListTableViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Withdrawal Request List"
        self.backButton()
        self.footerView()
        self.registerCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Navigation bar
    // MARK: - Add Back Button in navigation bar
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    //MARK: - Navigation bar back button action
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }

    // MARK: - Private methods
    // Remove tableview footer
    func footerView() {
        let footerView: UIView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = footerView
    }
    
    // MARK: - Regiter nib files
    func registerCell() {
        let nib: UINib = UINib(nibName: self.cellNibName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! PayoutRequestListTableViewCell
        
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 99
    }
    
}
