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
