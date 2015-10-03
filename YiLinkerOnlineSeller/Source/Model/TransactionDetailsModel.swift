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
    var transactionUnitPrice: String = ""
    var transactionStatusId: Int = 0
    var transactionStatusName: String = ""
    var transactionPayment: String = ""
    var transactionItems: [TransactionItemModel] = []
    
    override init() {
        
    }
    
    init(isSuccessful: Bool, message: String, transactionInvoice: String, transactionShippingFee: String, transactionDate: String, transactionPrice: String, transactionQuantity: Int, transactionUnitPrice: String, transactionStatusId: Int, transactionStatusName: String, transactionPayment: String, transactionItems: [TransactionItemModel]) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.transactionInvoice = transactionInvoice
        self.transactionShippingFee = transactionShippingFee
        self.transactionDate = transactionDate
        self.transactionPrice = transactionPrice
        self.transactionQuantity = transactionQuantity
        self.transactionUnitPrice = transactionUnitPrice
        self.transactionStatusId = transactionStatusId
        self.transactionStatusName = transactionStatusName
        self.transactionPayment = transactionPayment
        self.transactionItems = transactionItems
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> TransactionDetailsModel {
        
        var isSuccessful: Bool = false
        var message: String = ""
        var transactionInvoice: String = ""
        var transactionShippingFee: String = ""
        var transactionDate: String = "2000-01-01 00:00:00.000000"
        var transactionPrice: String = ""
        var transactionQuantity: Int = 0
        var transactionUnitPrice: String = ""
        var transactionStatusId: Int = 0
        var transactionStatusName: String = ""
        var transactionPayment: String = ""
        
        var transactionItems: [TransactionItemModel] = []
        
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
                    if tempDict["transactionInvoice"] != nil {
                        if let tempVar = tempDict["transactionInvoice"] as? String {
                            transactionInvoice = tempVar
                        }
                    }
                    
                    if tempDict["transactionShippingFee"] != nil {
                        if let tempVar = tempDict["transactionShippingFee"] as? String {
                            transactionShippingFee = tempVar
                        }
                    }
                    
                    if tempDict["transactionDate"] != nil {
                        if let tempDictInner = tempDict["transactionDate"] as? NSDictionary {
                            if tempDictInner["date"] != nil {
                                if let tempVar = tempDictInner["date"] as? String {
                                    transactionDate = tempVar
                                }
                            }
                        }
                    }

                    if tempDict["transactionPrice"] != nil {
                        if let tempVar = tempDict["transactionPrice"] as? String {
                            transactionPrice = tempVar
                        }
                    }
                    
                    if tempDict["transactionQuantity"] != nil {
                        if let tempVar = tempDict["transactionQuantity"] as? Int {
                            transactionQuantity = tempVar
                        }
                    }
                    
                    if tempDict["transactionUnitPrice"] != nil {
                        if let tempVar = tempDict["transactionUnitPrice"] as? String {
                            transactionUnitPrice = tempVar
                        }
                    }
                    
                    if tempDict["transactionStatus"] != nil {
                        if let tempDictInner = tempDict["transactionStatus"] as? NSDictionary {
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
                    
                    if tempDict["transactionPayment"] != nil {
                        if let tempVar = tempDict["transactionPayment"] as? String {
                            transactionPayment = tempVar
                        }
                    }
                    
                    if tempDict["transactionItems"] != nil {
                        for subValue in tempDict["transactionItems"] as! NSArray {
                            transactionItems.append(TransactionItemModel.parseDataWithDictionary(subValue))
                        }
                    }
                    
                }
            }
        }
        
        return TransactionDetailsModel(isSuccessful: isSuccessful, message: message, transactionInvoice: transactionInvoice, transactionShippingFee: transactionShippingFee, transactionDate: transactionDate, transactionPrice: transactionPrice, transactionQuantity: transactionQuantity, transactionUnitPrice: transactionUnitPrice,  transactionStatusId: transactionStatusId, transactionStatusName: transactionStatusName, transactionPayment: transactionPayment, transactionItems: transactionItems)
    }

}
