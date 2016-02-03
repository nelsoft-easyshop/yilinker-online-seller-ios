//
//  PayoutRequestListModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 1/29/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutRequestListModel: NSObject {
    
    var date: String = ""
    var withdrawalMethod: String = ""
    var totalAmount: String = ""
    var charge: String = ""
    var netAmount: String = ""
    var currencyCode: String = ""
    var status: String = ""
    var payTo: String = ""
    var bankName: String = ""
    var accountNumber: String = ""
    var accountName: String = ""
    
    init(date: String, withdrawalMethod: String, totalAmount: String, charge: String, netAmount: String, currencyCode: String, status: String, payTo: String, bankName: String, accountNumber: String, accountName: String) {
        self.date = date
        self.withdrawalMethod = withdrawalMethod
        self.totalAmount = totalAmount
        self.charge = charge
        self.netAmount = netAmount
        self.currencyCode = currencyCode
        self.status = status
        self.payTo = payTo
        self.bankName = bankName
        self.accountName = accountName
        self.accountNumber = accountNumber 
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> [PayoutRequestListModel] {
        
        var payoutRequestListModel: [PayoutRequestListModel] = []
        
        var date: String = ""
        var withdrawalMethod: String = ""
        var totalAmount: String = ""
        var charge: String = ""
        var netAmount: String = ""
        var currencyCode: String = ""
        var status: String = ""
        var payTo: String = ""
        var bankName: String = ""
        var accountNumber: String = ""
        var accountName: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let request: AnyObject = dictionary["data"] {
                if let value = request["requests"] as? NSArray {
                    for subValue in value as NSArray {
                        
                        date = formatDate(ParseHelper.string(subValue, key: "date", defaultValue: ""))
                        withdrawalMethod = ParseHelper.string(subValue, key: "withdrawalMethod", defaultValue: "")
                        totalAmount = ParseHelper.string(subValue, key: "totalAmount", defaultValue: "")
                        charge = ParseHelper.string(subValue, key: "charge", defaultValue: "")
                        netAmount = ParseHelper.string(subValue, key: "netAmount", defaultValue: "")
                        currencyCode = ParseHelper.string(subValue, key: "currencyCode", defaultValue: "")
                        status = ParseHelper.string(subValue, key: "status", defaultValue: "")
                        payTo = ParseHelper.string(subValue, key: "payTo", defaultValue: "")
                        bankName = ParseHelper.string(subValue, key: "bankName", defaultValue: "")
                        accountNumber = ParseHelper.string(subValue, key: "accountNumber", defaultValue: "")
                        accountName = ParseHelper.string(subValue, key: "accountName", defaultValue: "")
                        
                        payoutRequestListModel.append(PayoutRequestListModel(date: date, withdrawalMethod: withdrawalMethod, totalAmount: totalAmount, charge: charge, netAmount: netAmount, currencyCode: currencyCode, status: status, payTo: payTo, bankName: bankName, accountNumber: accountNumber, accountName: accountName))
                    }
                }
            }
        }
        
        return payoutRequestListModel
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
