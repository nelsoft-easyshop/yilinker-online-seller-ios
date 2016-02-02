//
//  PayoutEarningsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutEarningsModel: NSObject {
    
    var earningType: String = ""
    var earningTypeId: Int = 0
    var earningAmount: String = ""
    var currencyCode: String = ""
    
    static var payoutEarningsModel: [PayoutEarningsModel] = []
    
    init(earningType: String, earningTypeId: Int, earningAmount: String, currencyCode: String) {
        self.earningType = earningType as String
        self.earningTypeId = earningTypeId as Int
        self.earningAmount = earningAmount as String
        self.currencyCode = currencyCode as String
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> [PayoutEarningsModel] {
        
        var earningType: String = ""
        var earningTypeId: Int = 0
        var earningAmount: String = ""
        var currencyCode: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let request: AnyObject = dictionary["data"] {
                if let value = request["earningGroups"] as? NSArray {
                    for subValue in value as NSArray {
                        if let tempName = subValue["name"] as? String {
                            earningType = tempName
                        }
                        
                        if let tempTypeId = subValue["earningTypeId"] as? Int {
                            earningTypeId = tempTypeId
                        }
                        
                        if let tempTotalAmount = subValue["totalAmount"] as? String {
                            earningAmount = tempTotalAmount
                        }
                        
                        if let tempCurrencyCode = subValue["currencyCode"] as? String {
                            currencyCode = tempCurrencyCode
                        }
                        self.payoutEarningsModel.append(PayoutEarningsModel(earningType: earningType, earningTypeId: earningTypeId, earningAmount: earningAmount, currencyCode: currencyCode))
                    }
                }
            }
        }
        
        return self.payoutEarningsModel
    }
}
