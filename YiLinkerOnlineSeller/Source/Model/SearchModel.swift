//
//  SearchModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/8/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class SearchModel: NSObject {
   
    var invoiceNumber: [String] = []
    var targetType: [String] = []
    
    init(invoiceNumber: NSArray, targetType: NSArray) {
        self.invoiceNumber = invoiceNumber as! [String]
        self.targetType = targetType as! [String]
    }
    
    class func parseDataFromDictionary(dictionary: AnyObject ) -> SearchModel {
        var invoiceNumber: [String] = []
        var targetType: [String] = []
        
        if dictionary.isKindOfClass(NSDictionary){
            
            if let value: AnyObject = dictionary["data"] {
                for invoice in value as! NSArray {
                    if invoice["invoiceNumber"] != nil {
                        if let tempVar = invoice["invoiceNumber"] as? String {
                            invoiceNumber.append(tempVar)
                        }
                    }
                
                    if invoice["target"] != nil {
                        if let tempVar = invoice["target"] as? String {
                            targetType.append(tempVar)
                        }
                    }
                }
            }
        }
        
        let searchModel = SearchModel(invoiceNumber: invoiceNumber, targetType: targetType)
        
        return searchModel
    }
}
