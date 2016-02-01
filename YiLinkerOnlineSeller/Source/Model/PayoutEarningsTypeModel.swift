//
//  PayoutEarningsTypeModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutEarningsTypeModel: NSObject {
    
    var date: [String] = []
    var earningTypeId: [Int] = []
    var amount: [String] = []
    var currencyCode: [String] = []
    var status: [String] = []
    
    init(date: NSArray, earningTypeId: NSArray, amount: NSArray, currencyCode: NSArray, status: NSArray) {
        self.date = date as! [String]
        self.earningTypeId = earningTypeId as! [Int]
        self.amount = amount as! [String]
        self.currencyCode = currencyCode as! [String]
        self.status = status as! [String]
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> PayoutEarningsTypeModel {
        
        var date: [String] = []
        var earningTypeId: [Int] = []
        var amount: [String] = []
        var currencyCode: [String] = []
        var status: [String] = []
        
        if let request: AnyObject = dictionary["data"] {
            if let value = request["earnings"] as? NSArray {
                for subValue in value as NSArray {
                    date.append(subValue["date"] as! String)
                    earningTypeId.append(subValue["earningTypeId"] as! Int)
                    amount.append(subValue["amount"] as! String)
                    currencyCode.append(subValue["currencyCode"] as! String)
                    status.append(subValue["status"] as! String)
                }
            }
        }
        
        return PayoutEarningsTypeModel(date: date, earningTypeId: earningTypeId, amount: amount, currencyCode: currencyCode, status: status)
    }
}
