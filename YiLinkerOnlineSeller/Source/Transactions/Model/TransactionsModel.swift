//
//  TransactionsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/6/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TransactionsModel: NSObject {
    var message: String = ""
    var isSuccessful: Bool = false
    var transactions: [TransactionModel] = []
    
    init(message: String, isSuccessful: Bool, transactions: [TransactionModel]) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.transactions = transactions
    }
    
    override init() {
        
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> TransactionsModel {
        
        var message: String = ""
        var isSuccessful: Bool = false
        var transactions: [TransactionModel] = []
        
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
            
            if let tempVar = dictionary["data"] as? NSDictionary {
                if let tempArr = tempVar["orders"] as? NSArray {
                    for subValue in tempArr as NSArray {
                        let model: TransactionModel = TransactionModel.parseDataWithDictionary(subValue as! NSDictionary)
                        transactions.append(model)
                    }
                }
            }
        }
        
        return TransactionsModel(message: message, isSuccessful: isSuccessful, transactions: transactions)
    }
}
