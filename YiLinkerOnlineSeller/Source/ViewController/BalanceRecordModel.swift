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
    
    init(availableBalance: String, currencyCode: String, activeEarning: String, tentativeEarning: String, totalEarning: String, totalWithdrew: String, totalWithdrewInProcess: String, earnings: [EarningsElement]) {
        
        self.availableBalance = availableBalance
        self.currencyCode = currencyCode
        self.activeEarning = activeEarning
        self.tentativeEarning = tentativeEarning
        self.totalEarning = totalEarning
        self.totalWithdrew = totalWithdrew
        self.totalWithdrewInProcess = totalWithdrewInProcess
        self.earnings = earnings
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
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let data = dictionary["data"] as? NSDictionary {
                availableBalance = ParseHelper.string(data, key: "availableBalance", defaultValue: "")
                currencyCode = ParseHelper.string(data, key: "currencyCode", defaultValue: "")
                activeEarning = ParseHelper.string(data, key: "activeEarning", defaultValue: "")
                tentativeEarning = ParseHelper.string(data, key: "tentativeEarning", defaultValue: "")
                totalEarning = ParseHelper.string(data, key: "totalEarning", defaultValue: "")
                totalWithdrew = ParseHelper.string(data, key: "totalWidthrew", defaultValue: "")
                totalWithdrewInProcess = ParseHelper.string(data, key: "totalWidthrewInProcess", defaultValue: "")
                
                var element: EarningsElement
                for earning in data["earnings"] as! NSArray {
                    element.amount = ParseHelper.string(earning, key: "amount", defaultValue: "")
                    element.date = ParseHelper.string(earning, key: "date", defaultValue: "")
                    earnings.append(element)
                }
            }
            
            return BalanceRecordModel(availableBalance: availableBalance, currencyCode: currencyCode, activeEarning: activeEarning, tentativeEarning: tentativeEarning, totalEarning: totalEarning, totalWithdrew: totalWithdrew, totalWithdrewInProcess: totalWithdrewInProcess, earnings: earnings)
        }
        
        return BalanceRecordModel(availableBalance: "", currencyCode: "", activeEarning: "", tentativeEarning: "", totalEarning: "", totalWithdrew: "", totalWithdrewInProcess: "", earnings: earnings)
    }
}
