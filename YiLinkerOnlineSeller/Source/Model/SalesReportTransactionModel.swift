//
//  SalesReportTransactionModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/7/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class SalesReportTransactionModel: NSObject {
   
    var date: String = ""
    var numberOfOrders: String = ""
    
    init(date: String, numberOfOrders: String) {
        self.date = date
        self.numberOfOrders = numberOfOrders
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> SalesReportTransactionModel {
        
        var date: String = ""
        var numberOfOrders: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["date"] != nil {
                if let tempVar = dictionary["date"] as? String {
                    date = tempVar
                }
            }
            
            if dictionary["numberOfOrders"] != nil {
                if let tempVar = dictionary["numberOfOrders"] as? String {
                    numberOfOrders = tempVar
                }
            }
        }
        
        return SalesReportTransactionModel(date: date, numberOfOrders: numberOfOrders)
    }

}
