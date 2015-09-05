//
//  SubCategoryModel.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import Foundation

class SubCategoryModel: NSObject {
    
    var categoryId: Int = 0
    var categoryName: String = ""
    var sortOrder: Int = 0
    
    class func parseSubCategories(subCategories: NSDictionary) -> SubCategoryModel! {
        
        var model = SubCategoryModel()
        
        if subCategories.isKindOfClass(NSDictionary) {
            model.categoryId = subCategories["categoryId"] as! Int
            model.categoryName = subCategories["categoryName"] as! String
            model.sortOrder = subCategories["sortOrder"] as! Int
            
//            if dictionary["categoryId"] != nil {
//                if let tempVar = dictionary["categoryId"] as? Int {
//                    categoryId = tempVar
//                }
//            }
//            
//            if dictionary["categoryName"] != nil {
//                if let tempVar = dictionary["categoryName"] as? String {
//                    categoryName = tempVar
//                }
//            }
//            
//            if dictionary["sortOrder"] != nil {
//                if let tempVar = dictionary[sortOrder] as? Int {
//                    sortOrder = tempVar
//                }
//            }
            
        }
        
        return model
    }
    
}