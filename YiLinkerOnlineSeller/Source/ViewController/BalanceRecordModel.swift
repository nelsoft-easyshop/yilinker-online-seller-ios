//
//  BalanceRecordModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

typealias EarningsElement = (amount: Int, date: String)

class BalanceRecordModel: NSObject {
   
    var availableBalance: Int = 0
    var currencyCode: String = ""
    var activeEarning: Int = 0
    var tentativeEarning: Int = 0
    var totalEarning: Int = 0
    var totalWithdrew: Int = 0
    var totalWithdrewInProcess: Int = 0
    var earnings: [EarningsElement]
    
    init(availableBalance: Int, currencyCode: String, activeEarning: Int, tentativeEarning: Int, totalEarning: Int, totalWithdrew: Int, totalWithdrewInProcess: Int, earnings: [EarningsElement]) {
        
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
        var availableBalance: Int = 0
        var currencyCode: String = ""
        var activeEarning: Int = 0
        var tentativeEarning: Int = 0
        var totalEarning: Int = 0
        var totalWithdrew: Int = 0
        var totalWithdrewInProcess: Int = 0
        var earnings = [EarningsElement]()
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let data = dictionary["data"] as? NSDictionary {
                availableBalance = ParseHelper.int(data, key: "availableBalance", defaultValue: 0)
                currencyCode = ParseHelper.string(data, key: "currencyCode", defaultValue: "")
                activeEarning = ParseHelper.int(data, key: "activeEarning", defaultValue: 0)
                tentativeEarning = ParseHelper.int(data, key: "tentativeEarning", defaultValue: 0)
                totalEarning = ParseHelper.int(data, key: "totalEarning", defaultValue: 0)
                totalWithdrew = ParseHelper.int(data, key: "totalWidthrew", defaultValue: 0)
                totalWithdrewInProcess = ParseHelper.int(data, key: "totalWidthrewInProcess", defaultValue: 0)
                
                var element: EarningsElement
                for earning in data["earnings"] as! NSArray {
                    element.amount = ParseHelper.int(earning, key: "amount", defaultValue: 0)
                    element.date = ParseHelper.string(earning, key: "date", defaultValue: "")
                    earnings.append(element)
                }
            }
            
            
            return BalanceRecordModel(availableBalance: availableBalance, currencyCode: currencyCode, activeEarning: activeEarning, tentativeEarning: tentativeEarning, totalEarning: totalEarning, totalWithdrew: totalWithdrew, totalWithdrewInProcess: totalWithdrewInProcess, earnings: earnings)
        }
        
        return BalanceRecordModel(availableBalance: 0, currencyCode: "", activeEarning: 0, tentativeEarning: 0, totalEarning: 0, totalWithdrew: 0, totalWithdrewInProcess: 0, earnings: earnings)
    }
}
