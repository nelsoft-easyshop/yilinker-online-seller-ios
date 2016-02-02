//
//  PayoutEarningsTypeModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutEarningsTypeModel: NSObject {
    
    var date: String = ""
    var earningTypeId: Int = 0
    var amount: String = ""
    var currencyCode: String = ""
    var status: String = ""
    
    var boughtBy: String = ""
    var productName: String = ""
    var transactionNo: String = ""
    
    static var payoutEarningsTypeModel: [PayoutEarningsTypeModel] = []
    
    init(date: String, earningTypeId: Int, amount: String, currencyCode: String, status: String) {
        self.date = date as String
        self.earningTypeId = earningTypeId as Int
        self.amount = amount as String
        self.currencyCode = currencyCode as String
        self.status = status as String
    }
    
    init(date: String, earningTypeId: Int, amount: String, currencyCode: String, status: String, boughtBy: String, productName: String, transactionNo: String) {
        self.date = date as String
        self.earningTypeId = earningTypeId as Int
        self.amount = amount as String
        self.currencyCode = currencyCode as String
        self.status = status as String
        self.boughtBy = boughtBy as String
        self.productName = productName as String
        self.transactionNo = transactionNo as String
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> [PayoutEarningsTypeModel] {
        
        var date: String = ""
        var earningTypeId: Int = 0
        var amount: String = ""
        var currencyCode: String = ""
        var status: String = ""
        
        if let request: AnyObject = dictionary["data"] {
            if let value = request["earnings"] as? NSArray {
                for subValue in value as NSArray {
                    if let tempDate = subValue["date"] as? String {
                        date = tempDate
                    }
                    
                    if let tempTypeId = subValue["earningTypeId"] as? Int {
                        earningTypeId = tempTypeId
                    }
                    
                    if let tempAmount = subValue["amount"] as? String {
                        amount = tempAmount
                    }
                    
                    if let tempCurrencyCode = subValue["currencyCode"] as? String {
                        currencyCode = tempCurrencyCode
                    }
                    
                    if let tempStatus = subValue["status"] as? String {
                        status = tempStatus
                    }
                    self.payoutEarningsTypeModel.append(PayoutEarningsTypeModel(date: date, earningTypeId: earningTypeId, amount: amount, currencyCode: currencyCode, status: status))
                }
            }
        }
        
        return self.payoutEarningsTypeModel
    }
    
    class func parseTransactionDataWithDictionary(dictionary: AnyObject) -> [PayoutEarningsTypeModel] {
        
        var date: String = ""
        var earningTypeId: Int = 0
        var amount: String = ""
        var currencyCode: String = ""
        var status: String = ""
        var boughtBy: String = ""
        var productName: String = ""
        var transactionNo: String = ""
        
        if let request: AnyObject = dictionary["data"] {
            if let value = request["earnings"] as? NSArray {
                for subValue in value as NSArray {
                    if let tempDate = subValue["date"] as? String {
                        date = tempDate
                    }
                    
                    if let tempTypeId = subValue["earningTypeId"] as? Int {
                        earningTypeId = tempTypeId
                    }
                    
                    if let tempAmount = subValue["amount"] as? String {
                        amount = tempAmount
                    }
                    
                    if let tempCurrencyCode = subValue["currencyCode"] as? String {
                        currencyCode = tempCurrencyCode
                    }
                    
                    if let tempStatus = subValue["status"] as? String {
                        status = tempStatus
                    }
                    
                    if let tempBoughtBy = subValue["boughtBy"] as? String {
                        boughtBy = tempBoughtBy
                    }
                    
                    if let tempProductName = subValue["productName"] as? String {
                        productName = tempProductName
                    }
                    
                    if let tempTransctionNo = subValue["transactionNo"] as? String {
                        transactionNo = tempTransctionNo
                    }
                    
                    self.payoutEarningsTypeModel.append(PayoutEarningsTypeModel(date: date, earningTypeId: earningTypeId, amount: amount, currencyCode: currencyCode, status: status, boughtBy: boughtBy, productName: productName, transactionNo: transactionNo))
                }
            }
        }
        
        return self.payoutEarningsTypeModel
    }
}
