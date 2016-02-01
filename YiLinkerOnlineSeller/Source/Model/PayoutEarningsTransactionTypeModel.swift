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
