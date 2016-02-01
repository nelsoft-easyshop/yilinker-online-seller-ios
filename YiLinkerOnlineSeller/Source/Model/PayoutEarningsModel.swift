//
//  PayoutEarningsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 2/1/16.
//  Copyright (c) 2016 YiLinker. All rights reserved.
//

import UIKit

class PayoutEarningsModel: NSObject {
    
    var earningType: [String] = []
    var earningTypeId: [Int] = []
    var earningAmount: [String] = []
    var currencyCode: [String] = []
    
    init(earningType: NSArray, earningTypeId: NSArray, earningAmount: NSArray, currencyCode: NSArray) {
        self.earningType = earningType as! [String]
        self.earningTypeId = earningTypeId as! [Int]
        self.earningAmount = earningAmount as! [String]
        self.currencyCode = currencyCode as! [String]
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> PayoutEarningsModel {
        
        var earningType: [String] = []
        var earningTypeId: [Int] = []
        var earningAmount: [String] = []
        var currencyCode: [String] = []
        
        if let request: AnyObject = dictionary["data"] {
            if let value = request["earningGroups"] as? NSArray {
                for subValue in value as NSArray {
                    earningType.append(subValue["name"] as! String)
                    earningTypeId.append(subValue["earningTypeId"] as! Int)
                    earningAmount.append(subValue["totalAmount"] as! String)
                    currencyCode.append(subValue["currencyCode"] as! String)
                }
            }
        }
        
        return PayoutEarningsModel(earningType: earningType, earningTypeId: earningTypeId, earningAmount: earningAmount, currencyCode: currencyCode)
    }
}
