//
//  TransactionConsigneeModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/12/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionConsigneeModel: NSObject {
   
    var isSuccessful: Bool = false
    var message: String = ""
    var deliveryAddress: String = ""
    var consigneeName: String = ""
    var consigneeContactNumber: String = ""
    var buyerId: Int = 0
    
    init(isSuccessful: Bool, message: String, deliveryAddress: String, consigneeName: String, consigneeContactNumber: String, buyerId: Int) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.deliveryAddress = deliveryAddress
        self.consigneeName = consigneeName
        self.consigneeContactNumber = consigneeContactNumber
        self.buyerId = buyerId
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> TransactionConsigneeModel {
        
        var isSuccessful: Bool = false
        var message: String = ""
        var deliveryAddress: String = ""
        var consigneeName: String = ""
        var consigneeContactNumber: String = ""
        var buyerId: Int = 0
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["message"] != nil {
                if let tempVar = dictionary["message"] as? String {
                    message = tempVar
                }
            }
            
            if dictionary["isSuccessful"] != nil {
                if let tempVar = dictionary["isSuccessful"] as? Bool {
                    isSuccessful = tempVar
                }
            }
            
            if let tempDict = dictionary["data"] as? NSDictionary {
                if let tempVar = tempDict["deliveryAddress"] as? String {
                    deliveryAddress = tempVar
                }
                
                if let tempVar = tempDict["consigneeName"] as? String {
                    consigneeName = tempVar
                }
                
                if let tempVar = tempDict["consigneeContactNumber"] as? String {
                    consigneeContactNumber = tempVar
                }
                
                if let tempVar = tempDict["buyerId"] as? Int {
                    buyerId = tempVar
                }
            }
        }
        
        return TransactionConsigneeModel(isSuccessful: isSuccessful, message: message, deliveryAddress: deliveryAddress, consigneeName: consigneeName, consigneeContactNumber: consigneeContactNumber, buyerId: buyerId)
    }
}
