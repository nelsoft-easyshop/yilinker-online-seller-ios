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

        self.footerView()
        self.registerCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
