//
//  ResellerGetProductModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 9/19/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ResellerGetProductModel: NSObject {
    var isSuccessful: Bool = false
    var message: String = ""
    var resellerItems: [ResellerItemModel] = []
    
    override init() {
        super.init()
    }
    
    init(isSuccessful: Bool, message: String, resellerItems: [ResellerItemModel]) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.resellerItems = resellerItems
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> ResellerGetProductModel {
        let isSuccessfulKey: String = "isSuccessful"
        let messageKey: String = "message"
        let dataKey: String = "data"
        
        var isSuccessful: Bool = false
        var message: String = ""
        var resellerItems: [ResellerItemModel] = []
        
        if dictionary[isSuccessfulKey] != nil {
            if let tempVar = dictionary[isSuccessfulKey] as? Bool {
                isSuccessful = tempVar
            }
        }
        
        if isSuccessful {
            if dictionary[messageKey] != nil {
                if let tempVar = dictionary[messageKey] as? String {
                    message = tempVar
                }
            }
            
            if dictionary[dataKey] != nil {
                if let tempVar = dictionary[dataKey] as? NSArray {
                    var dictionaries: [NSDictionary] = tempVar as! [NSDictionary]
                    
                    for resellerDictionary in dictionaries {
                        let resellerItem: ResellerItemModel = ResellerItemModel.parseDataFromDictionary(resellerDictionary)
                        resellerItems.append(resellerItem)
                    }
                }
            }
        }
        
        return ResellerGetProductModel(isSuccessful: isSuccessful, message: message, resellerItems: resellerItems)
    }
}
