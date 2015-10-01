//
//  SearchProductNameModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Joriel Oller Fronda on 9/30/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class SearchProductNameModel: NSObject {
    var name: [String] = []
    var productId: [String] = []
    
    var name2: String = ""
    var productId2: String = ""
    
    init(name: NSArray, productId: NSArray) {
        self.name = name as! [String]
        self.productId = productId as! [String]
    }
    
    init(name2: String, productId2: String) {
        self.name2 = name2
        self.productId2 = productId2
    }

    
    class func parseDataFromDictionary(dictionary: AnyObject ) -> SearchProductNameModel {
        var name: [String] = []
        var productId: [String] = []
        
        if dictionary.isKindOfClass(NSDictionary){
            
            if let value: AnyObject = dictionary["data"] {
                for product in value as! NSArray {
                    if product["name"] != nil {
                        if let tempVar = product["name"] as? String {
                            name.append(tempVar)
                        }
                    }
                    
                    if product["productId"] != nil {
                        if let tempVar = product["productId"] as? String {
                            productId.append(tempVar)
                        }
                    }
                }
            }
        }
        
        let searchModel = SearchProductNameModel(name: name, productId: productId)
        
        return searchModel
    }
}

