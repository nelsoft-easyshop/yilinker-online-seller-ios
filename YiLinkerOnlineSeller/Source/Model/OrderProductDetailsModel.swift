//
//  OrderProductDetailsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/16/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class OrderProductDetailsModel: NSObject {
   
    var isSuccessful: Bool = false
    var message: String = ""
    var orderProductId: String = ""
    var productId: String = ""
    var quantity: Int = 0
    var unitPrice: String = ""
    var totalPrice: String = ""
    var productName: String = ""
    var handlingFee: String = ""
    var orderProductStatusName: String = ""
    var orderProductStatusDescription: String = ""
    var productImage: String = ""
    var sku: String = ""
    var originalUnitPrice: String = ""
    var discount: String = ""
    var width: String = ""
    var height: String = ""
    var length: String = ""
    var weight: String = ""
    var buyerFullname: String = ""
    var brandName: String = ""
    var conditionName: String = ""
    var productCategory: String = ""
    
    init(isSuccessful: Bool, message: String, orderProductId: String, productId: String, quantity: Int, unitPrice: String, totalPrice: String, productName: String, handlingFee: String, orderProductStatusName: String, orderProductStatusDescription: String, productImage: String, sku: String, originalUnitPrice: String, discount: String, width: String, height: String, length: String, weight: String, buyerFullname: String, brandName: String, conditionName: String, productCategory: String) {
    
        self.isSuccessful = isSuccessful
        self.message = message
        self.orderProductId = orderProductId
        self.productId = productId
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.totalPrice = totalPrice
        self.productName = productName
        self.handlingFee = handlingFee
        self.orderProductStatusName = orderProductStatusName
        self.orderProductStatusDescription = orderProductStatusDescription
        self.productImage = productImage
        self.sku = sku
        self.originalUnitPrice = originalUnitPrice
        self.discount = discount
        self.width = width
        self.height = height
        self.length = length
        self.weight = weight
        self.buyerFullname = buyerFullname
        self.brandName = brandName
        self.conditionName = conditionName
        self.productCategory = productCategory
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> OrderProductDetailsModel {
        
        var isSuccessful: Bool = false
        var message: String = ""
        var orderProductId: String = ""
        var productId: String = ""
        var quantity: Int = 0
        var unitPrice: String = ""
        var totalPrice: String = ""
        var productName: String = ""
        var handlingFee: String = ""
        var orderProductStatusName: String = ""
        var orderProductStatusDescription: String = ""
        var productImage: String = ""
        var sku: String = ""
        var originalUnitPrice: String = ""
        var discount: String = ""
        var width: String = ""
        var height: String = ""
        var length: String = ""
        var weight: String = ""
        var buyerFullname: String = ""
        var brandName: String = ""
        var conditionName: String = ""
        var productCategory: String = ""
        
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
            
            if dictionary["data"] != nil {
                if let tempDict = dictionary["data"] as? NSDictionary {
                    if tempDict["orderProductId"] != nil {
                        if let tempVar = tempDict["orderProductId"] as? String {
                            orderProductId = tempVar
                        }
                    }
                    
                    if tempDict["productId"] != nil {
                        if let tempVar = tempDict["productId"] as? String {
                            productId = tempVar
                        }
                    }
                    
                    if tempDict["quantity"] != nil {
                        if let tempVar = tempDict["quantity"] as? Int {
                            quantity = tempVar
                        }
                    }
                    
                    if tempDict["unitPrice"] != nil {
                        if let tempVar = tempDict["unitPrice"] as? String {
                            unitPrice = tempVar
                        }
                    }
                    
                    if tempDict["totalPrice"] != nil {
                        if let tempVar = tempDict["totalPrice"] as? String {
                            totalPrice = tempVar
                        }
                    }
                    
                    if tempDict["productName"] != nil {
                        if let tempVar = tempDict["productName"] as? String {
                            productName = tempVar
                        }
                    }
                    
                    if tempDict["handlingFee"] != nil {
                        if let tempVar = tempDict["handlingFee"] as? String {
                            handlingFee = tempVar
                        }
                    }
                    
                    if tempDict["orderProductStatus"] != nil {
                        if let tempDictInner = tempDict["orderProductStatus"] as? NSDictionary {
                            if tempDictInner["name"] != nil {
                                if let tempVar = tempDictInner["name"] as? String {
                                    orderProductStatusName = tempVar
                                }
                            }
                            
                            if tempDictInner["description"] != nil {
                                if let tempVar = tempDictInner["description"] as? String {
                                    orderProductStatusDescription = tempVar
                                }
                            }
                        }
                    }
                    
                    if tempDict["productImage"] != nil {
                        if let tempVar = tempDict["productImage"] as? String {
                            productImage = tempVar
                        }
                    }
                    
                    if tempDict["sku"] != nil {
                        if let tempVar = tempDict["sku"] as? String {
                            sku = tempVar
                        }
                    }
                    
                    if tempDict["originalUnitPrice"] != nil {
                        if let tempVar = tempDict["originalUnitPrice"] as? String {
                            originalUnitPrice = tempVar
                        }
                    }
                    
                    if tempDict["discount"] != nil {
                        if let tempVar = tempDict["discount"] as? String {
                            discount = tempVar
                        }
                    }
                    
                    if tempDict["width"] != nil {
                        if let tempVar = tempDict["width"] as? String {
                            width = tempVar
                        }
                    }
                    
                    if tempDict["height"] != nil {
                        if let tempVar = tempDict["height"] as? String {
                            height = tempVar
                        }
                    }
                    
                    if tempDict["length"] != nil {
                        if let tempVar = tempDict["length"] as? String {
                            length = tempVar
                        }
                    }
                    
                    if tempDict["weight"] != nil {
                        if let tempVar = tempDict["weight"] as? String {
                            sku = tempVar
                        }
                    }
                    
                    if tempDict["buyer"] != nil {
                        if let tempDictInner = tempDict["buyer"] as? NSDictionary {
                            if tempDictInner["fullname"] != nil {
                                if let tempVar = tempDictInner["fullname"] as? String {
                                    buyerFullname = tempVar
                                }
                            }
                        }
                    }
                    
                    if tempDict["brand"] != nil {
                        if let tempDictInner = tempDict["brand"] as? NSDictionary {
                            if tempDictInner["name"] != nil {
                                if let tempVar = tempDictInner["name"] as? String {
                                    brandName = tempVar
                                }
                            }
                        }
                    }
                    
                    if tempDict["condition"] != nil {
                        if let tempDictInner = tempDict["condition"] as? NSDictionary {
                            if tempDictInner["name"] != nil {
                                if let tempVar = tempDictInner["name"] as? String {
                                    conditionName = tempVar
                                }
                            }
                        }
                    }
                    
                    if tempDict["productCategoryId"] != nil {
                        if let tempDictInner = tempDict["productCategoryId"] as? NSDictionary {
                            if tempDictInner["name"] != nil {
                                if let tempVar = tempDictInner["name"] as? String {
                                    productCategory = tempVar
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        
        return OrderProductDetailsModel(isSuccessful: isSuccessful, message: message, orderProductId: orderProductId, productId: productId, quantity: quantity, unitPrice: unitPrice, totalPrice: totalPrice, productName: productName, handlingFee: handlingFee, orderProductStatusName: orderProductStatusName, orderProductStatusDescription: orderProductStatusDescription, productImage: productImage, sku: sku, originalUnitPrice: originalUnitPrice, discount: discount, width: width, height: height, length: length, weight: weight, buyerFullname: buyerFullname, brandName: brandName, conditionName: conditionName, productCategory: productCategory)
    }
}
