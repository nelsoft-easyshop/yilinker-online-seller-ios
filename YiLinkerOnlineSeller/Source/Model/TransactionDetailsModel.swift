//
//  TransactionDetailsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/8/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionDetailsModel: NSObject {
    
    var isSuccessful: Bool = false
    var message: String = ""
    var transactionInvoice: String = ""
    var transactionShippingFee: String = ""
    var transactionDate: String = ""
    var transactionPrice: String = ""
    var transactionQuantity: Int = 0
    var transactionStatusId: Int = 0
    var transactionStatusName: String = ""
    var transactionPayment: String = ""
    var transactionOrderProducts: [TransactionOrderProductModel] = []
    
    init(isSuccessful: Bool, message: String, transactionInvoice: String, transactionShippingFee: String, transactionDate: String, transactionPrice: String, transactionQuantity: Int, transactionStatusId: Int, transactionStatusName: String, transactionPayment: String, transactionOrderProducts: [TransactionOrderProductModel]) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.transactionInvoice = transactionInvoice
        self.transactionShippingFee = transactionShippingFee
        self.transactionDate = transactionDate
        self.transactionPrice = transactionPrice
        self.transactionQuantity = transactionQuantity
        self.transactionStatusId = transactionStatusId
        self.transactionStatusName = transactionStatusName
        self.transactionPayment = transactionPayment
        self.transactionOrderProducts = transactionOrderProducts
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> TransactionDetailsModel {
        
        var isSuccessful: Bool = false
        var message: String = ""
        var transactionInvoice: String = ""
        var transactionShippingFee: String = ""
        var transactionDate: String = ""
        var transactionPrice: String = ""
        var transactionQuantity: Int = 0
        var transactionStatusId: Int = 0
        var transactionStatusName: String = ""
        var transactionPayment: String = ""
        var transactionOrderProducts: [TransactionOrderProductModel] = []
        
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
                    if dictionary["transactionInvoice"] != nil {
                        if let tempVar = dictionary["transactionInvoice"] as? String {
                            transactionInvoice = tempVar
                        }
                    }
                    
                    if dictionary["transactionShippingFee"] != nil {
                        if let tempVar = dictionary["transactionShippingFee"] as? String {
                            transactionShippingFee = tempVar
                        }
                    }
                    
                    if dictionary["transactionDate"] != nil {
                        if let tempDictInner = dictionary["transactionDate"] as? NSDictionary {
                            if tempDictInner["date"] != nil {
                                if let tempVar = tempDictInner["date"] as? String {
                                    transactionShippingFee = tempVar
                                }
                            }
                        }
                    }

                    if dictionary["transactionPrice"] != nil {
                        if let tempVar = dictionary["transactionPrice"] as? String {
                            transactionPrice = tempVar
                        }
                    }
                    
                    if dictionary["transactionQuantity"] != nil {
                        if let tempVar = dictionary["transactionQuantity"] as? Int {
                            transactionQuantity = tempVar
                        }
                    }
                    
                    if dictionary["transactionStatus"] != nil {
                        if let tempDictInner = dictionary["transactionStatus"] as? NSDictionary {
                            if tempDictInner["statusId"] != nil {
                                if let tempVar = tempDictInner["statusId"] as? Int {
                                    transactionStatusId = tempVar
                                }
                            }
                            
                            if tempDictInner["statusName"] != nil {
                                if let tempVar = tempDictInner["statusName"] as? String {
                                    transactionStatusName = tempVar
                                }
                            }
                        }
                    }
                    
                    if dictionary["transactionPayment"] != nil {
                        if let tempVar = dictionary["transactionPayment"] as? String {
                            transactionPayment = tempVar
                        }
                    }
                    
                    if dictionary["transactionOrderProducts"] != nil {
                        for subValue in dictionary["transactionOrderProducts"] as! NSArray {
                            transactionOrderProducts.append(TransactionOrderProductModel.parseDataWithDictionary(subValue))
                        }
                    }
                    
                }
            }
        }
        
        return TransactionDetailsModel(isSuccessful: isSuccessful, message: message, transactionInvoice: transactionInvoice, transactionShippingFee: transactionShippingFee, transactionDate: transactionDate, transactionPrice: transactionPrice, transactionQuantity: transactionQuantity, transactionStatusId: transactionStatusId, transactionStatusName: transactionStatusName, transactionPayment: transactionPayment, transactionOrderProducts: transactionOrderProducts)
    }

}
