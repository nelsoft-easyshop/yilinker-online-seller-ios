//
//  PointModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class PointV2Model: NSObject {
    var amount: String = ""
    var currencyCode: String = ""
    var date: String = ""
    var pointDescription: String = ""
    
    init(amount: String, currencyCode: String, date: String, pointDescription: String) {
        self.amount = amount
        self.currencyCode = currencyCode
        self.date = date
        self.pointDescription = pointDescription
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> PointV2Model {
        
        var amount: String = ""
        var currencyCode: String = ""
        var date: String = ""
        var pointDescription: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if dictionary["amount"] != nil {
                if let tempVar = dictionary["amount"] as? String {
                    amount = tempVar
                }
            }
            
            if dictionary["description"] != nil {
                if let tempVar = dictionary["description"] as? String {
                    pointDescription = tempVar
                }
            }
            
            if dictionary["date"] != nil {
                if let tempVar = dictionary["date"] as? String {
                    date = tempVar
                }
            }
            
            if dictionary["currencyCode"] != nil {
                if let tempVar = dictionary["currencyCode"] as? String {
                    currencyCode = tempVar
                }
            }
        }
        
        return PointV2Model(amount: amount, currencyCode: currencyCode, date: date, pointDescription: pointDescription)
    }
}
