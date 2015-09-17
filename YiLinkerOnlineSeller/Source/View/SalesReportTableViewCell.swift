//
//  SalesReportTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 8/26/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol SalesReportTableViewCellDelegate {
    func changeDate()
}

class SalesReportTableViewCell: UITableViewCell {

    var delegate: SalesReportTableViewCellDelegate?
    
    @IBOutlet weak var soldCircleView: UIView!
    @IBOutlet weak var cancelledCircleView: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var largeLineChart: LineChartView!
    @IBOutlet weak var totalSalesLabel: UILabel!
    @IBOutlet weak var totalTransactionsLabel: UILabel!
    @IBOutlet weak var totalProducts: UILabel!
    @IBOutlet weak var smallLineChart: LineChartView!
    
    var salesReportModel: SalesReportModel!
    
    var startDate: NSDate = NSDate()
    var endDate: NSDate = NSDate()
    
    var valueFormater: NSNumberFormatter = NSNumberFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        valueFormater.numberStyle = NSNumberFormatterStyle.NoStyle
        
        initializeViews()
    }

    func initializeViews() {
        soldCircleView.layer.cornerRadius = soldCircleView.frame.height / 2
        cancelledCircleView.layer.cornerRadius = cancelledCircleView.frame.height / 2
        
        let tapRec = UITapGestureRecognizer()
        tapRec.addTarget(self, action: "tappedView")
        
        calendarView.addGestureRecognizer(tapRec)
    }
    
    func initializeGraph() {
        largeLineChart.noDataText = "No data available"
        largeLineChart.descriptionText = ""
        
        let xAxis: ChartXAxis = largeLineChart.xAxis
        xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        xAxis.labelFont = UIFont(name: "Panton-Semibold", size: 12)!
        xAxis.setLabelsToSkip(0)
        
        let yAxisRight: ChartYAxis = largeLineChart.rightAxis
        yAxisRight.enabled = false
        
        let yAxisLeft: ChartYAxis = largeLineChart.leftAxis
        yAxisLeft.labelPosition = ChartYAxis.YAxisLabelPosition.OutsideChart
        yAxisLeft.labelFont = UIFont(name: "Panton-Semibold", size: 12)!

        let legend: ChartLegend = largeLineChart.legend
        legend.enabled = false
        
        largeLineChart.pinchZoomEnabled = false
        largeLineChart.scaleYEnabled = false
        largeLineChart.doubleTapToZoomEnabled = false
        largeLineChart.zoom(0, scaleY: 0, x: 0, y: 0)
        
        largeLineChart.drawGridBackgroundEnabled = false
        largeLineChart.backgroundColor = UIColor.whiteColor()
        
        largeLineChart.animate(xAxisDuration: 2.5)
        
        
        //preview
        smallLineChart.noDataText = "No data available"
        
        let xAxis1: ChartXAxis = smallLineChart.xAxis
        xAxis1.enabled = false
        
        let yAxisRight1: ChartYAxis = smallLineChart.rightAxis
        yAxisRight1.enabled = false
        
        let yAxisLeft1: ChartYAxis = smallLineChart.leftAxis
        yAxisLeft1.enabled = false
        
        let legend1: ChartLegend = smallLineChart.legend
        legend1.enabled = false
        
        
        smallLineChart.descriptionText = ""
        smallLineChart.pinchZoomEnabled = false
        smallLineChart.scaleYEnabled = false
        smallLineChart.doubleTapToZoomEnabled = false
        smallLineChart.zoom(0, scaleY: 0, x: 0, y: 0)
        
        smallLineChart.drawGridBackgroundEnabled = false
        smallLineChart.backgroundColor = UIColor.whiteColor()
        
        smallLineChart.animate(xAxisDuration: 2.5)
        
        
        var xValues: [String] = []
        var cancelledOrder: [String] = []
        var confirmedOrder: [String] = []
        
        let cal = NSCalendar.currentCalendar()
        
        
        let unit:NSCalendarUnit = .Day
        
        let difference = cal.components(unit, fromDate: startDate, toDate: endDate, options: [])
        

        for var i = 0; i < difference.day; i++ {
            xValues.append(formatDateToString(startDate.addDays(i)))
        }
        
        for var i = 0; i < salesReportModel.cancelledTransactionPerDay.count; i++ {
            cancelledOrder.append(formatDateToString(formatStringToDate(salesReportModel.cancelledTransactionPerDay[i].date)))
        }
        
        for var i = 0; i < salesReportModel.confirmedTransactionPerDay.count; i++ {
            confirmedOrder.append(formatDateToString(formatStringToDate(salesReportModel.confirmedTransactionPerDay[i].date)))
        }
        
        var soldItemEntries: [ChartDataEntry] = []
        var cancelledItemEntries: [ChartDataEntry] = []
        
        var soldItemIndex: Int = 0
        var cancelledItemIndex:Int = 0
        
        var maximumYVals: Int = 0
     
        for var i = 0; i < xValues.count; i++ {
            let date: String = xValues[i] as String
            
            if confirmedOrder.contains(date) {
                let tempNumber = salesReportModel.confirmedTransactionPerDay[soldItemIndex].numberOfOrders as NSString
                print("tempNumber\(i) \(tempNumber)")
                soldItemEntries.append(ChartDataEntry(value: tempNumber.doubleValue, xIndex: i))
                soldItemIndex++
                
                if tempNumber.integerValue > maximumYVals {
                    maximumYVals = tempNumber.integerValue
                }
                
            } else {
                soldItemEntries.append(ChartDataEntry(value: 0, xIndex: i))
            }
            
            if cancelledOrder.contains(date) {
                let tempNumber = salesReportModel.cancelledTransactionPerDay[cancelledItemIndex].numberOfOrders as NSString
                print("tempNumber\(i) \(tempNumber)")
                cancelledItemEntries.append(ChartDataEntry(value: tempNumber.doubleValue, xIndex: i))
                cancelledItemIndex++
                
                if tempNumber.integerValue > maximumYVals {
                    maximumYVals = tempNumber.integerValue
                }
            } else {
                cancelledItemEntries.append(ChartDataEntry(value: 0, xIndex: i))
            }
        }
        
        let soldItemDataSet: LineChartDataSet = LineChartDataSet(yVals: soldItemEntries, label: "Sold Items")
        soldItemDataSet.axisDependency = ChartYAxis.AxisDependency.Left
        soldItemDataSet.lineWidth = 5
        soldItemDataSet.setColor(Constants.Colors.soldLineColor)
        soldItemDataSet.setCircleColor(Constants.Colors.soldColor)
        soldItemDataSet.circleRadius = 8
        soldItemDataSet.setCircleColor(Constants.Colors.soldColor)
        soldItemDataSet.drawCircleHoleEnabled = false
        soldItemDataSet.valueTextColor = Constants.Colors.soldColor
        
        let cancelledItemDataSet: LineChartDataSet = LineChartDataSet(yVals: cancelledItemEntries, label: "Cancelled Items")
        cancelledItemDataSet.axisDependency = ChartYAxis.AxisDependency.Left
        cancelledItemDataSet.lineWidth = 5
        cancelledItemDataSet.setColor(Constants.Colors.cancelledLineColor)
        cancelledItemDataSet.setCircleColor(Constants.Colors.cancelledColor)
        cancelledItemDataSet.circleRadius = 7
        cancelledItemDataSet.setCircleColor(Constants.Colors.cancelledColor)
        cancelledItemDataSet.drawCircleHoleEnabled = false
        cancelledItemDataSet.valueTextColor = Constants.Colors.cancelledColor
        
        var lineDataSets: [LineChartDataSet] = []
        lineDataSets.append(soldItemDataSet)
        lineDataSets.append(cancelledItemDataSet)
        
        let data: LineChartData = LineChartData(xVals: xValues, dataSets: lineDataSets)
        largeLineChart.data = data
        
        //preview
        let soldItemDataSet1: LineChartDataSet = LineChartDataSet(yVals: soldItemEntries, label: "Sold Items")
        soldItemDataSet1.axisDependency = ChartYAxis.AxisDependency.Left
        soldItemDataSet1.lineWidth = 1
        soldItemDataSet1.setColor(Constants.Colors.soldLineColor)
        soldItemDataSet1.setCircleColor(Constants.Colors.soldColor)
        soldItemDataSet1.circleRadius = 2
        soldItemDataSet1.setCircleColor(Constants.Colors.soldColor)
        soldItemDataSet1.drawCircleHoleEnabled = false
        soldItemDataSet1.drawValuesEnabled = false
        
        let cancelledItemDataSet1: LineChartDataSet = LineChartDataSet(yVals: cancelledItemEntries, label: "Cancelled Items")
        cancelledItemDataSet1.axisDependency = ChartYAxis.AxisDependency.Left
        cancelledItemDataSet1.lineWidth = 1
        cancelledItemDataSet1.setColor(Constants.Colors.cancelledLineColor)
        cancelledItemDataSet1.setCircleColor(Constants.Colors.cancelledColor)
        cancelledItemDataSet1.circleRadius = 2
        cancelledItemDataSet1.setCircleColor(Constants.Colors.cancelledColor)
        cancelledItemDataSet1.drawCircleHoleEnabled = false
        cancelledItemDataSet1.drawValuesEnabled = false
        
        if maximumYVals > 1 {
            soldItemDataSet.valueFormatter = valueFormater
            cancelledItemDataSet.valueFormatter = valueFormater
            
            soldItemDataSet1.valueFormatter = valueFormater
            cancelledItemDataSet1.valueFormatter = valueFormater
            
            yAxisLeft.valueFormatter = valueFormater
        }
        
        var lineDataSets1: [LineChartDataSet] = []
        lineDataSets1.append(soldItemDataSet1)
        lineDataSets1.append(cancelledItemDataSet1)
        
        let data1: LineChartData = LineChartData(xVals: xValues, dataSets: lineDataSets1)
        smallLineChart.data = data1

        largeLineChart.zoom(0, scaleY: 0, x: 0, y: 0)
        largeLineChart.zoom(CGFloat(xValues.count > 4 ? xValues.count/4 : 0), scaleY: CGFloat(0), x: CGFloat(0), y: CGFloat(0))
        
    }
    
    func tappedView(){
        delegate?.changeDate()
    }

    func passModel(salesReportModel: SalesReportModel, startDate: NSDate, endDate: NSDate) {
        self.salesReportModel = salesReportModel
        
        totalSalesLabel.text = "P \(salesReportModel.totalSales)"
        totalProducts.text = "\(salesReportModel.productCount)"
        totalTransactionsLabel.text = "\(salesReportModel.totalTransactionCount)"
        
        
        self.startDate = startDate
        self.endDate = endDate
        
        initializeGraph()
    }
    
    func formatDateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.stringFromDate(date)
    }
    
    func formatStringToDate(date: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.dateFromString(date)!
    }
}
