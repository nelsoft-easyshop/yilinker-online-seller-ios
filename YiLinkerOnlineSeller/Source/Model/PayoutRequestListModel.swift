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
                        
                        if let tempDate = subValue["date"] as? String {
                            date = formatDate(tempDate)
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
