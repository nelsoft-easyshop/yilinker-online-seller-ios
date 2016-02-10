//
//  BalanceRecordModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

typealias EarningsElement = (amount: String, date: String)

class BalanceRecordModel: NSObject {
   
    var availableBalance: String = ""
    var currencyCode: String = ""
    var activeEarning: String = ""
    var tentativeEarning: String = ""
    var totalEarning: String = ""
    var totalWithdrew: String = ""
    var totalWithdrewInProcess: String = ""
    var earnings: [EarningsElement]
    
    var fullName: String = ""
    var contact_number: String = ""
    var accountTitle: String = ""
    var bankId: Int = 0
    var bankName: String = ""
    var accountName: String = ""
    var accountNumber: String = ""
    var bankAccount: String = ""
    
    init(availableBalance: String, currencyCode: String, activeEarning: String, tentativeEarning: String, totalEarning: String, totalWithdrew: String, totalWithdrewInProcess: String, earnings: [EarningsElement], fullName: String, contact_number: String, account_title: String, bank_id: Int, bank_name: String, account_name: String, account_number: String, bank_account: String) {
        
        self.availableBalance = availableBalance
        self.currencyCode = currencyCode
        self.activeEarning = activeEarning
        self.tentativeEarning = tentativeEarning
        self.totalEarning = totalEarning
        self.totalWithdrew = totalWithdrew
        self.totalWithdrewInProcess = totalWithdrewInProcess
        self.earnings = earnings
     
        self.fullName = fullName
        self.contact_number = contact_number
        self.accountTitle = account_title
        self.bankId = bank_id
        self.bankName = bank_name
        self.accountName = account_name
        self.accountNumber = account_number
        self.bankAccount = bank_account
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> BalanceRecordModel {
        var availableBalance: String = ""
        var currencyCode: String = ""
        var activeEarning: String = ""
        var tentativeEarning: String = ""
        var totalEarning: String = ""
        var totalWithdrew: String = ""
        var totalWithdrewInProcess: String = ""
        var earnings = [EarningsElement]()
        
        var fullName: String = ""
        var contact_number: String = ""
        var accountTitle: String = ""
        var bankId: Int = 0
        var bankName: String = ""
        var accountName: String = ""
        var accountNumber: String = ""
        var bankAccount: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            println(dictionary)
            if let data = dictionary["data"] as? NSDictionary {
                availableBalance = ParseHelper.string(data, key: "availableBalance", defaultValue: "0.00")
                currencyCode = ParseHelper.string(data, key: "currencyCode", defaultValue: "₱")
                activeEarning = ParseHelper.string(data, key: "activeEarning", defaultValue: "0.00")
                tentativeEarning = ParseHelper.string(data, key: "tentativeEarning", defaultValue: "0.00")
                totalEarning = ParseHelper.string(data, key: "totalEarning", defaultValue: "0.00")
                totalWithdrew = ParseHelper.string(data, key: "totalWithdrew", defaultValue: "0.00")
                totalWithdrewInProcess = ParseHelper.string(data, key: "totalWithdrewInProcess", defaultValue: "0.00")
                
                var element: EarningsElement
                for earning in data["earnings"] as! NSArray {
                    element.amount = ParseHelper.string(earning, key: "amount", defaultValue: "0.00")
                    element.date = ParseHelper.string(earning, key: "date", defaultValue: "")
                    earnings.append(element)
                }
                
                fullName = ParseHelper.string(data, key: "fullName", defaultValue: "")
                contact_number = ParseHelper.string(data, key: "contactNumber", defaultValue: "")
                
                if let bank: AnyObject = data["bankDetails"] {
                    accountTitle = ParseHelper.string(bank, key: "accountTitle", defaultValue: "")
                    bankId = ParseHelper.int(bank, key: "bankId", defaultValue: 0)
                    bankName = ParseHelper.string(bank, key: "bankName", defaultValue: "")
                    accountName = ParseHelper.string(bank, key: "accountName", defaultValue: "")
                    accountNumber = ParseHelper.string(bank, key: "accountNumber", defaultValue: "")
                    bankAccount = bankName + " | " + accountName + " | " + accountNumber
                }
            }
            
            return BalanceRecordModel(availableBalance: availableBalance,
                currencyCode: currencyCode,
                activeEarning: activeEarning,
                tentativeEarning: tentativeEarning,
                totalEarning: totalEarning,
                totalWithdrew: totalWithdrew,
                totalWithdrewInProcess: totalWithdrewInProcess,
                earnings: earnings,
                fullName: fullName,
                contact_number: contact_number,
                account_title: accountTitle,
                bank_id: bankId,
                bank_name: bankName,
                account_name: accountName,
                account_number: accountNumber,
                bank_account: bankAccount)
        }
        
        return BalanceRecordModel(availableBalance: "0.00",
            currencyCode: "P",
            activeEarning: "0.00",
            tentativeEarning: "0.00",
            totalEarning: "0.00",
            totalWithdrew: "0.00",
            totalWithdrewInProcess: "0.00",
            earnings: earnings,
            fullName: "",
            contact_number: "",
            account_title: "",
            bank_id: 0,
            bank_name: "",
            account_name: "",
            account_number: "",
            bank_account: "")
    }
}
