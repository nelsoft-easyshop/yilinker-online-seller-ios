//
//  PayoutBalanceRecordViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 1/29/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutBalanceRecordViewController: UIViewController, DatePickerViewControllerDelegate, EmptyViewDelegate {
    
    // Views from Xib
    @IBOutlet weak var myChart: LineChartView!
    @IBOutlet weak var dateContainerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalEarningLabel: UILabel!
    @IBOutlet weak var activeEarningLabel: UILabel!
    @IBOutlet weak var tentativeEarningLabel: UILabel!
    @IBOutlet weak var totalWithdrewLabel: UILabel!
    
    @IBOutlet weak var totalEarningsHeaderLabel: UILabel!
    @IBOutlet weak var totalEarningsLabel: UILabel!
    @IBOutlet weak var activeEarningsTextLabel: UILabel!
    @IBOutlet weak var tentativeEarningsTextLabel: UILabel!
    @IBOutlet weak var totalWithdrewTextLabel: UILabel!
    
    // Model
    var recordModel: BalanceRecordModel!
    
    // Keys
    var startDate: NSDate = NSDate().addDays(-30)
    var endDate: NSDate = NSDate()
    
    // y axis for the graph
    var yAxisLeft: ChartYAxis!
    
    // loader
    var hud: MBProgressHUD?
    
    //
    var emptyView: EmptyView?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // initialize graph
        initializeGraph()
            
        // add tap gesture to the date label
        dateContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectDate:"))
        
        self.showHUD()
        
        self.totalEarningsHeaderLabel.text = PayoutStrings.recordTotalEarnings
        self.totalEarningsLabel.text = PayoutStrings.recordTotalEarnings
        self.activeEarningsTextLabel.text = PayoutStrings.recordActiveEarnings
        self.tentativeEarningsTextLabel.text = PayoutStrings.recordTentativeEarnings
        self.totalWithdrewTextLabel.text = PayoutStrings.recordTotalWithdrew
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.showHUD()
        fireGetWithdrawalBalance(self.formatDateToString(self.startDate, type: .Key), endDate: self.formatDateToString(self.endDate.addDays(1), type: .Key))
    }
    
    // MARK: - Functions
    
    // show date picker view controller
    func selectDate(gesture: UIGestureRecognizer) {
        var datePickerController: DatePickerViewController = DatePickerViewController(nibName: "DatePickerViewController", bundle: nil)
        datePickerController.delegate = self
        datePickerController.startDate = self.startDate
        datePickerController.endDate = self.endDate
        self.navigationController?.pushViewController(datePickerController, animated:true)
    }
    
    // initialize graph
    func initializeGraph() {
        
        myChart.noDataText = PayoutStrings.recordNoData
        myChart.descriptionText = ""
        
        // x axis
        var xAxis: ChartXAxis = myChart.xAxis
        xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        xAxis.labelFont = UIFont(name: "Panton-Semibold", size: 11)!
        xAxis.labelTextColor = .darkGrayColor()
        xAxis.wordWrapEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.setLabelsToSkip(0)

        // y axis
        var yAxisRight: ChartYAxis = myChart.rightAxis
        yAxisRight.enabled = false
        
        yAxisLeft = myChart.leftAxis
        yAxisLeft.labelPosition = ChartYAxis.YAxisLabelPosition.OutsideChart
        yAxisLeft.labelFont = UIFont(name: "Panton-Semibold", size: 11)!
        yAxisLeft.labelTextColor = .darkGrayColor()

        // legend
        var legend: ChartLegend = myChart.legend
        legend.enabled = false
        
        myChart.pinchZoomEnabled = false
        myChart.scaleYEnabled = false
        myChart.doubleTapToZoomEnabled = false
        myChart.zoom(0, scaleY: 0, x: 0, y: 0)
        
        myChart.drawGridBackgroundEnabled = false
        myChart.backgroundColor = UIColor.whiteColor()
        
        myChart.animate(xAxisDuration: 2)
    }
    
    // show graph's data
    func displayGraph() {

        var availableDates: [String] = []
        var dates: [String] = []
        var amounts: [String] = []
        var earningEntries: [ChartDataEntry] = []
        
        // get dates and amounts from api response
        for earning in recordModel.earnings {
            availableDates.append(formatDateToString(formatStringToDate(earning.date), type: .Graph).uppercaseString)
            amounts.append(earning.amount)
        }
        
        // adding days to to dates to complete the dates of the month
        let cal = NSCalendar.currentCalendar()
        let unit: NSCalendarUnit = .CalendarUnitDay
        let difference = cal.components(unit, fromDate: self.startDate, toDate: self.endDate.addDays(1), options: nil)
        
        for i in 0..<difference.day {
            dates.append(formatDateToString(startDate.addDays(i), type: .Graph).uppercaseString)
        }
        
        // adding values to amount to equal the items of dates
        // add data to chart
        var index: Int = 0
        var amountIndex: Int = recordModel.earnings.count
        for date in dates {
            if contains(availableDates, date) {
                if amountIndex != 0 {
                    amountIndex--
                }
                
                var yValue: String = recordModel.earnings[amountIndex].amount
                yValue = yValue.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range: nil)
                earningEntries.append(ChartDataEntry(value: (yValue as NSString).doubleValue, xIndex: index))
            } else {
                earningEntries.append(ChartDataEntry(value: 0, xIndex: index))
            }
            
            index++
        }
        

        // line data sets
        var earningsDataSet: LineChartDataSet = LineChartDataSet(yVals: earningEntries, label: "")
        earningsDataSet.axisDependency = ChartYAxis.AxisDependency.Left
        earningsDataSet.lineWidth = 4
        earningsDataSet.setColor(Constants.Colors.soldLineColor)
        earningsDataSet.setCircleColor(Constants.Colors.soldColor)
        earningsDataSet.circleRadius = 6
        earningsDataSet.setCircleColor(Constants.Colors.soldColor)
        earningsDataSet.drawCircleHoleEnabled = false
        earningsDataSet.valueTextColor = /*Constants.Colors.soldColor*/UIColor.clearColor()

        // Line of graph
        var lineDataSets: [LineChartDataSet] = []
        lineDataSets.append(earningsDataSet)

        // Data of graph
        var data: LineChartData = LineChartData(xVals: dates, dataSets: lineDataSets)
        myChart.data = data
        
        // Graph's scale
        myChart.zoom(0, scaleY: 0, x: 0, y: 0)
        myChart.zoom(CGFloat(dates.count > 4 ? dates.count/4 : 0), scaleY: CGFloat(0), x: CGFloat(0), y: CGFloat(0))
    }
    
    // convert date to string
    func formatDateToString(date: NSDate, type: DateType) -> String {
        var dateFormatter = NSDateFormatter()
        if type == .Calendar {
            dateFormatter.dateFormat = "MMM dd"
        } else if type == .Graph {
            dateFormatter.dateFormat = "dd MMM"
        } else if type == .Key {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }

        return dateFormatter.stringFromDate(date)
    }
    
    // convert string to date
    func formatStringToDate(date: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.dateFromString(date)!
    }
    
    // populate data
    func populateData() {
        displayGraph()
        
        self.totalEarningLabel.text = recordModel.currencyCode + String(recordModel.totalEarning)
        self.activeEarningLabel.text = recordModel.currencyCode + String(recordModel.activeEarning)
        self.tentativeEarningLabel.text = recordModel.currencyCode + String(recordModel.tentativeEarning)
        self.totalWithdrewLabel.text = recordModel.currencyCode + String(recordModel.totalWithdrew)
        
        // update calendar dates
        // get the first value and the last value for dates
        if dateLabel.text == " - " {
            self.dateLabel.text = formatDateToString(self.startDate, type: .Calendar) + " - " + formatDateToString(self.endDate, type: .Calendar)
        }
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(frame: CGRectZero)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func addEmptyView() {
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView!.delegate = self
            self.emptyView?.frame = self.view.frame
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    func didTapReload() {
        if Reachability.isConnectedToNetwork() {
            self.showHUD()
            self.emptyView?.hidden = true
            if self.recordModel == nil {
                fireGetWithdrawalBalance("", endDate: "")
            } else {
                fireGetWithdrawalBalance(formatDateToString(self.startDate, type: .Key), endDate: formatDateToString(self.endDate, type: .Key))
            }
        }
    }
    
    // MARK: - Requests
    
    func fireGetWithdrawalBalance(startDate: String, endDate: String) {
        if Reachability.isConnectedToNetwork() {
            let parameters: NSDictionary = ["access_token": SessionManager.accessToken(), "dateFrom": startDate, "dateTo": endDate, "page": "", "perPage": ""]
            WebServiceManager.fireGetBalanceRecordRequestWithUrl(APIAtlas.getBalanceRecordDetails, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                self.hud?.hidden = true
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if successful {
                    self.recordModel = BalanceRecordModel.parseDataWithDictionary(responseObject as! NSDictionary)
                    self.populateData()
                    println(responseObject)
                } else {
                    self.addEmptyView()
                    if requestErrorType == .ResponseError {
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                    } else if requestErrorType == .AccessTokenExpired {
                        self.fireRefreshToken()
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
        } else {
            self.addEmptyView()
            self.hud?.hidden = true
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.failed)
        }
        
    }
    
    func fireRefreshToken() {
        if Reachability.isConnectedToNetwork() {
            self.showHUD()
            WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.loginUrl, actionHandler: { (successful, responseObject, RequestErrorType) -> Void in
                self.hud?.hide(true)
                if successful {
                    self.fireGetWithdrawalBalance(self.formatDateToString(self.startDate, type: .Key), endDate: self.formatDateToString(self.endDate.addDays(1), type: .Key))
                } else {
                    //Forcing user to logout.
                    UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                        SessionManager.logout()
                        GPPSignIn.sharedInstance().signOut()
                        self.navigationController?.popToRootViewControllerAnimated(false)
                    })
                }
            })
        } else {
            self.hud?.hide(true)
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AlertStrings.checkInternet, title: AlertStrings.failed)
        }
        
    }
    
    // MARK: - Date Picker Delegate
    func datePickerClose(startDate: NSDate, endDate: NSDate) {
        self.startDate = startDate
        self.endDate = endDate
        
        // updating the calendar label
        self.dateLabel.text = formatDateToString(startDate, type: .Calendar) + " - " + formatDateToString(endDate, type: .Calendar)
        
        // show loader for reloading when view did appear
        self.showHUD()
    }
    
}