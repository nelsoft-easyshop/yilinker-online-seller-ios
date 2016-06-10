//
//  BankModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class BankModel: NSObject {
    
    var bankId: [Int] = []
    var bankName: [String] = []
    
    init(bankId: NSArray, bankName: NSArray) {
        self.bankId = bankId as! [Int]
        self.bankName = bankName as! [String]
    }
    
    class func  parseEnablebankData(dictionary: AnyObject) -> BankModel {
        
        var bankId: [Int] = []
        var bankName: [String] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let banks: AnyObject = dictionary["data"] {
                
                for bank in banks as! NSArray {
                    if let tempBankId = bank["bankId"] as? Int {
                        bankId.append(tempBankId)
                    }
                    
                    if let tempBankName = bank["bankName"] as? String {
                        bankName.append(tempBankName)
                    }
                }
            }
        }
        
        let bankModel = BankModel(bankId: bankId, bankName: bankName)
        
        return bankModel
    }
}
