//
//  ConditionParserModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct ConditionParseModelKey {
    static let isSuccessfulKey = "isSuccessful"
    static let dataKey = "data"
    static let messageKey = "message"
}

class ConditionParserModel: NSObject {
    var data: [NSDictionary] = []
    var isSuccessful: Bool = true
    var message: String = ""
    
    init(data: [NSDictionary], isSuccessful: Bool, message: String) {
        self.data = data
        self.isSuccessful = isSuccessful
        self.message = message
    }

    class func parseDataFromDictionary(dictionary: NSDictionary) -> ConditionParserModel {
        var data: [NSDictionary] = []
        var isSuccessful: Bool = true
        var message: String = ""
        
        if let val: AnyObject = dictionary[ConditionParseModelKey.isSuccessfulKey] {
            if let tempVal = dictionary[ConditionParseModelKey.isSuccessfulKey] as? Bool {
                isSuccessful = tempVal
            }
        }
        
        if let val: AnyObject = dictionary[ConditionParseModelKey.dataKey] {
            if let tempVal = dictionary[ConditionParseModelKey.dataKey] as? NSArray {
                data = tempVal as! [NSDictionary]
            }
        }
        
        if let val: AnyObject = dictionary[ConditionParseModelKey.messageKey] {
            if let tempVal = dictionary[ConditionParseModelKey.messageKey] as? String {
                message = tempVal
            }
        }
        
        let conditionParseModel: ConditionParserModel = ConditionParserModel(data: data, isSuccessful: isSuccessful, message: message)
        return conditionParseModel
    }
}
