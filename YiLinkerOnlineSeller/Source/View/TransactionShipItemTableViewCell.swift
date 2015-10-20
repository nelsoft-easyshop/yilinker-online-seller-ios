//
//  TransactionShipItemTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol TransactionShipItemTableViewCellDelegate {
    func cancelTransactionShipItem()
    func readyForPickupItem(date: String, remarks: String)
}

class TransactionShipItemTableViewCell: UITableViewCell, FSCalendarDelegate, FSCalendarDataSource  {
    
    var delegate: TransactionShipItemTableViewCellDelegate?

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pickupButton: UIButton!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var pickupScheduleLabel: UILabel!
    @IBOutlet weak var pickupScheduleDescriptionLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var notesTitleLabel: UILabel!
    
    @IBOutlet weak var calendarConstant: NSLayoutConstraint!
    @IBOutlet weak var timeConstant: NSLayoutConstraint!
    var pickerView: UIDatePicker!
    
    var selectedDate: NSDate = NSDate()
    var selectedTime: NSDate = NSDate()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
        initializeLocalizedStrings()
        addPicker()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeViews() {
        cancelButton.layer.cornerRadius = 5
        pickupButton.layer.cornerRadius = 5
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        timeTextField.addToolBarWithDoneTarget(self, done: Selector("tapMainView"))
        
        notesTextView.addToolBarWithDoneTarget(self, done: Selector("tapMainView"))
        
        calendarView.selectedDate = selectedDate
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.25
        
        timeTextField.text = formatTime(selectedTime)
        
        timeConstant.constant = 0
        calendarConstant.constant = 0
        timeView.hidden = true
    }
    
    func initializeLocalizedStrings() {
        pickupScheduleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_SHIP_PICKUP_SCHEDULE_LOCALIZE_KEY")
        pickupScheduleDescriptionLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_SHIP_PICKUP_DESCRIPTION_LOCALIZE_KEY")
        timeTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_SHIP_TIME_LOCALIZE_KEY")
        notesTitleLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_SHIP_NOTES_LOCALIZE_KEY")
        cancelButton.setTitle(StringHelper.localizedStringWithKey("TRANSACTION_SHIP_CANCEL_LOCALIZE_KEY"), forState: UIControlState.Normal)
        pickupButton.setTitle(StringHelper.localizedStringWithKey("TRANSACTION_SHIP_READY_LOCALIZE_KEY"), forState: UIControlState.Normal)
    }
    
    func addPicker() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        pickerView = UIDatePicker(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView!.datePickerMode = UIDatePickerMode.Time
        
        pickerView.addTarget(self, action: Selector("didSelectTime:"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.timeTextField.inputView = pickerView
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == pickupButton {
            
            let formatter1 = NSDateFormatter()
            formatter1.dateFormat = "yyyy-MM-dd"
            let dateString = formatter1.stringFromDate(selectedDate)
            let formatter2 = NSDateFormatter()
            formatter2.dateFormat = "kk:mm:ss"
            let timeString = formatter2.stringFromDate(selectedTime)
            var newDate: String = "\(dateString) \(timeString)"
            println(newDate)
            
            delegate?.readyForPickupItem(newDate, remarks: notesTextView.text)
        } else if sender as! UIButton == cancelButton {
            delegate?.cancelTransactionShipItem()
        }
    }
    
    func didSelectTime(datePicker:UIDatePicker) {
        selectedTime = datePicker.date
        timeTextField.text = formatTime(selectedTime)
    }
    
    func tapMainView() {
        notesTextView.resignFirstResponder()
        timeTextField.resignFirstResponder()
    }
    
    //FSCalendarDataSource
    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return NSDate()
    }
    
    //FSCalendarDelegate
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        selectedDate = date
        dateLabel.text = formatDate(date)
    }
    
    func formatDate(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.stringFromDate(date)
    }
    
    func formatTime(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "KK:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    
    
}
