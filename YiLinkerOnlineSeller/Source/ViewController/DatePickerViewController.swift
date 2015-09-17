//
//  DatePickerViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/27/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate{
    func datePickerClose(startDate: NSDate, endDate: NSDate)
}

class DatePickerViewController: UIViewController {
    
    var delegate: DatePickerViewControllerDelegate?
    
    var originalMinimumDate: NSDate = NSDate()
    var startDate: NSDate = NSDate()
    var endDate: NSDate = NSDate()
    
    var currentView: String = "startView"

    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalMinimumDate = datePicker.minimumDate!

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
            self.edgesForExtendedLayout = UIRectEdge.Bottom
        }
        
        datePicker.maximumDate = endDate
        datePicker.date = startDate
        startDateLabel.text = formatDate(startDate)
        endDateLabel.text = formatDate(endDate)
    }
    
    func initializeNavigationBar() {
        self.title = "Select Date"
        
        let backButton:UIButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        let customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        let checkButton:UIButton = UIButton(type: UIButtonType.Custom)
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check-white"), forState: UIControlState.Normal)
        let customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func done() {
        self.navigationController!.popViewControllerAnimated(true)
        delegate?.datePickerClose(startDate, endDate: endDate)
    }

    
    func initializeTapGesture() {
        let tapReport = UITapGestureRecognizer()
        tapReport.addTarget(self, action: "dateTapped:")
        startView.addGestureRecognizer(tapReport)
        
        let tapOrders = UITapGestureRecognizer()
        tapOrders.addTarget(self, action: "dateTapped:")
        endView.addGestureRecognizer(tapOrders)
    }
    
    func dateTapped(sender: UITapGestureRecognizer) {
        let senderView: UIView = sender.view!
        
        if senderView == startView {
            startDateLabel.textColor = Constants.Colors.productPrice
            endDateLabel.textColor = Constants.Colors.grayText
            currentView = "startView"
            datePicker.date = startDate
            datePicker.maximumDate = endDate
            datePicker.minimumDate = originalMinimumDate
        } else {
            endDateLabel.textColor = Constants.Colors.productPrice
            startDateLabel.textColor = Constants.Colors.grayText
            currentView = "endView"
            datePicker.date = endDate
            datePicker.maximumDate = NSDate()
            datePicker.minimumDate = startDate
        }
        
    }
    
    @IBAction func datePicked(sender: AnyObject) {
        let dateString = formatDate(datePicker.date)
        if currentView == "startView" {
            startDateLabel.text = dateString
            startDate = datePicker.date
            currentView = "startView"
        } else {
            endDateLabel.text = dateString
            endDate = datePicker.date
            currentView = "endView"
        }
    }
    
    func formatDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.stringFromDate(date)
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
