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
    
    var titles: [String] = ["Total Earning", "Tentative Receivable", "Total Withdrew", "Available Balance"]
    var prices: [String] = []
    var colors: [UIColor] = [Constants.Colors.appTheme, UIColor.blueColor(), UIColor.redColor(), Constants.Colors.pmYesGreenColor]
    var inProcess: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Payout Summary"
        let nibTVC = UINib(nibName: "PayoutSummaryTableViewCell", bundle: nil)
        self.tableView.registerNib(nibTVC, forCellReuseIdentifier: "PayoutSummaryIdentifier")
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }

    // MARK: - Actions
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: PayoutSummaryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("PayoutSummaryIdentifier") as! PayoutSummaryTableViewCell
        
        cell.titleLabel.text = titles[indexPath.row]
        cell.priceLabel.text = "P " + prices[indexPath.row]
        cell.priceLabel.textColor = colors[indexPath.row]
        
        if indexPath.row == 2 {
            cell.inProcessLabel.hidden = false
            cell.inProcessLabel.text = "IN PROCESS P " + inProcess
        }
        
        return cell
    }
   

}
