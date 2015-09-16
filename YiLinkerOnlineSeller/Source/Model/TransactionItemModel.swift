//
//  TransactionItemModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/16/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionItemModel: NSObject {
   
    var sellerId: Int  = 0
    var sellerStore: String  = ""
    var sellerContactNumber: String = ""
    var hasFeedback: Bool = false
    var products: [TransactionOrderProductModel] = []
    
    init(sellerId: Int, sellerStore: String, sellerContactNumber: String, hasFeedback: Bool, products: [TransactionOrderProductModel]) {
        self.sellerId = sellerId
        self.sellerStore = sellerStore
        self.sellerContactNumber = sellerContactNumber
        self.hasFeedback = hasFeedback
        self.products = products
    }
    
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> TransactionItemModel {
        
        var sellerId: Int  = 0
        var sellerStore: String  = ""
        var sellerContactNumber: String = ""
        var hasFeedback: Bool = false
        var products: [TransactionOrderProductModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["sellerId"] != nil {
                if let tempVar = dictionary["sellerId"] as? Int {
                    sellerId = tempVar
                }
            }
            
            if dictionary["sellerStore"] != nil {
                if let tempVar = dictionary["sellerStore"] as? String {
                    sellerStore = tempVar
                }
            }
            
            if dictionary["sellerContactNumber"] != nil {
                if let tempVar = dictionary["sellerContactNumber"] as? String {
                    sellerContactNumber = tempVar
                }
            }
            
            if dictionary["hasFeedback"] != nil {
                if let tempVar = dictionary["hasFeedback"] as? Bool {
                    hasFeedback = tempVar
                }
            }
            
            if dictionary["products"] != nil {
                for subValue in dictionary["products"] as! NSArray {
                    products.append(TransactionOrderProductModel.parseDataWithDictionary(subValue))
                }
            }
        }
        
        return TransactionItemModel(sellerId: sellerId, sellerStore: sellerStore, sellerContactNumber: sellerContactNumber, hasFeedback: hasFeedback, products: products)
    }
}
