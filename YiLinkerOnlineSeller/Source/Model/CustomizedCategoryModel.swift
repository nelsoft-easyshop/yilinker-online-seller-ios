//
//  CustomizedCategoryModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CustomizedCategoryModel: NSObject {
   
    var categoryId: Int = 0
    var name: String = ""
    var parentId: Int = 0
    var sortOrder: Int = 0
    
    init(categoryId: Int, name: String, parentId: Int, sortOrder: Int){
        self.categoryId = categoryId
        self.name = name
        self.parentId = parentId
        self.sortOrder = sortOrder
    }
    
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> CustomizedCategoryModel {
        
        var categoryId: Int = 0
        var name: String = ""
        var parentId: Int = 0
        var sortOrder: Int = 0
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["categoryId"] != nil {
                if let tempVar = dictionary["categoryId"] as? Int {
                    categoryId = tempVar
                }
            }
            
            if dictionary["name"] != nil {
                if let tempVar = dictionary["name"] as? String {
                    name = tempVar
                }
            }
            
            if dictionary["parentId"] != nil {
                if let tempVar = dictionary["parentId"] as? Int {
                    parentId = tempVar
                }
            }
            
            if dictionary["sortOrder"] != nil {
                if let tempVar = dictionary["sortOrder"] as? Int {
                    sortOrder = tempVar
                }
            }
        }
        
        return CustomizedCategoryModel(categoryId: categoryId, name: name, parentId: parentId, sortOrder: sortOrder)
    }
}
