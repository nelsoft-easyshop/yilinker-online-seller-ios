//
//  PayoutSummaryViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 1/29/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutSummaryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibTVC = UINib(nibName: "ProductManagementTableViewCell", bundle: nil)
        self.tableView.registerNib(nibTVC, forCellReuseIdentifier: "ProductManagementIdentifier")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProductManagementTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("ProductManagementIdentifier") as! ProductManagementTableViewCell
        
        return cell
    }
   

}
