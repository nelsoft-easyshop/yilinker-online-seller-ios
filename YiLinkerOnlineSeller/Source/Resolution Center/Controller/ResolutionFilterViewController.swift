//
//  ResolutionFilterViewController.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

// MARK: - Private class
class SelectedFilters {
    
    var time: ResolutionTimeFilter
    var status: ResolutionStatusFilter
    
    init(time: ResolutionTimeFilter, status: ResolutionStatusFilter) {
        self.time = time
        self.status = status
    }
    
    func getStatusFilter() -> String {
        switch status {
        case .Open:
            return "1"
        case .Closed:
            return "2"
        default:
            return "0"
        }
    }
    
    func isDefault() -> Bool {
        return self.time == .Total && self.status == .Both
    }
    
    func getTimeFilter() -> String {
        let formatter = NSDateFormatter()
        let now = NSDate()
        formatter.dateFormat = "yyyy-MM-dd"
        switch time {
        case .Today:
            self.time = ResolutionTimeFilter.Today
            return formatter.stringFromDate(now)
        case .ThisWeek:
            self.time = ResolutionTimeFilter.ThisWeek
            let day: Int = self.dayOfWeek(self.getTimeNow())!
            return formatter.stringFromDate(NSDate().addDays(1))
        case .ThisMonth:
            self.time = ResolutionTimeFilter.ThisMonth
            return formatter.stringFromDate(NSDate().addDays(1))
        case .Total:
            return ""
        default:
            return ""
        }
    }
    
    func getFilterType() -> ResolutionTimeFilter {
        return self.time
    }
    
    func sundayDate() -> String {
        let day: Int = self.dayOfWeek(self.getTimeNow())!
        return self.fromDateWeek(day)
    }
    
    func dayOfWeek(today:String) -> Int? {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.dateFromString(today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return nil
        }
    }
    
    func fromDateWeek(numberOfDays: Int) -> String {
        let userCalendar = NSCalendar.currentCalendar()
        let sundayDate = userCalendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: -(numberOfDays - 1), toDate: NSDate(), options: nil)!
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(sundayDate)
    }
    
    func getTimeNow() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let now = NSDate()
        return formatter.stringFromDate(now)
    }
}

//Strings
struct FilterStrings {
    static let title = StringHelper.localizedStringWithKey("FILTER_TITLE_LOCALIZE_KEY")
    static let dates = StringHelper.localizedStringWithKey("FILTER_DATES_LOCALIZE_KEY")
    static let today = StringHelper.localizedStringWithKey("FILTER_TODAY_LOCALIZE_KEY")
    static let week = StringHelper.localizedStringWithKey("FILTER_WEEK_LOCALIZE_KEY")
    static let month = StringHelper.localizedStringWithKey("FILTER_MONTH_LOCALIZE_KEY")
    static let total = StringHelper.localizedStringWithKey("FILTER_TOTAL_LOCALIZE_KEY")
    static let status = StringHelper.localizedStringWithKey("FILTER_STATUS_LOCALIZE_KEY")
    static let open = StringHelper.localizedStringWithKey("FILTER_OPEN_LOCALIZE_KEY")
    static let closed = StringHelper.localizedStringWithKey("FILTER_CLOSE_LOCALIZE_KEY")
}

class ResolutionFilterViewController: UITableViewController {
   
    // Bar buttons
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!
    
    // Checkboxes
    @IBOutlet weak var buttonToday: CheckBox!
    @IBOutlet weak var buttonThisWeek: CheckBox!
    @IBOutlet weak var buttonThisMonth: CheckBox!
    @IBOutlet weak var buttonTotal: CheckBox!
    @IBOutlet weak var buttonOpen: CheckBox!
    @IBOutlet weak var buttonClosed: CheckBox!
    
    // Labels
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closedLabel: UILabel!
    
    private var timeFilter: ResolutionTimeFilter = .Total
    private var statusFilter: ResolutionStatusFilter = .Both
    
    // Initialized ResolutionCenterViewControllerV2
    var delegate: ResolutionCenterViewControllerV2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timeFilter = self.delegate!.currentSelectedFilter.time
        self.selectTimeFilter(self.timeFilter)
        self.statusFilter = self.delegate!.currentSelectedFilter.status
        self.selectStatusFilter(self.statusFilter)
        
        // Add tap gesture recognizer to buttons
        self.buttonToday.addTarget(self, action: "todayPressed"
            , forControlEvents:.TouchUpInside)
        self.buttonThisWeek.addTarget(self, action: "thisWeekPressed"
            , forControlEvents:.TouchUpInside)
        self.buttonThisMonth.addTarget(self, action: "thisMonthPressed"
            , forControlEvents:.TouchUpInside)
        self.buttonTotal.addTarget(self, action: "totalPressed"
            , forControlEvents:.TouchUpInside)
        self.buttonOpen.addTarget(self, action: "openPressed"
            , forControlEvents:.TouchUpInside)
        self.buttonClosed.addTarget(self, action: "closedPressed"
            , forControlEvents:.TouchUpInside)
        
