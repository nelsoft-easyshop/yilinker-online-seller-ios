//
//  BankAccountModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/2/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class BankAccountModel: NSObject {
    
    var account_title: [String] = []
    var account_name: [String] = []
    var account_number: [Int] = []
    var bank_name: [String] = []
    
    init(account_title: NSArray, account_name: NSArray, account_number: NSArray, bank_name: NSArray){
        self.account_title = account_title as! [String]
        self.account_name = account_name as! [String]
        self.account_number = account_number as! [Int]
        self.bank_name = bank_name as! [String]
    }
    
    class func parseBankAccountDataFromDictionary(dictionary: AnyObject) -> BankAccountModel {
        var account_title: [String] = []
        var account_name: [String] = []
        var account_number: [Int] = []
        var bank_name: [String] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
          
        if let categories: AnyObject = dictionary["data"] {
            
            for category in categories as! NSArray {
                if let tempAccountNumber = category["accountNumber"] as? Int {
                    account_number.append(tempAccountNumber)
                }
                
                if let tempAccountTitle = category["accountTitle"] as? String {
                    account_title.append(tempAccountTitle)
                }
                
                if let tempAccountName = category["accountName"] as? String {
                    account_name.append(tempAccountName)
                }
                
                if let tempBankName = category["bankName"] as? String {
                   // let stringToBool = NSString(string: tempBankName)
                    bank_name.append(tempBankName)
                }
            }
            }
        }
        
        var bank_account_model = BankAccountModel(account_title: account_title, account_name: account_name, account_number: account_number, bank_name: bank_name)
        println(account_name.count)
        return bank_account_model
    }
}
