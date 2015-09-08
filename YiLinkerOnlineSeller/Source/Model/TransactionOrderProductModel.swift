//
//  TransactionOrderProductModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/8/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionOrderProductModel: NSObject {
   
    var orderProductId: String = ""
    var quantity: Int = 0
    var unitPrice: String = ""
    var totalPrice: String = ""
    var productName: String = ""
    var handlingFee: String = ""
    var dateAdded: String = ""
    var lastDateModified: String = ""
    var orderProductStatusId: Int = 0
    var orderProductStatusName: String = ""
    var orderProductStatusDescription: String = ""
    
    init(orderProductId: String, quantity: Int, unitPrice: String, totalPrice: String, productName: String, handlingFee: String, dateAdded: String, lastDateModified: String, orderProductStatusId: Int, orderProductStatusName: String, orderProductStatusDescription: String) {
        
        self.orderProductId = orderProductId
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.totalPrice = totalPrice
        self.productName = productName
        self.handlingFee = handlingFee
        self.dateAdded = dateAdded
        self.lastDateModified = lastDateModified
        self.orderProductStatusId = orderProductStatusId
        self.orderProductStatusName = orderProductStatusName
        self.orderProductStatusDescription = orderProductStatusDescription
        
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> TransactionOrderProductModel {
        
        var orderProductId: String = ""
        var quantity: Int = 0
        var unitPrice: String = ""
        var totalPrice: String = ""
        var productName: String = ""
        var handlingFee: String = ""
        var dateAdded: String = ""
        var lastDateModified: String = ""
        var orderProductStatusId: Int = 0
        var orderProductStatusName: String = ""
        var orderProductStatusDescription: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["orderProductId"] != nil {
                if let tempVar = dictionary["orderProductId"] as? String {
                    orderProductId = tempVar
                }
            }
            
            if dictionary["quantity"] != nil {
                if let tempVar = dictionary["quantity"] as? Int {
                    quantity = tempVar
                }
            }
            
            if dictionary["unitPrice"] != nil {
                if let tempVar = dictionary["unitPrice"] as? String {
                    unitPrice = tempVar
                }
            }
            
            if dictionary["totalPrice"] != nil {
                if let tempVar = dictionary["totalPrice"] as? String {
                    totalPrice = tempVar
                }
            }
            
            if dictionary["productName"] != nil {
                if let tempVar = dictionary["productName"] as? String {
                    productName = tempVar
                }
            }
            
            if dictionary["handlingFee"] != nil {
                if let tempVar = dictionary["handlingFee"] as? String {
                    handlingFee = tempVar
                }
            }
            
            if dictionary["dateAdded"] != nil {
                if let tempDict = dictionary["dateAdded"] as? NSDictionary {
                    if let tempVar = tempDict["date"] as? String {
                        dateAdded = tempVar
                    }
                }
            }
            
            if dictionary["lastDateModified"] != nil {
                if let tempDict = dictionary["lastDateModified"] as? NSDictionary {
                    if let tempVar = tempDict["date"] as? String {
                        lastDateModified = tempVar
                    }
                }
            }
            
            if dictionary["orderProductStatus"] != nil {
                if let tempDict = dictionary["orderProductStatus"] as? NSDictionary {
                    if let tempVar = tempDict["orderProductStatusId"] as? Int {
                        orderProductStatusId = tempVar
                    }
                    
                    if let tempVar = tempDict["name"] as? String {
                        orderProductStatusName = tempVar
                    }
                    
                    if let tempVar = tempDict["description"] as? String {
                        orderProductStatusDescription = tempVar
                    }
                }
            }
        }
        
        return TransactionOrderProductModel(orderProductId: orderProductId, quantity: quantity, unitPrice: unitPrice, totalPrice: totalPrice, productName: productName, handlingFee: handlingFee, dateAdded: dateAdded, lastDateModified: lastDateModified, orderProductStatusId: orderProductStatusId, orderProductStatusName: orderProductStatusName, orderProductStatusDescription: orderProductStatusDescription)
    }

    
}
