//
//  PayoutRequestListModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 1/29/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutRequestListModel: NSObject {
   
    var date: [String] = []
    var withdrawalMethod: [String] = []
    var totalAmount: [String] = []
    var charge: [String] = []
    var netAmount: [String] = []
    var currencyCode: [String] = []
    var status: [String] = []
    var payTo: [String] = []
    var bankName: [String] = []
    var accountNumber: [String] = []
    var accountName: [String] = []
    
    var date2: String = ""
    var withdrawalMethod2: String = ""
    var totalAmount2: String = ""
    var charge2: String = ""
    var netAmount2: String = ""
    var currencyCode2: String = ""
    var status2: String = ""
    var payTo2: String = ""
    var bankName2: String = ""
    var accountNumber2: String = ""
    var accountName2: String = ""
    
    init(date2: String, withdrawalMethod2: String, totalAmount2: String, charge2: String, netAmount2: String, currencyCode2: String, status2: String, payTo2: String, bankName2: String, accountNumber2: String, accountName2: String) {
        self.date2 = date2 as String
        self.withdrawalMethod2 = withdrawalMethod2 as String
        self.totalAmount2 = totalAmount2 as String
        self.charge2 = charge2 as String
        self.netAmount2 = netAmount2 as String
        self.currencyCode2 = currencyCode2 as String
        self.status2 = status2 as String
        self.payTo2 = payTo2 as String
        self.bankName2 = bankName2 as String
        self.accountName2 = accountName2 as String
        self.accountNumber2 = accountNumber2 as String
    }
    
    init(date: NSArray, withdrawalMethod: NSArray, totalAmount: NSArray, charge: NSArray, netAmount: NSArray, currencyCode: NSArray, status: NSArray, payTo: NSArray, bankName: NSArray, accountNumber: NSArray, accountName: NSArray) {
        self.date = date as! [String]
        self.withdrawalMethod = withdrawalMethod as! [String]
        self.totalAmount = totalAmount as! [String]
        self.charge = charge as! [String]
        self.netAmount = netAmount as! [String]
        self.currencyCode = currencyCode as! [String]
        self.status = status as! [String]
        self.payTo = payTo as! [String]
        self.bankName = bankName as! [String]
        self.accountName = accountName as! [String]
        self.accountNumber = accountNumber as! [String]
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> PayoutRequestListModel {
        
        var date: [String] = []
        var withdrawalMethod: [String] = []
        var totalAmount: [String] = []
        var charge: [String] = []
        var netAmount: [String] = []
        var currencyCode: [String] = []
        var status: [String] = []
        var payTo: [String] = []
        var bankName: [String] = []
        var accountNumber: [String] = []
        var accountName: [String] = []
        
        if let request: AnyObject = dictionary["data"] {
            if let value = request["requests"] as? NSArray {
                for subValue in value as NSArray {
                    date.append(subValue["date"] as! String)
                    withdrawalMethod.append(subValue["withdrawalMethod"] as! String)
                    totalAmount.append(subValue["totalAmount"] as! String)
                    charge.append(subValue["charge"] as! String)
                    netAmount.append(subValue["netAmount"] as! String)
                    currencyCode.append(subValue["currencyCode"] as! String)
                    status.append(subValue["status"] as! String)
                    payTo.append(subValue["payTo"] as! String)
                    bankName.append(subValue["bankName"] as! String)
                    accountNumber.append(subValue["accountNumber"] as! String)
                    accountName.append(subValue["accountName"] as! String)
                }
            }
        }
        
        return PayoutRequestListModel(date: date, withdrawalMethod: withdrawalMethod, totalAmount: totalAmount, charge: charge, netAmount: netAmount, currencyCode: currencyCode, status: status, payTo: payTo, bankName: bankName, accountNumber: accountNumber, accountName: accountName)
    }
}
