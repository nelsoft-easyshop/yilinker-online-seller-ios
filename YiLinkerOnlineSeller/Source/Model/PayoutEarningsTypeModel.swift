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
    
    init(date: String, earningTypeId: Int, amount: String, currencyCode: String, status: String) {
        self.date = date
        self.earningTypeId = earningTypeId
        self.amount = amount
        self.currencyCode = currencyCode
        self.status = status
    }
    
    init(date: String, earningTypeId: Int, amount: String, currencyCode: String, status: String, boughtBy: String, productName: String, transactionNo: String) {
        self.date = date
        self.earningTypeId = earningTypeId
        self.amount = amount
        self.currencyCode = currencyCode
        self.status = status
        self.boughtBy = boughtBy
        self.productName = productName
        self.transactionNo = transactionNo
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> [PayoutEarningsTypeModel] {
        
        var payoutEarningsTypeModel: [PayoutEarningsTypeModel] = []
        
        var date: String = ""
        var earningTypeId: Int = 0
        var amount: String = ""
        var currencyCode: String = ""
        var status: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let request: AnyObject = dictionary["data"] {
                if let value = request["earnings"] as? NSArray {
                    for subValue in value as NSArray {
                        
                        date = formatDate(ParseHelper.string(subValue, key: "date", defaultValue: ""))
                        earningTypeId = ParseHelper.int(subValue, key: "earningTypeId", defaultValue: 0)
                        amount = ParseHelper.string(subValue, key: "amount", defaultValue: "")
                        currencyCode = ParseHelper.string(subValue, key: "currencyCode", defaultValue: "")
                        status = ParseHelper.string(subValue, key: "status", defaultValue: "")
                        
                        payoutEarningsTypeModel.append(PayoutEarningsTypeModel(date: date, earningTypeId: earningTypeId, amount: amount, currencyCode: currencyCode, status: status))
                    }
                }
            }
        }
        
        return payoutEarningsTypeModel
    }
    
    class func parseTransactionDataWithDictionary(dictionary: AnyObject) -> [PayoutEarningsTypeModel] {
        
        var payoutEarningsTypeModel: [PayoutEarningsTypeModel] = []
        
        var date: String = ""
        var earningTypeId: Int = 0
        var amount: String = ""
        var currencyCode: String = ""
        var status: String = ""
        var boughtBy: String = ""
        var productName: String = ""
        var transactionNo: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let request: AnyObject = dictionary["data"] {
                if let value = request["earnings"] as? NSArray {
                    for subValue in value as NSArray {
                        
                        date = formatDate(ParseHelper.string(subValue, key: "date", defaultValue: ""))
                        earningTypeId = ParseHelper.int(subValue, key: "earningTypeId", defaultValue: 0)
                        amount = ParseHelper.string(subValue, key: "amount", defaultValue: "")
                        currencyCode = ParseHelper.string(subValue, key: "currencyCode", defaultValue: "")
                        status = ParseHelper.string(subValue, key: "status", defaultValue: "")
                        boughtBy = ParseHelper.string(subValue, key: "boughtBy", defaultValue: "")
                        productName = ParseHelper.string(subValue, key: "productName", defaultValue: "")
                        transactionNo = ParseHelper.string(subValue, key: "transactionNo", defaultValue: "")
                        
                        payoutEarningsTypeModel.append(PayoutEarningsTypeModel(date: date, earningTypeId: earningTypeId, amount: amount, currencyCode: currencyCode, status: status, boughtBy: boughtBy, productName: productName, transactionNo: transactionNo))
                    }
                }
            }
        }
        
        return payoutEarningsTypeModel
    }
    
    class func formatDate(date: String) -> String {
        
        let date: String? = "\(date)"
        let dateFromString = NSDateFormatter()
        dateFromString.dateFormat = "yyyy-MM-dd"
        dateFromString.dateFromString(date!)
        
        let stringFromDate = NSDateFormatter()
        stringFromDate.dateFormat = "MM/dd/yyyy"
        let formattedDate = stringFromDate.stringFromDate(dateFromString.dateFromString(date!)!)
        
        return formattedDate
    }
}
