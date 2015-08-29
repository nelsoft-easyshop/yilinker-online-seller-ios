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
    @IBOutlet weak var smallLineChart: LineChartView!
    @IBOutlet weak var totalSalesLabel: UILabel!
    @IBOutlet weak var totalTransactionsLabel: UILabel!
    @IBOutlet weak var totalProducts: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
    }

    func initializeViews() {
        soldCircleView.layer.cornerRadius = soldCircleView.frame.height / 2
        cancelledCircleView.layer.cornerRadius = cancelledCircleView.frame.height / 2
        
        let tapRec = UITapGestureRecognizer()
        tapRec.addTarget(self, action: "tappedView")
        
        calendarView.addGestureRecognizer(tapRec)
    }
    
    func tappedView(){
        delegate?.changeDate()
    }

    

}
