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
    
    static var payoutRequestListModel: [PayoutRequestListModel] = []
    
    init(date: String, withdrawalMethod: String, totalAmount: String, charge: String, netAmount: String, currencyCode: String, status: String, payTo: String, bankName: String, accountNumber: String, accountName: String) {
        self.date = date as String
        self.withdrawalMethod = withdrawalMethod as String
        self.totalAmount = totalAmount as String
        self.charge = charge as String
        self.netAmount = netAmount as String
        self.currencyCode = currencyCode as String
        self.status = status as String
        self.payTo = payTo as String
        self.bankName = bankName as String
        self.accountName = accountName as String
        self.accountNumber = accountNumber as String
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> [PayoutRequestListModel] {
        
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
                        
                        if let tempDate = subValue["date"] as? String {
                            date = tempDate
                        }
                        
                        if let tempWithdrawalMethod = subValue["withdrawalMethod"] as? String {
                            withdrawalMethod = tempWithdrawalMethod
                        }
                        
                        if let tempTotalAmount = subValue["totalAmount"] as? String {
                            totalAmount = tempTotalAmount
                        }
                        
                        if let tempCharge = subValue["charge"] as? String {
                            charge = tempCharge
                        }
                        
                        if let tempNetAmount = subValue["netAmount"] as? String {
                            netAmount = tempNetAmount
                        }
                        
                        if let tempcCurrencyCode = subValue["currencyCode"] as? String {
                            currencyCode = tempcCurrencyCode
                        }
                        
                        if let tempStatus = subValue["status"] as? String {
                            status = tempStatus
                        }
                        
                        if let tempPayTo = subValue["payTo"] as? String {
                            payTo = tempPayTo
                        }
                        
                        if let tempBankName = subValue["bankName"] as? String {
                            bankName = tempBankName
                        }
                        
                        if let tempAccountNumber = subValue["accountNumber"] as? String {
                            accountNumber = tempAccountNumber
                        }
                        
                        if let tempAccountName = subValue["accountName"] as? String {
                            accountName = tempAccountName
                        }
                        
                        self.payoutRequestListModel.append(PayoutRequestListModel(date: date, withdrawalMethod: withdrawalMethod, totalAmount: totalAmount, charge: charge, netAmount: netAmount, currencyCode: currencyCode, status: status, payTo: payTo, bankName: bankName, accountNumber: accountNumber, accountName: accountName))
                    }
                }
            }
        }
        
        return self.payoutRequestListModel
    }
}