        self.setUpNavigationBar()
        self.setStrings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    // MARK: - Set text to labels
    func setStrings() {
        self.title = FilterStrings.title
        
        todayLabel.text = FilterStrings.today
        weekLabel.text = FilterStrings.week
        monthLabel.text = FilterStrings.month
        totalLabel.text = FilterStrings.total
        
        openLabel.text = FilterStrings.open
        closedLabel.text = FilterStrings.closed
    }
    
    // MARK: - Set up navigation bar
    // Add save and cancel bar buton items
    func setUpNavigationBar() {
        // White title text
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        
        cancel.tintColor = UIColor.whiteColor()
        cancel.target = self
        cancel.action = "cancelPressed"
        
        save.tintColor = UIColor.whiteColor()
        save.target = self
        save.action = "savePressed"
    }
    
    // MARK: - Navigation bar actions
    // MARK: - Cancel & Save
    func cancelPressed() {
        //self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func savePressed() {
        self.delegate!.currentSelectedFilter.time = self.timeFilter
        self.delegate!.currentSelectedFilter.status = self.statusFilter
        self.dismissViewControllerAnimated(true, completion: nil)
        //        self.delegate!.applyFilter()
        
        switch self.statusFilter {
        case .Both:
            self.delegate!.setSelectedTab(0)
        case .Open:
            self.delegate!.setSelectedTab(1)
        case .Closed:
            self.delegate!.setSelectedTab(2)
        default:
            self.delegate!.setSelectedTab(0)
        }
    }
    
    // MARK: - Button actions
    func todayPressed() {
        selectTimeFilter(.Today)
    }
    
    func thisWeekPressed() {
        selectTimeFilter(.ThisWeek)
    }
    
    func thisMonthPressed() {
        selectTimeFilter(.ThisMonth)
    }
    
    func totalPressed() {
        selectTimeFilter(.Total)
    }
    
    func openPressed() {
        selectStatusFilter(.Open)
    }
    
    func closedPressed() {
        selectStatusFilter(.Closed)
    }
    
    // MARK: - Delects all checkboxes
    private func deselectAllTimeCheckBox() {
        self.buttonToday.setUnchecked()
        self.buttonThisWeek.setUnchecked()
        self.buttonThisMonth.setUnchecked()
        self.buttonTotal.setUnchecked()
    }
    
    // MARK: - Time Filter Checkbox Selection
    private func selectTimeFilter(timeFilterSelection: ResolutionTimeFilter) {
        self.timeFilter = timeFilterSelection
        self.deselectAllTimeCheckBox()
        self.setSelectedTimeCheckBox()
    }
    
    // MARK: - Check checkboxes
    private func setSelectedTimeCheckBox() {
        switch(self.timeFilter) {
        case .Today:
            self.buttonToday.setChecked()
        case .ThisWeek:
            self.buttonThisWeek.setChecked()
        case .ThisMonth:
            self.buttonThisMonth.setChecked()
        case .Total:
            self.buttonTotal.setChecked()
        default:
            ()
        }
    }
    
    // MARK: - Status Filter Checkbox Selection
    private func selectStatusFilter(filterSelection: ResolutionStatusFilter) {
        if self.statusFilter == .Both {
            if filterSelection == .Open {
                self.statusFilter = .Closed
                self.buttonOpen.setUnchecked()
                self.buttonClosed.setChecked()
            } else if filterSelection == .Closed {
                self.statusFilter = .Open
                self.buttonOpen.setChecked()
                self.buttonClosed.setUnchecked()
            } else if filterSelection == .Both {
                self.buttonOpen.setChecked()
                self.buttonClosed.setChecked()
            }
        }
        else if self.statusFilter == .Open && filterSelection == .Closed {
            self.statusFilter = .Both
            self.buttonOpen.setChecked()
            self.buttonClosed.setChecked()
        }
        else if self.statusFilter == .Closed && filterSelection == .Open {
            self.statusFilter = .Both
            self.buttonOpen.setChecked()
            self.buttonClosed.setChecked()
        }
        else if self.statusFilter == .Open {
            self.buttonOpen.setChecked()
            self.buttonClosed.setUnchecked()
        }
        else if self.statusFilter == .Closed {
            self.buttonOpen.setUnchecked()
            self.buttonClosed.setChecked()
        }
    }
}
