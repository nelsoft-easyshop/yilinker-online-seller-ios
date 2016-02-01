//
//  PayoutBalanceWithdrawalViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 1/29/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutBalanceWithdrawalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var headerView: UIView!
    var availableBalanceView: WithdrawAvailableBalanceView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getHeaderView().addSubview(getAvailableBalanceView())
        
        var newFrame: CGRect!
        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.availableBalanceView.frame)
        self.headerView.frame = newFrame
        
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
    }

    func getHeaderView() -> UIView {
        if self.headerView == nil {
            self.headerView = UIView(frame: CGRectZero)
            self.headerView.autoresizesSubviews = false
        }
        return self.headerView
    }
    
    func getAvailableBalanceView() -> WithdrawAvailableBalanceView {
        if self.availableBalanceView == nil {
            self.availableBalanceView = XibHelper.puffViewWithNibName("BalanceWithdrawalViewsViewController", index: 0) as! WithdrawAvailableBalanceView
        }
        return self.availableBalanceView
    }

}
