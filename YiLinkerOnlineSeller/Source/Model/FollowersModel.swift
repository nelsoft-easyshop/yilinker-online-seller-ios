//
//  FollowersModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/8/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class FollowersModel: NSObject {
    
    var isSuccessful: Bool = false
    var message: String = ""
    var data: [FollowerModel] = []
    
    init(isSuccessful: Bool, message: String, data: [FollowerModel]) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.data = data
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> FollowersModel {
        
        var isSuccessful: Bool = false
        var message: String = ""
        var data: [FollowerModel] = []
        
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
                for subValue in dictionary["data"] as! NSArray {
                    let model: FollowerModel = FollowerModel.parseDataWithDictionary(subValue as! NSDictionary)
                    data.append(model)
                }
            }
        }
        
        return FollowersModel(isSuccessful: isSuccessful, message: message, data: data)
    }
}
