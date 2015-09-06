//
//  CustomizedCategoriesModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CustomizedCategoriesModel: NSObject {
    var message: String = ""
    var isSuccessful: Bool = false
    var customizedCategories: [CustomizedCategoryModel]
    
    init(message: String, isSuccessful: Bool, customizedCategories: [CustomizedCategoryModel]) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.customizedCategories = customizedCategories
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> CustomizedCategoriesModel {
        
        var message: String = ""
        var isSuccessful: Bool = false
        var customizedCategories: [CustomizedCategoryModel] = []
        
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
                    let model: CustomizedCategoryModel = CustomizedCategoryModel.parseDataWithDictionary(subValue as! NSDictionary)
                    customizedCategories.append(model)
                }
            }
        }
        
        return CustomizedCategoriesModel(message: message, isSuccessful: isSuccessful, customizedCategories: customizedCategories)
    }
}
