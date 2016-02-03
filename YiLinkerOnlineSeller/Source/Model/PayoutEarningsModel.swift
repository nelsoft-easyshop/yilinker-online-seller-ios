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
    
    init(earningType: String, earningTypeId: Int, earningAmount: String, currencyCode: String) {
        self.earningType = earningType
        self.earningTypeId = earningTypeId
        self.earningAmount = earningAmount
        self.currencyCode = currencyCode 
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> [PayoutEarningsModel] {
        
        var payoutEarningsModel: [PayoutEarningsModel] = []
        
        var earningType: String = ""
        var earningTypeId: Int = 0
        var earningAmount: String = ""
        var currencyCode: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let request: AnyObject = dictionary["data"] {
                if let value = request["earningGroups"] as? NSArray {
                    for subValue in value as NSArray {
                        
                        earningType = ParseHelper.string(subValue, key: "name", defaultValue: "")
                        earningTypeId = ParseHelper.int(subValue, key: "earningTypeId", defaultValue: 0)
                        earningAmount = ParseHelper.string(subValue, key: "totalAmount", defaultValue: "")
                        currencyCode = ParseHelper.string(subValue, key: "currencyCode", defaultValue: "")
                        
                        payoutEarningsModel.append(PayoutEarningsModel(earningType: earningType, earningTypeId: earningTypeId, earningAmount: earningAmount, currencyCode: currencyCode))
                    }
                }
            }
        }
        
        return payoutEarningsModel
    }
}
