//
//  SalesReportModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/7/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class SalesReportModel: NSObject {
    var isSuccessful: Bool = false
    var message: String = ""
    
    var productCount: Int = 0
    var totalTransactionCount: Int = 0
    var totalSales: String = ""
    var confirmedTransactionPerDay: [SalesReportTransactionModel] = []
    var cancelledTransactionPerDay: [SalesReportTransactionModel] = []
    
    init(isSuccessful: Bool, message: String, productCount: Int, totalTransactionCount: Int, totalSales: String, confirmedTransactionPerDay: [SalesReportTransactionModel],cancelledTransactionPerDay: [SalesReportTransactionModel]) {
        
        self.isSuccessful = isSuccessful
        self.message = message
        self.productCount = productCount
        self.totalTransactionCount = totalTransactionCount
        self.totalSales = totalSales
        self.confirmedTransactionPerDay = confirmedTransactionPerDay
        self.cancelledTransactionPerDay = cancelledTransactionPerDay
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> SalesReportModel {
        
        var isSuccessful: Bool = false
        var message: String = ""
        
        var productCount: Int = 0
        var totalTransactionCount: Int = 0
        var totalSales: String = ""
        var confirmedTransactionPerDay: [SalesReportTransactionModel] = []
        var cancelledTransactionPerDay: [SalesReportTransactionModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["message"] != nil {
                if let tempVar = dictionary["message"] as? String {
                    message = tempVar
                }
            }
            
            if dictionary["isSuccessful"] != nil {
                if let tempVar = dictionary["isSuccessful"] as? Bool {
                    isSuccessful = tempVar
                }
            }
            
            if dictionary["data"] != nil {
                if let tempDict = dictionary["data"] as? NSDictionary {
                    if tempDict["productCount"] != nil {
                        if let tempVar = tempDict["productCount"] as? Int {
                            productCount = tempVar
                        }
                    }
                    
                    if tempDict["totalTransactionCount"] != nil {
                        if let tempVar = tempDict["totalTransactionCount"] as? Int {
                            totalTransactionCount = tempVar
                        }
                    }
                    
                    if tempDict["totalSales"] != nil {
                        if let tempVar = tempDict["totalSales"] as? String {
                            totalSales = tempVar
                        }
                    }
                    
                    if tempDict["confirmedTransactionPerDay"] != nil {
                        for subValue in tempDict["confirmedTransactionPerDay"] as! NSArray {
                            let model: SalesReportTransactionModel = SalesReportTransactionModel.parseDataWithDictionary(subValue as! NSDictionary)
                            confirmedTransactionPerDay.append(model)
                        }
                    }
                    
                    if tempDict["cancelledTransactionPerDay"] != nil {
                        for subValue in tempDict["cancelledTransactionPerDay"] as! NSArray {
                            let model: SalesReportTransactionModel = SalesReportTransactionModel.parseDataWithDictionary(subValue as! NSDictionary)
                            cancelledTransactionPerDay.append(model)
                        }
                    }
                }
            }
        }
        
        return SalesReportModel(isSuccessful: isSuccessful, message: message, productCount: productCount, totalTransactionCount: totalTransactionCount, totalSales: totalSales, confirmedTransactionPerDay: confirmedTransactionPerDay, cancelledTransactionPerDay: cancelledTransactionPerDay)
    }
}
