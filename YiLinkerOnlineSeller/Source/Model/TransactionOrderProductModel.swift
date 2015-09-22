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
    var productId: String = ""
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
    var productImage: String = ""
    var sku: String = ""
    var color: String = ""
    var size: String = ""
    var originalUnitPrice: String = ""
    var discount: String = ""
    var width: String = ""
    var height: String = ""
    var length: String = ""
    var weight: String = ""
    var fullDescription: String = ""
    var shortDescription: String = ""
    var transactionOrderItemStatus: TransactionOrderItemStatus = TransactionOrderItemStatus.UnSelected
    
    init(orderProductId: String, productId: String, quantity: Int, unitPrice: String, totalPrice: String, productName: String, handlingFee: String, dateAdded: String, lastDateModified: String, orderProductStatusId: Int, orderProductStatusName: String, orderProductStatusDescription: String, productImage: String, sku: String, color: String, size: String, originalUnitPrice: String, discount: String, width: String, height: String, length: String, weight: String, fullDescription: String, shortDescription: String) {
        
        self.orderProductId = orderProductId
        self.productId = productId
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
        self.productImage = productImage
        self.sku = sku
        self.color = color
        self.size = size
        self.originalUnitPrice = originalUnitPrice
        self.discount = discount
        self.width = width
        self.height = height
        self.length = length
        self.weight = weight
        self.fullDescription = fullDescription
        self.shortDescription = shortDescription
        
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> TransactionOrderProductModel {
        
        var orderProductId: String = ""
        var productId: String = ""
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
        var productImage: String = ""
        var sku: String = ""
        var color: String = ""
        var size: String = ""
        var originalUnitPrice: String = ""
        var discount: String = ""
        var width: String = ""
        var height: String = ""
        var length: String = ""
        var weight: String = ""
        var fullDescription: String = ""
        var shortDescription: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["productId"] != nil {
                if let tempVar = dictionary["productId"] as? String {
                    productId = tempVar
                }
            }
            
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
            
            if dictionary["productImage"] != nil {
                if let tempVar = dictionary["productImage"] as? String {
                    productImage = tempVar
                }
            }
            
            if dictionary["sku"] != nil {
                if let tempVar = dictionary["sku"] as? String {
                    sku = tempVar
                }
            }
            
            if dictionary["color"] != nil {
                if let tempVar = dictionary["color"] as? String {
                    color = tempVar
                }
            }
            
            if dictionary["size"] != nil {
                if let tempVar = dictionary["size"] as? String {
                    size = tempVar
                }
            }
            
            if dictionary["originalUnitPrice"] != nil {
                if let tempVar = dictionary["originalUnitPrice"] as? String {
                    originalUnitPrice = tempVar
                }
            }
            
            if dictionary["discount"] != nil {
                if let tempVar = dictionary["discount"] as? String {
                    discount = tempVar
                }
            }
            
            if dictionary["width"] != nil {
                if let tempVar = dictionary["width"] as? String {
                    width = tempVar
                }
            }
            
            if dictionary["height"] != nil {
                if let tempVar = dictionary["height"] as? String {
                    height = tempVar
                }
            }
            
            if dictionary["length"] != nil {
                if let tempVar = dictionary["length"] as? String {
                    length = tempVar
                }
            }
            
            if dictionary["weight"] != nil {
                if let tempVar = dictionary["weight"] as? String {
                    weight = tempVar
                }
            }
            
            if dictionary["description"] != nil {
                if let tempVar = dictionary["description"] as? String {
                    fullDescription = tempVar
                }
            }
            
            if dictionary["shortDescription"] != nil {
                if let tempVar = dictionary["shortDescription"] as? String {
                    shortDescription = tempVar
                }
            }
        }
        
        return TransactionOrderProductModel(orderProductId: orderProductId, productId: productId, quantity: quantity, unitPrice: unitPrice, totalPrice: totalPrice, productName: productName, handlingFee: handlingFee, dateAdded: dateAdded, lastDateModified: lastDateModified, orderProductStatusId: orderProductStatusId, orderProductStatusName: orderProductStatusName, orderProductStatusDescription: orderProductStatusDescription, productImage: productImage, sku: sku, color: color, size: size, originalUnitPrice: originalUnitPrice, discount: discount, width: width, height: height, length: length, weight: weight, fullDescription: fullDescription, shortDescription: shortDescription)
    }

    
}
