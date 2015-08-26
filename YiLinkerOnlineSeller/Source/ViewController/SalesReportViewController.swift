//
//  SalesReportViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class SalesReportViewController: UIViewController {
    @IBOutlet weak var salesReportsView: UIView!
    @IBOutlet weak var salesReportImageView: UIImageView!
    @IBOutlet weak var salesReportLabel: UILabel!
    
    @IBOutlet weak var recentOrdersView: UIView!
    @IBOutlet weak var recentOrdersImageView: UIImageView!
    @IBOutlet weak var recentOrdersLabel: UILabel!
    
    var isSalesReport: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        initializeNavigationBar()
        initializeTapGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
    }
    
    func initializeNavigationBar() {
        self.title = "Report"
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func initializeTapGesture() {
        let tapReport = UITapGestureRecognizer()
        tapReport.addTarget(self, action: "tabTapped:")
        salesReportsView.addGestureRecognizer(tapReport)
        
        let tapOrders = UITapGestureRecognizer()
        tapOrders.addTarget(self, action: "tabTapped:")
        recentOrdersView.addGestureRecognizer(tapOrders)
    }
    
    func tabTapped(sender: UITapGestureRecognizer) {
        let senderView: UIView = sender.view!
        
        if senderView == salesReportsView {
            salesReportsView.backgroundColor = UIColor.whiteColor()
            salesReportLabel.textColor = Constants.Colors.productPrice
            salesReportImageView.image = UIImage(named: "salesReport")
            
            recentOrdersView.backgroundColor = Constants.Colors.productPrice
            recentOrdersLabel.textColor = UIColor.whiteColor()
            recentOrdersImageView.image = UIImage(named: "recentOrders2")
        } else {
            salesReportsView.backgroundColor = Constants.Colors.productPrice
            salesReportLabel.textColor = UIColor.whiteColor()
            salesReportImageView.image = UIImage(named: "salesReport2")
            
            recentOrdersView.backgroundColor = UIColor.whiteColor()
            recentOrdersLabel.textColor = Constants.Colors.productPrice
            recentOrdersImageView.image = UIImage(named: "recentOrders")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
