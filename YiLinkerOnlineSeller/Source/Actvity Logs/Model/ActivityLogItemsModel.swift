//
//  ActivityLogItemsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/11/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ActivityLogItemsModel: NSObject {
   
    var isSuccessful: Bool = false
    var message: String = ""
    var activities: [ActivityLogItemModel] = []
    
    init(isSuccessful: Bool, message: String, activities: [ActivityLogItemModel]) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.activities = activities
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ActivityLogItemsModel {
        
        var isSuccessful: Bool = false
        var message: String = ""
        var activities: [ActivityLogItemModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if dictionary["isSuccessful"] != nil {
                if let tempVar = dictionary["isSuccessful"] as? Bool {
                    isSuccessful = tempVar
                }
            }
            
            if dictionary["message"] != nil {
                if let tempVar = dictionary["message"] as? String {
                    message = tempVar
                }
            }
            
            if dictionary["data"] != nil {
                if let tempDictOuter = dictionary["data"] as? NSDictionary {
                    for subValue in tempDictOuter["activities"] as! NSArray {
                        let model: ActivityLogItemModel = ActivityLogItemModel.parseDataWithDictionary(subValue as! NSDictionary)
                        activities.append(model)
                    }
                }
            }
        }
        
        return ActivityLogItemsModel(isSuccessful: isSuccessful, message: message, activities: activities)
    }
    
}
