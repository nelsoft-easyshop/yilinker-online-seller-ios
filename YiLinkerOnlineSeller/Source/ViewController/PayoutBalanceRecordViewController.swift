//
//  PayoutBalanceRecordViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 1/29/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

enum DateType {
    case Calendar
    case Graph
    case Key
}

class PayoutBalanceRecordViewController: UIViewController, DatePickerViewControllerDelegate {
    
    @IBOutlet weak var myChart: LineChartView!
    @IBOutlet weak var dateContainerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalEarningLabel: UILabel!
    @IBOutlet weak var activeEarningLabel: UILabel!
    @IBOutlet weak var tentativeEarningLabel: UILabel!
    @IBOutlet weak var totalWithdrewLabel: UILabel!
    
    
    
    var recordModel: BalanceRecordModel!
    
    var startDate: NSDate = NSDate()
    var endDate: NSDate = NSDate()
    
    var datePickerController: DatePickerViewController?
    
    var tempEndDate: NSDate = NSDate()//.addDays(1)
    var tempStartDate: NSDate = NSDate()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fireGetWithdrawalBalance("", endDate: "")
        
        dateContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectDate:"))
    }

    func selectDate(gesture: UIGestureRecognizer) {
        datePickerController = DatePickerViewController(nibName: "DatePickerViewController", bundle: nil)
        datePickerController!.delegate = self
        datePickerController?.startDate = tempStartDate
        datePickerController?.endDate = tempEndDate
        self.navigationController?.pushViewController(datePickerController!, animated:true)
    }
    
    func initializeGraph() {
        
        let noDataLocalizeString = StringHelper.localizedStringWithKey("NO_DATA_LOCALIZE_KEY")
        let soldLocalizeString = StringHelper.localizedStringWithKey("SOLD_ITEMS_LOCALIZE_KEY")
        let cancelledLocalizeString = StringHelper.localizedStringWithKey("CANCELLED_ITEMS_LOCALIZE_KEY")
        
        myChart.noDataText = "No Data Text"
        myChart.descriptionText = "Description Text"
        
        var xAxis: ChartXAxis = myChart.xAxis
        xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        xAxis.labelFont = UIFont(name: "Panton-Semibold", size: 12)!
        xAxis.wordWrapEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.setLabelsToSkip(0)
        
        var yAxisRight: ChartYAxis = myChart.rightAxis
        yAxisRight.enabled = false
        
        var yAxisLeft: ChartYAxis = myChart.leftAxis
        yAxisLeft.labelPosition = ChartYAxis.YAxisLabelPosition.OutsideChart
        yAxisLeft.labelFont = UIFont(name: "Panton-Semibold", size: 12)!
        
        var legend: ChartLegend = myChart.legend
        legend.enabled = false
        
        myChart.pinchZoomEnabled = false
        myChart.scaleYEnabled = false
        myChart.doubleTapToZoomEnabled = false
        myChart.zoom(0, scaleY: 0, x: 0, y: 0)
        
        myChart.drawGridBackgroundEnabled = false
        myChart.backgroundColor = UIColor.whiteColor()
        
        myChart.animate(xAxisDuration: 2.5)
        
        var xValues: [String] = []
        var confirmedOrder: [String] = []
        
        let cal = NSCalendar.currentCalendar()
        
        let unit: NSCalendarUnit = .CalendarUnitDay
        
        let difference = cal.components(unit, fromDate: startDate, toDate: endDate, options: nil)
        
        for var i = 0; i < difference.day; i++ {
            xValues.append(formatDateToString(startDate.addDays(i), type: .Graph))
        }
        
        var soldItemEntries: [ChartDataEntry] = []
        
        var soldItemIndex: Int = 0
        
        var maximumYVals: Int = 0
        
        var ctr: Int = 0
        for earning in recordModel.earnings {
            ctr++
            soldItemEntries.append(ChartDataEntry(value: (earning.amount as NSString).doubleValue, xIndex: ctr))
        }
        
        var soldItemDataSet: LineChartDataSet = LineChartDataSet(yVals: soldItemEntries, label: "sample")
        soldItemDataSet.axisDependency = ChartYAxis.AxisDependency.Left
        soldItemDataSet.lineWidth = 5
        soldItemDataSet.setColor(Constants.Colors.soldLineColor)
        soldItemDataSet.setCircleColor(Constants.Colors.soldColor)
        soldItemDataSet.circleRadius = 8
        soldItemDataSet.setCircleColor(Constants.Colors.soldColor)
        soldItemDataSet.drawCircleHoleEnabled = false
        soldItemDataSet.valueTextColor = Constants.Colors.soldColor
        
        // Line of graph(s)
        var lineDataSets: [LineChartDataSet] = []
        lineDataSets.append(soldItemDataSet)
        
        var data: LineChartData = LineChartData(xVals: xValues, dataSets: lineDataSets)
        myChart.data = data
        
        myChart.zoom(0, scaleY: 0, x: 0, y: 0)
        myChart.zoom(CGFloat(xValues.count > 4 ? xValues.count/4 : 0), scaleY: CGFloat(0), x: CGFloat(0), y: CGFloat(0))
    }
    
    func formatDateToString(date: NSDate, type: DateType) -> String {
        var dateFormatter = NSDateFormatter()
        if type == .Calendar {
            dateFormatter.dateFormat = "MMM dd"
        } else if type == .Graph {
            dateFormatter.dateFormat = "dd MMM"
        } else if type == .Key {
            dateFormatter.dateFormat = "yyyy-mm-dd"
        }

        return dateFormatter.stringFromDate(date)
    }
    
    func formatStringToDate(date: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.dateFromString(date)!
    }
    
    func populateData() {
        initializeGraph()
        
        self.totalEarningLabel.text = "P " + String(recordModel.totalEarning)
        self.activeEarningLabel.text = "P " + String(recordModel.activeEarning)
        self.tentativeEarningLabel.text = "P " + String(recordModel.tentativeEarning)
        self.totalWithdrewLabel.text = "P " + String(recordModel.totalWithdrew)
    }
    
    // MARK: - Requests
    
    func fireGetWithdrawalBalance(startDate: String, endDate: String) {
        
        let parameters: NSDictionary = ["access_token": "NTc3NGYyZGI0ZTNlOGRkY2U1ODI5MWU0Yzk5ZDRkYTBiOTA5NTI0OTRiMGY5MzhhNTA1ZTc0OGY1YWQ3MGM1Zg", "dateTo": startDate, "dateFrom": endDate, "page": 1, "perPage": 5]
        
        WebServiceManager.fireGetBalanceRecordRequestWithUrl(APIAtlas.getBalanceRecordDetails, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.recordModel = BalanceRecordModel.parseDataWithDictionary(responseObject as! NSDictionary)
                self.populateData()
                
                println(responseObject)
            } else {
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .PageNotFound {
                    Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                } else {
                    println(responseObject)
                }
            }
        })
    }
    
    // MARK: - Date Picker Delegate
    func datePickerClose(startDate: NSDate, endDate: NSDate) {
        self.startDate = startDate
        self.endDate = endDate
        
        // updating the calendar label
        self.dateLabel.text = formatDateToString(startDate, type: .Calendar) + " - " + formatDateToString(endDate, type: .Calendar)
        
        // requesting balance withdrawal
        fireGetWithdrawalBalance(formatDateToString(startDate, type: .Key), endDate: formatDateToString(endDate, type: .Key))
    }

}
