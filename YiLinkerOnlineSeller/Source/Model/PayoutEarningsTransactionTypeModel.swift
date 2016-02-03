//
//  PayoutEarningsTransactionTypeModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutEarningsTransactionTypeModel: NSObject {
    
    var date: [String] = []
    var earningTypeId: [Int] = []
    var amount: [String] = []
    var currencyCode: [String] = []
    var status: [String] = []
    var boughtBy: [String] = []
    var productName: [String] = []
    var transactionNo: [String] = []
    
    var date2: String = ""
    var earningTypeId2: Int = 0
    var amount2: String = ""
    var currencyCode2: String = ""
    var status2: String = ""
    var boughtBy2: String = ""
    var productName2: String = ""
    var transactionNo2: String = ""
    
    init(date: NSArray, earningTypeId: NSArray, amount: NSArray, currencyCode: NSArray, status: NSArray, transactionNo: NSArray, productName: NSArray, boughtBy: NSArray) {
        self.date = date as! [String]
        self.earningTypeId = earningTypeId as! [Int]
        self.amount = amount as! [String]
        self.currencyCode = currencyCode as! [String]
        self.status = status as! [String]
        self.transactionNo = transactionNo as! [String]
        self.productName = productName as! [String]
        self.boughtBy = boughtBy as! [String]
    }
    
    init(date2: String, earningTypeId2: Int, amount2: String, currencyCode2: String, status2: String, transactionNo2: String, productName2: String, boughtBy2: String) {
        self.date2 = date2 as String
        self.earningTypeId2 = earningTypeId2 as Int
        self.amount2 = amount2 as String
        self.currencyCode2 = currencyCode2 as String
        self.status2 = status2 as String
        self.transactionNo2 = transactionNo2 as String
        self.productName2 = productName2 as String
        self.boughtBy2 = boughtBy2 as String
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> PayoutEarningsTransactionTypeModel {
        
        var date: [String] = []
        var earningTypeId: [Int] = []
        var amount: [String] = []
        var currencyCode: [String] = []
        var status: [String] = []
        var boughtBy: [String] = []
        var productName: [String] = []
        var transactionNo: [String] = []
        
        if let request: AnyObject = dictionary["data"] {
            if let value = request["earnings"] as? NSArray {
                for subValue in value as NSArray {
                    date.append(subValue["date"] as! String)
                    earningTypeId.append(subValue["earningTypeId"] as! Int)
                    amount.append(subValue["amount"] as! String)
                    currencyCode.append(subValue["currencyCode"] as! String)
                    status.append(subValue["status"] as! String)
                    boughtBy.append(subValue["boughtBy"] as! String)
                    productName.append(subValue["productName"] as! String)
                    transactionNo.append(subValue["transactionNo"] as! String)
                }
            }
        }
        
        return PayoutEarningsTransactionTypeModel(date: date, earningTypeId: earningTypeId, amount: amount, currencyCode: currencyCode, status: status, transactionNo: transactionNo, productName: productName, boughtBy: boughtBy)
    }
}
